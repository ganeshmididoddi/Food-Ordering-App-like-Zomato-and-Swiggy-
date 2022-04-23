import 'package:flutter/material.dart';
import 'package:foodexpress_user/global/global.dart';

class CartItemCounter extends ChangeNotifier
{
  int cartLisItemCounter = sharedPreferences!.getStringList("userCart")!.length-1;
  int get count =>cartLisItemCounter;

  Future<void> displayCartListItemsNumber() async
  {
    cartLisItemCounter = sharedPreferences!.getStringList("userCart")!.length-1;

    await Future.delayed(const Duration(microseconds: 100),(){
      notifyListeners();
    });
  }
}