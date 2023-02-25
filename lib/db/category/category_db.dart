import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_money_management_app/models/category/category_model.dart';
import 'package:personal_money_management_app/screens/category/income_category_list.dart';

// ignore: constant_identifier_names
const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDB implements CategoryDbFunctions {
  CategoryDB._internal();

  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryListListner =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListListner =
      ValueNotifier([]);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDB.values.toList();
  }

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.put(value.id, value);
    refreshUI();
  }

  Future<void> refreshUI() async {
    final _allCategories = await getCategories();
    incomeCategoryListListner.value.clear();
    expenseCategoryListListner.value.clear();
    await Future.forEach(
      _allCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategoryListListner.value.add(category);
        } else {
          expenseCategoryListListner.value.add(category);
        }
      },
    );
    incomeCategoryListListner.notifyListeners();
    expenseCategoryListListner.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(categoryID);
    refreshUI();
  }
}
