import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wedding_invitation/app_colors.dart';

class ForeignGuidePage extends StatelessWidget {
  const ForeignGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Gap(64),
        SizedBox(
          width: 450,
          child: Text(
            'Guía para los amigos que vienen de lejos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              color: ButtonColors.button1TextColor,
            ),
          ),
        ),
        InformationPageView(),
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
                Icons.arrow_back_ios,
                color: ButtonColors.button2FillColor,
                size: 32,
              ),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
              },
            ),
          ),
          const Flexible(
            child: SizedBox(
              width: 80,
            ),
          ),
          SizedBox(
            width: 400,
            height: 500,
            child: PageView(
              controller: _pageController,
              children: const [
                InformationWidget(info: hospitality),
                InformationWidget(info: gastronomy),
                InformationWidget(info: makeUp),
              ],
            ),
          ),
          const Flexible(
            child: SizedBox(
              width: 80,
            ),
          ),
          Visibility(
            visible: _pageController.hasClients && _pageController.page! < 2,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: ButtonColors.button2FillColor,
                size: 32,
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
        SizedBox(
          width: 600,
          child: Text(
            info.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              color: ButtonColors.button1TextColor,
            ),
          ),
        ),
        const Gap(32),
        for (int i = 0; i < info.buttonTitles.length; i++)
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: MaterialButton(
              onPressed: () => launchPage(info.buttonUrls[i]),
              height: 64,
              minWidth: 420,
              elevation: 1,
              shape: const StadiumBorder(),
              color: ButtonColors.button1FillColor,
              child: Text(
                info.buttonTitles[i],
                style: const TextStyle(
                  fontSize: 24,
                  color: ButtonColors.button1TextColor,
                ),
              ),
            ),
          ),
        const Gap(32),
      ],
    );
  }

  Future<void> launchPage(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await canLaunchUrl(uri)) return;
      await launchUrl(uri);
    } catch (_) {}
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
