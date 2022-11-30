import 'package:custom_date_picker_example/custom_date_picker/custom_date_picker.dart';
import 'package:custom_date_picker_example/selected_date_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _date1;
  DateTime? _date2;
  DateTime? _date3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Spacer(),
              Text(
                'Calendar Widgets',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const SizedBox(
                height: 40,
              ),
              OutlinedButton(
                onPressed: () async {
                  final date = await showCustomDatePicker(
                      context: context, preset: Preset.none, selectedDate: _date1);
                  if (date != null) {
                    setState(() {
                      _date1 = date;
                    });
                  }
                },
                child: const Text('Without presets'),
              ),
              SelectedDateWidget(
                selectedDate: _date1,
                onTap: () {
                  setState(() {
                    _date1 = null;
                  });
                },
              ),
              OutlinedButton(
                onPressed: () async {
                  final date = await showCustomDatePicker(
                      context: context, preset: Preset.four, selectedDate: _date2);
                  if (date != null) {
                    setState(() {
                      _date2 = date;
                    });
                  }
                },
                child: const Text('With 4 presets'),
              ),
              SelectedDateWidget(
                  selectedDate: _date2,
                  onTap: () => setState(() {
                        _date2 = null;
                      })),
              OutlinedButton(
                onPressed: () async {
                  final date = await showCustomDatePicker(
                      context: context, preset: Preset.six,selectedDate: _date3);
                  if (date != null) {
                    setState(() {
                      _date3 = date;
                    });
                  }
                },
                child: const Text('With 6 presets'),
              ),
              SelectedDateWidget(
                  selectedDate: _date3,
                  onTap: () => setState(() {
                        _date3 = null;
                      })),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
