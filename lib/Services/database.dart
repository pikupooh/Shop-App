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
      'alternatePhoneNumber': "Enter alternate phone number",
    });
  }

  void createCart(String phoneNumber) async {
    final CollectionReference _doc = _db.collection('Cart');
    await _doc.document(phoneNumber).setData({
      'id': phoneNumber
    });
  }

  Stream<User> streamUser(User user) {
    return _db
        .collection('Users')
        .document(user.phone)
        .snapshots()
        .map((snap) => User.fromfirebase(snap));
  }

  Stream<List<CartItem>> getCartItems(User user){
    return _db.collection('Cart').document(user.phone).snapshots().map((snap) => CartItem().fromFirebase(snap));
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

  void addToCart (Product product, User user) async {
    CartItem cartItem = CartItem.fromProduct(product);
    var _ref = _db.collection('Cart').document(user.phone);
    final cartsnapShot = await Firestore.instance
        .collection('Cart')
        .document(user.phone)
        .get();
    
    if (cartsnapShot == null || !cartsnapShot.exists) {
      print("Cart Does not exits");
      DatabaseServices().createCart(user.phone);
    } else {
      print("Cart Exits");
    }
    await _ref.get().then((onValue) async {
      var data = onValue.data;
      if(data[product.name] == null){
        Map<dynamic, dynamic> item = {
          'cost': cartItem.cost,
          'name': cartItem.name,
          'quantity': cartItem.quantity,
          'totalCost': cartItem.totalCost };
          Map <String, dynamic> other = {product.name: item}; 
        data.addAll(other);
        await _ref.updateData({
          product.name: item
        });
      }
      else{
        // TODO optimise
        Map item = data[product.name];
        item['quantity'] += 1;
        item['totalCost'] =  (int.parse(item['cost']) * item['quantity']).toString() ;
        await _ref.updateData({
          product.name: item,
        });
      }
    });
  }
}
