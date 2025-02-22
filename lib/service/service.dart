import 'dart:convert';
import 'dart:io';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:terminal/models/jokes_model.dart';
import 'package:http/http.dart' as http;

class Service{


  Future<String> getIpAddress() async {
    final ipv4 = await Ipify.ipv4();
    print(ipv4); // 98.207.254.136
    return ipv4;
  }

  Future<String?> getPhoneModelAndroid() async {
    String? model;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
   if(Platform.isIOS){
     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
     print('Running on ${iosInfo.utsname.machine}');
     model = iosInfo.utsname.machine;
    } else{
     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
     print('Running on ${androidInfo.device}');// e.g. "Moto G (4)"
     model='${androidInfo.device}';
    }
    return model;
  }


   Future<List<dynamic>> getJokesFromApi() async {
    var response = await http.get(Uri.parse('https://v2.jokeapi.dev/joke/Programming?amount=10'));
    if (response.statusCode == 200) {
     // print(response.body);
      return parseResult(response.body);
    } else {
      throw Exception('Failed to load data');
    }
   }

   List<Jokes> parseResult(String responseBody) {
     final Map<String, dynamic> parsed = jsonDecode(responseBody);
     var jokes = List<Jokes>.from(
         parsed["jokes"].map((x) => Jokes.fromJson(x)));
     print(jokes);
     return jokes;
  }
}