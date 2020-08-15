import 'package:task_scape/resources/wsAPI.dart';

class MeetingPageService{

  static final MeetingPageService instance = MeetingPageService._();

  MeetingPageService._();


  Future<List> loadMeetingAgenda(String url) async{
    return await WsAPI().loadMeetingAgendas(url);
  }

  Future<List> loadGuests(String url) async{
    return await WsAPI().loadGuest(url);
  }

  Future<List> editAgendaMeeting(Map<String, dynamic> data, String url)async{
    return await WsAPI().editAgendaMeeting(data, url);
  }

  Future<void> deleteMeetingAgenda(String url) async{
    await WsAPI().deleteAgendaMeeting(url);
  }

  Future<void> exportPDF(int id) async{
    await WsAPI().exportPdf(id);
  }

  Future<int> updateMeeting(String url) async{
    return await WsAPI().updateMeeting(url);
  }

  loadMeeting(String url) async{
    return await WsAPI().loadMeeting(url);
  }

  Future<List> addMeetingAgenda(String url, Map<String,dynamic> newMeeitngAgenda) async{
    List resp =  await WsAPI().addMeetingAgenda(url, newMeeitngAgenda);
    print("resp service $resp");
    return resp;
  }

  addGuest(String url, Map<String, dynamic> newGuest) async{
    await WsAPI().addGuest(url, newGuest);
  }

  deleteGuest(String url) async{
    await WsAPI().deleteGuestMeeting(url);
  }

  Future<int> updateGuest(String url, int value) async{
    return await WsAPI().updateGuestStatus(url, value);
  }

}