import '../base/libraryExport.dart';

class OrderCartScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderCartScreenState();
}

class _OrderCartScreenState extends State<OrderCartScreen> {
  List<CartSummery> cartSummery = List<CartSummery>();

  @override
  void dispose() {
    String jsonCart = jsonEncode(cartSummery);
    String key = AppConstants.USER_CART_DATA;
    AppPreferences.setString(key, jsonCart);
    print('user card data Save $jsonCart');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCart();
  }

  void initCart() async {
    String key = AppConstants.USER_CART_DATA;
    String value = await AppPreferences.getString(key);

    if (value != null) {
      setState(() {
        cartSummery = List<CartSummery>();
        for (Map json in jsonDecode(value)) {
          cartSummery.add(CartSummery.fromJson(json));
        }
      });
    }
  }

  void goAllProduct() async {
    String jsonCart = jsonEncode(cartSummery);
    String key = AppConstants.USER_CART_DATA;
    AppPreferences.setString(key, jsonCart);
    print('user card data Save $jsonCart');
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            ProductSearchScreen(
              isBack: true,
            ),
      ),
    );
    initCart();
  }

  void itemRemoved(CartSummery item) {
    AwesomeDialog(
        title: 'Remove',
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        desc: 'Are you sure, you want to remove',
        btnCancelOnPress: () {
          print('Cancel On Pressed');
        },
        btnOkOnPress: () {
          setState(() {
            cartSummery.removeWhere((itemToCheck) => itemToCheck.id == item.id);
            String key = AppConstants.USER_CART_DATA;
            AppPreferences.setString(key, jsonEncode(cartSummery));
            print(jsonEncode(cartSummery));
            print('Item Removed');
          });
        }).show();
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
        title: Text('Cart'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
            ),
            onPressed: goAllProduct,
          ),
          IconButton(
            icon: Icon(
              Icons.note_add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => NotepadDefaultForm(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: cartSummery.length == 0
              ? Center(
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: goAllProduct,
            ),
          )
              : ListView.builder(
            itemCount: cartSummery.length,
            itemBuilder: (BuildContext context, int index) {
              CartSummery item = cartSummery[index];
              item.controller.addListener(() {
                item.quantity = item.controller.text;
                print('Quantity ${item.quantity}');
              });
              return Card(
                elevation: 8,
                child: Row(children: <Widget>[
                  FadeInImage.assetNetwork(
                    image: item.image,
                    placeholder: 'images/iv_empty.png',
                    height: 60,
                    width: 60,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                            child: Text(
                              item.product + ' - ' + item.extraParams,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_shopping_cart,
                                color: Colors.deepOrange),
                            onPressed: () {
                              itemRemoved(item);
                            },
                          ),
                        ]),
                        Row(children: <Widget>[
                          Text(
                            '₹ ${cartSummery[index].amount}/-',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              int value =
                                  int.tryParse(item.controller.text) ?? 0;
                              item.controller.text =
                                  (value > 1 ? value - 1 : value)
                                      .toString();
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              maxLines: 1,
                              controller: item.controller,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              int value =
                                  int.tryParse(item.controller.text) ?? 0;
                              item.controller.text =
                                  (value + 1).toString();
                            },
                          ),
                        ]),
                      ],
                    ),
                  ),
                ]),
              );
            },
          ),
        ),
        MaterialButton(
          minWidth: MediaQuery
              .of(context)
              .size
              .width,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
          ),
          height: 55,
          onPressed: () {
            if (cartSummery.length > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      OrderSummeryScreen(summery: cartSummery),
                ),
              );
            } else {
              AwesomeDialog(
                  title: 'Empty',
                  context: context,
                  desc: 'your cart is empty',
                  headerAnimationLoop: false,
                  animType: AnimType.TOPSLIDE,
                  dialogType: DialogType.WARNING,
                  btnOkOnPress: () {})
                  .show();
            }
          },
          color: Colors.lightBlueAccent,
          child: Text(
            ' ORDER SUMMARY ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}

class NotepadDefaultForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotepadDefaultFormState();
}

class _NotepadDefaultFormState extends State<NotepadDefaultForm> {
  List<CartSummery> cartSummery = List<CartSummery>();
  List<dynamic> textField = List();
  String quantityLabel = 'Quantity';
  String itemLabel = 'Item';
  bool isDefault = false;

  @override
  void initState() {
    super.initState();
    getNotepadFormApi();
  }

  void getNotepadForm() async {
    final _quantity = TextEditingController();
    final _name = TextEditingController();
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dismissOnTouchOutside: false,
      dialogType: DialogType.NO_HEADER,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(12),
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(children: <Widget>[
          Center(
            child: Text(
              'ITEM INFO',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            autofocus: false,
            controller: _name,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              hintText: itemLabel,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            autofocus: false,
            controller: _quantity,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              hintText: quantityLabel,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          )
        ]),
      ),
      btnCancelOnPress: () {},
      btnOkText: 'Next',
      btnOkOnPress: () {
        if (_name.text.isNotEmpty || _quantity.text.isNotEmpty)
          setState(() {
            cartSummery.add(
              CartSummery(
                cartSummery?.length ?? 0 + 1,
                '',
                '',
                '0',
                '0',
                _name.text,
                '',
                '',
                '',
                '',
                '0',
                _quantity.text,
                '0',
                '0',
              ),
            );
          });
      },
    ).show();
  }

  void getNotepadFormApi() async {
    Map response = (await ApiClient().getNotepadForm()).data;
    if (response['status'] == '200') {
      setState(() {
        Map result = response['result'][0];

        quantityLabel = result['add_quantity'] ?? 'Quantity';
        itemLabel = result['add_item'] ?? 'Item';

        isDefault = result['default'] == 'true' ?? false;
        textField = result['text_field'];
      });
    }
    getNotepadForm();
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
        title: Text('Notepad Default Form'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
            ),
            onPressed: getNotepadForm,
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: cartSummery.length == 0
              ? Center(
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: getNotepadForm,
            ),
          )
              : ListView.builder(
            itemCount: cartSummery.length,
            itemBuilder: (BuildContext context, int index) {
              CartSummery item = cartSummery[index];
              return Card(
                elevation: 8,
                child: Row(children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              item.product,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_shopping_cart,
                                color: Colors.deepOrange),
                            onPressed: () {
                              AwesomeDialog(
                                  title: 'Remove',
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.BOTTOMSLIDE,
                                  desc:
                                  'Are you sure, you want to remove',
                                  btnCancelOnPress: () {
                                    print('Cancel On Pressed');
                                  },
                                  btnOkOnPress: () {
                                    setState(() {
                                      cartSummery.removeWhere(
                                              (itemToCheck) =>
                                          itemToCheck.id == item.id);
                                      String key =
                                          AppConstants.USER_CART_DATA;
                                      AppPreferences.setString(
                                          key, jsonEncode(cartSummery));
                                      print(jsonEncode(cartSummery));
                                      print('Item Removed');
                                    });
                                  }).show();
                            },
                          ),
                        ]),
                        Row(children: <Widget>[
                          SizedBox(width: 120),
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              String value = item.controller.text;
                              if (int.tryParse(value) > 1) {
                                item.controller.text =
                                    (int.tryParse(value) - 1).toString();
                              }
                            },
                          ),
                          Expanded(
                            child: TextFormField(
                              maxLines: 1,
                              controller: item.controller,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              int value =
                                  int.tryParse(item.controller.text) ?? 0;
                              item.controller.text =
                                  (value + 1).toString();
                            },
                          ),
                        ]),
                      ],
                    ),
                  ),
                ]),
              );
            },
          ),
        ),
        MaterialButton(
          minWidth: MediaQuery
              .of(context)
              .size
              .width,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
          ),
          height: 55,
          onPressed: () {
            if (cartSummery.length > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      OrderSummeryScreen(summery: cartSummery),
                ),
              );
            }
            //NotepadOrderForm
            else if (isDefault) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      NotepadOrderForm(
                        textField: textField ?? [],
                      ),
                ),
              );
            }
            // Error
            else {
              AwesomeDialog(
                  title: 'Empty',
                  context: context,
                  desc: 'your cart is empty',
                  headerAnimationLoop: false,
                  animType: AnimType.TOPSLIDE,
                  dialogType: DialogType.WARNING,
                  btnOkOnPress: () {})
                  .show();
            }
          },
          color: Colors.lightBlueAccent,
          child: Text(
            isDefault && cartSummery.length == 0
                ? 'SKIP OPEN FORM'
                : 'ORDER SUMMARY',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}

class NotepadOrderForm extends StatefulWidget {
  final List<dynamic> textField;

  const NotepadOrderForm({Key key, this.textField}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotepadOrderFormState();
}

class _NotepadOrderFormState extends State<NotepadOrderForm> {
  List<CartSummery> cartSummery = List<CartSummery>();
  List<Map> orderForm = List<Map>();

  @override
  void initState() {
    super.initState();
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
        title: Text('Notepad Order Form'),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(12, 24, 12, 24),
            itemCount: widget.textField.length,
            itemBuilder: (BuildContext context, int index) {
              String value = widget.textField[index];
              var controller = TextEditingController();
              Map formItem = Map();
              formItem['key'] = value;
              formItem['value'] = controller;
              orderForm.add(formItem);
              return TextFormField(
                maxLines: 1,
                controller: controller,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(6),
                  labelText: value,
                ),
              );
            },
          ),
        ),
        MaterialButton(
          minWidth: MediaQuery
              .of(context)
              .size
              .width,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
          ),
          height: 55,
          onPressed: () {
            final List<Map> orderFormData = List();
            if (orderForm.length > 0) {
              for (Map formItem in orderForm) {
                Map formData = Map();
                formData['key'] = formItem['key'];
                formData['value'] = formItem['value'].text;

                orderFormData.add(formData);
                print('orderFormData $formData');
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      OrderSummeryScreen(
                          summery: cartSummery, orderFormData: orderFormData),
                ),
              );
            } else {
              AwesomeDialog(
                  title: 'Empty',
                  context: context,
                  desc: 'your cart is empty',
                  headerAnimationLoop: false,
                  animType: AnimType.TOPSLIDE,
                  dialogType: DialogType.WARNING,
                  btnOkOnPress: () {}).show();
            }
          },
          color: Colors.lightBlueAccent,
          child: Text(
            'ORDER SUMMARY',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}
