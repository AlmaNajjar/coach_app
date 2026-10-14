import 'package:coach_app/core/helper/constant.dart';
import 'package:coach_app/core/helper/responsive.dart';
import 'package:flutter/material.dart';


class TraineeDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMoreTap;

  const TraineeDetailsAppBar({
    super.key,
    this.onBackTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: textColor),
        onPressed: onBackTap ?? () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),
      title: Text(
        'Trainee Details',
        style: TextStyle(
          fontSize: 20.s,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: textColor),
          onPressed: onMoreTap ?? () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}