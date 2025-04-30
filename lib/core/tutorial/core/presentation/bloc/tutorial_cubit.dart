import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_enums.dart';

class TutorialTypeCubit extends Cubit<TutorialType?> {
  TutorialTypeCubit() : super(null);

  void setType(TutorialType type) => emit(type);
  void clear() => emit(null);
}