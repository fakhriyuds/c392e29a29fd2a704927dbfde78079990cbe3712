import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:kulina_test/model/food.dart';
import 'package:kulina_test/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final price = NumberFormat.simpleCurrency(
    decimalDigits: 0,
    locale: 'IDR',
  );
  HomeViewModel homeViewModel = HomeViewModel();
  List<Food> listCart = [];
  int totalCart = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providers = Provider.of<HomeViewModel>(context);
    listCart = providers.foodList;
    totalCart = providers.totalCart;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Review Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: listCart.any((element) => element.qty > 0)
          ? SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daftar Pesanan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      FlatButton(
                        onPressed: () {
                          listCart.forEach((element) {
                            element.qty = 0;
                          });
                          setState(() {
                            providers.totalCart = 0;
                          });
                        },
                        child: Text(
                          'Hapus Pesanan',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  GroupedListView(
                    elements:
                        listCart.where((element) => element.qty > 0).toList(),
                    groupBy: (Food e) => e.date,
                    groupSeparatorBuilder: (String element) {
                      DateTime test = DateTime.parse(element);
                      return Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          DateFormat('EEEE, MMM d yyyy', 'id').format(test),
//                  element,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                    useStickyGroupSeparators: true,
                    floatingHeader: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separator: SizedBox(
                      height: 16,
                    ),
                    itemBuilder: (BuildContext context, Food item) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(item.image_url),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 120,
//                    color: Colors.green[200],
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Text(
                                        item.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      InkWell(
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.grey,
                                        ),
                                        onTap: () {
                                          providers.totalCart -=
                                              (item.qty * item.price);
                                          setState(() {
                                            item.qty = 0;

//                                          widget.cartList.remove(item);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  Text(
                                    item.brand_name,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        price.format(item.price),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (item.qty > 1) {
                                                  setState(() {
                                                    item.qty -= 1;
                                                    providers.totalCart -=
                                                        item.price;
                                                  });
                                                }
                                              },
                                              child: SizedBox(
                                                width: 50,
                                                height: 30,
                                                child: Icon(Icons.remove),
                                              ),
                                            ),
                                            Text(item.qty.toString()),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  item.qty += 1;
                                                  providers.totalCart +=
                                                      item.price;
                                                });
                                              },
                                              child: SizedBox(
                                                width: 50,
                                                height: 30,
                                                child: Icon(Icons.add),
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    order: GroupedListOrder.ASC,
                  )
                ],
              ),
            )
          : Container(
              child: Center(
                child: Image.asset('assets/emptycart.png'),
              ),
            ),
      bottomNavigationBar: listCart.any((element) => element.qty > 0)
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              child: InkWell(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${listCart.where((element) => element.qty > 0).length} Item',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text('|',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Text(
                                'Rp $totalCart',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Text(
                            'Termasuk ongkos kirim',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
            )
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: 8),
            child: FlatButton(
                splashColor: Colors.orange,
              padding: EdgeInsets.all(16),
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Pesan Sekarang',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
          ),
    );
  }
}
