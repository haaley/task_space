import 'package:task_scape/resources/wsAPI.dart';
import 'dart:async';

class NewMeetingPageService {
  static final NewMeetingPageService instance = NewMeetingPageService._();

  NewMeetingPageService._();

  Future<List> getUsers(String startDate, String endDate) async {
    List response = await WsAPI().loadUsers(startDate, endDate);

    return response;
  }

  Future<List> newMeeting(Map<String, dynamic> data) async {
    List response = await WsAPI().newMeeting(data);

    return response;
  }

  Future<int> sendEmail(int idMeeting) async {
    int response = await WsAPI().sendEmailMeeting(idMeeting);

    return response;
  }

  Future<Map<String, dynamic>> addOutsideGuest(
      Map<String, dynamic> guest) async {
    Map<String, dynamic> response = await WsAPI().addOutsideGuest(guest);
    return response;
  }

  loadMeeting(String url) async{
    return await WsAPI().loadMeeting(url);
  }

  Future<int> editMeeting(Map<String, dynamic> data, String url) async{
    return await WsAPI().editMeeting(data, url);
  }

}