import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkillTile extends StatelessWidget {
  final Color tileColor;
  final String tileText;
  const SkillTile({
    super.key,
    required this.tileColor,
    required this.tileText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(
          5.r,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? 16.sp
                  : 32.sp,
          vertical: MediaQuery.of(context).orientation == Orientation.landscape
              ? 6.sp
              : 12.sp,
        ),
        child: Text(
          tileText,
          style: TextStyle(
            fontSize:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 15.sp
                    : 45.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
