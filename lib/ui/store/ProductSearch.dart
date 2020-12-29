import '../base/libraryExport.dart';

class ProductSearchScreen extends StatefulWidget {
  final bool isBack;

  const ProductSearchScreen({Key key, this.isBack = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearchScreen> {
  List<ProductDetails> mainDataList = List<ProductDetails>();
  List<CartSummery> cart = List<CartSummery>();
  List<ProductDetails> products;

  @override
  void initState() {
    super.initState();
    ApiClient().getProductCart().then((value) => {
          setState(() {
            Map<String, dynamic> response = value.data;
            products = List<ProductDetails>();
            if (response['status'] == '200') {
              response['result'].forEach((v) {
                products.add(ProductDetails.fromJson(v));
              });
            }
            mainDataList.addAll(products);
            print(response);
          })
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
              child: Text(cart.length.toString()),
            ),
          );
  }

  onChang(String value) {
    setState(() {
      products = mainDataList.where((item) => item.name.toLowerCase().contains(
                  value.toLowerCase(),),).toList();
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
        title: Text('Search Products'),
        actions: <Widget>[
          getCart(),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              autofocus: false,
              onChanged: onChang,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Search Here...',
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
              ),
            ),
          ),
          Expanded(
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
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 8.0,
                            child: InkWell(
                              onTap: () {
                                final int id = products[index].id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProductDetailScreen(id),
                                  ),
                                ).then((value) => {
                                      if (value && widget.isBack ?? false)
                                        Navigator.of(context).pop(true)
                                      else
                                        onBackPressed()
                                    });
                              },
                              child: ListTile(
                                leading: FadeInImage.assetNetwork(
                                  image: products[index].image,
                                  placeholder: 'images/iv_empty.png',
                                  height: 80,
                                  width: 60,
                                ),
                                title: Text(
                                  '${products[index].name}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '₹ ${products[index].tradePrice}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        }),
          )
        ]),
      ),
    );
  }
}
