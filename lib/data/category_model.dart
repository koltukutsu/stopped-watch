class CategoryModel {
  final String category;
  int average;
  List<RecordModel> recordsList;

  CategoryModel({
    required this.category,
    required this.average,
    required this.recordsList,
  });
}

class RecordModel {
  final int index;
  final int time;
  final DateTime recordedTime;

  RecordModel(
      {required this.index, required this.time, required this.recordedTime});
}
