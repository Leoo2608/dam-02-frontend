import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/api_response.dart';
import 'package:frontend_flutter/models/post.dart';
import 'package:frontend_flutter/pages/posts_delete_page.dart';
import 'package:frontend_flutter/pages/posts_modify_page.dart';
import 'package:frontend_flutter/services/posts_service.dart';
import 'package:frontend_flutter/widgets/sidebar_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class PostsPage extends StatefulWidget {
  static String id = 'posts_page';

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
 
  PostsService get service => GetIt.I<PostsService>();
  late APIResponse<List<Post>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState(){
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getPostsList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => PostModify(
                    controller: 'add'
                  ))).then((_){
                    _fetchNotes();
                  });
        },
        child:const FaIcon(FontAwesomeIcons.plus),
        elevation: 15.0,
        backgroundColor: const Color(0xff1b3966),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xff1b3966),
        centerTitle: true,
        elevation: 20.0,
        title: const Text('View Posts'),
      ),
      drawer: SidebarWidget(),
      body: Builder(
        builder: (_){
          if(_isLoading){
            return const Center(child: CircularProgressIndicator());
          }
          if(_apiResponse.error){
            return Center(child: Text(_apiResponse.errorMessage!));
          }
          return  ListView.separated(
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Colors.grey),
          itemBuilder: (_, index) {
            return Dismissible(
              key: ValueKey(_apiResponse.data[index].idpost),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {},
              confirmDismiss: (direction) async {
                final result = await showDialog(
                    context: context, builder: (_) => PostDelete());

                    if(result){
                      var message;
                      final deleteResult = await service.deletePost((_apiResponse.data[index].idpost).toString());
                      if(deleteResult.data == true){
                        message = 'El post se ha eliminado correctamente!';
                      }else{
                        message = deleteResult.errorMessage ?? 'An error occured';
                      }
                      showDialog(context: context, builder: (_)=>AlertDialog(
                        title: const Text('Done'),
                        content: Text(message),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('Ok'),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ));
                      return deleteResult.data;
                    }
                return result;
              },
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.only(left: 16),
                child: const Align(
                  child: Icon(Icons.delete, color: Colors.white),
                  alignment: Alignment.centerLeft,
                ),
              ),
              child: ListTile(
                title: Text(
                  _apiResponse.data[index].titulo,
                  style: const TextStyle(color: Color(0xff6C98C0)),
                ),
                subtitle: Text(_apiResponse.data[index].descripcion),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PostModify(controller: 'edit', idpost: (_apiResponse.data[index].idpost).toString() ))).then((value){
                        _fetchNotes();
                      });
                },
              ),
            );
          },
          itemCount: _apiResponse.data.length);
        }
      )
    );
  }
}
