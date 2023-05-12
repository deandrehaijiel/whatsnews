import 'package:audioplayers/audioplayers.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'pages.dart';

class FrequentlyAskedQuestionsPage extends StatelessWidget {
  FrequentlyAskedQuestionsPage({super.key});
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

  final List<String> _faqs = [
    'Q: What is "What\'s News?" app?\nA: "What\'s News?" is a news app that displays news on cards. Users can swipe away the cards and tap on them to read more. They can also visit the website where the news is posted.',
    'Q: Does "What\'s News?" collect any personal data from its users?\nA: No, "What\'s News?" does not collect any personal data from its users.',
    'Q: Is the app free to use?\nA: Yes, "What\'s News?" is a free app to use.',
    'Q: Can I share news articles from the app with my friends and family?\nA: Yes, you can share news articles from the app with others using the share feature.',
    'Q: How frequently is the news updated on the app?\nA: The news is updated in real-time as it is published on the respective news websites.',
    'Q: Is there a limit on the number of news articles I can read on the app?\nA: No, there is no limit on the number of news articles you can read on the app.',
    'Q: Can I customize the news categories that I see on the app?\nA: At the moment, the app does not offer the ability to customize the news categories. However, we are working on adding this feature in the future.',
    'Q: How can I provide feedback or report an issue with the app?\nA: You can send an email to our support team at support@whatsnews.com.',
    'Q: Does the app support offline reading?\nA: Yes, the app supports offline reading. Once you have loaded an article while connected to the internet, you can read it later even if you are not connected to the internet.',
    'Q: Is the app available in multiple languages?\nA: Currently, the app is only available in English. However, we are working on adding support for multiple languages in the future.',
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
              childCurrent: FrequentlyAskedQuestionsPage(),
              child: const HomePage(),
            ),
            (route) => false),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: const Color(0xffe8dfce),
          child: FadingEdgeScrollView.fromSingleChildScrollView(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: Colors.black,
                    thickness: 3,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Center(
                      child: Text(
                        "FAQs",
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
                  for (int i = 0; i <= 9; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _faqs[i],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
