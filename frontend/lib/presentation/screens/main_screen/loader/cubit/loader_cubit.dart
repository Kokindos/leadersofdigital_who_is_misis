import 'package:flutter_bloc/flutter_bloc.dart';

enum LoaderState { none, inProgress, downloaded }

class LoaderCubit extends Cubit<LoaderState> {
  LoaderCubit(super.initialState);

  void load(LoaderState state) async {
   emit(state);
  }
}
