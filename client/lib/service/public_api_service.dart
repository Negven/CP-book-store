

import 'dart:async';

import 'package:client/classes/api_service.dart';
import 'package:client/dto/access_state_dto.dart';
import 'package:client/dto/basket_book_dto.dart';
import 'package:client/dto/login_dto.dart';
import 'package:client/dto/oauth2_dto.dart';
import 'package:client/dto/order_dto.dart';
import 'package:client/dto/reg_dto.dart';
import 'package:client/dto/sign_in_dto.dart';
import 'package:client/enum/auth_provider.dart';
import 'package:client/enum/client_platform.dart';
import 'package:client/enum/language_code.dart';
import 'package:client/service/_services.dart';

import '../dto/book_dto.dart';


class PublicApiService extends ApiService {


  Future<OAuth2LinkDto> oauth2Link (AuthProvider provider, LanguageCode languageCode) => getSimple("/oauth2/link", OAuth2LinkDto.fromJson, {
    'provider': provider.toQuery(),
    'languageCode': languageCode.name,
    'platform': ClientPlatform.current.name
  });

  Future<OAuth2StatusDto> oauth2Status (String state, bool extended) => getSimple("/oauth2/status", OAuth2StatusDto.fromJson, {
    'state': state,
    'extended': extended.toString()
  });


  Future<AccessStateDto> signIn (SignInDto signInDto) => postSimple("/auth", signInDto.toJson(), AccessStateDto.fromJson);

  Future<AccessStateDto> login (LoginDto loginDto) => postSimple("/user/login", loginDto.toJson(), AccessStateDto.fromJson);

  Future<AccessStateDto> registration (RegDto loginDto) => postSimple("/user/registration", loginDto.toJson(), AccessStateDto.fromJson);

  Future<BookPageDto> getBooks ({String? query, int? page, String? sort, int? size})  =>
      getSimple("/book", BookPageDto.fromJson, {
        PN.query: query,
        PN.page: page,
        PN.limit: size ??  PV.pageSize,
        PN.sort: sort ?? 'rank,name,asc',
      });

  Future<BookDto> getBook (String? id)  => getSimple("/book/$id", BookDto.fromJson);


  Future<BasketBookPageDto> getBasketBooks (int basketId)  =>
      getSimple(
        "/basketBook",
          BasketBookPageDto.fromJson,
        {
          "basketId": basketId,
          PN.limit: PV.pageSizeMax,
        },
          {
            "Authorization": "Bearer ${Services.auth.token}"
          }
      );



  Future<AccessStateDto> addItemInBasket (BasketBookDto basketBookDto) => postSimple("/basketBook", basketBookDto.toJson(), AccessStateDto.fromJson, {"Authorization": "Bearer ${Services.auth.token}"});

  Future<AccessStateDto> deleteBasketItems (BasketBookDto basketBookDto) => deleteSimple("/basketBook/${basketBookDto.id}", AccessStateDto.fromJson, {"Authorization": "Bearer ${Services.auth.token}"});


  Future<AccessStateDto> createOrder (OrderDto orderDto) => postSimple("/order", orderDto.toJson(), AccessStateDto.fromJson, {"Authorization": "Bearer ${Services.auth.token}"});



}

