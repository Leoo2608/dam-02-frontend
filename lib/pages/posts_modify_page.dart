import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_flutter/models/post.dart';
import 'package:frontend_flutter/models/post_insert.dart';
import 'package:frontend_flutter/services/posts_service.dart';
import 'package:get_it/get_it.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostModify extends StatefulWidget {
  final String controller;
  final String idpost;
  PostModify({required this.controller, this.idpost = ''});

  @override
  State<PostModify> createState() => _PostModifyState();
}

class _PostModifyState extends State<PostModify> {
  bool get isEditing => widget.controller != 'add';
  PostsService get postsService => GetIt.I<PostsService>();
  late String errorMessage;
  late Post? post;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      postsService.getPost(widget.idpost).then((res) {
        setState(() {
          _isLoading = false;
        });
        if (res.error) {
          errorMessage = res.errorMessage ?? 'An error ocurred';
        }
        post = res.data;
        print(post?.titulo);
        _titleController.text = post!.titulo;
        _descController.text = post!.descripcion;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1b3966),
          centerTitle: true,
          elevation: 20.0,
          title: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: isEditing ? 'Edita tu post  ' : 'Crea un post  ',
                  style: const TextStyle(color: Colors.white, fontSize: 20.0)),
              WidgetSpan(
                child: FaIcon(isEditing
                    ? FontAwesomeIcons.edit
                    : FontAwesomeIcons.bullhorn),
              )
            ]),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Post Title',
                        labelText: 'Título del post',
                      ),
                    ),
                    Container(height: 8),
                    TextField(
                        controller: _descController,
                        decoration: InputDecoration(
                            hintText: 'Post Description',
                            labelText: 'Descripción del post')),
                    Container(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: RaisedButton(
                        child: const Text('Submit',
                            style: TextStyle(color: Colors.white)),
                        color: const Color(0xff1b3966),
                        onPressed: () async {
                          if (isEditing) {
                            setState(() {
                              _isLoading = true;
                            });
                            final post = PostManipulation(
                                titulo: _titleController.text,
                                descripcion: _descController.text);
                            final result = await postsService.updatePost(
                                widget.idpost, post);
                            setState(() {
                              _isLoading = false;
                            });
                            final title = 'Done';
                            final text = result.error == true
                                ? (result.errorMessage!)
                                : 'Tu post se ha actualizado correctamente!';
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(title),
                                      content: Text(text),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Ok'))
                                      ],
                                    )).then((data) {
                              if (result.error == false) {
                                Navigator.of(context).pop();
                              }
                            });
                          } else {
                            setState(() {
                              _isLoading = true;
                            });
                            final post = PostManipulation(
                                titulo: _titleController.text,
                                descripcion: _descController.text);
                            final result = await postsService.createPost(post);
                            setState(() {
                              _isLoading = false;
                            });
                            final title = 'Done';
                            final text = result.error == true
                                ? (result.errorMessage!)
                                : 'Tu post se ha creado correctamente!';
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(title),
                                      content: Text(text),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Ok'))
                                      ],
                                    )).then((data) {
                              if (result.error == false) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
        ));
  }
}
