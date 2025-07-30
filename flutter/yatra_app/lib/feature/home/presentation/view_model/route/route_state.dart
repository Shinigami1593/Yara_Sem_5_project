// lib/feature/home/presentation/view_model/state/route_state.dart

import 'package:equatable/equatable.dart';
import 'package:yatra_app/feature/home/domain/entity/route_entity.dart';

abstract class RouteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteLoaded extends RouteState {
  final List<RouteEntity> routes;

  RouteLoaded(this.routes);

  @override
  List<Object?> get props => [routes];
}

class RouteError extends RouteState {
  final String message;

  RouteError(this.message);

  @override
  List<Object?> get props => [message];
}
