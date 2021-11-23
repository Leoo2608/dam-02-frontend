import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_flutter/models/user.dart';
import 'package:frontend_flutter/services/auth_service.dart';

class SidebarWidget extends StatefulWidget {
  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  String _username = "";
  String textHolder = '';
  TextEditingController _controller = TextEditingController();
  Future<Null> getSharedPrefs() async {
    User user = await AuthService.currentUser();
    print(user.username);
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
    print(textHolder);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/img/USERFP2.png',
                        height: 30.0,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                        child: Text(
                          '$textHolder',
                          style: TextStyle(color: Colors.white, fontSize: 18,)
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            decoration: const BoxDecoration(
              color: Color(0xff1b3966),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: const FaIcon(FontAwesomeIcons.home),
            onTap: () {
              Navigator.pushNamed(context, 'home_page');
            },
          ),
          ListTile(
              title: const Text('Posts'),
              leading: const FaIcon(FontAwesomeIcons.folder),
              onTap: () {
                Navigator.pushNamed(context, 'posts_page');
              }),
          ListTile(
              title: const Text('Salir'),
              leading: const Icon(Icons.logout),
              onTap: () async{
                await AuthService.logout();
                Navigator.pushNamed(context, 'login_page');
              }),
        ],
      ),
    );
  }
}
