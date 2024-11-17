import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding_invitation/app_colors.dart';

class WeddingButton extends StatelessWidget {
  const WeddingButton({
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
    return MaterialButton(
      onPressed: onPressed ?? launchPage,
      height: height,
      minWidth: width,
      elevation: 1,
      shape: const StadiumBorder(),
      color: ButtonColors.button1FillColor,
      child: AutoSizeText(
        title,
        style: const TextStyle(
          color: ButtonColors.button1TextColor,
          fontSize: 24,
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
