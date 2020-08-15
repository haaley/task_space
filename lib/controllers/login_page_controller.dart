import 'package:task_scape/common/UserData.dart';
import 'package:task_scape/model/login.dart';
import 'package:task_scape/utils/dialogsWidget.dart';
import 'package:task_scape/utils/globalScaffold.dart';
import 'package:task_scape/views/login_page/widgets/alertDialogWidget.dart';
import 'package:task_scape/views/login_page/widgets/forgotPasswordWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/user.dart';
import '../services/loginPageService.dart';
import '../utils/globalScaffold.dart';
import '../views/home_page/home_page.dart';

class LoginPageController {
  LoginPageController._();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  static final LoginPageController instance = LoginPageController._();
  final left = ValueNotifier<Color>(Colors.black);
  final right = ValueNotifier<Color>(Colors.white);

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodePhone = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeLastName = FocusNode();

  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupPhoneController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupLastNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  ValueNotifier<bool> _obscureTextLogin = ValueNotifier(true);

  changePage(int i) {
    if (i == 0) {
      left.value = Colors.black;
      right.value = Colors.white;
    } else {
      left.value = Colors.white;
      right.value = Colors.black;
    }
  }

  onSignInButtonPress(pageController) {
    pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  onSignUpButtonPress(pageController) {
    pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  Widget buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.email,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: ValueListenableBuilder(
                          valueListenable: _obscureTextLogin,
                          builder: (context, value, child){
                            return TextField(
                              focusNode: myFocusNodePasswordLogin,
                              controller: loginPasswordController,
                              obscureText: value,
                              style: TextStyle(
                                  fontFamily: "WorkSansSemiBold",
                                  fontSize: 16.0,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.lock,
                                  size: 22.0,
                                  color: Colors.black,
                                ),
                                hintText: "Senha",
                                hintStyle: TextStyle(
                                    fontFamily: "WorkSansSemiBold", fontSize: 17.0),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      _obscureTextLogin.value = !_obscureTextLogin.value;
                                      print(_obscureTextLogin.value);
                                      _obscureTextLogin.notifyListeners();
                                    },
                                    child: Icon(
                                          value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 22.0,
                                          color: Colors.black,
                                    )
                                ),
                              ),
                            );
                          },
                        )
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 170.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Color.fromRGBO(240, 173, 78, 1),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Color(0xFFf7418c),
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () async {
                      Dialogs.showLoadingDialog(
                          context, _keyLoader, "Entrando...");
                      Login login = new Login(
                          name: loginEmailController.text,
                          password: loginPasswordController.text);
                      var response =
                          await LoginPageService.instance.authUser(login);

                      if (response == null) {
                        await saveLoggedUser();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomePage()));
                      } else {
                        print(response);
                        Navigator.of(context, rootNavigator: true).pop();
                        switch (response) {
                          case '401':
                            alertDialog(context,
                                "Senhas incorreta ou conta não ativada. Tente novamente ou verifique seu email e ative sua conta.");
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
                    }),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () {
                  ForgotPasswordWidget(context);

                },
                child: Text(
                  "Esqueceu a senha?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "WorkSansMedium"),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignUp(BuildContext context, PageController controller) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 510.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 18.0, bottom: 18.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeName,
                          controller: signupNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Nome",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 18.0, bottom: 18.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeLastName,
                          controller: signupLastNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.person,
                                color: Colors.black, size: 22.0),
                            hintText: "Sobrenome",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 18.0, bottom: 18.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmail,
                          controller: signupEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.email,
                                color: Colors.black, size: 22.0),
                            hintText: "Email",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 18.0, bottom: 18.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePhone,
                          controller: signupPhoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.call,
                              color: Colors.black,
                            ),
                            hintText: "Telefone",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 18.0, bottom: 18.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePassword,
                          controller: signupPasswordController,
                          obscureText: _obscureTextSignup,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Senha",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: () {

                              },
                              child: Icon(
                                _obscureTextSignup
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 18.0, bottom: 18.0, left: 25.0, right: 25.0),
                        child: TextField(
                          controller: signupConfirmPasswordController,
                          obscureText: _obscureTextSignupConfirm,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Confirmar Senha",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: () {},
                              child: Icon(
                                _obscureTextSignupConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 500.0),
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Color.fromRGBO(240, 173, 78, 1)),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Color(0xFFf7418c),
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "Registrar",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () async {
                      String response;
                      if (signupPasswordController.text ==
                          signupConfirmPasswordController.text) {
                        Login newUser = new Login(
                            name: signupEmailController.text,
                            password: signupPasswordController.text);
                        if(signupPhoneController.text.length == 15 && validateFields()){
                          Dialogs.showLoadingDialog(context, _keyLoader, "Cadastrando...");
                          String phone = signupPhoneController.text.substring(1,3)+signupPhoneController.text.substring(5,10) + signupPhoneController.text.substring(11,15);
                          print(phone);
                          response = await LoginPageService.instance.attemptRegister(
                            newUser.name,
                            newUser.password,
                            signupNameController.text,
                            signupLastNameController.text,
                            int.parse(phone),
                          );
                          Navigator.of(context, rootNavigator: true).pop();


                          if (response == "") {
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                                title: Icon(Icons.info, size: 56.0, color: Colors.orange,),
                                content: Text(
                                    "Usuário cadastrado com sucesso! Acesse seu email para ativar sua conta.", style: TextStyle(fontFamily: "WorkSansSemiBold"),textAlign: TextAlign.justify
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text('Ok'),
                                      onPressed: (){
                                        signupPhoneController.text = "";
                                        signupConfirmPasswordController.text="";
                                        signupEmailController.text ="";
                                        signupNameController.text = "";
                                        signupLastNameController.text = "";
                                        signupPasswordController.text = "";
                                        onSignInButtonPress(controller);
                                        Navigator.of(context).pop(false);
                                      }
                                  ),
                                ],
                              );
                            });

                          } else {
                            GlobalScaffold.instance.showSnackbar(SnackBar(
                                content: Text(
                                  response,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 3)));
                          }
                        }
                        else{
                          GlobalScaffold.instance.showSnackbar(SnackBar(
                              content: Text(
                                "Preencha todos os campos corretamente.",
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.orange,
                              duration: Duration(seconds: 3)));
                        }

                      } else {
                        SnackBar(
                            content: Text(
                              "Senhas não coincidem.",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 3));
                      }

                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void saveLoggedUser() async {
    var response = await LoginPageService.instance.getLoggedUser();

    UserData().nickname = response['nickname'];
    UserData().id = response['id'];
    UserData().email = response['email'];

    print(UserData().nickname);
  }

  bool validateFields(){
    if(signupEmailController.text.isNotEmpty && signupPasswordController.text.isNotEmpty && signupLastNameController.text.isNotEmpty && signupNameController.text.isNotEmpty) return true;
    else return false;
  }


}
