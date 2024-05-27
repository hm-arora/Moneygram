import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:moneygram/category/category_hive_helper.dart';
import 'package:moneygram/category/model/category.dart';
import 'package:moneygram/utils/custom_text_style.dart';
import 'package:moneygram/utils/enum/transaction_type.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';

class CategoryPickerScreen extends StatefulWidget {
  final Function(Category) onCategorySelected;
  const CategoryPickerScreen({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  State<CategoryPickerScreen> createState() => _CategoryPickerScreenState();
}

class _CategoryPickerScreenState extends State<CategoryPickerScreen> {
  TransactionType _selectedType = TransactionType.expense;
  List<Category> categoryList = [];
  List<Category> filterList = [];

  int? groupValue = 0;
  @override
  void initState() {
    fetchCategories();
    super.initState();
  }

  void fetchCategories() async {
    categoryList = await CategoryHiveHelper().getCategories();
    _filteredList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _body(),
        Positioned.fill(
            child:
                Align(alignment: Alignment.bottomCenter, child: _chipsRow())),
      ],
    );
  }

  Widget _body() {
    return Container(
        color: context.appHomeScreenBgColor,
        padding: EdgeInsets.only(top: 16, left: 12, right: 12),
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.3,
            maxHeight: MediaQuery.of(context).size.height * 0.7),
        child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                Text("Categories",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                ..._rows()
              ],
            )));
  }

  List<Widget> _rows() {
    List<Widget> rows = [];
    List<Widget> currentTiles = [];
    filterList.forEach((element) {
      var tile = _getTile(element);
      currentTiles.add(tile);
      if (currentTiles.length % 3 == 0) {
        rows.add(_getRow(currentTiles));
        currentTiles = [];
      }
    });
    if (currentTiles.isNotEmpty) {
      rows.add(_getRow(currentTiles));
    }
    return rows;
  }

  Widget _getTile(Category category) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          widget.onCategorySelected(category);
          Navigator.of(context).pop();
          // print(category);
        },
        child: Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.only(left: 6, right: 6, bottom: 6),
            padding: EdgeInsets.only(top: 14, bottom: 14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(category.emoji,
                  style: CustomTextStyle.emojiStyle(
                      context: context, fontSize: 24)),
              Flexible(
                child: Text(
                  category.name,
                  style: TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ])),
      ),
    );
  }

  Widget _getRow(List<Widget> widgets) {
    var widgetLength = widgets.length;
    if (widgetLength % 3 != 0) {
      // if widget length is 1, means adding 2 spacer for managing the width
      // if widget length is 2, will add only 1 spacer
      for (int i = widgetLength; i < 3; i++) {
        widgets.add(Spacer());
      }
    }
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: widgets),
    );
  }

  Widget _chipsRow() {
    return SafeArea(
      minimum: EdgeInsets.only(bottom: 24),
      child: CustomSlidingSegmentedControl<int>(
        initialValue: groupValue,
        padding: 18,
        children: {0: Text('Expense'), 1: Text('Income')},
        decoration: BoxDecoration(
          color: context.appToggleBgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: context.appPrimaryColor.withOpacity(.1),
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: Offset(
                0.0,
                2.0,
              ),
            ),
          ],
        ),
        thumbDecoration: BoxDecoration(
          color: context.appSecondaryColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: context.appPrimaryColor.withOpacity(.05),
              blurRadius: 2.0,
              spreadRadius: 0.5,
              offset: Offset(
                0.0,
                2.0,
              ),
            ),
          ],
        ),
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInToLinear,
        onValueChanged: (int? value) {
          groupValue = value;
          _selectedType =
              value == 0 ? TransactionType.expense : TransactionType.income;
          setState(() {
            _filteredList();
          });
        },
      ),
    );
  }

  Widget buildSegment(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: context.appSecondaryColor),
      ),
    );
  }

  void _filteredList() {
    filterList = categoryList
        .where((element) => element.transactionType == _selectedType)
        .toList();
  }
}
