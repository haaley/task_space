import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'package:path_provider/path_provider.dart';

class WsAPI {
  final storage = new secure.FlutterSecureStorage();
  var URL_API = "http://homologacao.sefaz.ma.gov.br/ws-app-atas";

  Future<List> loadMeetings() async {
    String url = "$URL_API/meeting";
    String token = await storage.read(key: "token");
    var answer;
    try {
      await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      })
          .timeout(Duration(seconds: 5))
          .then((response) {
        print("code: ${response.statusCode}");
        answer = response;
      });
    } on TimeoutException catch (_) {
      return [400];
    } on SocketException catch (_) {
      return [400];
    }
    try {
      return jsonDecode(
          utf8.decode(answer.bodyBytes))['_embedded']['meetingResponseList'];
    } catch (error) {
      return [];
    }
  }

  loadMeeting(String url) async {
    String value = await storage.read(key: "token");
    var res;
    try {
      await http
          .get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${value}"
      })
          .timeout(Duration(seconds: 5))
          .then((response) {
        res = response;
      });
    } on TimeoutException catch (e) {
      return "Timeout.";
    } on SocketException catch (e) {
      return "Erro de conexão.";
    }

    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  Future<List> loadMeetingAgendas(String url) async {
    String value = await storage.read(key: "token");
    var resp = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${value}"
    });
    var response =
    jsonDecode(utf8.decode(resp.bodyBytes))['agendaResponseList'];
    print('response ${response}');
    return response;
  }

  Future<String> forgotPassword(String email) async {
    var resp;
    try {
      await http
          .post("$URL_API/users/forgotPassword",
          body: json.encode({"email": email}),
          headers: {"Content-Type": "application/json"})
          .timeout(Duration(seconds: 5))
          .then((response) {
        resp = response.statusCode;
      });
      return resp.toString();
    } on TimeoutException catch (e) {
      return "1";
    } on SocketException catch (e) {
      return "2";
    }
  }

  Future<void> exportPdf(int id) async {
    String value = await storage.read(key: "token");

    Dio dio = Dio();
    String dirloc = (await getExternalStorageDirectory()).path;

    try {
      FileUtils.mkdir([dirloc]);
      await dio.download(
          "$URL_API/meeting/$id", dirloc + "/ata_" + id.toString() + ".pdf",
          options: Options(headers: {
            "Authorization": "Bearer $value",
            "Accept": "application/pdf"
          }));
    } catch (e) {
      print(e);
    }
  }

  Future<int> editMeeting(Map<String, dynamic> data, String url) async {
    String value = await storage.read(key: "token");
    var answ;
    try {
      await http
          .put(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${value}"
          },
          body: json.encode(data))
          .timeout(Duration(seconds: 10))
          .then((response) {
        answ = response;
      });

      return 201;
    } on TimeoutException catch (_) {
      print("timeout");
      return 400;
    } on SocketException catch (error) {
      print("socketexception");
      return 400;
    }

  }

  Future<List> editAgendaMeeting(Map<String, dynamic> data, String url) async {
    print("url $url");
    print("data $data");
    String value = await storage.read(key: "token");
    var answ;
    try {
      await http
          .put(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${value}"
          },
          body: json.encode(data))
          .timeout(Duration(seconds: 10))
          .then((response) {
        answ = response;
      });


    } on TimeoutException catch (_) {
      print("timeout");
      return [400];
    } on SocketException catch (erro) {
      print("socketexception");
      return [400];
    }

    List resp = [];
    resp.add(answ.statusCode.toString());
    resp.add(jsonDecode(answ.body));
    print("resp: "+resp.toString());
    return resp;
  }

  Future<void> deleteGuestMeeting(String url) async {
    String value = await storage.read(key: "token");
    var answ = await http.delete(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${value}"
    });

  }

  Future<void> deleteAgendaMeeting(String url) async {
    String value = await storage.read(key: "token");
    var answ = await http.delete(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${value}"
    });

  }

  Future<Map<String, dynamic>> addOutsideGuest(
      Map<String, dynamic> guest) async {
    String url = "${URL_API}/users/new";
    String value = await storage.read(key: "token");
    Map<String, dynamic> erro = new Map();
    var answ;
    try {
      await http
          .post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${value}"
          },
          body: json.encode(guest))
          .timeout(Duration(seconds: 10))
          .then((response) {
        answ = response;
      });
    } on TimeoutException catch (_) {
      erro['erro'] = "timeout";
      return erro;
    } on SocketException catch (error) {
      erro['erro'] = "socket";
      return erro;
    }

    return jsonDecode(utf8.decode(answ.bodyBytes));
  }

  Future<String> apiVersion() async {
    var url = '$URL_API/version';
    String value = await storage.read(key: "token");
    var response;
    try {
      await http
          .get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $value"
      })
          .timeout(Duration(seconds: 5))
          .then((response) {
        response = response;
      });
    } on TimeoutException catch (e) {
      return "";
    } on SocketException catch (e) {
      return "";
    }
    try {
      var teste = jsonDecode(utf8.decode(response.bodyBytes))["apiVersion"];
      return teste;
    } catch (erro) {
      return "";
    }
  }

  Future<List> login(String username, String password) async {
    var res;
    try {
      await http
          .post("$URL_API/authenticate",
          body: json.encode({"username": username, "password": password}),
          headers: {"Content-Type": "application/json"})
          .timeout(Duration(seconds: 5))
          .then((response) {
        res = response;
      });
    } on TimeoutException catch (e) {
      print(res.statusCode);
      return [1];
    } on SocketException catch (e) {
      return [2];
    }

    List answ = [];
    answ.add(res.statusCode);
    answ.add(res.body);
    return answ;
  }

  Future<String> register(String name, String lastname, String username,
      String password, int contact) async {
    var res;
    try {
      await http
          .post("$URL_API/users",
          body: json.encode({
            "nickname": name,
            "email": username,
            "password": password,
            "contact": contact,
            "company": "SEFAZ-MA"
          }),
          headers: {"Content-Type": "application/json"})
          .timeout(Duration(seconds: 5))
          .then((response) {
        res = response;
      });
    } on TimeoutException catch (e) {
      return "Timeout!";
    } on SocketException catch (e) {
      return "Sem conexão com a internet.";
    }
    if (res.statusCode == 400) {
      res = jsonDecode(utf8.decode(res.bodyBytes))['message'];
      return res;
    }
    else {
      return "200";
    }
  }

  Future<Map<String, dynamic>> loggedUser() async {
    var url = '$URL_API/users/me';
    String value = await storage.read(key: "token");
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $value"
    });
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<List> loadGuest(String url) async {
    String value = await storage.read(key: "token");
    var answ;
    try {
      await http
          .get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${value}"
      })
          .timeout(Duration(seconds: 10))
          .then((response) {
        answ = response;
      });
    } on TimeoutException catch(_){
      return [];
    } on SocketException catch(_){
      return [];
    }

    var response = jsonDecode(utf8.decode(answ.bodyBytes))['guestResponseList'];
    print("json guest ${response}");
    return response;
  }

  Future<int> updateGuestStatus(String url, int status) async{
    String newurl = url + "?guestStatus=${status}";
    String value = await storage.read(key: "token");

    var answ;
    try{
      await http
          .patch(newurl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${value}"
        },)
          .timeout(Duration(seconds: 10))
          .then((response) {
        answ = response.statusCode;
      });


    }on TimeoutException catch (_) {
      print("timeout");
      return 400;
    } on SocketException catch (error) {
      print("socketexception");
      return 400;
    }

    return 200;
  }

  Future<List> loadUsers(start, end) async {
    var url = '${URL_API}/users' + '?startExpected=${start}&endExpected=${end}';
    String value = await storage.read(key: "token");
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${value}"
    },);
    print(jsonDecode(utf8.decode(response.bodyBytes)).toString());
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<List> newMeeting(Map<String, dynamic> data) async {
    var url = '${URL_API}/meeting';
    String value = await storage.read(key: "token");
    print(data.toString());
    var answ;
    var body;
    try {
      await http
          .post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${value}"
          },
          body: json.encode(data))
          .timeout(Duration(seconds: 20))
          .then((response) {
        answ = response.statusCode;
        body = jsonDecode(response.body);
      });
    } on TimeoutException catch (_) {
      debugPrint("timeout");
      return [400];
    } on SocketException catch (error) {
      debugPrint("socketexception");
      return [400];
    }
    List resp = [];
    resp.add(201);
    resp.add(body['idMeeting']);
    return resp;
  }

  Future<int> sendEmailMeeting(int idMeeting) async{
    String newurl = URL_API + "/meeting/${idMeeting}/sendEmailMeetingCreated";
    String value = await storage.read(key: "token");
    print(newurl);
    var answ;
    try{
      await http
          .post(newurl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${value}"
        },)
          .timeout(Duration(seconds: 10))
          .then((response) {
        answ = response.statusCode;
      });
      return 200;
    }on TimeoutException catch (_) {
      return 400;
    } on SocketException catch (error) {
      return 400;
    }
  }

  Future<int> updateMeeting(String url) async {
    //url = url.replaceAll("172.20.3.52:8080", "homologacao.sefaz.ma.gov.br");
    String value = await storage.read(key: "token");
    var answ;
    try{
      await http
          .patch(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${value}"
        },)
          .timeout(Duration(seconds: 10))
          .then((response) {
        answ = response.statusCode;
      });

    }on TimeoutException catch (_) {
      print("timeout");
      return 400;
    } on SocketException catch (error) {
      print("socketexception");
      return 400;
    }

    return 200;
  }

  Future<void> addGuest(String url,Map<String, dynamic> data) async {
    //   url = url.replaceAll("172.20.3.52:8080", "homologacao.sefaz.ma.gov.br");
    print("Adicionando ${url} ${data['id']}");
    String value = await storage.read(key: "token");
    Map<String, dynamic> erro = new Map();
    var answ = await http
        .post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${value}"
        },
        body: json.encode(data));
  }

  Future<List> addMeetingAgenda(String url, Map<String, dynamic> data) async {
    String value = await storage.read(key: "token");
    var answ;
    try {
      await http
          .post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${value}"
          },
          body: json.encode(data))
          .timeout(Duration(seconds: 10))
          .then((response) {
        answ = response;
      });


    } on TimeoutException catch (_) {
      print("timeout");
      return [400];
    } on SocketException catch (error) {
      print("socketexception");
      return [400];
    }

    List resp = [];
    resp.add(answ.statusCode.toString());
    resp.add(jsonDecode(answ.body));
    print("api resp: $resp");
    return resp;
  }


}