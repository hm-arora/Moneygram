import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:moneygram/account/model/account.dart';
import 'package:moneygram/account/repository/account_repository.dart';
import 'package:moneygram/di/service_locator.dart';
import 'package:moneygram/utils/custom_text_style.dart';
import 'package:moneygram/utils/validation_utils.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';

/// Example for EmojiPickerFlutter
class AddEditAccountScreen extends StatefulWidget {
  final Account? account;
  final VoidCallback addOrEditPerformed;

  const AddEditAccountScreen(
      {required this.account, required this.addOrEditPerformed});

  @override
  _AddEditAccountScreenState createState() => _AddEditAccountScreenState();
}

class _AddEditAccountScreenState extends State<AddEditAccountScreen> {
  String _selectedEmoji = "🤑";
  TextEditingController _textEditingController = TextEditingController();
  bool _isKeyboardOpen = false;
  String hintText = "";
  final AccountRepository _accountRepository = locator.get();

  @override
  void initState() {
    if (widget.account != null) {
      _selectedEmoji = widget.account!.emoji;
      _textEditingController.text = widget.account!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    var title = widget.account != null ? "Edit" : "Add";
    return Scaffold(
      backgroundColor: context.appSecondaryColor,
      appBar: AppBar(
        title: Text('$title Account'),
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
                    ? "Add Account Name"
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
    var inputAccountName = _textEditingController.text;
    // in case of account addition
    // only checks whether name is given or not
    if (widget.account == null) {
      return ValidationUtils.isValidString(inputAccountName);
    }

    // in case of edit account, we need to check
    // valid name and whether emoji or name has changed
    if (!ValidationUtils.isValidString(inputAccountName)) {
      return false;
    }

    return widget.account!.emoji != _selectedEmoji ||
        widget.account!.name != inputAccountName;
  }

  void _actionButtonOnClicked() {
    var account = widget.account;
    var inputAccountName = _textEditingController.text;
    if (account != null) {
      account.emoji = _selectedEmoji;
      account.name = inputAccountName;
      _accountRepository.updateAccount(account);
    } else {
      account = Account(emoji: _selectedEmoji, name: inputAccountName);
      _accountRepository.addAccount(account: account);
    }
    // callback called so that it refresh the screen
    widget.addOrEditPerformed();
    Navigator.of(context).pop();
  }
}
