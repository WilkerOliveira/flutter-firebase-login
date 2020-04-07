import 'package:mobx/mobx.dart';

part 'user.g.dart';

class User = UserBase with _$User;

abstract class UserBase with Store {
  String userID;
  @observable
  String firstName;
  @observable
  String email;
  String profilePictureURL;
  String password;
  String nickName;
  String confirmPassword;
  String customLogin;
  bool customAvatar;
  String oldPassword;

  @action
  setFirstName(String name) => this.firstName = name;

  @action
  setEmail(String email) => this.email = email;

  UserBase({
    this.userID,
    this.firstName,
    this.email,
    this.profilePictureURL,
    this.nickName,
    this.customLogin,
    this.customAvatar,
  });

  Map<String, Object> toJson() {
    return {
      'userID': userID,
      'firstName': firstName,
      'email': email == null ? '' : email,
      'profilePictureURL': profilePictureURL,
      'nickName': nickName,
      'customLogin': customLogin,
      'customAvatar': customAvatar,
    };
  }

  @action
  fromJson(Map<String, Object> doc) {
    this.userID = doc['userID'];
    this.firstName = doc['firstName'];
    this.nickName = doc['nickName'];
    this.email = doc['email'];
    this.profilePictureURL = doc['profilePictureURL'];
    this.customLogin = doc['customLogin'];
    this.customAvatar = doc['customAvatar'];
  }

  UserBase.fromDb(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        nickName = map['nickName'],
        profilePictureURL = map['profilePictureURL'],
        customLogin = map['customLogin'],
        customAvatar = map['customAvatar'] == null || map['customAvatar'] == 0
            ? false
            : true,
        firstName = map['firstName'];

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['userID'] = userID;
    map['profilePictureURL'] = profilePictureURL;
    map['firstName'] = firstName;
    map['nickName'] = nickName;
    map['email'] = email;
    map['customAvatar'] = customAvatar != null && customAvatar ? 1 : 0;
    map['customLogin'] = customLogin;

    return map;
  }
}
