import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';

/// Canonical material values used in Firestore and their localized labels.
class RecyclingMaterial {
  const RecyclingMaterial._();

  static const paper = 'paper';
  static const plastic = 'plastic';
  static const electronics = 'electronics';
  static const metal = 'metal';

  static String normalize(String value) {
    final repaired = _repairMojibake(value).trim().toLowerCase();

    if (repaired == paper || repaired.contains('ورق')) return paper;
    if (repaired == plastic || repaired.contains('بلاستيك')) return plastic;
    if (repaired == electronics || repaired.contains('إلكترونيات')) {
      return electronics;
    }
    if (repaired == metal || repaired.contains('معدن')) return metal;

    return repaired;
  }

  static String displayName(String value) {
    switch (normalize(value)) {
      case paper:
        return 'add_process.paper'.tr();
      case plastic:
        return 'add_process.plastic'.tr();
      case electronics:
        return 'add_process.electronics'.tr();
      case metal:
        return 'add_process.metal'.tr();
      default:
        return _repairMojibake(value).trim();
    }
  }

  static String _repairMojibake(String value) {
    var repaired = value;

    for (var attempt = 0; attempt < 2; attempt++) {
      if (!RegExp(r'[ÃÂØÙ]').hasMatch(repaired)) break;
      try {
        final bytes = repaired.runes.map(_windows1252Byte).toList();
        repaired = utf8.decode(bytes);
      } on FormatException {
        break;
      } on ArgumentError {
        break;
      }
    }

    return repaired;
  }

  static int _windows1252Byte(int rune) {
    if (rune <= 0xFF) return rune;

    const windows1252 = <int, int>{
      0x20AC: 0x80,
      0x201A: 0x82,
      0x0192: 0x83,
      0x201E: 0x84,
      0x2026: 0x85,
      0x2020: 0x86,
      0x2021: 0x87,
      0x02C6: 0x88,
      0x2030: 0x89,
      0x0160: 0x8A,
      0x2039: 0x8B,
      0x0152: 0x8C,
      0x017D: 0x8E,
      0x2018: 0x91,
      0x2019: 0x92,
      0x201C: 0x93,
      0x201D: 0x94,
      0x2022: 0x95,
      0x2013: 0x96,
      0x2014: 0x97,
      0x02DC: 0x98,
      0x2122: 0x99,
      0x0161: 0x9A,
      0x203A: 0x9B,
      0x0153: 0x9C,
      0x017E: 0x9E,
      0x0178: 0x9F,
    };

    final byte = windows1252[rune];
    if (byte == null) {
      throw ArgumentError.value(rune, 'rune', 'Not a Windows-1252 character');
    }
    return byte;
  }
}
