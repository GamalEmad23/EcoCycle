import 'package:bloc/bloc.dart';

class NavBarCubit extends Cubit<int> {
  NavBarCubit() : super(0);

  void changeIndex(int index) => emit(index);
}
