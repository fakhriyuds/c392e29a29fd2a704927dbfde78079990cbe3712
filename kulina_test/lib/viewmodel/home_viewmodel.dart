import 'dart:convert';

import 'package:kulina_test/model/food.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class HomeViewModel {

  List<Food> foodList;
  int totalCart = 0;


  Future<List<Food>> getData({int page, int limit}) async {
    var url =
        'https://kulina-recruitment.herokuapp.com/products?_limit=$limit&?page=$page';
    var response = await http.get(url);
    List responseFood = json.decode(response.body);
    List<Food> listFoods = responseFood.map((e) => Food.fromJson(e)).toList();
    print(listFoods);
    return listFoods;
  }
}
