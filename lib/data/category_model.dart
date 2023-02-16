class CategoryModel {
  final String category;
  int average;
  List<RecordModel> recordsList;

  CategoryModel({
    required this.category,
    required this.average,
    required this.recordsList,
  });

  Map<String, dynamic> toJsonObject() {
    return {
      'category': category,
      'average': average,
      'recordsList': recordsList
          .map((RecordModel record) => record.toJsonObject())
          .toList(),
    };
  }

  CategoryModel.fromJsonObject(Map<String, dynamic> json)
      : category = json['category'],
        average = json["average"],
        recordsList = (json["recordsList"])
            .map((dynamic recordDynamic) {
          Map<String, dynamic> give = recordDynamic;
          RecordModel taken =
          RecordModel.fromJsonObject(give);
          return taken;
        })
            .toList()
            .cast<RecordModel>();
}

class RecordModel {
  final int index;
  final int time;
  final String recordedTime;
  final String recordedDate;
  RecordModel(
      {required this.index, required this.time, required this.recordedTime, required this.recordedDate});

  Map<String, dynamic> toJsonObject() {
    return {
      'index': index,
      'time': time,
      'recordedTime': recordedTime,
      'recordedDate': recordedDate,
    };
  }

  RecordModel.fromJsonObject(Map<String, dynamic> json)
      : index = json['index'],
        time = json['time'],
        recordedDate = json['recordedDate'],
        recordedTime = json['recordedTime'];
}
