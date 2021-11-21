import 'package:flutter/material.dart';

class PostDelete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Warning'),
      content: Text('¿Estas seguro de eliminar este post?'),
      actions:<Widget>[
        FlatButton(
          child: Text('Yes') ,
          onPressed: (){
            Navigator.of(context).pop(true);
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        )
      ],
    );
  }
  
}