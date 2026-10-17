import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';

class HealthGeneralDetailsCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final String selectedBloodType;
  final ValueChanged<String?> onBloodTypeChanged;
  final String selectedFitnessLevel;
  final ValueChanged<String?> onFitnessLevelChanged;
  final TextEditingController sportGoalController;
  final TextEditingController emergencyNameController;
  final TextEditingController emergencyPhoneController;

  const HealthGeneralDetailsCard({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.selectedBloodType,
    required this.onBloodTypeChanged,
    required this.selectedFitnessLevel,
    required this.onFitnessLevelChanged,
    required this.sportGoalController,
    required this.emergencyNameController,
    required this.emergencyPhoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.health_and_safety_outlined,
                      color: primary,
                      size: 20.s,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fitness Goal & Emergency Contact',
                          style: TextStyle(
                            fontSize: 14.s,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Blood type, goals, and emergency info',
                          style: TextStyle(fontSize: 11.s, color: grey),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: grey,
                    size: 22.s,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedBloodType,
                          items:
                              ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                                  .map(
                                    (b) => DropdownMenuItem(
                                      value: b,
                                      child: Text(b),
                                    ),
                                  )
                                  .toList(),
                          onChanged: onBloodTypeChanged,
                          decoration: InputDecoration(
                            labelText: 'Blood Type',
                            filled: true,
                            fillColor: backgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedFitnessLevel,
                          items: ['beginner', 'intermediate', 'advanced']
                              .map(
                                (f) =>
                                    DropdownMenuItem(value: f, child: Text(f)),
                              )
                              .toList(),
                          onChanged: onFitnessLevelChanged,
                          decoration: InputDecoration(
                            labelText: 'Fitness Level',
                            filled: true,
                            fillColor: backgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: sportGoalController,
                    decoration: InputDecoration(
                      labelText: 'Sport / Training Goal',
                      hintText: 'E.g. Weight loss, muscle gain...',
                      filled: true,
                      fillColor: backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: emergencyNameController,
                          decoration: InputDecoration(
                            labelText: 'Emergency Contact Name',
                            filled: true,
                            fillColor: backgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextFormField(
                          controller: emergencyPhoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Emergency Phone',
                            filled: true,
                            fillColor: backgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
