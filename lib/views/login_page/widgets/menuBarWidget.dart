import 'package:task_scape/controllers/login_page_controller.dart';
import 'package:task_scape/utils/tabIndicationPainter.dart';
import 'package:flutter/material.dart';

Widget MenuBar(BuildContext context, controller) {
  return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: controller),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  LoginPageController.instance.onSignInButtonPress(controller);
                },
                child: ValueListenableBuilder(
                  valueListenable: LoginPageController.instance.left,
                  builder: (context, value, child){
                    return Text(
                      "Entrar",
                      style: TextStyle(
                        color: value,
                        fontSize: 16.0,
                      ),
                    );
                  },
                )
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  LoginPageController.instance.onSignUpButtonPress(controller);
                },
                child: ValueListenableBuilder(
                  valueListenable: LoginPageController.instance.right,
                  builder: (context, value, child){
                    return Text(
                      "Cadastrar",
                      style: TextStyle(
                        color: value,
                        fontSize: 16.0,
                      ),
                    );
                  },
                )
              ),
            ),
          ],
        ),
      ));
}


