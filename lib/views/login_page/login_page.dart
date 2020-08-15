import 'package:task_scape/controllers/login_page_controller.dart';
import 'package:task_scape/views/login_page/widgets/menuBarWidget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
        overscroll.disallowGlow();
        },
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height > 900
              ? MediaQuery.of(context).size.height
              : 900.0,
          decoration: new BoxDecoration(color: Color.fromRGBO(0, 99, 170, 1)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 75.0),
                child: new Image(
                    width: 307.0,
                    height: 101.0,
                    fit: BoxFit.fill,
                    image: new AssetImage('assets/logo.png')),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: MenuBar(context,_pageController),
              ),
              Expanded(
                flex: 2,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) {
                    LoginPageController.instance.changePage(i);
                  },
                  children: <Widget>[
                    new ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: LoginPageController.instance.buildSignIn(context),
                    ),
                    new ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: LoginPageController.instance.buildSignUp(context, _pageController),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
