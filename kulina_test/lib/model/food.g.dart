// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Food _$FoodFromJson(Map<String, dynamic> json) {
  return Food(
    id: json['id'] as int,
    name: json['name'] as String,
    image_url: json['image_url'] as String,
    brand_name: json['brand_name'] as String,
    package_name: json['package_name'] as String,
    price: json['price'] as int,
    rating: (json['rating'] as num)?.toDouble(),
    qty: json['qty'] as int ?? 0,
    date: json['date'] as String,
  );
}

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.image_url,
      'brand_name': instance.brand_name,
      'package_name': instance.package_name,
      'price': instance.price,
      'rating': instance.rating,
      'date': instance.date,
      'qty': instance.qty,
    };
