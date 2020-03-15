import 'package:flutter/material.dart';
import 'package:redtrain/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fromKey = GlobalKey<FormState>();
  double screenHeight;
  bool _isChecked = false;
  String urlRegister = "https://smileylion.com/redtrain/php/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();

  ///String name;

  @override
  Widget build(BuildContext context) {
    
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      key: _fromKey,
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          )),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      height: screenHeight / 2,
      child: Image.asset(
        'assets/images/logintrain1.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 550,
      margin: EdgeInsets.only(top: screenHeight / 3.5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextFormField(
                      
                      controller: _nameEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name',hasFloatingPlaceholder: true,
                        hintText: 'jason',
                        helperText: 'This has to be over 2 characters in length.',
                        helperStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w100),
                        
                        icon: Icon(Icons.person),
                      )
                      ),
                  TextFormField(
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',hasFloatingPlaceholder: true,
                        hintText: 'abc@example.com',
                        helperText: 'eg: abc@example.com.',
                        helperStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w100),
                        icon: Icon(Icons.email),
                      )),
                  TextFormField(
                      controller: _phoneditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone',hasFloatingPlaceholder: true,
                        hintText: '01x1234567',
                        helperText: 'This has to be 10 or 11 number in length.',
                        helperStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w100),
                        icon: Icon(Icons.phone),
                      )),
                  TextFormField(
                    controller: _passEditingController,
                    decoration: InputDecoration(
                      labelText: 'Password',hasFloatingPlaceholder: true,
                      helperText: 'This has to be more than 5 with charaters and number.',
                      helperStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w100),
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool value) {
                          _onChange(value);
                        },
                      ),
                      GestureDetector(
                        onTap: _showEULA,
                        child: Text('I Agree to Terms  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 115,
                        height: 50,
                        child: Text('Register', 
                        style: TextStyle(fontSize: 16)),
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: _onRegister,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Already register? ", style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _loginScreen,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      //color: Color.fromRGBO(255, 200, 200, 200),
      margin: EdgeInsets.only(top: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        
      ),
    );
  }

  void _onRegister() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneditingController.text;
    String password = _passEditingController.text;
    String verify='0';
    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if((_isEmailValid(email))&&
      (_isPassword(password))&&(password.length>5)&&
      (phone.length>10)||(phone.length<11)&&
      (_isNameValid(name))&&(name.length>3)){
     
    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "verify": verify,
    }).then((res) {
      if (res.body == "success") {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
    }else{
      Toast.show("Check your registration information", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _loginScreen() {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Already register?",
          style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold)),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Are you sure wants to cancel register?",
                  style: TextStyle(fontSize: 20.0),
                  
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes", style: TextStyle(fontSize: 16.0)),
              onPressed: () {
                Navigator.push(
                  context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()));
              },
            ),
            new FlatButton(
              child: new Text("No", style: TextStyle(fontSize: 16.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("End-User License Agreement (EULA) of redTrain."),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement (EULA) is a legal agreement between you and redTrain.\n\n This EULA agreement governs your acquisition and use of our redTrain software (Software) directly from redTrain or indirectly through a redTrain authorized reseller or distributor (a Reseller).\n\nPlease read this EULA agreement carefully before completing the installation process and using the redTrain software. It provides a license to use the redTrain software and contains warranty information and liability disclaimers.\n\nIf you register for a free trial of the redTrain software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the redTrain software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.\n\nIf you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.\n\nThis EULA agreement shall apply only to the Software supplied by redTrain herewith regardless of whether other software is referred to or described herein. The terms also apply to any redTrain updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for redTrain.\n\nLicense Grant\n\n redTrain hereby grants you a personal, non-transferable, non-exclusive licence to use the redTrain software on your devices in accordance with the terms of this EULA agreement.\n\nYou are permitted to load the redTrain software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the redTrain software.\n\nYou are not permitted to:\n\n.Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things.\n. Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose.\n. Allow any third party to use the Software on behalf of or for the benefit of any third party.\n. Use the Software in any way which breaches any applicable local, national or international law.\n. Use the Software for any purpose that redTrain considers is a breach of this EULA agreement.\n\nIntellectual Property and Ownership\n\n redTrain shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of redTrain.\n\nredTrain reserves the right to grant licences to use the Software to third parties.\n\nTermination \n\nThis EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to redTrain.\n\nIt will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.\n\nGoverning Law\n\nThis EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of my."
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close", style: TextStyle(fontSize: 20.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
   bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

    bool _isNameValid(String name){
      return RegExp(r"^[a-zA-Z]").hasMatch(name);
    }

    bool _isPassword(String password){
      return RegExp(r"^[a-zA-Z0-9]").hasMatch(password);
    }

  
}