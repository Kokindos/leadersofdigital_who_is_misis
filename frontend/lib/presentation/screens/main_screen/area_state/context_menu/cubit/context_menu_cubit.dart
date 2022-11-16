import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

enum ContextMenuState {
  added,
  considered,
  deleted,
  info,
  none
}

class ContextMenuCubit extends Cubit<ContextMenuState> {
  ContextMenuCubit(super.initialState);

  void tapAdd() {
    emit(ContextMenuState.added);
    log("EMITTED ADDED");
  }

  void tapDelete() {
    emit(ContextMenuState.deleted);
    log("EMITTED DELETE");
  }

  void tapConsider() {
    emit(ContextMenuState.considered);
    log("EMITTED CONSIDERED");
  }

  void tapInfo() {
    emit(ContextMenuState.info);
    log("EMITTED INFO");
  }

  void tapNone() {
    emit(ContextMenuState.none);
  }
}
