import './base/libraryExport.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoryState();
}

class _CategoryState extends State<CategoryScreen> {
  List<CartSummery> cart = List<CartSummery>();
  List<Map> _category;
  List<Map> _slider;
  List<Map> _list;
  List<Map> _temp;

  @override
  void initState() {
    super.initState();
    HttpClient().landingPage().then((source) => {
          setState(() {
            Map response = jsonDecode(source);
            if (response['status'] == '200' && response['result'] == 1) {
              HttpClient().getCoverImage().then((source) => {
                    setState(() {
                      webStore();
                      loadListing(0);
                      Map response = jsonDecode(source);
                      if (response['status'] == '200') {
                        _slider = List<Map>();
                        response['result'].forEach((v) {
                          _slider.add(v);
                        });
                      }
                    })
                  });
            } else {
              webStore();
            }
          })
        });

    onBackPressed();
  }

  webStore() {
    ApiClient().getWebstoreL1().then((value) => {
          print(value.data),
          setState(() {
            Map response = value.data;
            _category = List<Map>();
            if (response['status'] == '200') {
              response['result'].forEach((v) {
                _category.add(v);
              });
            }
          }),
        });
  }

  onBackPressed() {
    print('Back Pressed');
    String key = AppConstants.USER_CART_DATA;
    AppPreferences.getString(key).then((value) => {
          setState(() {
            if (value != null) {
              cart = List<CartSummery>();
              for (Map json in jsonDecode(value)) {
                cart.add(CartSummery.fromJson(json));
              }
            }
          })
        });
  }

  Widget getCart() {
    return cart.isEmpty
        ? IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => OrderCartScreen(),
                ),
              ).then(
                (value) => onBackPressed(),
              );
            })
        : GFIconBadge(
            child: GFIconButton(
              size: GFSize.LARGE,
              color: Colors.transparent,
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => OrderCartScreen(),
                  ),
                ).then(
                  (value) => onBackPressed(),
                );
              },
            ),
            counterChild: GFBadge(
              shape: GFBadgeShape.circle,
              color: Colors.orangeAccent,
              child: Text(cart.length.toString()),
            ),
          );
  }

  loadListing(int pos) {
    HttpClient().getListingData(pos).then((source) => {
          setState(() {
            Map response = jsonDecode(source);
            if (response['status'] == '200') {
              if (_temp == null) _temp = List<Map>();
              _temp.add({getTitle(pos): response['result']});
              if (pos < 3) {
                loadListing(pos + 1);
              } else {
                _list = _temp;
              }
            }
          })
        });
  }

  String getTitle(int pos) {
    switch (pos) {
      case 0:
        return 'Top Trending';
      case 1:
        return 'New Arrival';
      case 2:
        return 'Deal of the month';
      case 3:
        return 'Feature products';
    }
    return 'Error';
  }

  Widget getSlider(double _width) {
    return _slider != null
        ? Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: GFCarousel(
                height: 200,
                items: _slider.map((_image) {
                  return FadeInImage.assetNetwork(
                    height: 200,
                    width: _width,
                    image: _image['cover_image'],
                    placeholder: 'images/iv_empty.png',
                  );
                }).toList(),
                autoPlay: true,
                pagination: true,
                viewportFraction: 1.0,
                onPageChanged: (index) {
                  setState(() {
                    index;
                  });
                }))
        : SizedBox(height: 0);
  }

  Widget getListData(double _width) {
    return _list != null
        ? Column(
            children: _list.map((item) {
            List<Widget> children = List();
            item.forEach((key, value) {
              print('keys $key');
              print('item value $value');
              for (Map product in value) {
                print('item value 2 $product');
                children.add(
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ProductDetailScreen(product['id']),
                        ),
                      ).then(
                        (value) => {onBackPressed()},
                      );
                    },
                    child: Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: FadeInImage.assetNetwork(
                          image: product['image'],
                          placeholder: 'images/iv_empty.png',
                          height: 80,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(3, 0, 0, 9),
                        child: Text(
                          product['print_name'],
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(3, 0, 0, 9),
                        child: GFRating(
                            value: 3.5, size: 18, color: Colors.orange),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(3, 0, 0, 9),
                        child: Text(
                          'Price ₹ ${product['trade_price']}',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15, color: Colors.orange),
                        ),
                      ),
                    ]),
                  ),
                );
              }
            });
            return Column(children: <Widget>[
              Container(
                width: _width,
                decoration: BoxDecoration(color: Colors.grey.shade300),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    '${item.keys.first.toString().toUpperCase()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
              ),
              Container(
                height: 182,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: children,
                ),
              ),
            ]);
          }).toList())
        : SizedBox(height: 0);
  }

  Widget getCategory(double _width) {
    return Column(children: <Widget>[
      _list != null
          ? Container(
              width: _width,
              decoration: BoxDecoration(color: Colors.grey.shade300),
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'ALL CATEGORY',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
            )
          : SizedBox(height: 0),
      StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _category.length,
        staggeredTileBuilder: (int index) =>
            index == _category.length - 1 && _category.length.isOdd
                ? StaggeredTile.fit(2)
                : StaggeredTile.fit(1),
        itemBuilder: (BuildContext context, int index) => Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      SubCategoryL2Screen(id: _category[index]['id']),
                ),
              ).then(
                (value) => onBackPressed(),
              );
            },
            child: Column(children: <Widget>[
              SizedBox(height: 20),
              FadeInImage.assetNetwork(
                placeholder: 'images/iv_empty.png',
                image: _category[index]['image'],
                fit: BoxFit.contain,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(6, 12, 6, 18),
                child: Text(
                  _category[index]['category'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
              )
            ]),
          ),
          elevation: 3.0,
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Store'),
        actions: <Widget>[
          getCart(),
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () {
                Share.share(AppConstants.SHARE_STORE);
              }),
        ],
      ),
      body: _category == null
          ? Center(
              child: GFLoader(loaderColorOne: Colors.white),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: MaterialButton(
                      height: 55,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(color: Colors.blue.shade300),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ProductSearchScreen(),
                          ),
                        ).then(
                          (value) => onBackPressed(),
                        );
                      },
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.blueGrey,
                          )
                        ],
                      ),
                    ),
                  ),
                  getSlider(width),
                  getListData(width),
                  getCategory(width),
                ]),
              ),
            ),
    );
  }
}

class SubCategoryL2Screen extends StatefulWidget {
  final int id;

  SubCategoryL2Screen({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubCategoryL2State();
}

class _SubCategoryL2State extends State<SubCategoryL2Screen> {
  List<CartSummery> cart = List<CartSummery>();
  List<Map> _list;

  @override
  void initState() {
    super.initState();

    ApiClient().getWebstoreL2(widget.id).then((value) => {
          print(value.data),
          setState(() {
            Map response = value.data;
            _list = List();
            if (response['status'] == '200') {
              response['result'].forEach((v) {
                _list.add(v);
              });
            }
          }),
        });
    onBackPressed();
  }

  onBackPressed() {
    print('Back Pressed');
    String key = AppConstants.USER_CART_DATA;
    AppPreferences.getString(key).then((value) => {
          setState(() {
            if (value != null) {
              cart = List<CartSummery>();
              for (Map json in jsonDecode(value)) {
                cart.add(CartSummery.fromJson(json));
              }
            }
          })
        });
  }

  Widget getCart() {
    return cart.isEmpty
        ? IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => OrderCartScreen(),
                ),
              ).then(
                (value) => onBackPressed(),
              );
            })
        : GFIconBadge(
            child: GFIconButton(
              size: GFSize.LARGE,
              color: Colors.transparent,
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => OrderCartScreen(),
                  ),
                ).then(
                  (value) => onBackPressed(),
                );
              },
            ),
            counterChild: GFBadge(
              shape: GFBadgeShape.circle,
              color: Colors.orangeAccent,
              child: Text(
                cart.length.toString(),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('search by category'),
        actions: <Widget>[
          getCart(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: _list == null
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
                : GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 3.0,
                    crossAxisSpacing: 3.0,
                    children: List.generate(
                      _list.length,
                      (index) => Card(
                        elevation: 8.0,
                        child: InkWell(
                          onTap: () {
                            int id = _list[index]['id'];
                            List<Map> array = _list[index]
                                    ['sub_category_itemwise_array']
                                .cast<Map>();
                            if (array.isEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProductListScreen(
                                    isCategory: true,
                                    id: id,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SubCategoryL3Screen(id: id),
                                ),
                              ).then(
                                (value) => onBackPressed(),
                              );
                            }
                          },
                          child: Column(children: <Widget>[
                            SizedBox(height: 20),
                            FadeInImage.assetNetwork(
                              placeholder: 'images/iv_empty.png',
                              image: _list[index]['image'],
                              fit: BoxFit.contain,
                              height: 60,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(6, 12, 6, 18),
                              child: Text(
                                _list[index]['sub_category'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

class SubCategoryL3Screen extends StatefulWidget {
  final int id;

  SubCategoryL3Screen({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubCategoryL3State();
}

class _SubCategoryL3State extends State<SubCategoryL3Screen> {
  List<CartSummery> cart = List<CartSummery>();
  List<Map> _list;

  @override
  void initState() {
    super.initState();
    ApiClient().getWebstoreL3(widget.id).then((value) => {
          print(value.data),
          setState(() {
            Map response = value.data;
            _list = List<Map>();
            if (response['status'] == '200') {
              response['result'].forEach((v) {
                _list.add(v);
              });
            }
          }),
        });
    onBackPressed();
  }

  onBackPressed() {
    print('Back Pressed');
    String key = AppConstants.USER_CART_DATA;
    AppPreferences.getString(key).then((value) => {
          setState(() {
            if (value != null) {
              cart = List<CartSummery>();
              for (Map json in jsonDecode(value)) {
                cart.add(CartSummery.fromJson(json));
              }
            }
          })
        });
  }

  Widget getCart() {
    return cart.isEmpty
        ? IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => OrderCartScreen(),
                ),
              ).then(
                (value) => onBackPressed(),
              );
            })
        : GFIconBadge(
            child: GFIconButton(
              size: GFSize.LARGE,
              color: Colors.transparent,
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => OrderCartScreen(),
                  ),
                ).then(
                  (value) => onBackPressed(),
                );
              },
            ),
            counterChild: GFBadge(
              shape: GFBadgeShape.circle,
              color: Colors.orangeAccent,
              child: Text(
                cart.length.toString(),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Sub Category'),
        actions: <Widget>[
          getCart(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: _list == null
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
                : GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    children: List.generate(
                      _list.length,
                      (index) => Card(
                        elevation: 8.0,
                        child: InkWell(
                          onTap: () {
                            int id = _list[index]['id'];
                            List<Map> array = _list[index]
                                    ['sub_category_itemwise_array']
                                .cast<Map>();
                            if (array.isEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProductListScreen(id: id),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SubCategoryL4Screen(id: id),
                                ),
                              ).then(
                                (value) => onBackPressed(),
                              );
                            }
                          },
                          child: Column(children: <Widget>[
                            SizedBox(height: 20),
                            Image(
                              height: 60,
                              image: AssetImage('images/iv_empty.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(6, 12, 6, 18),
                              child: Text(
                                _list[index]['product_master_category_name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

class SubCategoryL4Screen extends StatefulWidget {
  final int id;

  SubCategoryL4Screen({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubCategoryL4State();
}

class _SubCategoryL4State extends State<SubCategoryL4Screen> {
  List<CartSummery> cart = List<CartSummery>();
  List<Map> _list;

  @override
  void initState() {
    super.initState();
    ApiClient().getWebstoreL4(widget.id).then((value) => {
          print(value.data),
          setState(() {
            _list = List<Map>();
            Map response = value.data;
            if (response['status'] == '200') {
              response['result'].forEach((v) {
                _list.add(v);
              });
            }
          }),
        });
    onBackPressed();
  }

  onBackPressed() {
    print('Back Pressed');
    String key = AppConstants.USER_CART_DATA;
    AppPreferences.getString(key).then((value) => {
          setState(() {
            if (value != null) {
              cart = List<CartSummery>();
              for (Map json in jsonDecode(value)) {
                cart.add(CartSummery.fromJson(json));
              }
            }
          })
        });
  }

  Widget getCart() {
    return cart.isEmpty
        ? IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => OrderCartScreen(),
                ),
              ).then(
                (value) => onBackPressed(),
              );
            })
        : GFIconBadge(
            child: GFIconButton(
              size: GFSize.LARGE,
              color: Colors.transparent,
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => OrderCartScreen(),
                  ),
                ).then(
                  (value) => onBackPressed(),
                );
              },
            ),
            counterChild: GFBadge(
              shape: GFBadgeShape.circle,
              color: Colors.orangeAccent,
              child: Text(
                cart.length.toString(),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Sub Category'),
        actions: <Widget>[
          getCart(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: _list == null
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
                : GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    children: List.generate(
                      _list.length,
                      (index) => Card(
                        elevation: 8.0,
                        child: InkWell(
                          onTap: () {
                            String id = 'product_master_sub_subcat_id';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProductListScreen(
                                  id: _list[index][id],
                                  subId: _list[index]['id'],
                                ),
                              ),
                            );
                          },
                          child: Column(children: <Widget>[
                            SizedBox(height: 20),
                            Image(
                              height: 60,
                              image: AssetImage('images/iv_empty.png'),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(6, 12, 6, 18),
                              child: Text(
                                _list[index]
                                    ['product_master_sub_category_name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

// With tab layout products
/*class SubCategoryScreen extends StatefulWidget {
  final List<SubCategory> subList;

  SubCategoryScreen({Key key, @required this.subList}) : super(key: key);

  @override
  _SubCategoryScreenState createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen>
    with SingleTickerProviderStateMixin {
  List<ProductDetails> products;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(
        initialIndex: 0, length: widget.subList.length, vsync: this);

    setState(() {
      products = null;
      int id = widget.subList[0].id;
      ApiClient().getSubCategoryProduct(id).then((value) => {
            setState(() {
              Map<String, dynamic> response = value.data;
              products = List<ProductDetails>();
              if (response['status'] == '200') {
                response['result'].forEach((v) {
                  products.add(ProductDetails.fromJson(v));
                });
              }
              print(response);
            })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('Products'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  // do something
                },
              )
            ],
            bottom: TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: Colors.amber,
              tabs: widget.subList.map((_subCategory) {
                return Tab(text: _subCategory.subCategory);
              }).toList(),
              onTap: (index) {
                setState(() {
                  products = null;
                  int id = widget.subList[index].id;
                  ApiClient().getSubCategoryProduct(id).then((value) => {
                        setState(() {
                          Map<String, dynamic> response = value.data;
                          products = List<ProductDetails>();
                          if (response['status'] == '200') {
                            response['result'].forEach((v) {
                              products.add(ProductDetails.fromJson(v));
                            });
                          }
                          print(response);
                        })
                      });
                });
              },
              isScrollable: true,
              controller: _tabController,
            )),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: products == null
              ? Center(
                  child: GFLoader(),
                )
              : products.isEmpty
                  ? Center(
                      child: Text(
                        'Empty',
                        style: TextStyle(fontSize: 48, color: Colors.black87),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(6.0),
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 8.0,
                            margin: EdgeInsets.symmetric(
                                horizontal: 1.0, vertical: 6.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 0.0),
                              leading: FadeInImage.assetNetwork(
                                image: products[index].image,
                                placeholder: 'images/ic_konnect.png',
                                height: 80,
                                width: 60,
                              ),
                              title: Text(
                                products[index].name,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '₹ ' +
                                    products[index].tradePrice +
                                    '/- 1 ' +
                                    products[index].productUnit.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ));
                      }),
        ));
  }
}*/
