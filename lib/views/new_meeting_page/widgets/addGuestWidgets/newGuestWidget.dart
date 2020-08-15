import 'package:task_scape/controllers/new_meeting_page_controller.dart';
import 'package:task_scape/model/userProvider.dart';
import 'package:task_scape/views/new_meeting_page/widgets/alertDialogWidget.dart';
import 'package:task_scape/views/new_meeting_page/widgets/addGuestWidgets/newOutsideGuestWidget.dart';
import 'package:flutter/material.dart';


final TextEditingController _filter = new TextEditingController();
String _searchText = "";
List users;

class NewGuest extends StatefulWidget {

  @override
  _NewGuestState createState() => _NewGuestState();
}

class _NewGuestState extends State<NewGuest>  with SingleTickerProviderStateMixin {

  _NewGuestState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          print(_filter.text);
          _searchText = _filter.text;
        });
      }
    });
  }

  void loadData() async {
    await UserViewModel.loadUsers(NewMeetingPageController.instance.data["startExpected"], NewMeetingPageController.instance.data["endExpected"]);
    setState(() {
    });
  }


  @override
  void initState() {
    print("init");
    loadData();
    _searchText = "";
    _filter.clear();
    _filter.text = "";
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.85),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 99, 170, 1),
          title: Text("Editar Convidados"),
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Container(
                  child: TextField(
                    controller: _filter,
                    decoration: InputDecoration(
                      hintText: "Buscar Convidado",
                      suffixIcon: IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            size: 36.0,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            NewOutsideGuest(context);
                          }),
                    ),
                  ),
                )
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0, left: 20.0),
                  child:_body(context)
                )
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return alertDialog(
        context, 'Deseja sair da edição de convidados?', backAction) ??
        false;
  }

  _body(BuildContext context){
    users = NewMeetingPageController.instance.getListaUsuarios(_searchText);
    if(UserViewModel.users.isEmpty){
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else if(users[0] == 0){
      return Container(
        height: 200,
        child: Center(
          child: Text("Nenhum resultado."),
        ),
      );
    }
    else{
      return ListView.builder(
        itemCount: users.length,
        padding: new EdgeInsets.only(top: 5.0),
        itemBuilder: buildList,
      );
    }
  }

  Widget buildList(context, index) {
    return GestureDetector(
        child: Container(
          decoration:
          BoxDecoration(borderRadius: new BorderRadius.circular(10.0)),
          margin: const EdgeInsets.only(
              left: 10.0, right: 10.0, bottom: 10.0, top: 5.0),
          child: new Material(
              borderRadius: new BorderRadius.circular(6.0),
              elevation: 2.0,
              child: SingleChildScrollView(
                child: Container(
                  height: 95.0,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/avatar.png'),
                        width: 95.0,
                        height: 95.0,
                      ),
                      _getColumText(
                          users[index].fullname,
                          users[index].conflict ? 'Ocupado' : 'Disponivel',
                          users[index].email,
                          users[index].conflict
                      ),
                    ],
                  ),
                ),
              )),
        ),
        onTap: () {
          NewMeetingPageController.instance.addGuests(context, users[index].fullname, users[index].email,
              users[index].id, users[index].conflict);
          _filter.text = "";
        });
  }
}

Widget _getColumText(title, date, description, conflito) {
  return new Expanded(
      child: new Container(
        margin: new EdgeInsets.all(10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getTitleWidget(title, conflito),
            _getDateWidget(date),
            _getDescriptionWidget(description)
          ],
        ),
      ));
}

Widget _getTitleWidget(String curencyName, bool conflito) {
  return Text(
    curencyName,
    maxLines: 1,
    style: new TextStyle(
        fontWeight: FontWeight.bold,
        color: conflito ? Colors.red : Colors.black),
  );
}

Widget _getDescriptionWidget(String description) {
  return new Container(
    margin: new EdgeInsets.only(top: 5.0),
    child: new Text(
      description,
      maxLines: 2,
    ),
  );
}

Widget _getDateWidget(String date) {
  return new Text(
    date,
    style: new TextStyle(color: Colors.grey, fontSize: 10.0),
  );
}

void backAction(BuildContext context) {
  Navigator.of(context).pop(false);
  Navigator.of(context).pop(false);

}

