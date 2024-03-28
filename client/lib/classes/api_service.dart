

import 'dart:async';

import 'package:client/dto/page_dto.dart';
import 'package:client/env/env.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/error_utils.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';


class PN { // Parameter Name
  static const
    page = 'page',
    limit = 'limit',
    query = 'query',
    sort = 'sort',
    ignoreIfEmpty = 'ignoreIfEmpty',
    isActive = 'isActive'
    ;
}

class PV { // Parameter Value

  static const
    pageSize = 9,
    pageSizeMax = 999; // NB! Don't increase, instead of use infinite load or pageable
}

typedef RequestQuery = Map<String, dynamic>;


class _BaseApi extends GetConnect implements GetxService {

  _BaseApi() {
    timeout = const Duration(seconds: 30);
  }

  // Must be as strings, as GetConnect don't support other types
  Map<String, String>? _convertQuery(RequestQuery? query) {

    if (query == null) return null;

    var result = <String, String>{};
    for (var entry in query.entries) {

      var v = entry.value;
      if (v == null) {
        continue;
      }

      if (v is List) {
        v = v.map(_toString).whereNotNull().join(',');
      }

      result[entry.key] = v.toString();
    }

    return result;
  }

  String _toString(dynamic v) {

    if (v is Enum) {
      return v.name;
    }

    return v.toString();
  }

  Future<T> deleteSimple<T>(String url, FromJson<T> converter, [ Map<String, String>? headers]) async {
    final response = await delete(url, headers: headers);
    return _responseToJson(response, converter);
  }

  Future<T> getSimple<T>(String url, FromJson<T> converter, [RequestQuery? query, Map<String, String>? headers]) async {
    final response = await get(url, query: _convertQuery(query), headers: headers);
    return _responseToJson(response, converter);
  }

  Future<T> postSimple<T>(String url, dynamic data, FromJson<T> converter, [Map<String, String>? headers]) async {
    final response = await post(url, data, headers: headers);
    return _responseToJson(response, converter);
  }

  FutureOr<T> _responseToJson<T>(Response<dynamic> response, FromJson<T> converter) {
    if (response.status.hasError) {
      return Future.error(ErrorUtils.define(response));
    } else {
      return ConvertUtils.fromJsonStr(response.bodyString!, converter);
    }
  }

  Future<List<T>> getAllPaged<T>(String url, FromJson<PageDto<T>> converter, [RequestQuery? query]) async {

    query ??= {};
    query[PN.limit] = PV.pageSizeMax;

    final result = await getSimple(url, converter, query);
    return result.content;
  }


}

class ApiService extends _BaseApi {

  @override
  void onInit() {
    super.onInit();

    httpClient.baseUrl = iEnv.apiUrl;
    httpClient.addRequestModifier((Request<dynamic> request) {
      modifyRequest(request);
      return request;
    });
  }

  modifyRequest(Request<dynamic> request) {
    request.headers["Access-Control-Allow-Origin"] = "*";
    request.headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS';
    request.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, X-Auth-Token';
  }
}

