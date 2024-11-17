import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding_invitation/app_colors.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(32),
        const _InfoWidget(
          title: 'Agendar Recordatorio',
          url: 'https://calendar.app.google/geQtKQGj3BLEt11KA',
        ),
        const Gap(64),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Image.asset('assets/images/wedding_rings.png', width: 600),
        ),
        const Gap(32),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '15 Mar',
              style: TextStyle(
                fontSize: 32,
                color: ButtonColors.button1TextColor,
              ),
            ),
            Gap(16),
            SizedBox(
              height: 40,
              child: VerticalDivider(
                color: ButtonColors.button1TextColor,
                thickness: 1,
              ),
            ),
            Gap(16),
            Text(
              '7:00 PM',
              style: TextStyle(
                fontSize: 32,
                color: ButtonColors.button1TextColor,
              ),
            ),
          ],
        ),
        const Gap(32),
        const AutoSizeText(
          'Bodega Robinson, Concordia',
          maxLines: 1,
          style: TextStyle(
            fontSize: 28,
            color: ButtonColors.button1TextColor,
          ),
        ),
        const Gap(32),
        const _InfoWidget(
          title: 'Ver Mapa',
          url: 'https://maps.app.goo.gl/WLPnUwETkKjRZ3o8A',
        ),
        const Gap(16),
      ],
    );
  }
}

class _InfoWidget extends StatelessWidget {
  const _InfoWidget({
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: launchPage,
      height: 48,
      minWidth: 220,
      elevation: 1,
      shape: const StadiumBorder(),
      color: ButtonColors.button1FillColor,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: ButtonColors.button1TextColor,
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
