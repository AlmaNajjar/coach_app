extension CurrencyFormatter on String {
  /// تنسيق العملة مع احترام العملة القادمة من الـ API:
  /// - إذا كانت بالدولار ($ أو USD) تبقى بالدولار ($)
  /// - إذا كانت بالليرة السورية (SYP أو S.P أو ل.س) تُعرض بصيغة (ل.س)
  String toArabicCurrency({String? symbol}) {
    if (trim().isEmpty) return '';
    final trimmed = trim();

    if (symbol != null && symbol.isNotEmpty) {
      final cleaned = trimmed
          .replaceAll('\$', '')
          .replaceAll(
            RegExp(r'USD|SYP|S\.P|ل\.س|ليرة|سورية', caseSensitive: false),
            '',
          )
          .trim();
      return '$cleaned $symbol';
    }

    // إذا كانت العملة دولار: نحافظ على الدولار
    if (trimmed.contains('\$') || trimmed.toUpperCase().contains('USD')) {
      final cleaned = trimmed
          .replaceAll('\$', '')
          .replaceAll(RegExp(r'USD', caseSensitive: false), '')
          .trim();
      return '$cleaned \$';
    }

    // إذا كانت العملة ليرة سورية (SYP / S.P / ل.س): نعرضها بصيغة ل.س
    if (trimmed.toUpperCase().contains('SYP') ||
        trimmed.toUpperCase().contains('S.P') ||
        trimmed.contains('ل.س') ||
        trimmed.contains('ليرة')) {
      final cleaned = trimmed
          .replaceAll(
            RegExp(r'SYP|S\.P|ل\.س|ليرة|سورية', caseSensitive: false),
            '',
          )
          .trim();
      return '$cleaned ل.س';
    }

    // في حال عدم وجود رمز عملة، نترك النص كما جاء من الـ API
    return trimmed;
  }
}
