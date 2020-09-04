import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(String email, String password,
      String urlSegment) async {
    final url = "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAk_KTQP3QbX6ybt6-m89TITuLk51o3E8U";
    final response = await http.post(url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
  }

  Future<void> signup(String email, String password) async {
    const url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAk_KTQP3QbX6ybt6-m89TITuLk51o3E8U";
//    final response=await http.post(url,
//      body: json.encode({
//       'email':email,
//        'password':password,
//        'returnSecureToken':true,
//      }),
//    );
//    print(json.decode(response.body));
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    const url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAk_KTQP3QbX6ybt6-m89TITuLk51o3E8U";
//    final response=await http.post(url,
//      body: json.encode({
//        'email':email,
//        'password':password,
//        'returnSecureToken':true,
//      }),
//    );
//    print(json.decode(response.body));
//  }
    return _authenticate(email, password, 'signInWithPassword');
  }

}