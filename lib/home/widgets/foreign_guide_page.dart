import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/app_colors.dart';
import 'package:wedding_invitation/home/widgets/wedding_button.dart';
import 'package:wedding_invitation/l10n/l10n.dart';

class ForeignGuidePage extends StatelessWidget {
  const ForeignGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(64),
        SizedBox(
          width: 450,
          child: AutoSizeText(
            context.l10n.guideForForeigners,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              color: ButtonColors.button1TextColor,
            ),
          ),
        ),
        const InformationPageView(),
      ],
    );
  }
}

class InformationPageView extends StatefulWidget {
  const InformationPageView({super.key});

  @override
  State<InformationPageView> createState() => _InformationPageViewState();
}

class _InformationPageViewState extends State<InformationPageView> {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: _pageController.hasClients && _pageController.page! > 0,
          child: Column(
            children: [
              const Gap(40),
              GestureDetector(
                onTap: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  height: 32,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFa17a2d),
                        Color(0xFFf5e687),
                        Color(0xFFa17a2d),
                        Color(0xFFf5e687),
                      ],
                      tileMode: TileMode.repeated,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Color(0xFFa17a2d),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
              maxHeight: 520,
            ),
            child: PageView(
              controller: _pageController,
              children: const [
                InformationWidget(info: hospitality),
                InformationWidget(info: gastronomy),
                InformationWidget(info: makeUp),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _pageController.hasClients && _pageController.page! < 2,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Column(
            children: [
              const Gap(40),
              GestureDetector(
                onTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFa17a2d),
                        Color(0xFFf5e687),
                        Color(0xFFa17a2d),
                        Color(0xFFf5e687),
                      ],
                      tileMode: TileMode.repeated,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFFa17a2d),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onPageChanged() {
    setState(() {});
  }
}

class InformationWidget extends StatelessWidget {
  const InformationWidget({
    required this.info,
    super.key,
  });

  final InformationWidgetInfo info;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(64),
        AutoSizeText(
          info.title,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            color: ButtonColors.button1TextColor,
          ),
        ),
        const Gap(32),
        for (int i = 0; i < info.buttonTitles.length; i++)
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: OptionButton(
              title: info.buttonTitles[i],
              url: info.buttonUrls[i],
            ),
          ),
        const Gap(32),
      ],
    );
  }
}

class InformationWidgetInfo {
  const InformationWidgetInfo({
    required this.title,
    required this.buttonTitles,
    required this.buttonUrls,
  });

  final String title;
  final List<String> buttonTitles;
  final List<String> buttonUrls;
}

const hospitality = InformationWidgetInfo(
  title: 'HOSPEDAJES CERCA DE LA FIESTA',
  buttonTitles: [
    'Mayim Hotel Termal & Spa',
    'Amanzi Apart Hotel Termal',
    'Hathor Hotel',
  ],
  buttonUrls: [
    'https://www.mayimhoteltermal.com.ar/home',
    'https://www.amanzitermal.com.ar',
    'https://www.hathorconcordia.com.ar',
  ],
);

const gastronomy = InformationWidgetInfo(
  title: 'GASTRONOMÍA CONCORDIENSE',
  buttonTitles: [
    'El Bosquecito',
    'La orilla',
    'Jacinto Cocina de Campo',
  ],
  buttonUrls: [
    'https://maps.app.goo.gl/AdRMXtsumKnFtCL17',
    'https://maps.app.goo.gl/18yDuy1d4WZWLarK6',
    'https://maps.app.goo.gl/UFiJ1db33Ya4mWjn9',
  ],
);

const makeUp = InformationWidgetInfo(
  title: 'PELUQUERÍAS Y MAQUILLADORAS',
  buttonTitles: [
    'Manuela Cuadrado Peluquería',
    'Sofia Nicolini Maquillaje',
    'Hair Lab Peluquería',
  ],
  buttonUrls: [
    'https://www.instagram.com/sueltateelpelomc?igsh=MXcyczl2bnZ1MTV3cA==',
    'https://www.instagram.com/estudiosofianicolini?igsh=MXR6dHZqcDZyYzYweg==',
    'https://www.instagram.com/hair_lab_byreinahada?igsh=MWp4dTJtYmRvbDBuag==',
  ],
);
