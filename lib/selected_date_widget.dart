import 'package:custom_date_picker_example/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectedDateWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback? onTap;

  const SelectedDateWidget({Key? key, this.selectedDate, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedDate == null) {
      return const SizedBox(
        height: 80,
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 28),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.secondaryBlue,
        borderRadius: BorderRadius.all(
          Radius.circular(68),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            DateFormat('dd MMM yyyy').format(selectedDate!),
            style: const TextStyle(
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: onTap,
            child: const Icon(
              Icons.close,
              color: AppColors.primaryBlue,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
