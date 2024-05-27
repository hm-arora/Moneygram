import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:moneygram/core/theme/moneygram_theme.dart';

class DatePickerScreen extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  DatePickerScreen(
      {Key? key, required this.selectedDate, required this.onDateSelected});

  @override
  DatePickerScreenState createState() => DatePickerScreenState();
}

/// State for DatePickerScreen
class DatePickerScreenState extends State<DatePickerScreen> {
  late DateTime _selectedDate;
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {
        _selectedDate = args.value;
      }
    });
  }

  @override
  void initState() {
    _selectedDate = widget.selectedDate ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: context.appHomeScreenBgColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                    child: Text(
                  "Choose Date",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
                Spacer(),
                _saveButton()
              ],
            ),
            const SizedBox(height: 16),
            Container(
                height: 400,
                child: Container(
                  child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    todayHighlightColor: context.appPrimaryColor,
                    selectionColor: context.appPrimaryColor,
                    initialSelectedDate: _selectedDate,
                    selectionTextStyle: TextStyle(
                        color: context.appSecondaryColor, fontSize: 18),
                    showNavigationArrow: true,
                    headerStyle: DateRangePickerHeaderStyle(
                        textStyle: TextStyle(
                            fontSize: 20,
                            color: context.appPrimaryColor,
                            fontWeight: FontWeight.bold)),
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        dayFormat: "EEE",
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                            textStyle: TextStyle(
                                color:
                                    context.appPrimaryColor.withOpacity(0.5)))),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle: TextStyle(
                            color: context.appPrimaryColor, fontSize: 18),
                        todayTextStyle: TextStyle(
                            color: context.appPrimaryColor.withOpacity(0.9),
                            fontSize: 18)),
                    yearCellStyle: DateRangePickerYearCellStyle(
                      textStyle: TextStyle(color: context.appPrimaryColor),
                      todayTextStyle: TextStyle(color: context.appPrimaryColor),
                    ),
                  ),
                ))
          ],
        ));
  }

  Widget _saveButton() {
    return InkWell(
      onTap: () {
        widget.onDateSelected(_selectedDate);
        Navigator.of(context).pop();
      },
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Text(
          "Done",
          style: TextStyle(color: context.appSecondaryColor),
        ),
        decoration: BoxDecoration(
            color: context.appPrimaryColor,
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
