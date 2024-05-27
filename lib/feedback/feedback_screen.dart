import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';
import 'package:moneygram/utils/analytics_helper.dart';
import 'package:moneygram/utils/custom_text_style.dart';
import 'package:moneygram/utils/validation_utils.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String selectedExperience = "";
  bool _isKeyboardOpen = false;
  String _feedbackText = "";

  @override
  Widget build(BuildContext context) {
    _isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        backgroundColor: context.appHomeScreenBgColor, body: _content());
  }

  Widget _content() {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          /*This method here will hide the soft keyboard.*/
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [_header(), const SizedBox(height: 12), _body()]),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ..._rateYourExperience(),
            const SizedBox(height: 48),
            Text("Anything we could do better?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _inputField(),
            const SizedBox(height: 12),
            _sendFeedback()
          ]),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
        color: context.appSecondaryColor,
        child: IntrinsicHeight(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text("Your Feedback",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                ),
                _aboveSaveButton()
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, thickness: 0)
          ],
        )));
  }

  Widget _aboveSaveButton() {
    bool isEnable = isValidResponse();
    return AnimatedOpacity(
      opacity: _isKeyboardOpen ? 1 : 0,
      duration: Duration(milliseconds: 100),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
            onTap: isEnable
                ? () {
                    _feedbackSubmitted(
                        eventName:
                            AnalyticsHelper.feedbackAboveSubmitButtonClicked);
                  }
                : null,
            child: IntrinsicWidth(
              child: Container(
                  height: 26,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: isEnable
                          ? context.appPrimaryColor
                          : context.appDisableBgColorBtn,
                      borderRadius: BorderRadius.circular(13)),
                  child: Text(
                    'Save',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: isEnable
                            ? context.appSecondaryColor
                            : context.appDisableTextColorBtn,
                        fontWeight: FontWeight.w600),
                  )),
            )),
      ),
    );
  }

  List<Widget> _rateYourExperience() {
    var textWidget = Text("Rate your experience",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600));

    double gap = 6;
    var emojiRow = Row(children: [
      _emojiWidget("😠", isFirst: true),
      SizedBox(width: gap),
      _emojiWidget("😔"),
      SizedBox(width: gap),
      _emojiWidget("😐"),
      SizedBox(width: gap),
      _emojiWidget("🙂"),
      SizedBox(width: gap),
      _emojiWidget("😃")
    ]);
    return [textWidget, SizedBox(height: 12), emojiRow];
  }

  Widget _emojiWidget(String emoji, {bool isFirst = false}) {
    var isSelected = selectedExperience == emoji;
    return InkWell(
      onTap: isSelected
          ? null
          : () {
              AnalyticsHelper.logEvent(
                  event: AnalyticsHelper.feedbackEmojiClicked,
                  params: {"emoji": emoji});
              setState(() {
                selectedExperience = emoji;
              });
            },
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? context.appPrimaryColor.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(8)),
        padding:
            EdgeInsets.only(left: isFirst ? 0 : 4, right: 4, top: 6, bottom: 6),
        child: Text(
          emoji,
          style: CustomTextStyle.emojiStyle(
              context: context, fontSize: isSelected ? 40 : 32),
        ),
      ),
    );
  }

  Widget _inputField() {
    return TextField(
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 8,
      onChanged: ((value) {
        setState(() {
          _feedbackText = value;
        });
      }),
      decoration: InputDecoration(
        hintText: "Tell us what you like, or what you didn't",
        hintMaxLines: 1,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        hintStyle: TextStyle(
            fontSize: 16, color: context.appPrimaryColor.withOpacity(0.3)),
        fillColor: context.appSecondaryColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: context.appSecondaryColor,
            width: 0.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: context.appPrimaryColor.withOpacity(0.26),
            width: 0.2,
          ),
        ),
      ),
    );
  }

  bool isValidResponse() {
    return ValidationUtils.isValidString(_feedbackText) &&
        ValidationUtils.isValidString(selectedExperience);
  }

  Widget _sendFeedback() {
    bool isEnable = isValidResponse();
    return AnimatedOpacity(
      opacity: _isKeyboardOpen ? 0 : 1,
      duration: Duration(milliseconds: 100),
      child: InkWell(
        onTap: isEnable
            ? () {
                _feedbackSubmitted(
                    eventName:
                        AnalyticsHelper.feedbackBottomSubmitButtonClicked);
              }
            : null,
        child: Container(
          padding: EdgeInsets.only(top: 12),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Text(
              "Save",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: isEnable
                      ? context.appSecondaryColor
                      : context.appDisableTextColorBtn),
            ),
            decoration: BoxDecoration(
                color: isEnable
                    ? context.appPrimaryColor
                    : context.appDisableBgColorBtn,
                boxShadow: [
                  BoxShadow(
                    color: context.appSecondaryColor.withOpacity(0.03),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
        ),
      ),
    );
  }

  void _feedbackSubmitted({required String eventName}) {
    Fluttertoast.showToast(
        msg: "Thanks for submitting the feedback 😊",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0);
    var params = {"reaction": selectedExperience, "feedback": _feedbackText};
    AnalyticsHelper.logEvent(event: eventName, params: params);
    Navigator.of(context).pop();
  }
}
