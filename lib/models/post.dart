// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) => List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
    Post({
        required this.idpost,
        required this.titulo,
        required this.descripcion,
    });

    int idpost;
    String titulo;
    String descripcion;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        idpost: json["idpost"],
        titulo: json["titulo"],
        descripcion: json["descripcion"],
    );


    Map<String, dynamic> toJson() => {
        "idpost": idpost,
        "titulo": titulo,
        "descripcion": descripcion,
    };
}
