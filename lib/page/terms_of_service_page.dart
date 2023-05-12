import 'package:audioplayers/audioplayers.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'pages.dart';

class TermsOfServicePage extends StatelessWidget {
  TermsOfServicePage({super.key});

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

  final List<String> _termsOfService = [
    'Welcome to What\'s News?, a mobile news application that allows you to stay up-to-date with the latest news stories from various sources around the world.',
    'These Terms of Service (the "Agreement") are a legal agreement between you ("you" or "User") and What\'s News? ("we," "us," or "our"). By using or accessing the What\'s News? app (the "Service"), you agree to be bound by the terms and conditions of this Agreement. If you do not agree to these terms and conditions, you may not use or access the Service.',
    '1. Use of the Service\nYou may use the Service only for lawful purposes and in accordance with this Agreement. You agree not to use the Service:',
    'In any way that violates any applicable federal, state, local or international law or regulation.',
    'To engage in any conduct that restricts or inhibits anyone\'s use or enjoyment of the Service, or which, as determined by us, may harm us or users of the Service or expose them to liability.',
    'To engage in any activity that interferes with or disrupts the Service (or the servers and networks which are connected to the Service).',
    'To use the Service in any way that could damage, disable, overburden, or impair the Service or interfere with any other party\'s use of the Service, including their ability to engage in real time activities through the Service.',
    '2. Intellectual Property Rights\nThe Service and its entire contents, features, and functionality (including but not limited to all information, software, text, displays, images, video, and audio, and the design, selection, and arrangement thereof), are owned by What\'s News?, its licensors, or other providers of such material and are protected by United States and international copyright, trademark, patent, trade secret, and other intellectual property or proprietary rights laws.',
    '3. Privacy Policy\nWe respect the privacy of our users. Please refer to our Privacy Policy for information on how we collect, use, and disclose information from our users.',
    '4. Disclaimers and Limitations of Liability\nTHE SERVICE, INCLUDING ALL CONTENT, FUNCTIONS, AND INFORMATION MADE AVAILABLE ON OR ACCESSED THROUGH THE SERVICE, IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT ANY REPRESENTATIONS, WARRANTIES, GUARANTEES, OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ALL IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT.',
    'WE MAKE NO WARRANTY THAT THE SERVICE WILL MEET YOUR REQUIREMENTS, OR THAT THE SERVICE WILL BE UNINTERRUPTED, TIMELY, SECURE, OR ERROR-FREE; NOR DO WE MAKE ANY WARRANTY AS TO THE RESULTS THAT MAY BE OBTAINED FROM THE USE OF THE SERVICE, OR AS TO THE ACCURACY, RELIABILITY, OR CONTENT OF ANY INFORMATION, SERVICE, OR MERCHANDISE PROVIDED THROUGH THE SERVICE.',
    'IN NO EVENT SHALL WHAT\'S NEWS? OR OUR AFFILIATES, LICENSORS, SERVICE PROVIDERS, EMPLOYEES, AGENTS, OFFICERS, OR DIRECTORS BE LIABLE FOR DAMAGES OF ANY KIND INCLUDING, WITHOUT LIMITATION, COMPENSATORY, CONSEQUENTIAL, INCIDENTAL, INDIRECT, SPECIAL, OR SIMILAR DAMAGES, WHETHER IN CONTRACT, TORT, STRICT LIABILITY, OR OTHERWISE, ARISING OUT OF YOUR USE OF THE SERVICE OR YOUR INABILITY TO USE THE SERVICE, OR FOR ANY OTHER CLAIM RELATED IN ANY WAY TO YOUR USE OF THE SERVICE, INCLUDING, BUT NOT LIMITED TO, ANY ERRORS OR OMISSIONS IN ANY CONTENT, OR ANY LOSS OR DAMAGE OF ANY KIND INCURRED AS A RESULT OF THE USE OF ANY CONTENT (OR PRODUCT) POSTED, TRANSMITTED, OR OTHERWISE MADE AVAILABLE VIA THE SERVICE, EVEN IF ADVISED OF THEIR POSSIBILITY. BECAUSE SOME STATES OR JURISDICTIONS DO NOT ALLOW THE EXCLUSION OR THE LIMITATION OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, IN SUCH STATES OR JURISDICTIONS, OUR LIABILITY SHALL BE LIMITED TO THE MAXIMUM EXTENT PERMITTED BY LAW.',
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
              childCurrent: TermsOfServicePage(),
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
                children: [
                  const Divider(
                    color: Colors.black,
                    thickness: 3,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Center(
                      child: Text(
                        "Terms of Service",
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
                  for (int i = 0; i <= 11; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _termsOfService[i],
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
