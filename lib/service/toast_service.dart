abstract class IToastService {
  void showMessage(ToastMessage message);
}

enum ToastType { success, error, warning, info }

class ToastMessage {
  final ToastType type;
  final String text;
  final Duration duration;

  ToastMessage(
      {required this.type,
      required this.text,
      this.duration = const Duration(seconds: 2)});
}
