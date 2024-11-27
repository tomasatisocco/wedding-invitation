import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/app_colors.dart';
import 'package:wedding_invitation/home/widgets/wedding_button.dart';

class DressCodePage extends StatelessWidget {
  const DressCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Gap(64),
        AutoSizeText(
          'DRESS CODE',
          maxLines: 1,
          style: TextStyle(
            fontSize: 40,
            color: ButtonColors.button1TextColor,
          ),
        ),
        Gap(32),
        Text(
          'FORMAL',
          style: TextStyle(
            fontSize: 32,
            color: ButtonColors.button1TextColor,
          ),
        ),
        Gap(32),
        DressCodeExamples(),
        Gap(32),
        AutoSizeText(
          'Blanco reservado para la novia',
          maxLines: 1,
          style: TextStyle(
            fontSize: 28,
            color: ButtonColors.button1TextColor,
          ),
        ),
        Gap(32),
        WeddingButton(title: 'Ver Más', url: 'https://pin.it/MtkEDXSyB'),
      ],
    );
  }
}

class DressCodeExamples extends StatefulWidget {
  const DressCodeExamples({super.key});

  @override
  State<DressCodeExamples> createState() => _DressCodeExamplesState();
}

class _DressCodeExamplesState extends State<DressCodeExamples> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onPageChanged());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: _pageController.hasClients && _pageController.page! > 0,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: ButtonColors.button1TextColor,
              ),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
              },
            ),
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ButtonColors.button1TextColor),
              ),
              constraints: const BoxConstraints(maxWidth: 300, maxHeight: 400),
              child: PageView(
                controller: _pageController,
                children: const [
                  DressItem('assets/images/dress_code_1.png'),
                  DressItem('assets/images/dress_code_2.png'),
                  DressItem('assets/images/dress_code_3.png'),
                  DressItem('assets/images/dress_code_4.png'),
                  DressItem('assets/images/dress_code_5.png'),
                  DressItem('assets/images/dress_code_6.png'),
                  DressItem('assets/images/dress_code_7.png'),
                  DressItem('assets/images/dress_code_8.png'),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _pageController.hasClients && _pageController.page! < 7,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: ButtonColors.button1TextColor,
              ),
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onPageChanged() {
    setState(() {});
  }
}

class DressItem extends StatelessWidget {
  const DressItem(this.image, {super.key});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Image.asset(image, height: 200),
    );
  }
}
