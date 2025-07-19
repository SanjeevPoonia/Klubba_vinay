import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:klubba/utils/app_modal.dart';
import 'package:klubba/view/no_internet_screen.dart';
import 'package:toast/toast.dart';
import 'app_exceptions.dart';
import 'constants.dart';

class ApiBaseHelper {
  final String _baseUrl = AppConstant.appBaseURL;
  Future<dynamic> get(String url, BuildContext context) async {
    var responseJson;
    print(_baseUrl+url+'  API CALLED');
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        'Content-Type': 'application/json',
      });
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
    }      throw FetchDataException('No Internet connection');

    return responseJson;
  }

  Future<dynamic> postAPI(
      String url, var apiParams, BuildContext context) async {
    print(_baseUrl+url+'  API CALLED');
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest'
          }
      );
      print(response.body.toString()+"hhh");
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
   /* final connectivityResult = await (Connectivity().checkConnectivity());
    print("Internet data");
    print(connectivityResult.toString());
    if(connectivityResult==ConnectivityResult.none)
    {

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => NoInternetScreen()));
    }
    else
      {
        try {
          final response = await http.post(Uri.parse(_baseUrl + url),
              body: json.encode(apiParams),
              headers: {
                'Content-Type': 'application/json',
                'Accept':'application/json',
                'X-Requested-With':'XMLHttpRequest'
              }
          );
          var decodedJson=jsonDecode(response.body.toString());
          print(decodedJson);

          responseJson = _returnResponse(response, context);
        } on SocketException {
          throw FetchDataException('No Internet connection');
        }
      }*/
    return responseJson;
  }

  Future<dynamic> postAPIWithHeader(
      String url, var apiParams, BuildContext context) async {
    print(_baseUrl+url+'  API CALLED');
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest',
            'Authorization':AppModel.userToken
          }
      );
      print(response.body.toString()+"hhh");
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    /* final connectivityResult = await (Connectivity().checkConnectivity());
    print("Internet data");
    print(connectivityResult.toString());
    if(connectivityResult==ConnectivityResult.none)
    {

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => NoInternetScreen()));
    }
    else
      {
        try {
          final response = await http.post(Uri.parse(_baseUrl + url),
              body: json.encode(apiParams),
              headers: {
                'Content-Type': 'application/json',
                'Accept':'application/json',
                'X-Requested-With':'XMLHttpRequest'
              }
          );
          var decodedJson=jsonDecode(response.body.toString());
          print(decodedJson);

          responseJson = _returnResponse(response, context);
        } on SocketException {
          throw FetchDataException('No Internet connection');
        }
      }*/
    return responseJson;
  }
  dynamic _returnResponse(http.Response response, BuildContext context) {
   // var responseJson = jsonDecode(response.body.toString());
    print(response.statusCode.toString() +'Status Code******* ');

   // log('api helper response $response');
    switch (response.statusCode) {
      case 200:
        log(response.body.toString());
        return response;
      case 302:
        print(response.body.toString());
        return response;
      case 201:
        print(response.body.toString());
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        Toast.show('Unauthorized User!!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        throw BadRequestException(response.body.toString());
        break;
      case 403:
        Toast.show('Internal server error !!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        throw UnauthorisedException(response.body.toString());
      case 500:
        Toast.show('Internal server error!!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        break;
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
  checkInternetConnection() async {


  }
}
