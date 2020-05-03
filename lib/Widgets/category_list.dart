import 'package:flutter/material.dart';
import 'package:shop_app/Models/categories.dart';
import 'package:shop_app/Services/database.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return _buildCategory();
  }

  Widget _buildCategory() {
    return Container(
      //color: Colors.black12,
      height: 120,
      child: StreamBuilder(
        stream: DatabaseServices().getCateries(),
        builder: (context, snap) {
          List<Category> categories = snap.data;
          if (snap.hasData)
            return _buildCategoryList(
                categories); //_buildCategoryList(snap.data.documents);
          return CircularProgressIndicator();
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Container(
          // height: 30,
          // width: 100,
          child: Column(
        children: <Widget>[
          // TODO UI
          Material(
            shadowColor: Color(0x77d1dff7),
            elevation: 10,
            shape: CircleBorder(),
            child: InkWell(
              customBorder: CircleBorder(),
              onTap: () {},
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Color(0x77d1dff7),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/${doc.name}.png' ?? 'assets/Fish.png',
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/Fish.png');
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            doc.name,
            style: TextStyle(fontSize: 17),
          ),
        ],
      )),
    );
  }
}
