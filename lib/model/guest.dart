class Guest {
  Guest({
    this.id,
    this.name,
    this.email,
    this.conflict,
    this.status,
    this.self
  });

  num id;
  String name;
  String email;
  bool conflict;
  String status;
  String self;

  factory Guest.fromJson(Map<String, dynamic> parsedJson) {
    return Guest(
        id: parsedJson['id'],
        name: parsedJson['name'] as String,
        email: parsedJson['email'] as String,
        conflict: parsedJson['conflito'] as bool,
        status: parsedJson['status'] as String,
        self: parsedJson['_links']['self']['href']);
  }
}
