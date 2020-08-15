class UserData {
  static UserData _instance;
  factory UserData() {
    _instance ??= UserData._internalConstructor();
    return _instance;
  }
  UserData._internalConstructor();

  int id;
  String nickname;
  String email;
  String company;
}