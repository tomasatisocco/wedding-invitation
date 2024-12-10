import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    required this.title,
    required this.url,
    this.height = 64,
    this.width = 420,
    this.onPressed,
    super.key,
  });

  final String title;
  final String url;
  final double width;
  final double height;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MaterialButton(
        onPressed: onPressed ?? launchPage,
        height: height,
        minWidth: width,
        elevation: 1,
        shape: const StadiumBorder(),
        color: const Color(0xffb9964d),
        child: AutoSizeText(
          title,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Future<void> launchPage() async {
    try {
      final uri = Uri.parse(url);
      if (!await canLaunchUrl(uri)) return;
      await launchUrl(uri);
    } catch (_) {}
  }
}

class WeddingButton extends StatelessWidget {
  const WeddingButton({
    required this.text,
    this.onPressed,
    this.url,
    this.maxWidth,
    super.key,
  });

  final void Function()? onPressed;
  final String text;
  final String? url;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? 500,
        minWidth: maxWidth != null ? 0 : 300,
        maxHeight: 56,
      ),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFa17a2d),
            Color(0xFFfcfedb),
            Color(0xFFa17a2d),
            Color(0xFFfcfedb),
            Color(0xFFa17a2d),
            Color(0xFFfcfedb),
          ],
          tileMode: TileMode.repeated,
          transform: GradientRotation(60),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: MaterialButton(
        disabledColor: Colors.white,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: onPressed ?? launchPage,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.brown,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> launchPage() async {
    try {
      if (url == null) return;
      final uri = Uri.parse(url!);
      if (!await canLaunchUrl(uri)) return;
      await launchUrl(uri);
    } catch (_) {}
  }
}
