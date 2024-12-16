import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/app_colors.dart';
import 'package:wedding_invitation/home/widgets/wedding_button.dart';
import 'package:wedding_invitation/l10n/l10n.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: -140,
          bottom: -60,
          child: Image.asset(
            'assets/images/tree.png',
            height: 340,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Gap(40),
              WeddingButton(
                text: context.l10n.scheduleReminder,
                url: 'https://calendar.app.google/geQtKQGj3BLEt11KA',
                maxWidth: 220,
              ),
              const Gap(40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '15 Mar',
                    style: TextStyle(
                      fontSize: 24,
                      color: ButtonColors.button1TextColor,
                    ),
                  ),
                  Gap(16),
                  SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      color: ButtonColors.button1FillColor,
                      thickness: 2,
                    ),
                  ),
                  Gap(16),
                  Text(
                    '7:00 PM',
                    style: TextStyle(
                      fontSize: 24,
                      color: ButtonColors.button1TextColor,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              const AutoSizeText(
                'Bodega Robinson, Concordia',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 24,
                  color: ButtonColors.button1TextColor,
                ),
              ),
              const Gap(40),
              WeddingButton(
                text: context.l10n.seeMap,
                url: 'https://maps.app.goo.gl/WLPnUwETkKjRZ3o8A',
                maxWidth: 220,
              ),
              const Gap(40),
            ],
          ),
        ),
      ],
    );
  }
}
