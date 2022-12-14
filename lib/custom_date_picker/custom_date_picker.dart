import 'package:custom_date_picker_example/cubits/preset_cubit.dart';
import 'package:custom_date_picker_example/custom_date_picker/custom_calendar.dart';
import 'package:custom_date_picker_example/custom_date_picker/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Preset { none, four, six }

class CustomDatePickerDialog extends StatelessWidget {
  final Preset preset;
  final DateTime? selectedDate;

  const CustomDatePickerDialog(
      {Key? key, required this.preset, this.selectedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (preset == Preset.none)
              const SizedBox.shrink()
            else ...[
              HeaderWidget(preset: preset),
              const SizedBox(height: 10),
            ],
            CustomCalendar(
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(DateTime.now().year, DateTime.now().month),
              lastDate: DateTime(2100),
              preset: preset,
            ),
          ],
        ),
      ),
    );
  }
}

Future<DateTime?> showCustomDatePicker(
    {required BuildContext context,
    required Preset preset,
    DateTime? selectedDate}) async {
  return await showDialog(
    context: context,
    builder: (_) => BlocProvider(
      create: (context) => PresetCubit(
        index: preset == Preset.six ? 1 : 0,
      ),
      child: CustomDatePickerDialog(preset: preset, selectedDate: selectedDate),
    ),
  );
}
