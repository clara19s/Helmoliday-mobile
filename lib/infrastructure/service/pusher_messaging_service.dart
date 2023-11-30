import 'dart:async';
import 'dart:convert';

import 'package:helmoliday/service/api_service.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../service/messaging_service.dart';

class PusherMessagingService implements IMessagingService {
  final StreamController<Message> _messageStreamController =
      StreamController<Message>.broadcast();
  final ApiService _apiService;
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  final _apiKey = "c79fa94e85416eeb4f1e";
  final _cluster = "eu";
  String? _channelName;
  PusherChannel? _channel;

  PusherMessagingService(ApiService apiService) : _apiService = apiService;

  @override
  Future<void> connect(Map<String, dynamic> connectionOptions) async {
    await pusher.init(
        apiKey: _apiKey,
        cluster: _cluster,
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
        print("Event received: $event");
        if (event.eventName == "message") {
          final data = jsonDecode(event.data);
          final message = Message.fromJson(data);
          _messageStreamController.add(message);
        }
      },
    );
  }

  @override
  Future<void> disconnect() async {
    if (_channelName != null) await pusher.unsubscribe(channelName: _channelName!);
    pusher.disconnect();
    return Future.value();
  }

  @override
  Future<bool> sendMessage(Message message) async {
    final data = message.data;

    final response = await _apiService.post(
      '/holidays/${_channel!.channelName.replaceFirst("presence-", "")}/chat/messages',
      data: data.toRequestMap(),
    );

    return response.statusCode == 200;
  }

  @override
  Stream<Message> getMessagesStream() {
    return _messageStreamController.stream;
  }
}
