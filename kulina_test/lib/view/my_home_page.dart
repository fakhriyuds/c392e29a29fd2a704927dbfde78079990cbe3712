import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:kulina_test/model/food.dart';
import 'package:kulina_test/view/cart_page.dart';
import 'package:kulina_test/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final price = NumberFormat.simpleCurrency(
    decimalDigits: 0,
    locale: 'IDR',
  );
  bool orderClicked = false;
  List<Food> listFood = [];
  int totalCart = 0;
  int page = 1;
  DateTime selectedValue = DateTime.now();
  HomeViewModel homeViewModel = HomeViewModel();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initializeDateFormatting('id');
    homeViewModel.getData(limit: 7, page: page).then((value) {
      setState(() {
        listFood =
            List.generate(value.length, (index) => value[index]).toList();
        page += 1;
      });
    });
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted)
      homeViewModel.getData(limit: 7, page: page).then((value) {
        List<Food> listFoodNew =
            List.generate(value.length, (index) => value[index]).toList();

        setState(() {
          listFood.addAll(listFoodNew);
          page += 1;
        });
      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var top = MediaQuery.of(context).padding.top;

    int today = now.weekday;

    var dayNr = (today + 6) % 7;

    var thisMonday = now.subtract(new Duration(days: (dayNr)));
    var saturday = thisMonday.add(new Duration(days: 5));
    var sunday = thisMonday.add(new Duration(days: 6));

    final providers = Provider.of<HomeViewModel>(context);
    return Scaffold(
      extendBody: true,
//      appBar: AppBar(
//        backgroundColor: Colors.white,
//        elevation: 0,
//        leading: IconButton(
//          icon: Icon(
//            Icons.arrow_back,
//            color: Colors.grey,
//          ),
//          onPressed: () {},
//        ),
//        title: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: [
//            Row(
//              children: [
//                Text(
//                  'Alamat Pengantaran',
//                  style: TextStyle(color: Colors.black54, fontSize: 10),
//                ),
//                Icon(
//                  Icons.keyboard_arrow_down,
//                  color: Colors.orange,
//                )
//              ],
//            ),
//            Text(
//              'Kulina',
//              style: TextStyle(color: Colors.black),
//            )
//          ],
//        ),
//      ),
      body: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onLoading: _onLoading,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  floating: false,
                  expandedHeight: 140,
                  flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.grey,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Alamat Pengantaran',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 10),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.orange,
                                        )
                                      ],
                                    ),
                                    Text(
                                      'Kulina',
                                      style: TextStyle(color: Colors.black),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            )),
                      )),
                  backgroundColor: Colors.white,
                  bottom: PreferredSize(
                      preferredSize: Size.fromHeight(35),
                      child: Container(
                        child: DatePicker(
                          DateTime.now(),
                          width: 60,
                          locale: 'id',
                          height: 90,
                          initialSelectedDate: DateTime.now(),
                          daysCount: 56,
                          selectionColor: Colors.orange[50],
                          selectedTextColor: Colors.orange,
                          deactivatedColor: Colors.grey,
                          inactiveDates: [
                            saturday,
                            sunday,
                            saturday.add(Duration(days: 7)),
                            sunday.add(Duration(days: 7)),
                            saturday.add(Duration(days: 14)),
                            sunday.add(Duration(days: 14)),
                            saturday.add(Duration(days: 21)),
                            sunday.add(Duration(days: 21)),
                            saturday.add(Duration(days: 28)),
                            sunday.add(Duration(days: 28)),
                            saturday.add(Duration(days: 35)),
                            sunday.add(Duration(days: 35)),
                            saturday.add(Duration(days: 42)),
                            sunday.add(Duration(days: 42)),
                            saturday.add(Duration(days: 49)),
                            sunday.add(Duration(days: 49)),
                          ],
                          onDateChange: (date) {
                            // New date selected
                            setState(() {
                              selectedValue = date;
                            });
                          },
                        ),
                      )),
                ))
          ],
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 114,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
//                  selectedValue.toString(),
                      DateFormat('EEEE, MMM d yyyy', 'id')
                          .format(selectedValue),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    primary: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height),
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 24),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                listFood[index].image_url,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )),
//                        Container(
//                          margin: EdgeInsets.symmetric(vertical: 8),
//                          padding: EdgeInsets.all(4),
//                          child: Text(
//                            'BARU',
//                            style: TextStyle(
//                                color: Colors.white, fontSize: 12),
//                          ),
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(4),
//                            color: Colors.green,
//                          ),
//                        ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  listFood[index].rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                RatingBar(
                                  initialRating: listFood[index].rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemSize: 10,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Text(
                            listFood[index].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              listFood[index].package_name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[500]),
                            ),
                          ),
                          Text(
                            listFood[index].name,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[400]),
                          ),
                          Spacer(),
                          Wrap(
                            children: [
                              Text(
                                '${price.format(listFood[index].price)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'termasuk ongkir',
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              )
                            ],
                            spacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.end,
                          ),
                          listFood[index].qty > 0
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            if (listFood[index].qty >= 1) {
                                              setState(() {
                                                listFood[index].qty -= 1;
                                                totalCart -=
                                                    listFood[index].price;
                                              });
                                            }
                                          },
                                          child: Container(
                                              height: 35,
                                              child: Icon(
                                                Icons.remove,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey[200]))),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          height: 35,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          alignment: Alignment.center,
                                          child: Text(
                                            listFood[index].qty.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey[200])),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              listFood[index].qty += 1;
                                              totalCart +=
                                                  listFood[index].price;
                                            });
                                          },
                                          child: Container(
                                              height: 35,
                                              child: Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey[200]))),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : FlatButton(
                                  onPressed: () {
                                    listFood[index].date =
                                        selectedValue.toString();
                                    setState(() {
                                      listFood[index].qty += 1;
                                      totalCart += listFood[index].price;
                                    });
                                  },
                                  textColor: Colors.red,
                                  color: Colors.white,
                                  child: Text(
                                    'Tambah ke keranjang',
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: Colors.red)),
                                )
                        ],
                      );
                    },
                    itemCount: listFood.length,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: listFood.any((element) => element.qty > 0)
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              child: InkWell(
                onTap: () {
                  providers.foodList = listFood;
                  providers.totalCart = totalCart;
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CartPage()))
                      .then((value) {
                    setState(() {
                      totalCart = providers.totalCart;
                    });
                  });
                },
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
                                '${listFood.where((element) => element.qty > 0).length} Item',
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
                                'Rp ${totalCart}',
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
          : Container(
              height: 0,
            ),
    );
  }
}
