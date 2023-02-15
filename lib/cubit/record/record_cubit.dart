import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopped_watch/data/category_model.dart';

part "record_state.dart";

class RecordCubit extends Cubit<RecordState> {
  RecordCubit() : super(RecordIdleState());
  List<CategoryModel> categoryList = [];

  getRecords() async {
    emit(RecordIdleState());
    final prefs = await SharedPreferences.getInstance();
    final List<String>? categoryItems = prefs.getStringList("categoryItems");
    if (categoryItems != null) {
      final List categoryItemsFinal = categoryItems.map((String categoryItem) {
        Map<String, dynamic> categoryItemAsJson = jsonDecode(categoryItem);
        return CategoryModel.fromJsonObject(categoryItemAsJson);
      }).toList();

      List<CategoryModel> categoryItemsFinalCasted =
          categoryItemsFinal.cast<CategoryModel>();
      categoryList = categoryItemsFinalCasted;
      emit(GotRecordsState());
    } else {
      emit(NoRecordsState());
    }
  }

  saveRecords() async {
    if (categoryList.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      List<String> finalPut = [];
      for (CategoryModel categoryItem in categoryList) {
        final String finalPutString = jsonEncode(categoryItem.toJsonObject());
        finalPut.add(finalPutString);
      }
      print(finalPut);
      await prefs.setStringList("categoryItems", finalPut);
    }

    print("Setted again!: ${categoryList.length}");
    emit(GotRecordsState());
  }
}
