import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/app_colors.dart';

class CountDownPage extends StatelessWidget {
  const CountDownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Gap(32),
        Text(
          'TOMI & EMI',
          style: TextStyle(
            fontSize: 40,
            color: ButtonColors.button1TextColor,
          ),
        ),
        Gap(64),
        SizedBox(
          width: 300,
          child: Text(
            'NUESTRA BODA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              color: ButtonColors.button1TextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Gap(32),
        SizedBox(
          width: 400,
          child: Text(
            'Y después de 10 años empieza el "para siempre" que tanto soñamos...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: ButtonColors.button1TextColor,
            ),
          ),
        ),
        Gap(64),
        AutoSizeText(
          '¡Falta cada vez menos!',
          maxLines: 1,
          style: TextStyle(
            fontSize: 40,
            color: ButtonColors.button1TextColor,
          ),
        ),
        Gap(32),
        CountdownTimer(),
      ],
    );
  }
}

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _remainingTime;
  final targetDate = DateTime(2025, 03, 15, 19);

  @override
  void initState() {
    super.initState();
    _remainingTime = targetDate.difference(DateTime.now());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = targetDate.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remainingTime.inDays;
    final hours = _remainingTime.inHours % 24;
    final minutes = _remainingTime.inMinutes % 60;
    final seconds = _remainingTime.inSeconds % 60;

    return Center(
      child: SizedBox(
        width: 800,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TimeIndicator(time: days, title: 'DAYS'),
            TimeIndicator(time: hours, title: 'HOURS'),
            TimeIndicator(time: minutes, title: 'MINUTES'),
            TimeIndicator(time: seconds, title: 'SECONDS'),
          ],
        ),
      ),
    );
  }
}

class TimeIndicator extends StatelessWidget {
  const TimeIndicator({
    required this.time,
    required this.title,
    super.key,
  });

  final num time;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: ButtonColors.button2FillColor,
          ),
          child: Center(
            child: Text(
              time.toString(),
              style: const TextStyle(
                fontSize: 24,
                color: ButtonColors.button2TextColor,
              ),
            ),
          ),
        ),
        const Gap(8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: ButtonColors.button1TextColor,
          ),
        ),
      ],
    );
  }
}
