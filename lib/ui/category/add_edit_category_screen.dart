import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:moneygram/category/model/category.dart' as Moneygram;
import 'package:moneygram/category/repository/category_repository.dart';
import 'package:moneygram/di/service_locator.dart';
import 'package:moneygram/utils/custom_text_style.dart';
import 'package:moneygram/utils/enum/transaction_type.dart';
import 'package:moneygram/utils/validation_utils.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';

/// Example for EmojiPickerFlutter
class AddEditCategoryScreen extends StatefulWidget {
  final Moneygram.Category? category;
  final TransactionType transactionType;
  final VoidCallback addOrEditPerformed;

  const AddEditCategoryScreen(
      {required this.category,
      required this.transactionType,
      required this.addOrEditPerformed});

  @override
  _AddEditCategoryScreenState createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  bool emojiShowing = true;
  String _selectedEmoji = "🤑";
  TextEditingController _textEditingController = TextEditingController();
  bool _isKeyboardOpen = false;
  String hintText = "";
  final CategoryRepository _categoryRepository = locator.get();

  @override
  void initState() {
    if (widget.category != null) {
      _selectedEmoji = widget.category!.emoji;
      _textEditingController.text = widget.category!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    var title = widget.category != null ? "Edit" : "Add";
    return Scaffold(
      backgroundColor: context.appSecondaryColor,
      appBar: AppBar(
        title: Text('$title Category'),
        actions: [
          _actionDoneButton(),
        ],
      ),
      body: _body(),
    );
  }

  Widget _actionDoneButton() {
    var color = isAnythingChange()
        ? context.appPrimaryColor
        : context.appPrimaryColor.withOpacity(0.2);
    return InkWell(
        onTap: () {
          _actionButtonOnClicked();
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.done,
              size: 32,
              color: color,
            )));
  }

  Widget _body() {
    return GestureDetector(
      onTap: () {
        /*This method here will hide the soft keyboard.*/
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            _selectedEmojiContainer(),
            _inputField(),
            Spacer(),
            _emojiPicker(),
          ],
        ),
      ),
    );
  }

  Widget _selectedEmojiContainer() {
    return Container(
      padding: EdgeInsets.only(top: 24),
      child: Container(
          decoration: BoxDecoration(
              color: context.appBgColor,
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(_selectedEmoji,
              style: CustomTextStyle.emojiStyle(
                  context: context,
                  fontSize: 40,
                  fontWeight: FontWeight.bold))),
    );
  }

  Widget _inputField() {
    return IntrinsicWidth(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: IntrinsicWidth(
          child: TextField(
            controller: _textEditingController,
            cursorColor: context.appPrimaryColor,
            style: TextStyle(fontSize: 24),
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
                hintStyle: TextStyle(
                    fontSize: 24,
                    color: context.appPrimaryColor.withOpacity(0.3)),
                border: InputBorder.none,
                fillColor: Colors.transparent,
                hintText: _textEditingController.text.isEmpty
                    ? "Add Category Name"
                    : null),
          ),
        ),
      ),
    );
  }

  Widget _emojiPicker() {
    return Offstage(
      offstage: _isKeyboardOpen,
      child: Container(
          height: 400,
          color: context.appBgColor,
          child: SafeArea(
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() {
                  _selectedEmoji = emoji.emoji;
                });
              },
              config: Config(
                  columns: 7,
                  emojiSizeMax: 24 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.30
                          : 1.0),
                  bgColor: context.appBgColor,
                  indicatorColor: context.appPrimaryColor,
                  iconColor: Colors.grey,
                  iconColorSelected: context.appPrimaryColor,
                  skinToneDialogBgColor: context.appSecondaryColor,
                  enableSkinTones: false,
                  showRecentsTab: false,
                  emojiTextStyle: CustomTextStyle.emojiStyle(
                      context: context, fontSize: 16)),
            ),
          )),
    );
  }

  bool isAnythingChange() {
    var inputCategoryName = _textEditingController.text;
    // in case of category addition
    // only checks whether name is given or not
    if (widget.category == null) {
      return ValidationUtils.isValidString(inputCategoryName);
    }

    // in case of edit category, we need to check
    // valid name and whether emoji or name has changed
    if (!ValidationUtils.isValidString(inputCategoryName)) {
      return false;
    }

    return widget.category!.emoji != _selectedEmoji ||
        widget.category!.name != inputCategoryName;
  }

  void _actionButtonOnClicked() {
    var category = widget.category;
    var inputCategoryName = _textEditingController.text;
    if (category != null) {
      category.emoji = _selectedEmoji;
      category.name = inputCategoryName;
      _categoryRepository.updateCategory(category);
    } else {
      category = Moneygram.Category(
          emoji: _selectedEmoji,
          name: inputCategoryName,
          transactionType: widget.transactionType);
      _categoryRepository.addCategory(category: category);
    }
    // callback called so that it refresh the screen
    widget.addOrEditPerformed();
    Navigator.of(context).pop();
  }
}
