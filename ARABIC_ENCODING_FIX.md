# Arabic Text Encoding Fix Guide

## Root Cause Analysis

**The Problem:** Arabic text like "النص" displays as "Ø§Ù„Ù†Øµ"

**Why It Happens:**
- UTF-8 bytes are being **interpreted as Windows-1252 or ISO-8859-1**
- Double encoding: UTF-8 data treated as if it's a single-byte encoding
- HTTP headers not specifying `charset=utf-8`
- Database or API returning data with wrong charset declaration

---

## 🔴 Layer-by-Layer Fixes

### 1. **Dart/Flutter UI Layer** ✅ LIKELY CULPRIT

**Issue:** Flutter widgets may not properly decode UTF-8 strings from HTTP responses.

**Fix - Use UTF-8 Decoding Explicitly:**

```dart
// ❌ WRONG - Can cause encoding issues
final response = await http.get(url);
final data = response.body; // Raw string, may be misinterpreted

// ✅ CORRECT - Force UTF-8 decoding
final response = await http.get(url);
final decodedBody = utf8.decode(response.bodyBytes); // Explicit UTF-8 decode
final data = jsonDecode(decodedBody);
```

**Create a Safe HTTP Client Wrapper:**

Create `lib/core/services/http_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SafeHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Ensure UTF-8 is requested
    request.headers['Accept-Charset'] = 'utf-8';
    request.headers['Content-Type'] = 'application/json; charset=utf-8';
    
    final response = await super.send(request);
    return response;
  }
}

class ApiService {
  static final client = SafeHttpClient();

  static Future<Map<String, dynamic>> getJson(String url) async {
    try {
      final response = await client.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        // Explicitly decode as UTF-8
        final decoded = utf8.decode(response.bodyBytes);
        return jsonDecode(decoded);
      }
      throw Exception('Failed with status: ${response.statusCode}');
    } on Exception catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  static Future<String> postJson(String url, Map<String, dynamic> body) async {
    try {
      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept-Charset': 'utf-8',
        },
        body: jsonEncode(body),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Explicitly decode as UTF-8
        return utf8.decode(response.bodyBytes);
      }
      throw Exception('Failed with status: ${response.statusCode}');
    } on Exception catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
```

**Update your API calls (e.g., in `recycling_request_cubit.dart`):**

```dart
// Replace line 254 in recycling_request_cubit.dart
final response = await request.send();
final responseData = await response.stream.bytesToString();

// Change to:
final response = await request.send();
final responseBytes = await response.stream.toBytes();
final responseData = utf8.decode(responseBytes); // ✅ Explicit UTF-8 decode
final data = json.decode(responseData);
```

---

### 2. **HTTP Headers Layer**

**Issue:** Missing or incorrect `charset=utf-8` in HTTP responses.

**Cloudinary Upload Fix** (in `recycling_request_cubit.dart`):

```dart
Future<String?> uploadImageToCloudinary(File file) async {
  try {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest('POST', url);
    
    // ✅ Add UTF-8 headers
    request.headers['Accept-Charset'] = 'utf-8';
    request.headers['Accept'] = 'application/json; charset=utf-8';
    
    request.fields['upload_preset'] = uploadPreset;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    
    // ✅ Explicit UTF-8 decode
    final responseBytes = await response.stream.toBytes();
    final responseData = utf8.decode(responseBytes);
    final data = json.decode(responseData);

    return data['secure_url'];
  } catch (e) {
    print("Cloudinary error: $e");
    return null;
  }
}
```

---

### 3. **Firebase Firestore Layer**

**Issue:** Firestore stores UTF-8 correctly, but Dart might misinterpret it.

**Fix - Ensure Proper String Handling:**

```dart
// In statistics_cubit.dart
Future<void> getStatisticsData() async {
  emit(StatisticsLoading());

  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(StatisticsFailure(message: "User not found"));
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recycling_requests')
        .orderBy('createdAt', descending: true)
        .get();

    double totalWeight = 0;
    int operationsCount = snapshot.docs.length;
    List<RecyclingRequestModel> recentActivities = [];

    for (var doc in snapshot.docs) {
      var data = doc.data();
      
      // ✅ Ensure strings from Firestore are properly handled
      // Firestore returns UTF-8 strings, but ensure they're not double-encoded
      var model = RecyclingRequestModel.fromMap(data, doc.id);
      
      // If you need to clean corrupted text:
      if (model.material.contains('Ø')) {
        // This is corrupted UTF-8, try to fix it
        model.material = _fixUtf8Corruption(model.material);
      }
      
      recentActivities.add(model);
      totalWeight += model.weight;
    }

    // ... rest of the code
  } catch (e) {
    emit(StatisticsFailure(message: e.toString()));
  }
}

// Helper function to fix corrupted UTF-8
String _fixUtf8Corruption(String corrupted) {
  try {
    // Convert corrupted string to UTF-8 bytes, then decode
    List<int> bytes = corrupted.codeUnits.cast<int>();
    return utf8.decode(bytes);
  } catch (e) {
    return corrupted; // Return original if can't fix
  }
}
```

---

### 4. **Text Widget Display Layer**

**Issue:** Text widgets may not properly render bidirectional text.

**Fix - Proper Arabic Text Display:**

```dart
import 'package:flutter/material.dart';

// ✅ Ensure all Text widgets support RTL properly
Text(
  'النص', // Arabic text
  textDirection: TextDirection.rtl, // Explicit RTL
  style: TextStyle(
    fontFamily: 'Segoe UI Historic', // Font that supports Arabic
    fontSize: 16,
  ),
)

// Or use context.locale to auto-detect:
Directionality(
  textDirection: Localizations.localeOf(context).languageCode == 'ar' 
    ? TextDirection.rtl 
    : TextDirection.ltr,
  child: Text(jsonData['title']), // From API or Firestore
)
```

---

### 5. **JSON Parsing Layer**

**Issue:** `jsonDecode()` can misinterpret UTF-8 bytes.

**Fix - Ensure Proper Decoding:**

```dart
import 'dart:convert';

// ❌ WRONG
String responseBody = response.body;
var data = jsonDecode(responseBody); // May fail with Arabic

// ✅ CORRECT
List<int> responseBytes = response.bodyBytes;
String decodedBody = utf8.decode(responseBytes);
var data = jsonDecode(decodedBody);

// For nested operations
Map<String, dynamic> parsedData = jsonDecode(decodedBody);
String arabicText = parsedData['material']; // Now properly decoded
```

---

### 6. **Database Layer** (Firebase Config)

**Issue:** Firebase database encoding settings.

**Fix - Ensure UTF-8 in Firestore:**

When saving to Firestore, Dart automatically uses UTF-8. But verify:

```dart
// In recycling_request_cubit.dart, submitRequest()
final model = RecyclingRequestModel(
  material: selectedMaterial, // 'بلاستيك' - UTF-8 encoded
  center: selectedCenter,
  weight: double.tryParse(weight) ?? 0.0,
  userId: user.uid,
  imageUrl: imageUrl,
);

// Firestore automatically handles UTF-8 encoding
await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .collection('recycling_requests')
    .add(model.toMap()); // ✅ UTF-8 saved correctly
```

---

## 🛠️ Complete Implementation Checklist

### Step 1: Create Safe HTTP Client
Create `lib/core/services/http_service.dart` (code shown above)

### Step 2: Update Imports
In any file making HTTP requests, add:
```dart
import 'dart:convert'; // For utf8
import 'package:eco_cycle/core/services/http_service.dart';
```

### Step 3: Fix Cloudinary Upload
Update `lib/features/recycling_request/cubit/recycling_request_cubit.dart` lines 242-263

### Step 4: Fix Response Parsing
Replace all:
```dart
final data = json.decode(response.body);
```
with:
```dart
final data = json.decode(utf8.decode(response.bodyBytes));
```

### Step 5: Update Text Display
In all screens displaying dynamic Arabic text, add explicit RTL:
```dart
Directionality(
  textDirection: context.locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
  child: // your widgets
)
```

### Step 6: Update `main.dart`
Ensure MaterialApp supports Arabic locale properly:
```dart
MaterialApp(
  localizationsDelegates: context.localizationDelegates,
  supportedLocales: context.supportedLocales,
  locale: context.locale, // Respects easy_localization
  // ... rest
)
```

---

## 🧪 Debugging Steps to Locate Corruption

### 1. **Check if Issue is in Transit (HTTP)**
```dart
// Add this debug print in your API service
final response = await http.get(url);
print('Response bytes: ${response.bodyBytes}'); // Raw bytes
print('Response string: ${response.body}'); // Decoded by http package
print('Decoded properly: ${utf8.decode(response.bodyBytes)}'); // Force UTF-8
```

### 2. **Check if Issue is in Storage (Firestore)**
```dart
// In your Firestore read
final doc = await FirebaseFirestore.instance
    .collection('centers')
    .doc('test')
    .get();
print('Raw data: ${doc.data()}');
print('Name field: ${doc['name']}');
print('Name bytes: ${doc['name'].codeUnits}');
```

### 3. **Check if Issue is in Display**
```dart
// In your Text widget
final text = 'النص'; // Arabic
print('Text: $text');
print('Codes: ${text.codeUnits}');
print('Bytes: ${utf8.encode(text)}');

Text(
  text,
  textDirection: TextDirection.rtl,
  // Add style to test
  style: TextStyle(
    fontSize: 20,
    fontFamily: 'Arial', // Try different fonts
  ),
)
```

### 4. **Monitor Network Traffic**
Use Charles Proxy or Burp Suite to monitor:
- HTTP response headers (check `Content-Type: application/json; charset=utf-8`)
- Response body encoding
- Verify Arabic text in response

---

## 📋 Quick Fixes Summary

| Problem | Solution |
|---------|----------|
| Arabic from API shows garbled | Use `utf8.decode(response.bodyBytes)` |
| Arabic from Firebase shows garbled | Verify HTTP headers during fetch |
| Arabic text won't align right | Add `textDirection: TextDirection.rtl` |
| Arabic in TextField is backwards | Use `Directionality` wrapper |
| Special characters still broken | Check font supports Arabic (use "Segoe UI Historic", "Noto Sans Arabic") |

---

## 🚀 Implementation Priority

1. **High Priority** - Fix HTTP response decoding (Step 1-2)
2. **High Priority** - Fix JSON parsing (Step 4)
3. **Medium Priority** - Fix text display RTL (Step 5)
4. **Low Priority** - Database UTF-8 (already works if steps 1-4 done)

Apply these fixes and test with Arabic text from different sources!
