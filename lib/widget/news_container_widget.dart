import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsContainerWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final String? url;
  final String? image;
  final String? publishedAt;
  final String? content;

  const NewsContainerWidget({
    super.key,
    this.title,
    this.description,
    this.url,
    this.image,
    this.publishedAt,
    this.content,
  });

  void _launchNews(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Failed to open URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    late Uri uri;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onLongPress: () {
          uri = Uri.parse(url!);
          _launchNews(uri);
        },
        onVerticalDragEnd: (details) => Navigator.of(context).pop(),
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            children: [
              image != ''
                  ? Image.network('$image')
                  : Image.asset('assets/images/newspaper.png'),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedTextKit(
                            displayFullTextOnTap: true,
                            isRepeatingAnimation: false,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                title!,
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AnimatedTextKit(
                            displayFullTextOnTap: true,
                            isRepeatingAnimation: false,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                description!,
                                textStyle: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 16,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AnimatedTextKit(
                            displayFullTextOnTap: true,
                            isRepeatingAnimation: false,
                            animatedTexts: [
                              TypewriterAnimatedText(
                                content!,
                                textStyle: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 16,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  right: 10,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedTextKit(
                    displayFullTextOnTap: true,
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        publishedAt!,
                        textAlign: TextAlign.end,
                        textStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Share.share(url!),
        backgroundColor: const Color(0xffe8dfce),
        child: const Icon(
          Icons.share_sharp,
        ),
      ),
    );
  }
}
