# Arabic Text Encoding - Troubleshooting Guide

## Common Issues & Exact Fixes for EcoCycle

### Issue 1: Corrupted Text from Firestore (Centers, Materials)

**Symptom:** 
```
Center name shows: "Ø§Ù„Ù†Øµ"
Expected: "النص"
```

**Root Cause:** Firestore returns UTF-8 but it's already stored correctly. Issue is in how it's being decoded/displayed.

**Fix Applied:**
- ✅ `getCenters()` in `recycling_request_cubit.dart` now calls `_fixUtf8Corruption()`
- ✅ Display using `ArabicText` widget (auto-detects RTL)

**Verify:**
```dart
// In recycling_request_cubit.dart getCenters() - should be fixed
centers = snapshot.docs
    .map((doc) => _fixUtf8Corruption(doc['name'] as String)) // ✅ Fixed
    .toList();
```

---

### Issue 2: Corrupted Text from Statistics Activity (Recent Activities)

**Symptom:**
```
Material type shows: "Ø§Ù„Ù†Øµ" instead of "ورق"
```

**Root Cause:** Same as Issue 1, but in `statistics_cubit.dart`

**Fix Applied:**
- ✅ Added UTF-8 recovery in `getStatisticsData()` loop
- ✅ Helper function `_fixUtf8Corruption()` added

**Verify:**
```dart
// In statistics_cubit.dart getStatisticsData() - line 34-36
for (var doc in snapshot.docs) {
  var data = doc.data();
  var model = RecyclingRequestModel.fromMap(data, doc.id);
  
  // ✅ This fixes any corrupted Arabic text
  model.material = _fixUtf8Corruption(model.material);
  
  recentActivities.add(model);
  totalWeight += model.weight;
}
```

---

### Issue 3: Corrupted Text from API Responses (If You Add Backend)

**Symptom:**
```
API returns: {"name": "Ø§Ù„Ù†Øµ"}
```

**Root Cause:** HTTP response parsed as wrong encoding

**Fix Applied:**
- ✅ Created `SafeHttpClient` with UTF-8 headers
- ✅ `ApiService.getJson()` uses `utf8.decode(response.bodyBytes)`

**How to Use:**
```dart
// Import the service
import 'package:eco_cycle/core/services/http_service.dart';

// Use it like this:
final centerData = await ApiService.getJson('https://your-api.com/centers');
// Arabic text is now correctly decoded
```

---

### Issue 4: Text Alignment Wrong (Text Shows But Backwards)

**Symptom:**
```
Arabic text appears: الص نت (reversed/not properly shaped)
```

**Root Cause:** Missing `textDirection: TextDirection.rtl`

**Fix Applied:**
- ✅ Created `ArabicText` widget with auto-detection
- ✅ Created `ArabicDirectionality` wrapper for complex layouts

**How to Use:**
```dart
// Before (❌ wrong alignment)
Text('النص')

// After (✅ correct RTL direction)
ArabicText('النص')

// Or for multiple widgets
ArabicDirectionality(
  detectTextFrom: materialName,
  child: Column(
    children: [
      Text(materialName),
      Text(materialDescription),
    ],
  ),
)
```

---

### Issue 5: Cloudinary Upload Fails With Corrupted Response

**Symptom:**
```
Upload image, then secure_url shows garbled characters
JSON parsing error
```

**Root Cause:** `bytesToString()` method loses UTF-8 encoding context

**Fix Applied:**
- ✅ Updated `uploadImageToCloudinary()` in `recycling_request_cubit.dart`
- ✅ Uses `utf8.decode(response.stream.toBytes())` instead
- ✅ Adds proper UTF-8 headers to request

**Verify:**
```dart
// In recycling_request_cubit.dart uploadImageToCloudinary() - lines 242-263
final response = await request.send();
// ✅ FIXED: Use utf8.decode(toBytes()) instead of bytesToString()
final responseBytes = await response.stream.toBytes();
final responseData = utf8.decode(responseBytes);
final data = json.decode(responseData);
```

---

### Issue 6: Mixed Language Text (English + Arabic)

**Symptom:**
```
"مرحبا Welcome" displays as "Welcome مرحبا" or vice versa
```

**Root Cause:** Bidirectional text needs proper handling

**Fix Applied:**
- ✅ `ArabicText` auto-detects language of the string
- ✅ Sets proper `textDirection` based on detection

**How to Use:**
```dart
// Single string with mixed content
ArabicText('مرحبا بك في EcoCycle') // Detects Arabic, sets RTL

// Multiple strings - use wrapper
ArabicDirectionality(
  detectTextFrom: userMessage, // Detect from main content
  child: Column(
    children: [
      Text(userMessage),
      Text(subtitle),
    ],
  ),
)
```

---

## Diagnostic Steps

### Step 1: Identify Where Corruption Happens

Add these debug prints to find the exact problem:

```dart
// In recycling_request_cubit.dart getCenters():
final snapshot = await FirebaseFirestore.instance.collection('centers').get();

for (var doc in snapshot.docs) {
  String rawName = doc['name'] as String;
  print('=== DEBUG getCenters ===');
  print('Raw name: $rawName');
  print('Name length: ${rawName.length}');
  print('Code units: ${rawName.codeUnits}');
  print('Bytes: ${utf8.encode(rawName)}');
  print('Fixed name: ${_fixUtf8Corruption(rawName)}');
  print('=======================');
}
```

### Step 2: Check if Issue is in Transport (API)

```dart
// Temporary debug code
Future<void> testApiEncoding() async {
  try {
    final response = await http.get(Uri.parse('https://your-api.com/test'));
    
    print('=== DEBUG HTTP Response ===');
    print('Status: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body bytes: ${response.bodyBytes}');
    print('Body string (wrong): ${response.body}');
    print('Body UTF-8 decoded (correct): ${utf8.decode(response.bodyBytes)}');
    print('===========================');
  } catch (e) {
    print('Error: $e');
  }
}
```

### Step 3: Verify Widget Display

```dart
// In your screen, temporarily add:
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        children: [
          // Test hardcoded Arabic
          Text('ورق', style: TextStyle(fontSize: 24), textDirection: TextDirection.rtl),
          SizedBox(height: 20),
          
          // Test from variable
          ArabicText(materialName, style: TextStyle(fontSize: 24)),
          
          // Debug info
          Text('Material: $materialName'),
          Text('Is correct: ${materialName == 'ورق'}'),
        ],
      ),
    ),
  );
}
```

---

## Quick Fix Checklist

- [ ] Created `lib/core/services/http_service.dart`? 
- [ ] Created `lib/core/widgets/arabic_text.dart`?
- [ ] Updated `recycling_request_cubit.dart` (Cloudinary + getCenters)?
- [ ] Updated `statistics_cubit.dart` (getStatisticsData)?
- [ ] Replaced `Text()` with `ArabicText()` in screens?
- [ ] Tested with actual Arabic data?

---

## Common Mistakes to Avoid

❌ **Mistake 1:** Still using `response.body` directly
```dart
// DON'T do this:
final data = jsonDecode(response.body);
```
✅ **Fix:**
```dart
// DO this:
final data = jsonDecode(utf8.decode(response.bodyBytes));
```

---

❌ **Mistake 2:** Not using ArabicText for dynamic content
```dart
// DON'T do this:
Text(dynamicArabicString) // No RTL, no encoding fixes
```
✅ **Fix:**
```dart
// DO this:
ArabicText(dynamicArabicString) // Auto-detects, fixes encoding, sets RTL
```

---

❌ **Mistake 3:** Forgetting to import utf8
```dart
// DON'T forget:
import 'dart:convert'; // Needed for utf8
```

---

❌ **Mistake 4:** Modifying the hardcoded Arabic strings
```dart
// These are CORRECT and should stay:
selectedMaterial = 'بلاستيك';  // ✅ Correct
materialText = 'ورق';          // ✅ Correct
```
Don't change these to English - they're properly stored in your `.dart` files as UTF-8.

---

## Expected Results After Fixes

| Before | After |
|--------|-------|
| "Ø§Ù„Ù†Øµ" | "النص" ✅ |
| Text backwards | Text RTL (correct) ✅ |
| API fails | API works ✅ |
| Mixed languages confusing | Clear separation ✅ |
| Cloudinary fails | Upload works ✅ |

---

## Still Having Issues?

1. **Check file encoding:** Ensure all `.dart` files are saved as UTF-8
   - VS Code: Bottom right, click "UTF-8"
   - Android Studio: File → File Encoding → UTF-8

2. **Clear app cache:**
   - Android: `flutter clean`
   - iOS: `flutter clean` + delete build folder

3. **Rebuild:**
   ```bash
   flutter pub get
   flutter clean
   flutter run
   ```

4. **Check Firestore data:**
   - Open Firebase Console
   - Check if center names are stored as Arabic (not corrupted in database)

5. **Monitor network:**
   - Use Charles Proxy to see actual HTTP responses
   - Verify Content-Type headers include charset=utf-8

---

## More Help

See `ARABIC_ENCODING_FIX.md` for detailed technical explanations.
See `ARABIC_ENCODING_IMPLEMENTATION.md` for integration steps.
