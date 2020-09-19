import 'package:dio/src/response.dart';

import '../base/libraryExport.dart';

class ProductListScreen extends StatefulWidget {
  final bool isCategory;
  final int id, subId;

  ProductListScreen(
      {Key key, this.isCategory = false, this.id = 0, this.subId = 0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<CartSummery> cart = List<CartSummery>();
  List<ProductDetails> _list;

  @override
  void initState() {
    super.initState();
    String key = AppConstants.USER_CART_DATA;
    AppPreferences.getString(key).then((value) => {
          setState(() {
            if (value != null) {
              for (Map json in jsonDecode(value)) {
                cart.add(CartSummery.fromJson(json));
              }
            }
          })
        });

    if (widget.isCategory) {
      refreshData(ApiClient().getSubCategoryProduct(widget.id));
    }
    //
    else {
      refreshData(ApiClient().get3FourthProduct(widget.id, widget.subId));
    }
  }

  void onItemClicked(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ProductDetailScreen(id),
      ),
    ).then(
      (value) => {
        if (value)
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => OrderCartScreen()),
            )
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _count = 2; //_crossAxisCount
    var _spacing = 8; //_crossAxisSpacing
    var _cellHeight = 200; // _gridCellHeight
    var _screenWidth = MediaQuery.of(context).size.width;
    var _width = (_screenWidth - ((_count - 1) * _spacing)) / _count;
    var _aspectRatio = _width / _cellHeight;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Products'),
        actions: <Widget>[
          GFIconBadge(
            child: GFIconButton(
              size: GFSize.LARGE,
              color: Colors.transparent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => OrderCartScreen()),
                );
              },
              icon: Icon(Icons.shopping_cart, color: Colors.white),
            ),
            counterChild: GFBadge(
              shape: GFBadgeShape.circle,
              color: Colors.orangeAccent,
              child: Text(cart.length.toString()),
            ),
          )
        ],
      ),
      body: _list == null
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: GFLoader(loaderColorOne: Colors.white),
              ),
            )
          : _list.isEmpty
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      'Empty',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _count, childAspectRatio: _aspectRatio),
                  itemCount: _list.length,
                  itemBuilder: (context, index) {
                    return Card(
                        elevation: 8.0,
                        child: InkWell(
                          onTap: () {
                            onItemClicked(_list[index].id);
                          },
                          child: Stack(children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: FadeInImage.assetNetwork(
                                        image: _list[index].image,
                                        placeholder: 'images/iv_empty.png',
                                        height: 80,
                                      )),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(3, 0, 0, 9),
                                      child: Text(_list[index].name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87))),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(3, 0, 0, 9),
                                      child: GFRating(
                                          value: 3.5,
                                          size: 18,
                                          color: Colors.orange)),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(3, 0, 0, 9),
                                      child: Text(
                                          'Price ₹ ${_list[index].tradePrice}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.orange))),
                                ])),
                            Positioned.fill(
                                child: Align(
                              alignment: Alignment.topRight,
                              child: getIconButton(_list[index]),
                            ))
                          ]),
                        ));
                  }),
    );
  }

  void refreshData(Future<Response<Map>> product) {
    product.then((value) => {
          print(value.data),
          setState(() {
            Map response = value.data;
            _list = List<ProductDetails>();
            if (response['status'] == '200') {
              response['result'].forEach((v) {
                _list.add(ProductDetails.fromJson(v));
              });
            }
          })
        });
  }

  IconButton getIconButton(ProductDetails favoriteItem) {
    CartSummery existingItem = cart.firstWhere(
        (itemToCheck) => itemToCheck.id == favoriteItem.id,
        orElse: () => null);
    if (existingItem == null) {
      return IconButton(
        icon: Icon(Icons.add_shopping_cart, color: Colors.green),
        onPressed: () {
          if (favoriteItem.itemList.isEmpty) {
            setState(() {
              cart.add(CartSummery.fromProductDetails(favoriteItem));
              String key = AppConstants.USER_CART_DATA;
              AppPreferences.setString(key, jsonEncode(cart));
              print(jsonEncode(cart));
              print('Item Added');
            });
          } else {
            onItemClicked(favoriteItem.id);
          }
        },
      );
    }
    // Remove Shopping cart
    else {
      return IconButton(
        icon: Icon(Icons.remove_shopping_cart, color: Colors.deepOrange),
        onPressed: () {
          setState(() {
            cart.removeWhere(
                (itemToCheck) => itemToCheck.id == favoriteItem.id);
            String key = AppConstants.USER_CART_DATA;
            AppPreferences.setString(key, jsonEncode(cart));
            print(jsonEncode(cart));
            print("Item Removed");
          });
        },
      );
    }
  }
}
