import 'package:task_scape/common/UserData.dart';
import 'package:task_scape/model/user.dart';
import 'package:task_scape/services/newMeetingPageService.dart';

class UserViewModel{

  static List<User> users;

  static Future loadUsers(String startDate, String endDate) async{
    print("load provider");
    try{
      users = List<User>();

      List parsedJson = await NewMeetingPageService.instance.getUsers(startDate, endDate);
      var categoryJson = parsedJson as List;
      categoryJson.forEach((u) {
        if(u['id'] != UserData().id) {
          bool has = false;
          users.forEach((element) {
            if(element.id == u['id']){
              has = true;
            }
          });
          if(!has){
            print(u.toString());
            users.add(new User.fromJson(u));
          }
        }

      });
      users
          .sort((a, b) => a.fullname.compareTo(b.fullname));

    }catch(e){

    }
  }
}