import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/app_colors.dart';
import 'package:wedding_invitation/home/widgets/wedding_button.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(32),
        const WeddingButton(
          title: 'Agendar Recordatorio',
          url: 'https://calendar.app.google/geQtKQGj3BLEt11KA',
          height: 48,
          width: 220,
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
        const WeddingButton(
          title: 'Ver Mapa',
          url: 'https://maps.app.goo.gl/WLPnUwETkKjRZ3o8A',
          height: 48,
          width: 220,
        ),
        const Gap(16),
      ],
    );
  }
}
