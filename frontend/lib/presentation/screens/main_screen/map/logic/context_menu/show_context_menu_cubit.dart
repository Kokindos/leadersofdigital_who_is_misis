import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/presentation/screens/main_screen/map/logic/context_menu/show_context_menu_state.dart';

class ShowContextMenuCubit extends Cubit<ShowContextMenuState> {
  ShowContextMenuCubit(super.initialState);


  void push(ShowContextMenuState s) {
    emit(s);
  }
}