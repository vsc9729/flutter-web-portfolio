import 'package:shared_preferences/shared_preferences.dart';

class MyLocalStorage {
  static late SharedPreferences prefs;
  Map<dynamic, dynamic> authenticationInfo = {};

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  addToImageList(String base64Image) async {
    List<String> imageList = prefs.getStringList("imageList") ?? [];
    imageList.add(base64Image);
    await prefs.setStringList("imageList", imageList);
  }

  List<String> getImageList() {
    return prefs.getStringList("imageList") ?? [];
  }

  clearAll() async {
    await prefs.clear();
  }
}

MyLocalStorage localStorage = MyLocalStorage();
