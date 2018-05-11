import 'package:startup_namer/data/silk_image.dart';

class SilkResponse {
  final int eventId;
  final List<SilkImage> silks;

  SilkResponse(this.eventId, this.silks);
}