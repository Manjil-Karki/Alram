class BriefAlramModel {
  int? id;
  String? title;
  DateTime? time;
  int? isSet;
  String? days;

  BriefAlramModel({this.id, this.title, this.time, this.isSet, this.days});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'time': time!.millisecondsSinceEpoch,
      'is_set': isSet,
      'set_days': days,
    };
  }

  @override
  String toString() {
    return 'BriefAlram {_id: $id, title: $title, time: $time, is_set: $isSet, days: $days}';
  }
}
