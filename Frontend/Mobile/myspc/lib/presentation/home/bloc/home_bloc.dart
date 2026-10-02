import 'package:bloc/bloc.dart';
import 'home_state.dart';

/// Display-only shell. Fetching and event handling are intentionally omitted.
class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(const HomeState());
}
