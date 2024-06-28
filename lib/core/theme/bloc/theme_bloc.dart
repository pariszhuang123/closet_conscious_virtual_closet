import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(ThemeData initialTheme) : super(ThemeState(initialTheme)) {
    on<ThemeChanged>((event, emit) {
      emit(ThemeState(event.theme));
    });
  }
}
