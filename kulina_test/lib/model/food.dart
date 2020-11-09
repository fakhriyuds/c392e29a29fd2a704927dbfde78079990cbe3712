import 'package:json_annotation/json_annotation.dart';

part 'food.g.dart';

@JsonSerializable(nullable: true,explicitToJson: true)
class Food {
  Food({
    this.id,
    this.name,
    this.image_url,
    this.brand_name,
    this.package_name,
    this.price,
    this.rating,
    this.qty,
    this.date

  });

  int id;
  String name;
  String image_url;
  String brand_name;
  String package_name;
  int price;
  double rating;
  String date;
  @JsonKey(defaultValue: 0)
  int qty;

  factory Food.fromJson(Map<String,dynamic>json) =>_$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);
}