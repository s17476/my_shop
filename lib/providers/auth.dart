import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  Future<void> authenticate(
    String urlSegment,
    String email,
    String password,
  ) async {
    final uri = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAvruDdwPFIh_Zq-WFJNBxeOYtNcpTxiQU');
    try {
      final response = await http.post(
        uri,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      // print(json.decode(response.body));
      final resData = json.decode(response.body);

      if (resData['error'] != null) {
        // print('ERROO                 ' + resData['error']['message']);
        throw HttpException.message(
          statusCode: resData['error']['code'],
          message: resData['error']['message'],
        );
      }
//set user data
      _token = resData['idToken'];
      _userId = resData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            resData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      // print('ERROO    catch             ' + error.toString());
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return authenticate('signUp', email, password);
  }

  Future<void> login(String email, String password) async {
    return authenticate('signInWithPassword', email, password);
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }
}
