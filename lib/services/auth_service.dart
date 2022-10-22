
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyAf64DrobW4yr68okMvUdbrgJfZ0FOAKBM';

  final storage = const FlutterSecureStorage();

  Future<String?> signUp( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https( _baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final response = await http.post( url, body: json.encode( authData ) );
    final Map<String, dynamic> decodedResponse = json.decode( response.body );

    if ( decodedResponse.containsKey('idToken') ) {
      await storage.write(key: 'authToken', value: decodedResponse['idToken']);
      return null;
    }

    return decodedResponse['error']['message'];

  }

  Future<String?> signIn( String email, String password ) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https( _baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final response = await http.post( url, body: json.encode( authData ) );
    final Map<String, dynamic> decodedResponse = json.decode( response.body );

    if ( decodedResponse.containsKey('idToken') ) {
      await storage.write(key: 'authToken', value: decodedResponse['idToken']);
      return null;
    }

    return decodedResponse['error']['message'];

  }

  Future<String> isAuthenticated() async {
    return await storage.read(key: 'authToken') ?? '';
  }

  Future logout() async {
    await storage.delete(key: 'authToken');
  }

}