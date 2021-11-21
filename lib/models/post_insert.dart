class PostManipulation {
  String titulo;
  String descripcion;
  PostManipulation({required this.titulo, required this.descripcion});

  Map<String, dynamic> toJson() =>{
    "titulo": titulo,
    "descripcion": descripcion
};
}


