import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';

class PersonalInfoSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController dobController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController weightTargetController;
  final TextEditingController startDateController;
  final String selectedGender;
  final ValueChanged<String?> onGenderChanged;

  const PersonalInfoSection({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.dobController,
    required this.heightController,
    required this.weightController,
    required this.weightTargetController,
    required this.startDateController,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  // للتحكم بفتح وإغلاق الكارت
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor, // خلفية بيضاء من ملف constant
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
          // 1. شريط العنوان التفاعلي (عند الضغط عليه يفتح أو يغلق)
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(8.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: primary,
                        size: 20.s,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 15.s,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: grey,
                  size: 24.s,
                ),
              ],
            ),
          ),

          // 2. الحقول تظهر فقط عندما يكون الكارت مفتوحاً
          if (_isExpanded) ...[
            SizedBox(height: 16.h),
            Divider(color: grey.withOpacity(0.15), height: 1),
            SizedBox(height: 16.h),

            // السطر الأول: Name & Age
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Full Name',
                    controller: widget.nameController, // ✅ نمرر الكونترولر
                    hint: 'Enter full name',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildFormField(
                    label: 'Age',
                    controller: widget.ageController, // ✅ نمرر الكونترولر
                    hint: 'e.g. 25',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Date of Birth',
                    controller: widget.dobController,
                    hint: 'YYYY-MM-DD',
                    readOnly: true, // يمنع لوحة المفاتيح
                    suffixIcon: Icons.calendar_today_outlined,
                    onTap: () => _selectDate(
                      context,
                      widget.dobController,
                    ), // ✅ يفتح التقويم
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildGenderDropdown(), // ✅ قائمة اختيار الجنس
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // السطر الثالث: Height & Weight
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Height (cm)',
                    controller: widget.heightController,
                    hint: 'e.g. 178',
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildFormField(
                    label: 'Weight (kg)',
                    controller: widget.weightController,
                    hint: 'e.g. 75',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // السطر الرابع: Weight Target & Date of Start
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Weight Target (kg)',
                    controller: widget.weightTargetController,
                    hint: 'e.g. 70',
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildFormField(
                    label: 'Date of Start',
                    controller: widget.startDateController,
                    hint: 'YYYY-MM-DD',
                    readOnly: true,
                    suffixIcon: Icons.calendar_today_outlined,
                    onTap: () => _selectDate(
                      context,
                      widget.startDateController,
                    ), // ✅ يفتح التقويم
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // دالة مساعدة مخصصة لرسم الحقول المربعة بأناقة
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.s,
            fontWeight: FontWeight.w500,
            color: grey,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          readOnly:
              readOnly, // للتواريخ نجعلها للقراءة فقط ونفتح التقويم عند الضغط
          onTap: onTap,
          keyboardType: keyboardType, // مثلاً أرقام للوزن والطول
          style: TextStyle(
            fontSize: 13.s,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 12.s, color: grey.withOpacity(0.5)),
            filled: true,
            fillColor: backgroundColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, size: 16.s, color: grey)
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: grey.withOpacity(0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: primary)),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formatted =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      controller.text = formatted;
    }
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 12.s,
            fontWeight: FontWeight.w500,
            color: grey,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: grey.withOpacity(0.15)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.selectedGender,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20.s,
                color: grey,
              ),
              items: ['Male', 'Female'].map((String val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(
                    val,
                    style: TextStyle(
                      fontSize: 13.s,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                );
              }).toList(),
              onChanged: widget.onGenderChanged,
            ),
          ),
        ),
      ],
    );
  }
}
