import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Models/cart_item.dart';
import 'package:shop_app/Models/categories.dart';
import 'package:shop_app/Models/product.dart';
import 'package:shop_app/Models/user.dart';

class DatabaseServices {
  final _db = Firestore.instance;

  void createUser(String phoneNumber) async {
    final CollectionReference _doc = _db.collection('Users');
    await _doc.document(phoneNumber).setData({
      'address': "None",
      'phoneNumber': phoneNumber,
      'cartID': phoneNumber,
      'name': "Name",
      'imageUrl': 'none',
      'alternatePhoneNumber': "Enter alternate phone number",
    });
  }

  void updateProfile(String phoneNumber, String name, String alternatePhone,
      String imageUrl, String address) async {
    final CollectionReference _doc = _db.collection('Users');
    await _doc.document(phoneNumber).updateData({
      'address': address ?? "Enter your Address",
      'name': name ?? "Name",
      'alternatePhoneNumber': alternatePhone ?? "Alternate phone number",
      'imageUrl': imageUrl
    });
  }

  void createCart(String phoneNumber) async {
    final CollectionReference _doc = _db.collection('Cart');
    await _doc
        .document(phoneNumber)
        .setData({'id': phoneNumber, 'totalCartCost': "0"});
  }

  Stream<User> streamUser(User user) {
    return _db
        .collection('Users')
        .document(user.phone)
        .snapshots()
        .map((snap) => User.fromfirebase(snap));
  }

  Stream<List<CartItem>> getCartItems(User user) {
    return _db
        .collection('Cart')
        .document(user.phone)
        .snapshots()
        .map((snap) => CartItem().fromFirebase(snap));
  }

  Stream<List<Category>> getCateries() {
    var ref = _db.collection('Categories').snapshots();
    return ref.map((list) =>
        list.documents.map((item) => Category.fromFirebase(item)).toList());
  }

  Stream<List<Product>> getProducts(String cat) {
    var ref = cat != "all"
        ? _db.collection("Shop").where('category', isEqualTo: cat).snapshots()
        : _db.collection("Shop").snapshots();
    return ref.map((list) =>
        list.documents.map((item) => Product.fromFirebase(item)).toList());
  }

  void addToCart(Product product, User user) async {
    CartItem cartItem = CartItem.fromProduct(product);
    print(cartItem.toString());
    var _ref = _db.collection('Cart').document(user.phone);
    final cartsnapShot =
        await Firestore.instance.collection('Cart').document(user.phone).get();

    if (cartsnapShot == null || !cartsnapShot.exists) {
      print("Cart Does not exits");
      DatabaseServices().createCart(user.phone);
    } else {
      print("Cart Exits");
    }
    await _ref.get().then((onValue) async {
      var data = onValue.data;
      print(data.toString());
      print("item does not exits");
      if (data[product.name] == null) {
        Map<dynamic, dynamic> item = {
          'imageurl': cartItem.imageurl,
          'cost': cartItem.cost,
          'name': cartItem.name,
          'quantity': cartItem.quantity,
          'totalCost': cartItem.totalCost
        };
        Map<String, dynamic> other = {product.name: item};
        data.addAll(other);
        // String totalCartCost =
        //     (int.parse(data['totalCartCost']) + int.parse(product.cost))
        //         .toString();
        //print("totalCost" + totalCartCost);
        await _ref.updateData({product.name: item});
      } else {
        // TODO optimise
        print("Item exits");
        Map item = data[product.name];
        item['quantity'] += 1;
        item['totalCost'] =
            (int.parse(item['cost']) * item['quantity']).toString();
        await _ref.updateData({product.name: item});
      }
    });
  }

  void updateCart(User user) async {
    //print("updatecart");
    var _ref = _db.collection('Cart').document(user.phone);
    if(_ref == null) return;
    await _ref.get().then((onValue) async {
      List<CartItem> cartItems = CartItem().fromFirebase(onValue);
      if (cartItems != null && cartItems.length >= 1) {
        cartItems.forEach((item) async {
          await _db
              .collection('Shop')
              .document(item.name)
              .get()
              .then((onValue) {
            if (onValue != null) {
              item.cost = onValue.data['cost'];
              if (onValue.data['totalcost'] == null) item.totalCost = "0";
              item.totalCost =
                  (int.parse(item.cost) * item.quantity).toString();
              //print(item.toMap().toString());
              _ref.updateData({item.name: item.toMap()});
            }
          });
        });
      }
    });
    await _ref.get().then((onValue) async {
      int totalCartCost = 0;
      //print(onValue.data.toString());
      if (onValue != null) {
        onValue.data.forEach((key, value) {
          if (key != 'id' && key != 'totalCartCost') {
            totalCartCost += int.parse(value['totalcost']);
            //print(value['totalcost'].toString() + " " + totalCartCost.toString());
          }
        });
        //print(totalCartCost);
        await _ref.updateData({'totalCartCost': totalCartCost});
      }
    });
  }
}
