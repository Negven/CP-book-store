

import 'dart:async';

import 'package:client/classes/api_service.dart';
import 'package:client/dto/access_state_dto.dart';
import 'package:client/dto/basket_book_dto.dart';
import 'package:client/dto/login_dto.dart';
import 'package:client/dto/order_dto.dart';
import 'package:client/dto/reg_dto.dart';
import 'package:client/service/_services.dart';

import '../dto/book_dto.dart';


class PublicApiService extends ApiService {


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

