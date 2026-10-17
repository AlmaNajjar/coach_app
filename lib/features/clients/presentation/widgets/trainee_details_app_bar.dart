import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';

class TraineeDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onBackTap;

  const TraineeDetailsAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: textColor),
        onPressed:
            onBackTap ??
            () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.s,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12.s,
                fontWeight: FontWeight.normal,
                color: grey,
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (trailing != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(child: trailing),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 65.h : kToolbarHeight);
}
