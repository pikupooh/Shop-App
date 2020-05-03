import 'package:flutter/material.dart';
import 'package:shop_app/Models/categories.dart';
import 'package:shop_app/Services/database.dart';

class CatergoryList extends StatefulWidget {
  @override
  _CatergoryListState createState() => _CatergoryListState();
}

class _CatergoryListState extends State<CatergoryList> {
  @override
  Widget build(BuildContext context) {
    return _buildCategory();
  }

  Widget _buildCategory() {
    return Container(
      height: 100,
      child: StreamBuilder(
        stream: DatabaseServices().getCateries(),
        builder: (context, snap) {
          List<Category> categories = snap.data ;
          if (snap.hasData) return _buildCategoryList(categories); //_buildCategoryList(snap.data.documents);
          return Text("Loading");
        },
      ),
    );
  }

  Widget _buildCategoryList(List<Category> snapshot) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: snapshot
          .map((data) => _buildCaterogyListItem(context, data))
          .toList(),
    );
  }

  Widget _buildCaterogyListItem(BuildContext context, Category doc) {
    return Container(
      height: 30, 
      width: 100,
      child: Stack(
        children: <Widget>[
          // TODO UI
          Positioned(
            height: 20,
            child: Text(doc.name),
          ),
        ],
      ));
  }
}