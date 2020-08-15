import 'dart:collection';
import 'package:task_scape/common/UserData.dart';
import 'package:task_scape/model/guest.dart';
import 'package:task_scape/resources/wsAPI.dart';
import 'package:task_scape/services/meetingPageService.dart';
import 'package:flutter/cupertino.dart';

class GuestModel with ChangeNotifier{
  final List<Guest> _guestList = [];

  UnmodifiableListView<Guest> get guestList => UnmodifiableListView(_guestList);

  int get qtdGuests => _guestList.length;

  bool findGuest(Guest guest){
    bool has = false;
    _guestList.forEach((element){
      if(element.id == guest.id){
        has = true;
      }
    });
    return has;
  }

  bool addGuest(Guest guest){
    if(!findGuest(guest)){
      _guestList.add(guest);
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeGuest(int index){
    _guestList.removeAt(index);
    notifyListeners();
  }

  void removeAllGuests(){
    _guestList.clear();
  }

  List getList(){
    var maps = {};
    List list = [];
    _guestList.forEach((p){
      maps = {};
      maps["id"] = p.id;
      maps["status"] = p.status == "AUTHOR" ? 0 : p.status == "GUEST" ? 1 : 2;
      list.add(maps);
    });
    print("lista: " + list.toString());
    return list;
  }

  Future<List> loadGuests(String url) async{
    List guests = [];
    guests = await MeetingPageService.instance.loadGuests(url);
    guests.forEach((element) {
      addGuest(new Guest.fromJson(element));
    });

    return guests;
  }

}