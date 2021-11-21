import 'dart:convert';

import 'package:frontend_flutter/models/api_response.dart';
import 'package:frontend_flutter/models/post.dart';
import 'package:frontend_flutter/models/post_insert.dart';
import 'package:frontend_flutter/services/auth_service.dart';
import 'package:http/http.dart' as http;

class PostsService {
  
  static const API = 'https://backend-dam-p2.herokuapp.com/api/auth';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

   addTokenToReqs() async{
    String token = await AuthService.currentToken();
    headers.addAll({"Authorization":"Bearer "+token});
  }

  Future<APIResponse<List<Post>>> getPostsList() async{
     await addTokenToReqs();
    return http.get(Uri.parse(API + '/posts'), headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final posts = <Post>[];
        for (var item in jsonData) {
          posts.add(Post.fromJson(item));
        }
        return APIResponse<List<Post>>(data: posts);
      }
      return APIResponse<List<Post>>(
          data: <Post>[], error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<List<Post>>(
        data: <Post>[], error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<Post>> getPost(String idpost) async{
    await addTokenToReqs();
    return http.get(Uri.parse(API + '/posts/' + idpost), headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        var post;
        for (var item in jsonData) {
          post = Post(
              idpost: item['idpost'],
              titulo: item['titulo'],
              descripcion: item['descripcion']);
        }

        return APIResponse<Post>(data: post);
      }
      return APIResponse<Post>(
          data: Post(idpost: 0, titulo: '', descripcion: ''),
          error: true,
          errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<Post>(
        data: Post(idpost: 0, titulo: '', descripcion: ''),
        error: true,
        errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> createPost(PostManipulation post)async {
     await addTokenToReqs();
    return http
        .post(Uri.parse(API + '/posts'), headers: headers, body: json.encode(post.toJson()))
        .then((data) {
      if (data.statusCode == 201 || data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          data: false, error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<bool>(
            data: false, error: true, errorMessage: 'An error occured'));
  }

   Future<APIResponse<bool>> updatePost(String idpost, PostManipulation post) async{
      await addTokenToReqs();
    return http
        .put(Uri.parse(API + '/posts/' + idpost), headers: headers, body: json.encode(post.toJson()))
        .then((data) {
      if (data.statusCode == 204 || data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          data: false, error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<bool>(
            data: false, error: true, errorMessage: 'An error occured'));
  }

  Future<APIResponse<bool>> deletePost(String idpost) async{
     await addTokenToReqs();
    return http
        .delete(Uri.parse(API + '/posts/' + idpost), headers: headers)
        .then((data) {
      if (data.statusCode == 204 || data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          data: false, error: true, errorMessage: 'An error occured');
    }).catchError((_) => APIResponse<bool>(
            data: false, error: true, errorMessage: 'An error occured'));
  }

}
