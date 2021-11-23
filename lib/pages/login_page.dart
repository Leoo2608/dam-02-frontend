import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_flutter/models/login_request.dart';
import 'package:frontend_flutter/models/user.dart';
import 'package:frontend_flutter/services/auth_service.dart';
import 'package:frontend_flutter/widgets/sidebar_widget.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  bool _isLoading = false;

  Future<Null> getSharedPrefs() async {
    User user = await AuthService.currentUser();
    print(user.username);
  }
   @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Alert'),
        content: new Text('¿Deseas salir?'),
        actions: <Widget>[
          TextButton(
          
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: ()async{
              SystemNavigator.pop();
            },
            child: new Text('Si'),
          ),
        ],
      ),
      )) ?? false;
  }
  
  TextEditingController _userController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: const Color(0xff1b3966),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(100),
                          bottomLeft: Radius.circular(100))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text('CRUD Flutter + Node',
                          style: TextStyle(
                              color: Color(0xff1b3966),
                              fontSize: 35.0,
                              fontWeight: FontWeight.w100)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 30, 0, 20),
                        child: Text("Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white,
                            )),
                      ),
                      TextField(
                        controller: _userController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Usuario',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            prefixIcon: Icon(Icons.person, color: Colors.white)),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: _passController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Contraseña',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.white),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            )),
                        obscureText: !_passwordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () async {
                            if (_userController.text.trim() != '' &&
                                _passController.text.trim() != '') {
                              setState(() {
                                _isLoading = true;
                              });
                              LoginRequest model = LoginRequest(
                                  username: _userController.text,
                                  password: _passController.text);
                              await AuthService.login(model).then((res) {
                                Navigator.pushNamed(context, 'home_page');
                              });
                              setState(() {
                                _isLoading = false;
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: const Text('Error!'),
                                        content: Text('Llene los campos!'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: const Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ));
                            }
                          },
                          child: const Text('Ingresar',
                              style: TextStyle(
                                  color: Color(0xff1b3966),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
