import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helmoliday/view_model/holiday/holiday_chat_view_model.dart';
import 'package:helmoliday/widget/chat/message_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HolidayChatScreen extends StatelessWidget {
  final String holidayId;

  const HolidayChatScreen({
    super.key,
    required this.holidayId,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return ChangeNotifierProvider<HolidayChatViewModel>(
      create: (nContext) =>
          HolidayChatViewModel(holidayId: holidayId, context: nContext),
      child: Consumer<HolidayChatViewModel>(builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chat'),
          ),
          body: GestureDetector(
            onTap: viewModel.focusNode.unfocus,
            child: _BodyWidget(
              viewModel: viewModel,
              bottom: bottom,
            ),
          ),
          bottomNavigationBar: _InputWidget(viewModel: viewModel, bottom: bottom),
        );
      }),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  final HolidayChatViewModel viewModel;
  final double bottom;

  const _BodyWidget({Key? key, required this.viewModel, required this.bottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    final messages = viewModel.messages;
    if (messages.isEmpty) {
      return const Center(
        child: Text("Vous n'avez encore aucun message"),
      );
    }

    return ListView.builder(
      itemCount: messages.length,
      controller: viewModel.scrollController,
      itemBuilder: (_, index) {
        final message = messages[index];
        return MessageWidget(
          message: message,
          key: ValueKey(message.data.clientId),
          currentUserId: viewModel.currentUserId!
        );
      },
    );
  }
}

class _InputWidget extends StatelessWidget {
  final HolidayChatViewModel viewModel;
  final double bottom;

  const _InputWidget({required this.viewModel, required this.bottom, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width * 0.21;

    return Transform.translate(
      offset: Offset(0.0, -1 * bottom),
      child: SafeArea(
        bottom: bottom < 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: viewModel.images.isEmpty ? 0 : imageSize,
              child: ListView.builder(
                itemCount: viewModel.images.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) {
                  final file = viewModel.images[i];
                  return _ImageWidget(
                    onRemove: () => viewModel.removeImage(i),
                    file: file,
                    size: imageSize,
                  );
                },
              ),
            ),
            TextField(
              minLines: 1,
              maxLines: 3,
              focusNode: viewModel.focusNode,
              controller: viewModel.textController,
              autofocus: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).canvasColor,
                hintText: 'Entrez un message',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                suffixIcon: IconButton(
                  onPressed: viewModel.sendMessage,
                  icon: const Icon(Icons.send),
                ),
                prefixIcon: IconButton(
                  onPressed: viewModel.pickImages,
                  icon: const Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  final XFile file;
  final VoidCallback onRemove;
  final double size;

  const _ImageWidget({
    Key? key,
    required this.onRemove,
    required this.file,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageSize = size - 15;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 10),
      child: SizedBox(
        height: size,
        width: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(file.path),
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: -10,
              right: -10,
              child: IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.cancel),
              ),
            )
          ],
        ),
      ),
    );
  }
}
