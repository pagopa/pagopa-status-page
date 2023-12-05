import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<bool> {
  SettingsCubit() : super(false);

  void toggle() => emit(!state);
}