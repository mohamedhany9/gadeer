import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:get/get.dart' as getx;

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.connectTimeout = 60000;
    _dio.options.sendTimeout = 60000;
    _dio.options.receiveTimeout = 60000;

    if (!kReleaseMode) {
      _dio.interceptors.add(LogInterceptor(responseBody: true));
    }
    // _dio.interceptors.add(InterceptorsWrapper(
    //     onError: (DioError dioError, _) => errorInterceptor(dioError)));

    _dio.options.baseUrl = Constants.baseUrl;
    _dio.options.headers.addAll({"Accept": "application/json"});
    _dio.options.receiveDataWhenStatusError = true;

    /*_dio.options.headers.addAll({
            "Authorization":
                "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaXNBZG1pbiI6dHJ1ZSwiaWF0IjoxNTkwNzc1NjQ2LCJleHAiOjE1OTMzNjc2NDZ9.CP_xj_cdDlLtw0YuWbD-fKvvn-HDN52rAYmNu3j2CC4"
          });*/
  }

  Future<T?> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    headers = await addToken(headers);
    final res = await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: extra,
      ),
    );
    return res.data;
  }

  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    onReceiveProgress,
  }) async {
    headers = await addToken(headers);

    late Response<T> res;
    await _dio
        .get<T>(
      path,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: extra,
      ),
    )
        .then((value) {
      if (value.statusCode == 200) {
        res = value;
      }
      if (value.statusCode == 408) {
        get(path,
            queryParameters: queryParameters,
            extra: extra,
            headers: headers,
            onReceiveProgress: onReceiveProgress);
      }
    });
    return res.data;
  }

  Future<T?> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    onSendProgress,
    onReceiveProgress,
  }) async {
    headers = await addToken(headers);

    late Response<T> res;
    try {
      await _dio
          .post<T>(
        path,
        data: data,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          extra: extra,
        ),
      )
          .then((value) {
        if (value.statusCode == 200) {
          res = value;
        }
        if (value.statusCode == 408) {
          post(path,
              data: data,
              onReceiveProgress: onReceiveProgress,
              headers: headers,
              extra: extra,
              queryParameters: queryParameters);
        }
      });
    } on DioError catch (e) {
      if (e.response?.statusCode == 422) {
        print("should catch dio error");
        print("should ${e.response}");

        res = e.response as Response<T>;
      } else {
        throw e;
      }
    }
    return res.data;
  }

  Future<T?> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    onSendProgress,
    onReceiveProgress,
  }) async {
    headers = await addToken(headers);
    // headers.addAll({
    //   "content-type": "multipart/form-data"
    // });

    late Response<T> res;
    await _dio
        .post<T>(
      path,
      data: data,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      options: Options(
        headers: headers,
        extra: extra,
      ),
    )
        .then((value) {
      if (value.statusCode == 200) {
        res = value;
      }
      if (value.statusCode == 408) {
        post(path,
            data: data,
            onReceiveProgress: onReceiveProgress,
            headers: headers,
            extra: extra,
            queryParameters: queryParameters);
      }
    });
    return res.data;
  }

  errorInterceptor(DioError dioError) async {
    if ((dioError.response?.statusCode == 401)) {
      HiveService().put<bool>(Constants.gaderBox, Constants.isLoggedIn, false);
      HiveService().put<String?>(Constants.gaderBox, Constants.token, null);
      getx.Get.offAllNamed(
        Routes.login,
      );
    } else {
      throw dioError;
    }
    FirebaseCrashlytics.instance.log(dioError.message.toString());
    FirebaseCrashlytics.instance.log(dioError.response.toString());
  }

  Future<Map<String, dynamic>> addToken(Map<String, dynamic>? headers) async {
    if (headers == null) {
      headers = {};
    }
    String? token;
    token = await HiveService().get(Constants.gaderBox, Constants.token);
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }
}
