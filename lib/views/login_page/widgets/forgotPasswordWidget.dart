import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:task_scape/views/login_page/widgets/alertDialogWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../services/loginPageService.dart';
import '../../../utils/globalScaffold.dart';

TextEditingController forgotEmailController = new TextEditingController();
GlobalKey<FormState> _formkey = GlobalKey<FormState>();
final GlobalKey<State> _keyLoader = new GlobalKey<State>();

 ForgotPasswordWidget(BuildContext context){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: Text('Digite o seu email:'),
      content: Form(
        key: _formkey,
        child: TextFormField(
          controller: forgotEmailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
              fontFamily: "WorkSansSemiBold",
              fontSize: 16.0,
              color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              FontAwesomeIcons.envelope,
              color: Colors.black,
            ),
            hintText: "Email",
            hintStyle: TextStyle(
                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
          ),
          validator: (value) {
            if (value.isEmpty ||
                value.length < 2 ||
                !value.contains("@")) {
              return 'Coloque um Email válido.';
            }
            else{
              return "";
            }
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
            child: Text('Enviar'),
            onPressed: () async{

              if(_formkey.currentState.validate()){
                Navigator.of(context).pop(false);
                Dialogs.showLoadingDialog(
                    context, _keyLoader, "Enviando...");

                String answ = await LoginPageService.instance.forgotPassword(forgotEmailController.text);
                Navigator.of(_keyLoader.currentContext,
                    rootNavigator: true)
                    .pop();
                forgotEmailController.text = "";

                switch (answ) {
                  case '200':
                    alertDialog(context, "Um link para restauração de senha será enviado para o email cadastrado em alguns instantes.");
                    break;
                  case '1':
                    GlobalScaffold.instance.showSnackbar(SnackBar(
                        content: Text(
                          "Erro de Conexão Timeout.",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 3)));
                    break;
                  case '2':
                    GlobalScaffold.instance.showSnackbar(SnackBar(
                        content: Text(
                          "Sem conexão com a Internet.",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 3)));
                    break;
                  default:
                    GlobalScaffold.instance.showSnackbar(SnackBar(
                        content: Text(
                          "Ocorreu um erro.",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 3)));
                    break;
                }
              }
              else{
                GlobalScaffold.instance.showSnackbar(SnackBar(
                    content: Text(
                      "Insira um email válido.",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 3)));
              }

            }),
        FlatButton(
            child: Text('Cancelar'),
            onPressed: (){
              forgotEmailController.text = "";
              Navigator.of(context).pop(false);
            }
        ),
      ],
    );
  });
}