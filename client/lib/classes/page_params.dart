


abstract class PageParams {

  final map = <String,String>{};

  PageParams(Uri uri, Map<String,String> params) {
    map.addAll(params);
    map.addAll(uri.queryParameters);
  }

  get(String key, String initialValue) {
    return map[key] ?? initialValue;
  }

}