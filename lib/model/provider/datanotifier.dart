import 'package:flutter/material.dart';
import 'package:userdetails/model/api/api_service.dart';

class DataNotifier extends ChangeNotifier {
  final List<Map<String, dynamic>> _data = [];
  bool _data_loading = false;
  DataNotifier() {
    getUserData();
  }

  get data => _data; //getter for getting data on page

  //implemented setter getter for loading, till data is fetching
  get data_loading => _data_loading;
  set data_loading(val) {
    _data_loading = val;
    notifyListeners();
  }

  //function for getting news list according to search value

  Future<dynamic> getUserData() async {
    data_loading = true;
    var response = await ApiService().fetchData(); //fetch data from given url

    if (response['data'] != null) {
      var api_data = response['data'];
      api_data.forEach((value) {
        _data.add({
          "id": value['id'].toString(),
          "email": value['email'].toString(),
          "avatar": value['avatar'].toString(),
          "name": value['first_name'].toString() +
              ' ' +
              value['last_name'].toString(),
        });
      });
    }

    data_loading = false;
    notifyListeners();
  }
}
