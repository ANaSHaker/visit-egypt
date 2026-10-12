
import 'package:dio/dio.dart';

class DioHelper{
  static Dio? dio;

  static void init(){
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://maps.googleapis.com',
        receiveDataWhenStatusError: true,
      )
    );

  }

  static Future<Response> getData(
      {required String path, Map<String, dynamic>? data})async{
    return await dio!.get(path,queryParameters: data);
  }
  static Future<Response> postData({required String path,required Map<String,dynamic> data,}){
    dio!.options.headers = {
      'lang':'en',
      'Content-Type' : 'application/json',
    };
    return dio!.post(path,data: data);
  }

  static Future<Response> postEvent({required String path,required FormData data}){
    dio!.options.headers = {
      'lang':'en',
      'Content-Type' : 'multipart/form-data',
      'Accept':'*/*',

    };
    return dio!.post(path,data: data);
  }
  static Future<Response> postCulture({required String path,required FormData data,}){
    dio!.options.headers = {
      'lang':'en',
      'Content-Type' : 'multipart/form-data',
      'Accept':'*/*',

    };
    return dio!.post(path,data: data);
  }

  static Future<Response> putData({required String path,required Map<String,dynamic> data,}){
    dio!.options.headers = {
      'lang':'en',
      'Content-Type' : 'application/json',
    };
    return dio!.put(path,data: data);
  }
  static Future<Response> deletetData({required String path}){
    dio!.options.headers = {
      'lang':'en',
      'Content-Type' : 'application/json',
    };
    return dio!.delete(path);
  }
}