import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:redtrain/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:numberpicker/numberpicker.dart';
//import 'package:toast/toast.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'cartscreen.dart';
import 'user.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double screenHeight, screenWidth;
  //bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  List traindata;
  var _place = ['padang besar', 'arau'];
  var _placeItemSelected = 'padang besar';
  DateTime _date = DateTime.now();
  var dateFormat = DateFormat('dd-MM-yyyy');
  TextEditingController _dateController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    //TextEditingController _prdController = new TextEditingController();
    if (traindata == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Search Train'),
          ),
          body: Container(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Loading...",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )));
    } else {
      return Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
            title: Text('Search Train'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        //FlatButton(
                        //onPressed: () => _sortItem("origin"), child: null),
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
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                              size: 40,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Pick a Date : \t',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            InkWell(
                                onTap: () => selectDate(context),
                                child: IgnorePointer(
                                  child: Container(
                                    width: 150,
                                    height: 50,
                                    child: TextField(
                                      controller: _dateController,
                                      decoration: InputDecoration(
                                        hintText:
                                            ('${dateFormat.format(_date)}'),
                                        hintStyle: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ));
    }
  }

  void _dropDownItemSelected(String newValueSelected) {
    setState(() {
      this._placeItemSelected = newValueSelected;
    });
  }

  void _loadData() {
    String urlLoadJobs = "https://smileylion.com/redtrain/php/load_trains.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        traindata = extractdata["trains"];
        cartquantity = widget.user.quantity;
      });
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('myName'), //Text(widget.user.name),
            accountEmail: Text('myEmail'), //Text(widget.user.email),
            otherAccountsPictures: <Widget>[
              //Text("RM " + widget.user.credit,
              //style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ],
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

  void _sortItem(String type) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Searching...");
    pr.show();
    String urlLoadJobs = "https://smileylion.com/redtrain/php/load_trains.php";
    http.post(urlLoadJobs, body: {
      "origin": type,
    }).then((res) {
      setState(() {
        curtype = type;
        var extractdata = json.decode(res.body);
        traindata = extractdata["trains"];
        FocusScope.of(context).requestFocus(new FocusNode());
        pr.dismiss();
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    pr.dismiss();
  }

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2019),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _date) {
      print(_date.toString());

      setState(() {
        _date = picked;
        print(_date.toString());
      });
    }
  }
}
