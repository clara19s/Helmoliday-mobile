import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:helmoliday/service/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../service/messaging_service.dart';

class PusherMessagingService implements IMessagingService {
  final StreamController<Message> _messageStreamController =
      StreamController<Message>.broadcast();
  final ApiService _apiService;
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  final _apiKey = dotenv.env['PUSHER_API_KEY'];
  final _cluster = dotenv.env['PUSHER_CLUSTER'];
  String? _channelName;
  PusherChannel? _channel;

  PusherMessagingService(ApiService apiService) : _apiService = apiService;

  @override
  Future<void> connect(Map<String, dynamic> connectionOptions) async {
    if (_apiKey == null || _cluster == null) {
      throw Exception("Pusher API key or cluster is not set");
    }
    await pusher.init(
        apiKey: _apiKey!,
        cluster: _cluster!,
        onError: (String message, int? code, dynamic e) {
          print("Error: ${e.message}");
        },
        onSubscriptionError: (String message, dynamic e) {
          print("Subscription error: ${e.message}");
        },
        onAuthorizer: (channelName, socketId, options) async {
          var response =
              await _apiService.post(connectionOptions["authEndpoint"], data: {
            "SocketId": socketId,
            "ChannelName": connectionOptions["channelName"],
          });
          return response.data;
        });
    await pusher.connect();
    _channel = await pusher.subscribe(
      channelName: connectionOptions["channelName"],
      onSubscriptionSucceeded: (presence) {
        _channelName = connectionOptions["channelName"];
      },
      onMemberAdded: (member) {
        print("Member added: $member");
      },
      onMemberRemoved: (member) {
        print("Member removed: $member");
      },
      onEvent: (event) {
        if (event.eventName == "message") {
          final data = jsonDecode(event.data);
          final message = Message.fromJson(data);
          _messageStreamController.add(message);
        }
      },
    );
    await _apiService
        .get(
        '/holidays/${connectionOptions["channelName"].replaceFirst("presence-", "")}/chat/messages')
        .then((response) {
      final messages = response.data as List<dynamic>;
      for (var message in messages) {
        _messageStreamController.add(Message.fromJson(message));
      }
    });
  }

  @override
  Future<void> disconnect() async {
    if (_channelName != null)
      await pusher.unsubscribe(channelName: _channelName!);
    pusher.disconnect();
    return Future.value();
  }

  @override
  Future<bool> sendMessage(Message message) async {
    final data = message.data;

    // Conversion des images locales en Multipart
    List<MultipartFile> multipartImageList = [];
    if (data.localImages != null) {
      for (var image in data.localImages!) {
        multipartImageList.add(await convertXFileToMultipartFile(image));
      }
    }

    var formData = FormData.fromMap({
      'ClientId': data.clientId,
      'Text': data.text,
      'Images': multipartImageList,
    });
    final response = await _apiService.post(
      '/holidays/${_channel!.channelName.replaceFirst("presence-", "")}/chat/messages',
      data: formData,
    );

    return response.statusCode == 200;
  }

  @override
  Stream<Message> getMessagesStream() {
    return _messageStreamController.stream;
  }

  Future<MultipartFile> convertXFileToMultipartFile(XFile file) async {
    final bytes = await file.readAsBytes();
    return MultipartFile.fromBytes(bytes, filename: file.name);
  }
}
