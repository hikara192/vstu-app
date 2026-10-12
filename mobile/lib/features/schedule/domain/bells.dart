import '../../../core/utils/dates.dart';

const Map<int, (String, String)> timeSlots = <int, (String, String)>{
  1: ('8:00', '9:35'),
  2: ('9:50', '11:25'),
  3: ('11:40', '13:15'),
  4: ('14:00', '15:35'),
  5: ('15:45', '17:20'),
};

const Duration academicHour = Duration(minutes: 45);

const Duration academicPause = Duration(minutes: 5);

const Duration minLessonWithPause = Duration(minutes: 55);

const String dayStart = '8:00';

(String, String) resolveTimeSlot(int number, int timeOffset) {
  final slot = timeSlots[number];
  if (slot == null) return ('', '');
  if (timeOffset == 0) return slot;
  return (_shift(slot.$1, timeOffset), _shift(slot.$2, timeOffset));
}

String _shift(String time, int minutes) {
  final shifted = moment(DateTime(2000), time).add(Duration(minutes: minutes));
  return '${shifted.hour}:${shifted.minute.toString().padLeft(2, '0')}';
}
