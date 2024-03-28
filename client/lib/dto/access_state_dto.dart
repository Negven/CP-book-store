

import 'package:client/dto/access_details_dto.dart';
import 'package:client/enum/access_state.dart';
import 'package:client/utils/convert_utils.dart';
import 'package:client/utils/date_time_utils.dart';


class _AccessStateFields {
  final state = 'state';
  final token = "token";
  final userId = "userId";
}

class AccessStateDto {

  static final f = _AccessStateFields();

  final AccessState state;
  final bool isGranted;
  final String? token;
  final int? userId;

  AccessStateDto({required this.state, this.token, this.userId}) :
        isGranted = state == AccessState.granted;

  static AccessStateDto fromJson(Json json) {
    final state = AccessState.values.byName(json["message"][f.state]);
    final token = json["message"][f.token];
    final userId = json["message"][f.userId];
    // if (state != AccessState.granted) return AccessStateDto(state: state, token: token);

    return AccessStateDto(state: state, token: token, userId: userId);
    // return CredentialDto(state, json);
  }
}


class _CredentialFields extends _AccessStateFields {
  final details = 'details';
  final order = 'order';
}

// NB! de-& serializing dto from/to storage on the client device
class CredentialDto extends AccessStateDto implements ToJson, Uid, Comparable<CredentialDto> {

  static final f = _CredentialFields();

  late final AccessDetailsDto details;

  int _order = 0;
  int get sortOrder => _order != 0 ? _order : uid!.hashCode;
  set sortOrder(int order) { _order = order; }

  CredentialDto(state, Json json) : super(state: state) {
    details = AccessDetailsDto.fromJson(json[f.details]);
    _order = json[f.order] ?? 0;
  }

  bool isExpired() {
    return details.expiration.isBefore(UtcDateTime.now);
  }

  bool isSame(CredentialDto other) {
    return this == other;
  }

  @override
  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};
    json[f.state] = state.name;
    json[f.order] = _order;
    json[f.details] = details.toJson();
    return json;
  }

  static CredentialDto fromJson(Map<String, dynamic> json) {
    return AccessStateDto.fromJson(json) as CredentialDto;
  }

  @override
  // String? get uid => details.wallet.id;

  @override
  int compareTo(CredentialDto other) {
    return sortOrder.compareTo(other.sortOrder);
  }

  static List<CredentialDto> expired(Iterable<CredentialDto> dtos) {
    return dtos.where((element) => element.isExpired()).toList();
  }

  static List<CredentialDto> notExpired(Iterable<CredentialDto> dtos) {
    return dtos.where((element) => !element.isExpired()).toList();
  }

  @override
  // TODO: implement uid
  String? get uid => throw UnimplementedError();

}