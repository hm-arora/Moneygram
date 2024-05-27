import 'package:hive/hive.dart';
import 'package:moneygram/category/data_source/category_local_data_source.dart';
import 'package:moneygram/category/model/category.dart';
import 'package:moneygram/utils/enum/box_types.dart';
import 'package:collection/collection.dart';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  late final categoryBox = Hive.box<Category>(BoxType.category.stringValue);

  @override
  Future<void> addCategory(Category category) async {
    final int boxId = await categoryBox.add(category);
    category.id = boxId;
    await category.save();
  }

  @override
  Future<List<Category>> categories({bool includingInActive = false}) async {
    final categories = categoryBox.values.where((element) {
      // if including inactive is true, means getting all elements
      if (includingInActive) {
        return true;
      }
      return element.isActive;
    }).toList();
    return categories;
  }

  @override
  Future<void> deleteCategory(int key) async {
    // to delete a particular category, need to delete the corresponding transactions
    return categoryBox.delete(key);
  }

  @override
  Category? fetchCategory(int categoryId) {
    return categoryBox.values.firstWhereOrNull((element) {
      return element.isActive && element.id == categoryId;
    });
  }

  @override
  Future<Category?> fetchCategoryFromId(int categoryId) async {
    // var values = categoryBox.values;
    // return values.firstWhereOrNull((element) {
    //   return element.isActive && element.id == categoryId;
    // });
    var category = categoryBox.get(categoryId);
    // if category is null or not active then return null
    if (category == null || !category.isActive) {
      return null;
    }
    return category;
  }

  @override
  Box<Category> getBox() {
    return categoryBox;
  }
}
