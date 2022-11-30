import 'package:custom_date_picker_example/bloc/preset_cubit.dart';
import 'package:custom_date_picker_example/custom_date_picker/header_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'custom_date_picker.dart';

class HeaderWidget extends StatelessWidget {
  final Preset preset;

  const HeaderWidget({Key? key, required this.preset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PresetCubit, int>(
      builder: (context, state) {
        return Column(
          children: [
            if (preset == Preset.four) ...[
              Row(
                children: [
                  Expanded(
                    child: HeaderItem(
                      title: 'Never Ends',
                      isSelected: state == 0,
                      onTap: () =>
                          context.read<PresetCubit>().updatePresetIndex(0),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: HeaderItem(
                      title: '15 Days Later',
                      isSelected: state == 1,
                      onTap: () =>
                          context.read<PresetCubit>().updatePresetIndex(1),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: HeaderItem(
                        title: '30 Days Later',
                        isSelected: state == 2,
                        onTap: () =>
                            context.read<PresetCubit>().updatePresetIndex(2)),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: HeaderItem(
                        title: '60 Days Later',
                        isSelected: state == 3,
                        onTap: () =>
                            context.read<PresetCubit>().updatePresetIndex(3)),
                  ),
                ],
              )
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: HeaderItem(
                        title: 'Yesterday',
                        isSelected: state == 0,
                        onTap: () =>
                            context.read<PresetCubit>().updatePresetIndex(0)),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: HeaderItem(
                        title: 'Today',
                        isSelected: state == 1,
                        onTap: () =>
                            context.read<PresetCubit>().updatePresetIndex(1)),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: HeaderItem(
                        title: 'Tomorrow',
                        isSelected: state == 2,
                        onTap: () =>
                            context.read<PresetCubit>().updatePresetIndex(2)),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: HeaderItem(
                        title: 'This Saturday',
                        isSelected: state == 3,
                        onTap: () =>
                            context.read<PresetCubit>().updatePresetIndex(3)),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: HeaderItem(
                        title: 'This Sunday',
                        isSelected: state == 4,
                        onTap: () =>
                            context.read<PresetCubit>().updatePresetIndex(4)),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: HeaderItem(
                      title:
                          'Next ${DateFormat('EEEE').format(DateTime.now())}',
                      isSelected: state == 5,
                      onTap: () =>
                          context.read<PresetCubit>().updatePresetIndex(5),
                    ),
                  ),
                ],
              )
            ]
          ],
        );
      },
    );
  }
}
