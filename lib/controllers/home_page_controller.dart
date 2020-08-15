import 'package:task_scape/services/homePageService.dart';
import 'package:task_scape/views/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class HomePageController {
  static final HomePageController instance = HomePageController._();

  HomePageController._();

  final search_icon = ValueNotifier<IconData>(Icons.search);
  final title_bar = ValueNotifier<Widget>(Text("Reuniões"));
  final TextEditingController _filter = new TextEditingController();
  final filteredMeetings = ValueNotifier<List>([]);
  final meetingList = ValueNotifier<List>([]);

  Future<List> loadMeetings() async {
    List list = [];
    list = await HomePageService.instance.loadMeetings();
    list.forEach((element) {
      meetingList.value.add(element);
    });

    return list;
  }

  List filteringMeetings(List result){
    result.forEach((e) {
      String data =
      e['startExpected'].replaceAll('T', ' ').replaceAll("Z", '');
      DateTime startDate = DateTime.parse(data);

      if (startDate.day == DateTime.now().day &&
          startDate.month == DateTime.now().month &&
          startDate.year == DateTime.now().year &&
          e['status'] != "FINISHED") {
        now.add(e);
      }

      if (startDate.isBefore(DateTime.now()) &&
          DateTime.now().difference(startDate).inHours > 12 ||
          e['status'] == "FINISHED") {
        past.add(e);
      }

      if (startDate.isAfter(DateTime.now()) &&
          startDate.difference(DateTime.now()).inHours > 12 &&
          e['status'] == "SCHEDULED") {
        future.add(e);
      }
    });
    List filtered = [];
    filtered.add(past);
    filtered.add(now);
    filtered.add(future);

    return filtered;
  }

  List filteredSearchResult(String _searchText, List result) {
    List filtered = new List();

      if (_searchText.isEmpty) {
        filtered.clear();
        if(pend_filter) {
          for (int i = 0; i < result.length; i++) {
            List listagenda = result[i]['agendaResponseList'];
            bool has = false;
            listagenda.forEach((e) {
              if (e['status'] == "PENDING") {
                print(e['status']);
                has = true;
              }
              else {
                print(e['status']);
              }
            });
            if (has) filtered.add(result[i]);
          }
        }
        else{
          result.forEach((e) {
            filtered.add(e);
          });
        }
      } else {
        filtered.clear();
        if (pend_filter) {
          for (int i = 0; i < result.length; i++) {
            List listagenda = result[i]['agendaResponseList'];
            bool has = false;
            listagenda.forEach((e) {
              if (e['status'] == "PENDING" && (e['title']
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()) ||
                  result[i]['title'].toLowerCase()
                      .contains(_searchText.toLowerCase()))) {
                print(e['status']);
                has = true;
              }
            });
            if (has) filtered.add(result[i]);
          }
        }
        else {
          for (int i = 0; i < result.length; i++) {
            List listagenda = result[i]['agendaResponseList'];
            if (result[i]['title']
                .toLowerCase()
                .contains(_searchText.toLowerCase())) {
              filtered.add(result[i]);
              print("add ${result[i]['title']}");
            } else {
              bool has = false;
              listagenda.forEach((e) {
                if (e['title']
                    .toLowerCase()
                    .contains(_searchText.toLowerCase())) {
                  print(e['title']);
                  has = true;
                }
              });
              if (has) filtered.add(result[i]);
            }
          }
        }
      }

      return filtered;
  }

  getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appname = packageInfo.appName;
    version = packageInfo.version;
    apiversion = await HomePageService.instance.apiVersion();
  }


}