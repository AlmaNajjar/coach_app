import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeekCalendarCard extends StatefulWidget {
  /// اليوم المختار بالبداية (الافتراضي: اليوم الحالي)
  final DateTime? initialDate;

  /// بينادى عند اختيار يوم أو عند تغيير الأسبوع (بيرجع التاريخ بدون وقت)
  final ValueChanged<DateTime>? onDateSelected;

  const WeekCalendarCard({
    super.key,
    this.initialDate,
    this.onDateSelected,
  });

  @override
  State<WeekCalendarCard> createState() => _WeekCalendarCardState();
}

class _WeekCalendarCardState extends State<WeekCalendarCard> {
  // ───────────── Palette ─────────────
  static const Color _primary = Color(0xFF3B8FE3);
  static const Color _primaryLight = Color(0xFF63B0F5);
  static const Color _navy = Color(0xFF1B2D4F);
  static const Color _muted = Color(0xFF93A3BC);
  static const Color _soft = Color(0xFFF1F6FC);

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _monthsFull = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static const int _initialPage = 1000;

  late final PageController _controller;
  late final DateTime _baseMonday; // اثنين الأسبوع الأساسي (الصفحة 1000)
  late final DateTime _todayMonday;
  late DateTime _selected;
  int _page = _initialPage;

  @override
  void initState() {
    super.initState();
    _selected = _dateOnly(widget.initialDate ?? DateTime.now());
    _baseMonday = _mondayOf(_selected);
    _todayMonday = _mondayOf(DateTime.now());
    _controller = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ───────────── Date helpers ─────────────
  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime _mondayOf(DateTime d) =>
      DateTime(d.year, d.month, d.day - (d.weekday - 1));

  static DateTime _addDays(DateTime d, int n) =>
      DateTime(d.year, d.month, d.day + n);

  /// رقم اليوم (UTC) لتفادي مشاكل التوقيت الصيفي عند الطرح
  static int _dayNumber(DateTime d) =>
      DateTime.utc(d.year, d.month, d.day).millisecondsSinceEpoch ~/ 86400000;

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime _weekStartForPage(int page) =>
      _addDays(_baseMonday, (page - _initialPage) * 7);

  // ───────────── Header texts ─────────────
  String get _title {
    final start = _weekStartForPage(_page);
    final diffWeeks = (_dayNumber(start) - _dayNumber(_todayMonday)) ~/ 7;
    switch (diffWeeks) {
      case 0:
        return 'This Week';
      case -1:
        return 'Last Week';
      case 1:
        return 'Next Week';
      default:
        return _monthsFull[_addDays(start, 3).month - 1];
    }
  }

  String get _rangeLabel {
    final s = _weekStartForPage(_page);
    final e = _addDays(s, 6);
    return '${_months[s.month - 1]} ${s.day} – ${_months[e.month - 1]} ${e.day}';
  }

  // ───────────── Actions ─────────────
  void _goToPage(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int page) {
    HapticFeedback.selectionClick();
    // نحافظ على نفس اليوم بالأسبوع (الجمعة تبقى الجمعة)
    final newSelected =
        _addDays(_weekStartForPage(page), _selected.weekday - 1);
    setState(() {
      _page = page;
      _selected = newSelected;
    });
    widget.onDateSelected?.call(newSelected);
  }

  void _onDayTap(DateTime day) {
    if (_isSameDay(day, _selected)) return;
    HapticFeedback.selectionClick();
    setState(() => _selected = day);
    widget.onDateSelected?.call(day);
  }

  // ───────────── UI ─────────────
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // تثبيت حجم الخط داخل الكرد حتى ما يكبر مع إعدادات النظام
    return MediaQuery(
      data: mq.copyWith(textScaler: mq.textScaler.clamp(maxScaleFactor: 1.0)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 14.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: _primary.withOpacity(0.08),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            SizedBox(height: 12.h),
            _buildDivider(),
            SizedBox(height: 10.h),
            SizedBox(
              height: 60.h,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, page) => _WeekRow(
                  weekStart: _weekStartForPage(page),
                  selected: _selected,
                  labels: _weekdays,
                  onDayTap: _onDayTap,
                  addDays: _addDays,
                  dayNumber: _dayNumber,
                  isSameDay: _isSameDay,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.calendar_today_rounded, size: 17.h, color: _primary),
        SizedBox(width: 10.w),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            _title,
            key: ValueKey(_title),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _navy,
              letterSpacing: 0.1,
            ),
          ),
        ),
        const Spacer(),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            _rangeLabel,
            key: ValueKey(_rangeLabel),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: _muted,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        _ArrowButton(
          icon: Icons.chevron_left_rounded,
          onTap: () => _goToPage(_page - 1),
        ),
        SizedBox(width: 6.w),
        _ArrowButton(
          icon: Icons.chevron_right_rounded,
          onTap: () => _goToPage(_page + 1),
        ),
      ],
    );
  }

  /// خط رفيع بيتلاشى من الأطراف
  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _soft.withOpacity(0),
            const Color(0xFFE4EDF8),
            _soft.withOpacity(0),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
class _ArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: 28.h,
          height: 28.h,
          decoration: const BoxDecoration(
            color: Color(0xFFF1F6FC),
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon, size: 19.h, color: const Color(0xFF1B2D4F)),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
/// صف الأسبوع: الكبسولة الزرقاء بتنزلق خلف الأيام
class _WeekRow extends StatelessWidget {
  final DateTime weekStart;
  final DateTime selected;
  final List<String> labels;
  final ValueChanged<DateTime> onDayTap;
  final DateTime Function(DateTime, int) addDays;
  final int Function(DateTime) dayNumber;
  final bool Function(DateTime, DateTime) isSameDay;

  const _WeekRow({
    required this.weekStart,
    required this.selected,
    required this.labels,
    required this.onDayTap,
    required this.addDays,
    required this.dayNumber,
    required this.isSameDay,
  });

  static const Color _primary = Color(0xFF3B8FE3);
  static const Color _primaryLight = Color(0xFF63B0F5);
  static const Color _navy = Color(0xFF1B2D4F);
  static const Color _muted = Color(0xFF93A3BC);

  @override
  Widget build(BuildContext context) {
    final diff = dayNumber(selected) - dayNumber(weekStart);
    final hasSelection = diff >= 0 && diff < 7;
    final index = diff.clamp(0, 6);
    final today = DateTime.now();

    return Stack(
      children: [
        // ───── الكبسولة المنزلقة ─────
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: hasSelection ? 1 : 0,
            duration: const Duration(milliseconds: 280),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 480),
              curve: Curves.easeOutCubic,
              alignment: Alignment(-1 + (2 * index / 6), 0),
              child: FractionallySizedBox(
                widthFactor: 1 / 7,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [_primaryLight, _primary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _primary.withOpacity(0.28),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // ───── الأيام ─────
        Row(
          children: List.generate(7, (i) {
            final day = addDays(weekStart, i);
            final isSelected = isSameDay(day, selected);
            final isToday = isSameDay(day, today);

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onDayTap(day),
                child: _DayContent(
                  label: labels[i],
                  number: day.day,
                  selected: isSelected,
                  isToday: isToday,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════
class _DayContent extends StatelessWidget {
  final String label;
  final int number;
  final bool selected;
  final bool isToday;

  const _DayContent({
    required this.label,
    required this.number,
    required this.selected,
    required this.isToday,
  });

  static const Color _primary = Color(0xFF3B8FE3);
  static const Color _navy = Color(0xFF1B2D4F);
  static const Color _muted = Color(0xFF93A3BC);

  @override
  Widget build(BuildContext context) {
    const dur = Duration(milliseconds: 300);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: dur,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: selected ? Colors.white.withOpacity(0.85) : _muted,
            ),
            child: Text(label),
          ),
          SizedBox(height: 4.h),
          AnimatedDefaultTextStyle(
            duration: dur,
            style: TextStyle(
              fontSize: 16,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? Colors.white : _navy.withOpacity(0.88),
            ),
            child: Text('$number'),
          ),
          SizedBox(height: 5.h),
          // نقطة صغيرة تحت اليوم الحالي
          AnimatedContainer(
            duration: dur,
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isToday
                  ? (selected ? Colors.white : _primary)
                  : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}