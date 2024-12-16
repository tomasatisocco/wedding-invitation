import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/app_colors.dart';
import 'package:wedding_invitation/home/widgets/wedding_button.dart';
import 'package:wedding_invitation/l10n/l10n.dart';

class GiftPage extends StatelessWidget {
  const GiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: -80,
          child: Transform.rotate(
            angle: -0.5,
            child: Image.asset(
              'assets/images/tree.png',
              height: 340,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              children: [
                const Gap(40),
                AutoSizeText(
                  maxLines: 1,
                  context.l10n.gifts.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    color: ButtonColors.button1TextColor,
                  ),
                ),
                const Gap(32),
                SizedBox(
                  width: 360,
                  child: AutoSizeText(
                    context.l10n.giftsThanks,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: ButtonColors.button1TextColor,
                    ),
                  ),
                ),
                const Gap(32),
                SizedBox(
                  width: 360,
                  child: AutoSizeText(
                    context.l10n.giftsDisclaimer,
                    maxLines: 7,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: ButtonColors.button1TextColor,
                    ),
                  ),
                ),
                const Gap(32),
                WeddingButton(
                  text: context.l10n.bankInformation,
                  onPressed: () => showBankInformation(context),
                  maxWidth: 220,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showBankInformation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: ButtonColors.button2FillColor,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.bankInformation,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: ButtonColors.button2TextColor,
                ),
              ),
              const Gap(16),
              const Text(
                'CBU',
                style: TextStyle(
                  fontSize: 20,
                  color: ButtonColors.button2TextColor,
                ),
              ),
              const Gap(8),
              const Text(
                '0000003100052554102251',
                style: TextStyle(
                  fontSize: 20,
                  color: ButtonColors.button2TextColor,
                ),
              ),
              const Gap(16),
              const Text(
                'Alias',
                style: TextStyle(
                  fontSize: 20,
                  color: ButtonColors.button2TextColor,
                ),
              ),
              const Gap(8),
              const Text(
                'emiliaytomas2025',
                style: TextStyle(
                  fontSize: 20,
                  color: ButtonColors.button2TextColor,
                ),
              ),
              const Gap(16),
              MaterialButton(
                onPressed: () async {
                  await Clipboard.setData(
                    const ClipboardData(text: '0000003100052554102251'),
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.copied),
                    ),
                  );
                  Navigator.pop(context);
                },
                shape: const StadiumBorder(),
                color: ButtonColors.button1FillColor,
                height: 48,
                minWidth: 220,
                child: Text(
                  context.l10n.copy,
                  style: const TextStyle(
                    fontSize: 20,
                    color: ButtonColors.button1TextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
