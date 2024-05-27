import 'package:moneygram/ui/home/models/timeline.dart';

void main(List<String> args) {
  var timeline = Timeline.currentWeek();
  print(timeline.toString());
  var p = timeline.previousWeek();
  print(p.toString());
}
