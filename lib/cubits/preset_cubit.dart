import 'package:flutter_bloc/flutter_bloc.dart';

class PresetCubit extends Cubit<int> {
  PresetCubit({int? index}) : super(index ?? 0);

  void updatePresetIndex(int index) => emit(index);
}
