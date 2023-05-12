import 'package:audioplayers/audioplayers.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'pages.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  final _scrollController = ScrollController();
  final _player = AudioPlayer();

  final List<String> _titles = [
    'headlines',
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  final DateTime now = DateTime.now();

  final List<String> _about = [
    "Welcome to What's News? - Your go-to app for staying up to date with the latest news from around the world.",
    "Our app is designed to provide you with a seamless and user-friendly experience. We understand that staying up-to-date with the latest news can be overwhelming and time-consuming, which is why we have created a news app that is simple, easy to navigate, and highly engaging.",
    "At What's News?, we believe that staying informed is essential. Our app displays news in a card format, making it easy for you to quickly scroll through the latest headlines. You can easily swipe away news cards that don't interest you and tap on the ones that do to read more.",
    "Our app also provides users with the option to visit the website where the news was originally posted, giving you access to even more in-depth coverage on the topics that matter most to you.",
    "We strive to provide our users with the most accurate and up-to-date news, sourced from reputable news outlets. We understand that the world of news can be complex and at times, even overwhelming, which is why we take great care in selecting the stories that we present to you.",
    "Thank you for choosing What's News? as your go-to news app. We are dedicated to providing you with a seamless and engaging experience, as we believe that staying informed is essential in today's fast-paced world.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: -16,
        backgroundColor: const Color(0xffe8dfce),
        elevation: 0,
      ),
      body: GestureDetector(
        onHorizontalDragStart: (_) =>
            _player.play(AssetSource('sounds/newspaper.mp3')),
        onHorizontalDragEnd: (_) => Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeftPop,
              duration: const Duration(milliseconds: 750),
              childCurrent: AboutPage(),
              child: const HomePage(),
            ),
            (route) => false),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(10),
          color: const Color(0xffe8dfce),
          child: FadingEdgeScrollView.fromSingleChildScrollView(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const Divider(
                    color: Colors.black,
                    thickness: 3,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Center(
                      child: Text(
                        "ABOUT",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 45,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 6,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: Container(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            top: 5,
                            bottom: 5,
                          ),
                          child: Row(
                            children: [
                              for (int i = 0; i <= 7; i++)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _titles[i].toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color(0xffe8dfce),
                                        fontFamily: 'Times New Roman',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    i == 7
                                        ? const SizedBox()
                                        : Container(
                                            height: 10,
                                            width: 10,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffe8dfce),
                                            ),
                                          ),
                                    i == 7
                                        ? const SizedBox()
                                        : const SizedBox(width: 10),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Issue: 240599',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      Text(
                        'WORLDS BEST SELLING',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                      Text(
                        'Est - 1999',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Times New Roman',
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                      color: Colors.grey[400],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'First Edition',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Times New Roman',
                              ),
                            ),
                            Text(
                              DateFormat.MMMMEEEEd()
                                  .format(now)
                                  .replaceAll(',', ''),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Times New Roman',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  for (int i = 0; i <= 5; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _about[i],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
