import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryCollection{
  List<String> category;

  CategoryCollection();
  factory CategoryCollection.fromFirebase(){
    
  }
}

class Category{
  String name ;

}