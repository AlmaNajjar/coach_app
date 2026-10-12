class SubscriberFormatters {
  SubscriberFormatters._();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String date(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

  /// 1500000 → 1,500,000
  static String number(double v) => v.round().toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => ',',
      );

  static String money(double v, String currency) =>
      currency.isEmpty ? number(v) : '${number(v)} $currency';

  static String initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return parts
        .take(2)
        .map((w) => String.fromCharCode(w.runes.first))
        .join()
        .toUpperCase();
  }
}