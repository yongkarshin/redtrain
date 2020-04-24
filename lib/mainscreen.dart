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
  //var _place = ['padang besar', 'arau'];
  //var _placeItemSelected = 'padang besar';
  DateTime _date = DateTime.now();
  var dateFormat = DateFormat('dd-MM-yyyy');
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _prdController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    
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
          resizeToAvoidBottomPadding: false,
          drawer: mainDrawer(context),
          appBar: AppBar(
            title: Text('Train'),
          ),
          body: Stack(
            children: <Widget>[
              searchTrain(context),
            ],
          ));
    }
  }

  Widget searchTrain(BuildContext context) {
    return Container(
      height: 600,
      margin: EdgeInsets.only(top: screenHeight / 15),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  //From Origin
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "From",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  TextField(
                    autofocus: false,
                    controller: _prdController,
                    decoration: InputDecoration(
                              labelText: 'City or station',
                              icon: Icon(Icons.transfer_within_a_station),
                            ),
                            onChanged: (string){
                              
                            },
                  ),
                 

                  //To Destination
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: Align(
                          alignment: Alignment.center,
                          child: IconButton(
                              icon: Icon(Icons.swap_vertical_circle),
                              iconSize: 35,
                              onPressed: null),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "To",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () => _selectDestination(""),
                      child: IgnorePointer(
                        child: Container(
                          width: 350,
                          height: 50,
                          child: TextField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Going Where ?',
                              icon: Icon(Icons.transfer_within_a_station),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  
                  // Select departure date
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Departure",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () => selectDate(context),
                      child: IgnorePointer(
                        child: Container(
                          width: 350,
                          height: 50,
                          child: TextField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Date',
                              icon: Icon(Icons.calendar_today),
                              hintText: ('${dateFormat.format(_date)}'),
                              hintStyle:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  //select how many passenger
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Passenger",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  TextField(
                    controller: null,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      labelText: 'Person',
                      icon: Icon(Icons.people_outline),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //search train button
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minWidth: 215,
                    height: 50,
                    child: Text('Search Train',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          fontFamily: 'Roboto',
                        )),
                    color: Colors.yellow,
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: _search,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _departureList(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Depature Location'),
      content: Container(
        height: 20,
        
        child: Row(
          children: <Widget>[
            TextField(
            autofocus: false,
            controller: _prdController,
            decoration: InputDecoration(
              icon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
            MaterialButton(
              color: Colors.black,
              onPressed: () => {_searchDepature(_prdController.text)},
              child: Text("Search xxxx",style: TextStyle(color: Colors.black)),
            ),
          ],
          
          
        ),
      ),
    );
  }
  void _searchDepature(String prname){

  }
//connect to php
  void _Departure(String origin) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Searching...");
    pr.show();
    String urlLoadJobs = "https://smileylion.com/redtrain/php/";
    http.post(urlLoadJobs, body: {
      "origin": origin,
    }).then((res) {
      setState(() {
        curtype = origin;
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
//connect to php
  void _selectDestination(String origin) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Searching...");
    pr.show();
    String urlLoadJobs = "https://smileylion.com/redtrain/php/";
    http.post(urlLoadJobs, body: {
      "origin": origin,
    }).then((res) {
      setState(() {
        curtype = origin;
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

  void _search() {}
}
