import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';

class HealthSaveButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSave;

  const HealthSaveButton({
    super.key,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton.icon(
          onPressed: isSaving ? null : onSave,
          icon: isSaving
              ? SizedBox(
                  width: 18.s,
                  height: 18.s,
                  child: CircularProgressIndicator(
                    color: white,
                    strokeWidth: 2,
                  ),
                )
              : Icon(
                  Icons.check_circle_outline_rounded,
                  size: 20.s,
                  color: white,
                ),
          label: Text(
            isSaving ? 'Saving...' : 'Save',
            style: TextStyle(
              fontSize: 15.s,
              fontWeight: FontWeight.bold,
              color: white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }
}
