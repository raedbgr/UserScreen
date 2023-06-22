import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:untitled/Models/updates.dart';
import 'package:untitled/Models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class MyController extends GetxController {
  List<Eluser> userList = <Eluser>[];
  File? imageFile;
  RxBool isLoading = true.obs;
  bool isExist = false;
  Eluser oldUser = Eluser();
  int? indx;
  int? indx2;
  List<updateMod> updateList = <updateMod>[];
  updateMod upd = updateMod();
  String? msg;
  String? date;
  File? temp;
  int? generalIndex;

  pickImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      imageFile = File(image.path);
    }
    update();
  }

  void addUser (String name, int age, File pic, String date){
    Eluser user = Eluser(name: name, age: age, pic: pic, date: date);
    userList.add(user);
    imageFile = null;
    savePrefs(); // save after adding new users
    update();
  }

  void updateUser(String name, int age, File? pic) {
    Eluser? userToUpdate = userList[indx!];

    if (userToUpdate != null) {
      userToUpdate.updateName(name);
      userToUpdate.updateAge(age);
      if (pic != null) userToUpdate.updatePic(pic);
      savePrefs();

      // return date of update formatted
      DateTime dateTime = DateTime.now();
      String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);

      //------------------------------------
      Eluser? updatedUser = userList[indx!];
      String updatedField = '';

      if (updatedUser.name != oldUser.name && updatedUser.age != oldUser.age && updatedUser.pic != oldUser.pic) {
        updatedField = 'NameAgePic';
      } else if (updatedUser.age != oldUser.age && updatedUser.pic != oldUser.pic) {
        updatedField = 'agePic';
      } else if (updatedUser.name != oldUser.name && updatedUser.pic != oldUser.pic) {
        updatedField = 'namePic';
      } else if (updatedUser.name != oldUser.name && updatedUser.age != oldUser.age) {
        updatedField = 'nameAge';
      } else if (updatedUser.pic != temp && updatedUser.pic == null) {
        updatedField = 'RemovedPicture';
        temp = null;
      } else if (updatedUser.pic != oldUser.pic) {
        updatedField = 'Picture';
      } else if (updatedUser.age != oldUser.age) {
        updatedField = 'Age';
      } else if (updatedUser.name != oldUser.name) {
        updatedField = 'Name';
      }

      msg = '${_getUpdate(updatedField, updatedUser)}';
      date = formattedDateTime;
      updateMod upd = updateMod();
      upd.msg = msg;
      upd.date = date;
      updateList.add(upd);
      saveHistoryPrefs(updateList);
      //------------------------------------

      update();
    }
  }

  void removeUser (Eluser user){
    userList.remove(user);
    savePrefs();
    update();
  }

  savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedData = userList.map((user) => jsonEncode(user.toJson())).toList();
    prefs.setStringList("users", encodedData);
  }

  loadPrefs() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // nameList = prefs.getStringList("names")! as List<String>;
    List<String>? encodedData = prefs.getStringList("users");
    if (encodedData != null) {
      userList.clear();
      for (String data in encodedData) {
        Map<String, dynamic> decodedData = jsonDecode(data);
        Eluser user = Eluser.fromJson(decodedData);
        userList.add(user);
      }
    }
    isLoading.value = false;
    update();
  }

  String? _getUpdate(String field, Eluser updatedUser) {
    switch (field) {
      case 'RemovedPicture':
        return 'User ${oldUser.name} removed his picture.';
      case 'Name':
        return 'User ${oldUser.name} updated his name to ${updatedUser.name}.';
      case 'Age':
        return 'User ${oldUser.name} updated his age to ${updatedUser.age}.';
      case 'Picture':
        return 'User ${oldUser.name} updated his picture.';
      case 'nameAge':
        return 'User ${oldUser.name} updated his name and age to ${updatedUser.name} and ${updatedUser.age}.';
      case 'namePic':
        return 'User ${oldUser.name} updated his name to ${updatedUser.name} and his picture.';
      case 'agePic':
        return 'User ${oldUser.name} updated his age to ${updatedUser.age} and his picture.';
      case 'nameAgePic':
        return 'User ${oldUser.name} updated his name and age to ${updatedUser.name}, ${updatedUser.age} and his picture.';
      default:
        return '';
    }
  }

  saveHistoryPrefs(List<updateMod> historyList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert list of updateMod objects to List<Map<String, dynamic>>
    List<Map<String, dynamic>> jsonList = historyList.map((update) => update.toJson()).toList();

    // Convert List<Map<String, dynamic>> to JSON string
    String jsonString = jsonEncode(jsonList);

    // Save the JSON string to shared preferences
    await prefs.setString('history', jsonString);
  }

  loadHistoryPrefs() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('history');
    if (jsonString != null) {
      List<dynamic> jsonData = jsonDecode(jsonString);
      updateList.clear();
      for (dynamic data in jsonData) {
        updateMod update = updateMod.fromJson(data as Map<String, dynamic>);
        updateList.add(update);
      }
    }
    isLoading.value = false;
    update();
  }
}
