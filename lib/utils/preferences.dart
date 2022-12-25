import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  Prefs._internal();

  static Prefs prefs = Prefs._internal();

  factory Prefs() {
    return prefs;
  }

  final String isLoggedIn = "isLoggedIn";
  final String apiToken = "apiToken";
  final String letsStart = "letsStart";
  final String defaultGoal = "defaultGoal";
  final String cartCount = "cartCount";
  final String firebaseCalled = "firebaseCalled";
  final String firebaseToken = "firebaseToken";

  getAllPrefsClear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("isLoggedIn");
    prefs.remove("login");
    prefs.remove("apiToken");
    prefs.remove("defaultGoal");
    prefs.remove("cartCount");
    prefs.remove("firebaseToken");
  }

  getLoginData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)!);
  }

  setLoginData(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  Future<String> getLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(isLoggedIn) ?? '';
  }

  Future<bool> setLoggedIn(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(isLoggedIn, value);
  }

  Future<String> getApiToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(apiToken) ?? '';
  }

  Future<bool> setApiToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(apiToken, value);
  }

  Future<String> getLetsStart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(letsStart) ?? '';
  }

  Future<bool> setLetsStart(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(letsStart, value);
  }

  Future<String> getDefaultGoal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(defaultGoal) ?? '0';
  }

  Future<bool> setDefaultGoal(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(defaultGoal, value);
  }

  Future<String> getCartCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(cartCount) ?? '0';
  }

  Future<bool> setCartCount(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(cartCount, value);
  }

  Future<String> getFirebaseCalled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(firebaseCalled) ?? '0';
  }

  Future<bool> setFirebaseCalled(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(firebaseCalled, value);
  }

  Future<String> getFirebaseToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(firebaseToken) ?? '0';
  }

  Future<bool> setFirebaseToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(firebaseToken, value);
  }
}
