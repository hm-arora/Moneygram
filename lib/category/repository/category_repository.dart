import 'package:moneygram/category/model/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> categories({bool isSort, bool includingInActive});

  Future<void> addCategory({
    required Category category,
  });

  Future<void> deleteCategory(int key);

  Future<void> updateCategory(Category category);

  Future<Category?> fetchCategoryFromId(int categoryId);
}
