import 'package:flutter/material.dart';
import 'package:pesan_menu_application/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _cart = [];
  List<CartModel> get cart => _cart;

  int _totalItems = 0;
  int get totalItems => _totalItems;

  int get totalPrice {
    int total = 0;
    for (var item in _cart) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void addRemove(String name, int menuId, bool isAdd, int price) {
    if (_cart.where((element) => menuId == element.menuId).isNotEmpty) {
      var index = _cart.indexWhere((element) => element.menuId == menuId);
      _cart[index].quantity = 
        (isAdd) ? _cart[index].quantity + 1 : 
        (_cart[index].quantity > 0) ? _cart[index].quantity - 1 : 0;

      _totalItems = (isAdd) ? _totalItems + 1 : (_totalItems > 0) ? _totalItems - 1 : 0;

      if (_cart[index].quantity == 0) {
        _cart.removeAt(index);
      }
    } else {
      _cart.add(CartModel(name: name, menuId: menuId, quantity: 1, price: price));
      _totalItems += 1;
    }
   
    notifyListeners();
  }
}
