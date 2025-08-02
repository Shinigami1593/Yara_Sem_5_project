// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripModel _$TripModelFromJson(Map<String, dynamic> json) => TripModel(
      id: json['_id'] as String,
      route: RouteModel.fromJson(json['route'] as Map<String, dynamic>),
      vehicle: VehicleModel.fromJson(json['vehicle'] as Map<String, dynamic>),
      departureTime: json['departureTime'] as String? ?? '',
      arrivalTime: json['arrivalTime'] as String? ?? '',
      status: json['status'] as String? ?? 'scheduled',
      createdAt: TripModel._dateTimeFromJson(json['createdAt']),
    );

Map<String, dynamic> _$TripModelToJson(TripModel instance) => <String, dynamic>{
      '_id': instance.id,
      'route': instance.route.toJson(),
      'vehicle': instance.vehicle.toJson(),
      'departureTime': instance.departureTime,
      'arrivalTime': instance.arrivalTime,
      'status': instance.status,
      'createdAt': TripModel._dateTimeToJson(instance.createdAt),
    };
