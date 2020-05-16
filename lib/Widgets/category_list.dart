import 'package:flutter/material.dart';
import 'package:shop_app/Models/categories.dart';
import 'package:shop_app/Services/database.dart';
import 'package:shop_app/reusables/constants.dart';

class CategoryList extends StatefulWidget {
  final Function onTap;
  CategoryList({this.onTap});
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
      height: 100,
      child: StreamBuilder(
        stream: DatabaseServices().getCateries(),
        builder: (context, snap) {
          List<Category> categories = snap.data;
          if (snap.hasData)
            return _buildCategoryList(
                categories); //_buildCategoryList(snap.data.documents);
          return Text('Categories Loading');
        },
      ),
    );
  }

  Widget _buildCategoryList(List<Category> snapshot) {
    return ListView(
      reverse: true,
      scrollDirection: Axis.horizontal,
      children: snapshot
              .map((data) => _buildCaterogyListItem(context, data))
              .toList() +
          [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
              child: FittedBox(
                child: Container(
                    // height: 30,
                    // width: 100,
                    child: Column(
                  children: <Widget>[
                    // TODO UI
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kbackgroundColor,
                        boxShadow: [
                          BoxShadow(
                              color: kshadowColor,
                              offset: Offset(8, 6),
                              blurRadius: 12),
                          BoxShadow(
                              color: klightShadowColor,
                              offset: Offset(-8, -6),
                              blurRadius: 12),
                        ],
                      ),
                      child: InkWell(
                        customBorder: CircleBorder(),
                        onTap: () {
                          widget.onTap("all");
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              'assets/All.png' ?? 'assets/Fish.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "All",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                )),
              ),
            )
          ],
    );
  }

  Widget _buildCaterogyListItem(BuildContext context, Category doc) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
            // height: 30,
            // width: 100,
            child: Column(
          children: <Widget>[
            // TODO UI
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kbackgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: kshadowColor,
                      offset: Offset(8, 6),
                      blurRadius: 12),
                  BoxShadow(
                      color: klightShadowColor,
                      offset: Offset(-8, -6),
                      blurRadius: 12),
                ],
              ),
              child: InkWell(
                customBorder: CircleBorder(),
                onTap: () {
                  widget.onTap(doc.name);
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      
                      'assets/${doc.name}.png' ?? 'assets/Fish.png',fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              
              doc.name,
              softWrap: true,
              style: TextStyle(fontSize: 16),
            ),
          ],
        )),
      ),
    );
  }
}
