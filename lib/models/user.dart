class User {
  int idusuario;
  String username;
  int idrol;
  String nomrol;

  User(
      {required this.idusuario,
      required this.username,
      required this.idrol,
      required this.nomrol});

  Map<String, dynamic> toJson() => {
        'idusuario': idusuario,
        'username': username,
        'idrol': idrol,
        'nomrol': nomrol,
      };
  User.fromJson(Map<String, dynamic> json)
      : idusuario = json['idusuario'],
        username = json['username'],
        idrol = json['idrol'],
        nomrol = json['nomrol'];
}
