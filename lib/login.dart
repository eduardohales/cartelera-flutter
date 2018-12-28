import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cartelera/sliderBubble.dart';
import 'package:cartelera/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  PageController _pageController;
  bool obscureLoginFlag = true;
  bool obscurePasswordFlag = true;
  bool obscureConfirmFlag = true;
  
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final usernameTextController = TextEditingController(); 
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmTextController = TextEditingController();

  final loginemailTextController = TextEditingController();
  final loginpasswordTextController = TextEditingController();


  Color loginColor = Colors.black;
  Color registerColor = Colors.white;
  

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    usernameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void showSnackBar(String value, num statusCode) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
        ),
      ),
      backgroundColor: Colors.red[700].withOpacity(0.7),
      duration: Duration(seconds: 1),
    )).closed.then((SnackBarClosedReason reason) {
      if(statusCode == 200)
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  void registerUser(String username, String email, String password) async {
    var url = "http://localhost:8080/user";
     final body = <String, String>{
      'username': username,
      'email': email,
      'password': password,
    };
    http.post(url, body: body).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      //print(response);
      bool ok = json.decode(response.body)['ok'];
      if (ok)
        showSnackBar(json.decode(response.body)['msg'].toString(), response.statusCode);
      else
        showSnackBar(json.decode(response.body)['err'].toString(), response.statusCode);
    });
  }

  void loginUser(String email, String password) async {
    var url = "http://localhost:8080/login";
     final body = <String, String>{
      'email': email,
      'password': password,
    };
    http.post(url, body: body).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      //print(response);
      bool ok = json.decode(response.body)['ok'];
      if (ok) {
        showSnackBar(json.decode(response.body)['msg'].toString(), response.statusCode);
        //getUser(json.decode(response.body)['user']['_id']);
      }
      else
        showSnackBar(json.decode(response.body)['err'].toString(), response.statusCode);
    });
  }
/*
  void storeUser(String value) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('id', value);
  }

  void getUser(String value) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.getString('id');
  }
*/
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        // Crea una vista en la que un solo hijo puede ser deslizable.
        child: SingleChildScrollView(
          // Background de la pagina
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: new BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image:
                      AssetImage('assets/battlefront-2-pc-star-wars-sbzo.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.25), BlendMode.dstATop)),
            ),
            // Barra y pestañas deslizables
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Nombre Titulo
                Padding(
                  padding: EdgeInsets.only(top: 100.0, right: 50),
                  child: Text(
                    'NegroFlix',
                    style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 50,
                        shadows: <Shadow>[
                          Shadow(color: Colors.red[900], blurRadius: 20),
                          Shadow(color: Colors.white, blurRadius: 50)
                        ]),
                  ),
                ),
                // Barra deslizable
                Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: _buildLogSlider(context),
                ),
                // Expande el widget hijo en todo el contenedor.
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) {
                      if (i == 0) {
                        setState(() {
                          registerColor = Colors.white;
                          loginColor = Colors.black;
                        });
                      } else if (i == 1) {
                        setState(() {
                          registerColor = Colors.black;
                          loginColor = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildSignIn(context),
                      ),
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: _buildRegister(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogSlider(BuildContext context) {
    return Container(
      width: 300.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.grey[700].withOpacity(0.4),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () => _pageController.animateToPage(0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: loginColor,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () => _pageController.animateToPage(1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.decelerate),
                child: Text(
                  "Register",
                  style: TextStyle(
                      color: registerColor,
                      fontSize: 14.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              // Formulario para el sign in
              Card(
                elevation: 5.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 175.0,
                  child: Column(
                    children: <Widget>[
                      // Text field para el email
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        child: TextField(
                          controller: loginemailTextController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email Address",
                          ),
                        ),
                      ),
                      // Linea separadora ploma
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      // Text field para la contraseña
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        child: TextField(
                          obscureText: obscureLoginFlag,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          controller: loginpasswordTextController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            suffixIcon: GestureDetector(
                              onTap: () => setState(() {
                                    obscureLoginFlag = !obscureLoginFlag;
                                  }),
                              child: Icon(
                                obscureLoginFlag
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Login Button
              Opacity(
                opacity: 0.95,
                child: Container(
                  margin: EdgeInsets.only(top: 165.0),
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      // Color del fondo
                      color: Colors.red[900]),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.black,
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 50.0),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        loginUser(
                          loginemailTextController.text, 
                          loginpasswordTextController.text
                          ); 
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                      }),
                ),
              )
            ],
          ),
          // Forgot Password
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () {
                  showSnackBar('Not implemented', 0);
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )),
          ),
          // Linea izquierda separadora
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                // texto or entre lineas
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "Or",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "WorkSansMedium"),
                  ),
                ),
                // Linea derecha separadora
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          // Login con facebook o google
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, right: 40.0),
                child: GestureDetector(
                  onTap: () {
                    showSnackBar('Not implemented', 0);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.facebook,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: ()  {
                    showSnackBar('Not implemented', 0);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegister(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          // Permite crear un widget sobre otro.
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              // Vista para el formulario
              Card(
                elevation: 5.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 305.0,
                  child: Column(
                    children: <Widget>[
                      // Input para el username
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        child: TextField(
                          controller: usernameTextController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(FontAwesomeIcons.user,
                                color: Colors.black, size: 15.0),
                            hintText: "Username",
                            hintStyle: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      // Input para el correo
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        child: TextField(
                          controller: emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                              size: 15,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      // Input para la contraseña
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        child: TextField(
                          controller: passwordTextController,
                          obscureText: obscurePasswordFlag,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                              size: 15,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: () => setState(() {
                                    obscurePasswordFlag = !obscurePasswordFlag;
                                  }),
                              child: Icon(
                                obscurePasswordFlag
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      // Input para confirmar la contraseña
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                        child: TextField(
                          controller: confirmTextController,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          obscureText: obscureConfirmFlag,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(FontAwesomeIcons.lock,
                                color: Colors.black, size: 15.0),
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(fontSize: 16.0),
                            suffixIcon: GestureDetector(
                                onTap: () => setState(() {
                                      obscureConfirmFlag = !obscureConfirmFlag;
                                    }),
                                child: Icon(
                                  obscureConfirmFlag
                                      ? FontAwesomeIcons.eye
                                      : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black87,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Opacity(
                opacity: 0.95,
                child: Container(
                  margin: EdgeInsets.only(top: 295.0),
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      // Color del fondo
                      color: Colors.red[900]),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.black,
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 50.0),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        print(emailTextController?.text);
                        registerUser(
                          usernameTextController.text,
                          emailTextController.text,
                          passwordTextController.text
                        ); 
                      }),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}



  