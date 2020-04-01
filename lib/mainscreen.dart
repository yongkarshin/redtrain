//import 'dart:async';
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:redtrain/user.dart';
//import 'package:http/http.dart' as http;
//import 'package:progress_dialog/progress_dialog.dart';
//import 'package:numberpicker/numberpicker.dart';
//import 'package:toast/toast.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'cartscreen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double screenHeight, screenWidth;
  //bool _visible = false;
  String cartquantity = "0";
  List traindata;
  var _place = ['padang besar', 'arau'];
  var _placeItemSelected = 'padang besar';

  @override
  void initState() {
    super.initState();
    //_loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    //TextEditingController _prdController = new TextEditingController();
    
      return Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
            title: Text('Search Train'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.business,
                      color: Colors.black,
                      size: 50,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Origin \t\t\t\t\t\t\t\t : \t',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      items: _place
                          .map((String dropDownStringItem) => DropdownMenuItem(
                                child: Text(
                                  dropDownStringItem,
                                  style: TextStyle(fontSize: 18),
                                ),
                                value: dropDownStringItem,
                              ))
                          .toList(),
                      onChanged: (newValueSelected) {
                        _dropDownItemSelected(newValueSelected);
                      },
                      value: _placeItemSelected,
                      isExpanded: false,
                      hint: Text('Origin', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.business,
                          color: Colors.black,
                          size: 50,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text('Destination : \t',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          items: _place
                              .map((String dropDownStringItem) =>
                                  DropdownMenuItem(
                                    child: Text(
                                      dropDownStringItem,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    value: dropDownStringItem,
                                  ))
                              .toList(),
                          onChanged: (newValueSelected) {
                            _dropDownItemSelected(newValueSelected);
                          },
                          value: _placeItemSelected,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ));
    
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._placeItemSelected = newValueSelected;
    });
  }

  
}

Widget mainDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text('myName'), //Text(widget.user.name),
          accountEmail: Text('myEmail'), //Text(widget.user.email),
          //otherAccountsPictures: <Widget>[
          //Text("RM " + widget.user.credit,
          //style: TextStyle(fontSize: 16.0, color: Colors.white)),
          //],
          currentAccountPicture: CircleAvatar(
            backgroundColor:
                Theme.of(context).platform == TargetPlatform.android
                    ? Colors.white
                    : Colors.white,
            //child: Text(
            //widget.user.name.toString().substring(0, 1).toUpperCase(),
            //style: TextStyle(fontSize: 40.0),
            //),
          ),
        ),
        ListTile(
          title: Text("Search product"),
          trailing: Icon(Icons.arrow_forward),
        ),
        ListTile(
          title: Text("Shopping Cart"),
          trailing: Icon(Icons.arrow_forward),
        ),
        ListTile(
          title: Text("Purchased History"),
          trailing: Icon(Icons.arrow_forward),
        ),
        ListTile(
          title: Text("User Profile"),
          trailing: Icon(Icons.arrow_forward),
        ),
      ],
    ),
  );
}
