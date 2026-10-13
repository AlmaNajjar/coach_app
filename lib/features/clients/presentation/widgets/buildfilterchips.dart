import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';

class Buildfilterchips extends StatelessWidget {
  const Buildfilterchips({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  final List<String> chips = const ['All', 'Active', 'Upcoming', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? primary : white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? primary : grey.withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Text(
                  chips[index],
                  style: TextStyle(
                    fontSize: 12.s,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? white : grey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
