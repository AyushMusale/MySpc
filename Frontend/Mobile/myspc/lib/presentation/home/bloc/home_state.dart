import 'package:equatable/equatable.dart';
import '../models/home_model.dart';

enum HomeStatus { initial, success }

/// The success state is ready to carry the server's home payload.
class HomeState extends Equatable {
  const HomeState({this.status = HomeStatus.initial, this.home});

  const HomeState.success(HomeModel home)
      : status = HomeStatus.success,
        home = home;

  final HomeStatus status;
  final HomeModel? home;

  @override
  List<Object?> get props => [status, home];
}
