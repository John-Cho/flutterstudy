import 'package:infrun/common/const/data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange { expensive, medium, cheap }

@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json){
    return _$RestaurantModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);


  // factory RestaurantModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantModel(
  //       id: json['id'],
  //       name: json['name'],
  //       thumbUrl: json['thumbUrl'],
  //       tags: List<String>.from(json['tags']),
  //       priceRange: RestaurantPriceRange.values.firstWhere(
  //         (element) {
  //           return element.name == json['priceRange'];
  //         },
  //       ),
  //       ratings: json['ratings'],
  //       ratingsCount: json['ratingsCount'],
  //       deliveryTime: json['deliveryTime'],
  //       deliveryFee: json['deliveryFee']);
  // }
}