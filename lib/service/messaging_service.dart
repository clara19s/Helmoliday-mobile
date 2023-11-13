import 'dart:convert';

import 'package:helmoliday/util/date_util.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user.dart';

abstract class IMessagingService {
  Future<void> connect(Map<String, dynamic> connectionOptions);
  Future<void> disconnect();
  Future<bool> sendMessage(Message message);
  Stream<Message> getMessagesStream();
}

class Message {
  final DateTime sentAt;
  final MessageData data;
  final User from;
  final MessageStatus status;

  Message({
    required this.sentAt,
    required this.data,
    required this.from,
    required this.status,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sentAt: DateUtility.parseDate(json['sentAt'] as String),
      data: MessageData.fromJson(json['data'] as Map<String, dynamic>),
      from: User.fromJson(json['from'] as Map<String, dynamic>),
      status: MessageStatus.sent
    );
  }

  Message copy({
    DateTime? sentAt,
    MessageData? data,
    MessageStatus? status,
    User? from,
  }) {
    return Message(
      sentAt: sentAt ?? this.sentAt,
      data: data ?? this.data,
      from: from ?? this.from,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Message &&
              runtimeType == other.runtimeType &&
              data == other.data;

  @override
  int get hashCode => data.hashCode;
}

class MessageData {
  final String clientId;
  final String? text;
  final List<String>? images;
  final List<XFile>? localImages;

  MessageData({
    required this.clientId,
    required this.text,
    this.images,
    this.localImages,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      clientId: json['clientId'] as String,
      text: json['text'] as String?,
      images: json['images'] == null
          ? <String>[]
          : (json['images'] as List<dynamic>).cast<String>(),
    );
  }

  MessageData copy({
    String? clientId,
    String? text,
    List<String>? images,
    List<XFile>? localImages,
  }) {
    return MessageData(
      clientId: clientId ?? this.clientId,
      text: text ?? this.text,
      images: images ?? this.images,
      localImages: localImages ?? this.localImages,
    );
  }

  String toJson() => json.encode({
    'clientId': clientId,
    'text': text,
    'images': images,
    'localImages': localImages?.map((e) => e.name).toList(),
  });

  Map<String, dynamic> toRequestMap() => <String, dynamic>{
    'clientId': clientId,
    'text': text,
    'images': images,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MessageData &&
              runtimeType == other.runtimeType &&
              clientId == other.clientId;

  @override
  int get hashCode => clientId.hashCode;
}

enum MessageStatus { sending, sent, failed }