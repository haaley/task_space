class MeetingAgenda {
  MeetingAgenda(
      {
      this.idMeetingAgenda,
      this.status,
      this.description,
      this.title,
      this.self});

  num idMeetingAgenda;
  num status;
  String description;
  String title;
  String self;

  factory MeetingAgenda.fromJson(Map<String, dynamic> parsedJson) {
    return MeetingAgenda(
        title: parsedJson['title'] as String,
        description: parsedJson['description'] as String,
        idMeetingAgenda: parsedJson['idAgenda'],
        status: parsedJson['status'] == "FINISHED" ? 1:0,
        self: parsedJson['_links']['self']['href']
    );
  }
}
