// lib/feature/home/presentation/view_model/event/route_event.dart

import 'package:equatable/equatable.dart';

abstract class RouteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchRoutesWithInputEvent extends RouteEvent {
  final String sourceName;
  final String destinationName;
  final List<double> sourceCoords;
  final List<double> destinationCoords;

  FetchRoutesWithInputEvent({
    required this.sourceName,
    required this.destinationName,
    required this.sourceCoords,
    required this.destinationCoords,
  });

  @override
  List<Object?> get props => [sourceName, destinationName, sourceCoords, destinationCoords];
}

