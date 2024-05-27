import 'package:hive/hive.dart';
import 'package:moneygram/category/model/category.dart';

abstract class CategoryLocalDataSource {
  Future<void> addCategory(Category category);
  Future<void> deleteCategory(int key);
  Future<List<Category>> categories({bool includingInActive});
  Box<Category> getBox();
  Category? fetchCategory(int categoryId);
  Future<Category?> fetchCategoryFromId(int categoryId);
}
