import 'package:custom_date_picker_example/app_colors.dart';
import 'package:custom_date_picker_example/custom_date_picker/header_widget.dart';
import 'package:flutter/material.dart';

enum Preset { none, four, six }

class CustomDatePickerDialog extends StatefulWidget {
  final Preset preset;

  const CustomDatePickerDialog({Key? key, required this.preset})
      : super(key: key);

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HeaderWidget(),
            const SizedBox(height: 10),
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              onDateChanged: (value) {},
            ),
            Theme(
              data: ThemeData(
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    minimumSize: const Size(80, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('21 Sep 2022'),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.secondaryBlue,
                        foregroundColor: AppColors.primaryBlue,
                        minimumSize: const Size(80, 40),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.secondaryBlue,
                        minimumSize: const Size(80, 40),
                      ),
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<DateTime?> showCustomDatePicker(
    {required BuildContext context, required Preset preset}) async {
  return await showDialog(
    context: context,
    builder: (context) => CustomDatePickerDialog(preset: preset),
  );
}
