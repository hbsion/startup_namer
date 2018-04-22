class Stream {
  final int channelId;

  Stream({this.channelId});

  Stream.fromJson(Map<String, dynamic> json) : this(channelId: json["channelId"]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Stream &&
              runtimeType == other.runtimeType &&
              channelId == other.channelId;

  @override
  int get hashCode => channelId.hashCode;


  @override
  String toString() {
    return 'Stream{channelId: $channelId}';
  }

}