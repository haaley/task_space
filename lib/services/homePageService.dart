import 'package:task_scape/resources/wsAPI.dart';

class HomePageService{
  static final HomePageService instance = HomePageService._();

  HomePageService._();

  var wsApi = new WsAPI();

   Future<List> loadMeetings() async{
    return await wsApi.loadMeetings();
  }

  apiVersion() async{
     return await wsApi.apiVersion();
  }

}