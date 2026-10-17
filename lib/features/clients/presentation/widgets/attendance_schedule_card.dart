import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:coach_app/features/clients/data/models/member_shift_model.dart';
import 'package:flutter/material.dart';

class AttendanceScheduleCard extends StatefulWidget {
  // كول باك لإرسال البيانات المحددة إلى صفحة تفاصيل المتدرب
  final void Function({
    required String scheduleType,
    required List<int> selectedDays,
    required String startTime,
    required String endTime,
  })?
  onScheduleChanged;

  const AttendanceScheduleCard({super.key, this.onScheduleChanged});

  @override
  State<AttendanceScheduleCard> createState() => _AttendanceScheduleCardState();
}

class _AttendanceScheduleCardState extends State<AttendanceScheduleCard> {
  // ثوابت ألوان منظمة للبطاقة
  static const _holidayBgColor = Color(0xFFF3F4F6); // رمادي ناعم ليوم العطلة
  static const _holidayBadgeBg = Color(0xFFFEE2E2); // خلفية شارة Off
  static const _holidayBadgeText = Color(0xFFDC2626); // نص شارة Off
  static const _snackBarDarkBg = Color(0xFF1E293B); // كحلي غامق للتنبيه

  int _selectedTab = 1; // 0: Daily, 1: 3 Days, 2: Random

  final List<String> _days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  final String _holiday = 'Fri'; // عطلة النادي
  final Set<String> _selectedDays = {}; // تبدأ فارغة

  int _randomDaysCount = 3;

  // أوقات التمرين الافتراضية
  TimeOfDay _startTime = const TimeOfDay(hour: 16, minute: 0); // 04:00 PM
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 30); // 05:30 PM

  @override
  void initState() {
    super.initState();
    // إشعار أولي بالبيانات الافتراضية
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyParent());
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _notifyParent() {
    if (widget.onScheduleChanged == null) return;

    String scheduleType;
    List<int> daysIndices;

    if (_selectedTab == 0) {
      scheduleType = 'daily';
      daysIndices = _days
          .where((d) => d != _holiday)
          .map((d) => d.toDayInt()) // ✅ استخدام الـ extension الذكي
          .toList();
    } else if (_selectedTab == 1) {
      scheduleType = 'three_days';
      daysIndices = _selectedDays.map((d) => d.toDayInt()).toList(); // ✅
    } else {
      scheduleType = 'custom';
      daysIndices = [];
    }

    widget.onScheduleChanged!(
      scheduleType: scheduleType,
      selectedDays: daysIndices,
      startTime: _formatTime(_startTime),
      endTime: _formatTime(_endTime),
    );
  }

  void _toggleDay(String day) {
    if (day == _holiday) return;
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        if (_selectedTab == 1 && _selectedDays.length >= 3) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              elevation: 4,
              backgroundColor: _snackBarDarkBg,
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              content: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: primary,
                      size: 18.s,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'You can only select up to 3 days!',
                      style: TextStyle(
                        fontSize: 13.s,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        _selectedDays.add(day);
      }
      _notifyParent();
    });
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
        _notifyParent();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. العنوان
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  color: primary,
                  size: 20.s,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Attendance Schedule',
                style: TextStyle(
                  fontSize: 15.s,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // 2. كبسولات أنواع الدوام الثلاثة
          Row(
            children: [
              _buildTypeTab(index: 0, title: 'Daily'),
              SizedBox(width: 8.w),
              _buildTypeTab(index: 1, title: '3 Days'),
              SizedBox(width: 8.w),
              _buildTypeTab(index: 2, title: 'Random'),
            ],
          ),
          SizedBox(height: 16.h),

          // 3. المحتوى حسب النوع المختار
          if (_selectedTab == 2) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select training days per week:',
                      style: TextStyle(
                        fontSize: 12.s,
                        color: grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '(Min 3 - Max 6)',
                      style: TextStyle(
                        fontSize: 11.s,
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [3, 4, 5, 6].map((count) {
                    final isSelected = _randomDaysCount == count;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _randomDaysCount = count);
                        _notifyParent();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 58.w,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: isSelected ? primary : backgroundColor,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isSelected ? primary : grey.withOpacity(0.2),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$count Days',
                          style: TextStyle(
                            fontSize: 12.s,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? white : textColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _days.map((day) {
                final isHoliday = day == _holiday;
                final isSelected =
                    !isHoliday &&
                    (_selectedTab == 0 || _selectedDays.contains(day));

                return GestureDetector(
                  onTap: isHoliday || _selectedTab == 0
                      ? null
                      : () => _toggleDay(day),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: isHoliday
                          ? _holidayBgColor
                          : (isSelected ? primary : backgroundColor),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isHoliday
                            ? Colors.transparent
                            : (isSelected ? primary : grey.withOpacity(0.2)),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 11.s,
                            fontWeight: FontWeight.w600,
                            color: isHoliday
                                ? const Color(0xFF6B7280)
                                : (isSelected ? white : textColor),
                          ),
                        ),
                        if (isHoliday)
                          Container(
                            margin: EdgeInsets.only(top: 2.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: _holidayBadgeBg,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: const Text(
                              'Off',
                              style: TextStyle(
                                fontSize: 9,
                                color: _holidayBadgeText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else if (isSelected) ...[
                          SizedBox(height: 2.h),
                          Icon(Icons.check, size: 12.s, color: white),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          SizedBox(height: 16.h),

          // 4. اختيار وقت التمرين (Start Time & End Time)
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTimePickerBox(
                    label: 'Start Time',
                    time: _formatTime(_startTime),
                    onTap: () => _pickTime(isStart: true),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildTimePickerBox(
                    label: 'End Time',
                    time: _formatTime(_endTime),
                    onTap: () => _pickTime(isStart: false),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerBox({
    required String label,
    required String time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: grey.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, size: 16.s, color: primary),
            SizedBox(width: 6.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10.s, color: grey),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 13.s,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeTab({required int index, required String title}) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
            if (index == 0) {
              _selectedDays.clear();
              _selectedDays.addAll(_days.where((d) => d != _holiday));
            } else if (index == 1) {
              if (_selectedDays.length > 3) {
                _selectedDays.clear();
              }
            }
            _notifyParent();
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? primary : backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.s,
              fontWeight: FontWeight.w600,
              color: isSelected ? white : grey,
            ),
          ),
        ),
      ),
    );
  }
}
