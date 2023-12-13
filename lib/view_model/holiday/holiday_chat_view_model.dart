import 'package:flutter/material.dart';
import 'package:helmoliday/infrastructure/service/pusher_messaging_service.dart';
import 'package:helmoliday/repository/auth_repository.dart';
import 'package:helmoliday/service/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../service/messaging_service.dart';

class HolidayChatViewModel extends ChangeNotifier {
  late final AuthRepository _authRepository;
  late final IMessagingService _messagingService;
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final focusNode = FocusScopeNode();
  final _picker = ImagePicker();
  final BuildContext context;
  final String holidayId;
  bool isLoading = true;
  String? currentUserId;

  final _messages = <Message>[];
  List<Message> get messages => _messages;

  final _images = <XFile>[];
  List<XFile> get images => _images;

  HolidayChatViewModel({
    required this.context,
    required this.holidayId,
  }) {
    _authRepository = context.read<AuthRepository>();
    _messagingService = PusherMessagingService(context.read<ApiService>());
    init();
  }

  Future<void> init() async {
    currentUserId = (await _authRepository.getCurrentUser())?.id;
    _messagingService.getMessagesStream().listen(onNewMessage);
    await _messagingService.connect({
      'authEndpoint': '/holidays/$holidayId/chat/auth',
      'channelName': 'presence-$holidayId'
    });
    isLoading = false;
    notifyListeners();
    return Future.value();
  }

  Future<void> onNewMessage(Message message) {
    print("j'ai reçu un message !");
    _updateOrAddMessage(message);
    return Future.value();
  }

  Future<void> sendMessage() async {
    final messageContent = textController.text.trim();
    if (messageContent.isEmpty) return Future.value();
    var user = (await _authRepository.getCurrentUser())!;

    final message = Message(
      sentAt: DateTime.now(),
      data: MessageData(
        clientId: const Uuid().v4(),
        text: messageContent,
        localImages: _images.toList()
      ),
      from: user,
      status: MessageStatus.sending,
    );

    _images.clear();
    textController.clear();
    _messages.add(message);
    notifyListeners();
    _scrollToBottom();

    var sendResult = await _messagingService.sendMessage(message);
    if (!sendResult) {
      _updateOrAddMessage(message.copy(status: MessageStatus.failed));
      return Future.value();
    }
    _updateOrAddMessage(message.copy(status: MessageStatus.sent));
  }

  void _updateOrAddMessage(Message message) {
    final index = _messages.indexOf(message);

    if (index >= 0) {
      _messages[index] = message;
    } else {
      _messages.add(message);
    }
    notifyListeners();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_messages.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _messagingService.disconnect();
    _messages.clear();
    _images.clear();
    super.dispose();
  }

  Future<void> removeImage(int index) async {
    if (index >= _images.length) return;
    _images.removeAt(index);
    notifyListeners();
  }

  Future<void> pickImages() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Prendre une photo"),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Choisir une photo dans la galerie"),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
    return Future.value();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _images.add(pickedFile);
      notifyListeners();
    }
  }
}
