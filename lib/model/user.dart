class User{

  User({
    this.id,
    this.email,
    this.nickname,
    this.fullname,
    this.status,
    this.conflict
  });

  num id;
  String email;
  String nickname;
  String fullname;
  String status;
  bool conflict;
  
  factory User.fromJson(Map<String,dynamic> parsedJson){
    return User(
      id:  parsedJson['id'],
      email: parsedJson['email'] as String,
      nickname: parsedJson['nickname'] as String,
      fullname: parsedJson['name'] as String,
      conflict: parsedJson['conflito'] as bool,
      status: parsedJson['status'] as String
    );
  }
}