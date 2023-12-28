import 'package:flutter/material.dart';

class TempDataProvider extends ChangeNotifier {
  int id = 1;

  void setId(int newId) {
    id = newId;
    notifyListeners();
  }

  int getId() {
    return id;
  }
}
