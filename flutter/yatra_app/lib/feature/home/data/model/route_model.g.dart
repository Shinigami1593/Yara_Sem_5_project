// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) => RouteModel(
      id: json['id'] as String,
      name: json['name'] as String,
      source: json['source'] as String,
      destination: json['destination'] as String,
      points: (json['points'] as List<dynamic>)
          .map((e) => CoordinateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String?,
      status: json['status'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$RouteModelToJson(RouteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'source': instance.source,
      'destination': instance.destination,
      'points': instance.points.map((e) => e.toJson()).toList(),
      'type': instance.type,
      'status': instance.status,
      'userId': instance.userId,
    };
