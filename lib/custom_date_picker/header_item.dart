import 'package:custom_date_picker_example/app_colors.dart';
import 'package:flutter/material.dart';

class HeaderItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const HeaderItem(
      {Key? key, required this.title, required this.isSelected, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 150,
          minHeight: 40,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.secondaryBlue,
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}
