import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:bootpay_api/bootpay_api.dart';
import 'package:bootpay_api/model/payload.dart';
import 'package:bootpay_api/model/extra.dart';
import 'package:bootpay_api/model/user.dart';
import 'package:bootpay_api/model/item.dart';

void goBootpayRequest(BuildContext context) async {
  Payload payload = Payload();
  payload.androidApplicationId = '5b8f6a4d396fa665fdc2b5e8';
  payload.iosApplicationId = '5f2cd9df0627a80025553dc4';
  payload.pg = 'undefined';
  payload.method = 'undefined';
//  payload.methods = ['card', 'phone', 'vbank', 'bank'];
  payload.name = 'testUser';
  payload.price = 2500.0;
  payload.orderId = DateTime.now().millisecondsSinceEpoch.toString();
//    payload.params = {
//      "callbackParam1" : "value12",
//      "callbackParam2" : "value34",
//      "callbackParam3" : "value56",
//      "callbackParam4" : "value78",
//    };

  User user = User();
  user.username = "사용자 이름";
  user.email = "user1234@gmail.com";
  user.area = "서울";
  user.phone = "010-1234-4567";

  Extra extra = Extra();
  extra.appScheme = 'bootpayFlutterSample';

  Item item1 = Item();
  item1.itemName = "쓰담 이용권"; // 주문정보에 담길 상품명
  item1.qty = 1; // 해당 상품의 주문 수량
  item1.unique = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
  item1.price = 1000; // 상품의 가격

  Item item2 = Item();
  item2.itemName = "키보드"; // 주문정보에 담길 상품명
  item2.qty = 1; // 해당 상품의 주문 수량
  item2.unique = "ITEM_CODE_KEYBOARD"; // 해당 상품의 고유 키
  item2.price = 1000; // 상품의 가격
  List<Item> itemList = [item1, item2];

  BootpayApi.request(
    context,
    payload,
    extra: extra,
    user: user,
    items: itemList,
    onDone: (String json) {
      print('onDone: $json');
    },
    onReady: (String json) {
      print('onReady: $json');
    },
    onCancel: (String json) {
      print('onCancel: $json');
    },
    onError: (String json) {
      print('onError: $json');
    },
  );
}