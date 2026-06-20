import 'package:flutter/material.dart';

/// Widget that safely displays Arabic text with proper RTL direction
class ArabicText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const ArabicText(
    this.text, {
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = _isArabicText(text);

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  /// Detects if text contains Arabic characters
  bool _isArabicText(String text) {
    // Arabic Unicode ranges:
    // 0x0600–0x06FF: Arabic
    // 0x0750–0x077F: Arabic Supplement
    // 0x08A0–0x08FF: Arabic Extended-A
    // 0xFB50–0xFDFF: Arabic Presentation Forms-A
    // 0xFE70–0xFEFF: Arabic Presentation Forms-B

    for (int codeUnit in text.codeUnits) {
      if ((codeUnit >= 0x0600 && codeUnit <= 0x06FF) ||
          (codeUnit >= 0x0750 && codeUnit <= 0x077F) ||
          (codeUnit >= 0x08A0 && codeUnit <= 0x08FF) ||
          (codeUnit >= 0xFB50 && codeUnit <= 0xFDFF) ||
          (codeUnit >= 0xFE70 && codeUnit <= 0xFEFF)) {
        return true;
      }
    }
    return false;
  }
}

/// Wrapper for any widget containing Arabic text
class ArabicDirectionality extends StatelessWidget {
  final Widget child;
  final String detectTextFrom; // Text to detect language from

  const ArabicDirectionality({
    required this.child,
    required this.detectTextFrom,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = _isArabicText(detectTextFrom);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }

  bool _isArabicText(String text) {
    for (int codeUnit in text.codeUnits) {
      if ((codeUnit >= 0x0600 && codeUnit <= 0x06FF) ||
          (codeUnit >= 0x0750 && codeUnit <= 0x077F) ||
          (codeUnit >= 0x08A0 && codeUnit <= 0x08FF) ||
          (codeUnit >= 0xFB50 && codeUnit <= 0xFDFF) ||
          (codeUnit >= 0xFE70 && codeUnit <= 0xFEFF)) {
        return true;
      }
    }
    return false;
  }
}
