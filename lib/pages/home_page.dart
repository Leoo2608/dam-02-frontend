import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/user.dart';
import 'package:frontend_flutter/services/auth_service.dart';
import 'package:frontend_flutter/widgets/sidebar_widget.dart';

class HomePage extends StatefulWidget {
  static String id = 'home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Alert'),
        content: new Text('¿Deseas cerrar sesión?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: ()async{
              await AuthService.logout();
                  Navigator.pushNamed(context, 'login_page');
            },
            child: new Text('Si'),
          ),
        ],
      ),
      )) ?? false;
  }

  String _username = "";
  String textHolder = '';
  TextEditingController _controller = TextEditingController();
  Future<Null> getSharedPrefs() async {
    User user = await AuthService.currentUser();
    _username = user.username;
    setState(() {
      textHolder = _username;
    });
  }

  @override
  void initState() {
    super.initState();
    _username = "";
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff1b3966),
            centerTitle: true,
            elevation: 20.0,
            title: const Text('CRUD Flutter'),
            actions: <Widget>[
              Image.asset(
                'assets/img/USERFP2.png',
                cacheHeight: 30,
                height: 30,
              ),
            ],
          ),
          drawer: SidebarWidget(),
          body: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 0.5,
              child: Container(
                color: const Color(0xff1b3966),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Text(
                        'Bienvenido $textHolder!',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
