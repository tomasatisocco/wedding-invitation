import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/app_colors.dart';
import 'package:wedding_invitation/home/widgets/wedding_button.dart';

class GiftPage extends StatelessWidget {
  const GiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(64),
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/gift.png', width: 320),
            const Column(
              children: [
                Text(
                  'OBSEQUIOS',
                  style: TextStyle(
                    fontSize: 40,
                    color: ButtonColors.button1TextColor,
                  ),
                ),
                Gap(32),
                SizedBox(
                  width: 480,
                  child: Text(
                    'Gracias por ser parte de este momento especial.\nSi desean agasajarnos con un regalo, agradecemos que sea una contribución económica, la misma será destinada a nuestra luna de miel y próxima mudanza al extranjero',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: ButtonColors.button1TextColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const Gap(64),
        WeddingButton(
          title: 'Cuenta Bancaria',
          url: '',
          onPressed: () => showBankInformation(context),
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
              const Text(
                'Cuenta Bancaria',
                style: TextStyle(
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
                    const SnackBar(
                      content: Text('Copiado'),
                    ),
                  );
                  Navigator.pop(context);
                },
                shape: const StadiumBorder(),
                color: ButtonColors.button1FillColor,
                height: 48,
                minWidth: 220,
                child: const Text(
                  'Copiar',
                  style: TextStyle(
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
