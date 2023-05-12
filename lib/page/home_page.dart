import 'dart:convert';
import 'dart:math';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zwidget/zwidget.dart';

import '../data/datas.dart';
import '../widget/widgets.dart';
import 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var _maxSlide = 0.75;
  var _extraHeight = 0.1;
  late double _startingPos;
  var _drawerVisible = false;
  late AnimationController _animationController;
  Size _screen = const Size(0, 0);
  late CurvedAnimation _animator;
  late AnimationController _slideAnimationController;
  late Animation<Offset> _animationUp;

  int _tappedIndex = -1;
  late double _scale;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();

    _getNews('sources=bbc-news');

    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animationUp = Tween<Offset>(
      begin: const Offset(0.0, -3.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.elasticInOut,
      ),
    );

    _slideAnimationController.forward();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animator = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
      reverseCurve: Curves.easeInQuad,
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void didChangeDependencies() {
    _screen = MediaQuery.of(context).size;
    _maxSlide *= _screen.width;
    _extraHeight *= _screen.height;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _appinioSwiperController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _startingPos = details.globalPosition.dx;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final globalDelta = details.globalPosition.dx - _startingPos;
    if (globalDelta > 0) {
      final pos = globalDelta / _screen.width;
      if (_drawerVisible && pos <= 1.0) return;
      _animationController.value = pos;
    } else {
      final pos = 1 - (globalDelta.abs() / _screen.width);
      if (!_drawerVisible && pos >= 0.0) return;
      _animationController.value = pos;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dx.abs() > 500) {
      if (details.velocity.pixelsPerSecond.dx > 0) {
        _animationController.forward(from: _animationController.value);
        _drawerVisible = true;
      } else {
        _animationController.reverse(from: _animationController.value);
        _drawerVisible = false;
      }
      return;
    }
    if (_animationController.value > 0.5) {
      {
        _animationController.forward(from: _animationController.value);
        _drawerVisible = true;
      }
    } else {
      {
        _animationController.reverse(from: _animationController.value);
        _drawerVisible = false;
      }
    }
  }

  void _toggleDrawer() {
    if (_animationController.value < 0.5) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _tapDown(TapDownDetails details, int index) {
    setState(() {
      _tappedIndex = index;
    });
    _scaleController.forward();
  }

  void _tapUp(TapUpDetails details) {
    _scaleController.reverse();
    setState(() {
      _tappedIndex = -1;
    });
  }

  List<News> _newsList = [];
  int _newsIndex = 0;
  late Uri _uri;
  final AppinioSwiperController _appinioSwiperController =
      AppinioSwiperController();

  bool _connection = true;
  bool _loadingNews = true;

  final _player = AudioPlayer();

  final List<String> _titles = [
    'bbc-news',
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  final List<bool> _boolTitles = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  final List<String> _footerTitles = [
    'ABOUT',
    'TERMS OF SERVICE',
    'FAQS',
  ];

  Future<void> _getNews(String endpoints) async {
    setState(() {
      _connection = true;
      _loadingNews = true;
    });

    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?$endpoints&language=en');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': dotenv.env['News_API']!,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List<dynamic>;

        setState(() {
          _newsList = articles
              .map((article) => News(
                    title: article['title'] ?? '',
                    cardTitle: article['title'] ?? '',
                    description: article['description'] ?? '',
                    cardDescription: article['description'] ?? '',
                    url: article['url'] ?? '',
                    image: article['urlToImage'] ?? '',
                    publishedAt: article['publishedAt'] ?? '',
                    content: article['content'] ?? '',
                  ))
              .toList();
        });

        for (var news in _newsList) {
          if (news.publishedAt != null) {
            news.publishedAt = news.publishedAt!.substring(0, 10);
          }
          if (news.content != null && news.content!.length > 200) {
            news.content = news.content!.substring(0, 200);
          }
        }
        setState(() {
          _loadingNews = false;
        });
      }
    } catch (e) {
      setState(() {
        _connection = false;
      });
    }
  }

  void _launchNews(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 + _scaleController.value;
    return Material(
      child: Stack(
        children: [
          Container(color: const Color(0xFFaaa598)),
          _buildBackgroundAndHome(),
          _buildDrawer(),
          _builderHeader(),
          _buildGestureDetector(),
        ],
      ),
    );
  }

  _buildBackgroundAndHome() => Positioned.fill(
        top: -_extraHeight,
        bottom: -_extraHeight,
        child: AnimatedBuilder(
          animation: _animator,
          builder: (context, widget) => Transform.translate(
            offset: Offset(_maxSlide * _animator.value, 0),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY((pi / 2 + 0.1) * -_animator.value),
              alignment: Alignment.centerLeft,
              child: widget,
            ),
          ),
          child: Container(
            color: const Color(0xffe8dfce),
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _animator,
                  builder: (_, __) => Container(
                    color: Colors.black.withAlpha(
                      (150 * _animator.value).floor(),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: !_connection
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: Text(
                                  'Please check your Internet connection and refresh again.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: Color(0xffbb0000),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : _loadingNews
                              ? Center(
                                  child: LoadingAnimationWidget.inkDrop(
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                )
                              : ZWidget.forwards(
                                  alignment: const Alignment(1, -6),
                                  layers: 3,
                                  depth: 30,
                                  midChild: Container(),
                                  topChild: AppinioSwiper(
                                    controller: _appinioSwiperController,
                                    swipeOptions:
                                        AppinioSwipeOptions.allDirections,
                                    unlimitedUnswipe: true,
                                    padding: const EdgeInsets.only(
                                      left: 25,
                                      right: 25,
                                      top: 25,
                                      bottom: 40,
                                    ),
                                    cardsCount: _newsList.length,
                                    cardsBuilder:
                                        (BuildContext context, int index) {
                                      _newsIndex = index;
                                      return SlideTransition(
                                        position: _animationUp,
                                        child: NewsCardOpenContainer(
                                          openBuilder: NewsContainerWidget(
                                            title: _newsList[index].title,
                                            description:
                                                _newsList[index].description,
                                            url: _newsList[index].url,
                                            image: _newsList[index].image,
                                            publishedAt:
                                                _newsList[index].publishedAt,
                                            content: _newsList[index].content,
                                          ),
                                          closedBuidler: NewsCardWidget(
                                              news: _newsList[index]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        swipeLeftButton(_appinioSwiperController),
                        const SizedBox(
                          width: 20,
                        ),
                        NewsCardButtonWidget(
                          onTap: () {
                            _uri = Uri.parse(_newsList[_newsIndex].url!);
                            _launchNews(_uri);
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xff007EBD),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Colors.black,
                                width: 5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff007EBD).withOpacity(0.9),
                                  spreadRadius: -10,
                                  blurRadius: 20,
                                  offset: const Offset(
                                      0, 20), // changes position of shadow
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.newspaper_rounded,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        swipeRightButton(_appinioSwiperController),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  _buildDrawer() => Positioned.fill(
        top: -_extraHeight,
        bottom: -_extraHeight,
        left: 0,
        right: _screen.width - _maxSlide,
        child: AnimatedBuilder(
          animation: _animator,
          builder: (context, widget) {
            return Transform.translate(
              offset: Offset(_maxSlide * (_animator.value - 1), 0),
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(pi * (1 - _animator.value) / 2),
                alignment: Alignment.centerRight,
                child: widget,
              ),
            );
          },
          child: Container(
            color: const Color(0xffe8dfce),
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _animator,
                  builder: (_, __) => Container(
                    width: _maxSlide,
                    color: Colors.black.withAlpha(
                      (150 * (1 - _animator.value)).floor(),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 5,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black12],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  top: _extraHeight,
                  bottom: _extraHeight,
                  child: SafeArea(
                    child: SizedBox(
                      width: _maxSlide,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 35,
                          bottom: 35,
                          left: 35,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffbb0000),
                                      width: 4,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Transform.translate(
                                  offset: const Offset(-30, 0),
                                  child: const Text(
                                    "WHATS NEWS?",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                    onTapDown: (_) => _tapDown(_, 0),
                                    onTapUp: _tapUp,
                                    onTap: () {
                                      setState(() {
                                        _boolTitles[0] = true;
                                        _boolTitles[1] = false;
                                        _boolTitles[2] = false;
                                        _boolTitles[3] = false;
                                        _boolTitles[4] = false;
                                        _boolTitles[5] = false;
                                        _boolTitles[6] = false;
                                        _boolTitles[7] = false;
                                      });
                                      _slideAnimationController.reverse();
                                      _animationController.reverse();
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _getNews('sources=${_titles[0]}');
                                      });
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _slideAnimationController.forward();
                                      });
                                    },
                                    child: Transform.scale(
                                      scale: _tappedIndex == 0 ? _scale : 1.0,
                                      child: Text(
                                        'HEADLINES',
                                        style: TextStyle(
                                          fontSize: _boolTitles[0] ? 21 : 18,
                                          color: _boolTitles[0]
                                              ? const Color(0xffbb0000)
                                              : null,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                    onTapDown: (_) => _tapDown(_, 1),
                                    onTapUp: _tapUp,
                                    onTap: () {
                                      setState(() {
                                        _boolTitles[0] = false;
                                        _boolTitles[1] = true;
                                        _boolTitles[2] = false;
                                        _boolTitles[3] = false;
                                        _boolTitles[4] = false;
                                        _boolTitles[5] = false;
                                        _boolTitles[6] = false;
                                        _boolTitles[7] = false;
                                      });
                                      _slideAnimationController.reverse();
                                      _animationController.reverse();
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _getNews('category=${_titles[1]}');
                                      });
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _slideAnimationController.forward();
                                      });
                                    },
                                    child: Transform.scale(
                                      scale: _tappedIndex == 1 ? _scale : 1.0,
                                      child: Text(
                                        _titles[1].toUpperCase(),
                                        style: TextStyle(
                                          fontSize: _boolTitles[1] ? 21 : 18,
                                          color: _boolTitles[1]
                                              ? const Color(0xffbb0000)
                                              : null,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                    onTapDown: (_) => _tapDown(_, 2),
                                    onTapUp: _tapUp,
                                    onTap: () {
                                      setState(() {
                                        _boolTitles[0] = false;
                                        _boolTitles[1] = false;
                                        _boolTitles[2] = true;
                                        _boolTitles[3] = false;
                                        _boolTitles[4] = false;
                                        _boolTitles[5] = false;
                                        _boolTitles[6] = false;
                                        _boolTitles[7] = false;
                                      });
                                      _slideAnimationController.reverse();
                                      _animationController.reverse();
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _getNews('category=${_titles[2]}');
                                      });
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _slideAnimationController.forward();
                                      });
                                    },
                                    child: Transform.scale(
                                      scale: _tappedIndex == 2 ? _scale : 1.0,
                                      child: Text(
                                        _titles[2].toUpperCase(),
                                        style: TextStyle(
                                          fontSize: _boolTitles[2] ? 21 : 18,
                                          color: _boolTitles[2]
                                              ? const Color(0xffbb0000)
                                              : null,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                    onTapDown: (_) => _tapDown(_, 3),
                                    onTapUp: _tapUp,
                                    onTap: () {
                                      setState(() {
                                        _boolTitles[0] = false;
                                        _boolTitles[1] = false;
                                        _boolTitles[2] = false;
                                        _boolTitles[3] = true;
                                        _boolTitles[4] = false;
                                        _boolTitles[5] = false;
                                        _boolTitles[6] = false;
                                        _boolTitles[7] = false;
                                      });
                                      _slideAnimationController.reverse();
                                      _animationController.reverse();
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _getNews('category=${_titles[3]}');
                                      });
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _slideAnimationController.forward();
                                      });
                                    },
                                    child: Transform.scale(
                                      scale: _tappedIndex == 3 ? _scale : 1.0,
                                      child: Text(
                                        _titles[3].toUpperCase(),
                                        style: TextStyle(
                                          fontSize: _boolTitles[3] ? 21 : 18,
                                          color: _boolTitles[3]
                                              ? const Color(0xffbb0000)
                                              : null,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                    onTapDown: (_) => _tapDown(_, 4),
                                    onTapUp: _tapUp,
                                    onTap: () {
                                      setState(() {
                                        _boolTitles[0] = false;
                                        _boolTitles[1] = false;
                                        _boolTitles[2] = false;
                                        _boolTitles[3] = false;
                                        _boolTitles[4] = true;
                                        _boolTitles[5] = false;
                                        _boolTitles[6] = false;
                                        _boolTitles[7] = false;
                                      });
                                      _slideAnimationController.reverse();
                                      _animationController.reverse();
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _getNews('category=${_titles[4]}');
                                      });
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _slideAnimationController.forward();
                                      });
                                    },
                                    child: Transform.scale(
                                      scale: _tappedIndex == 4 ? _scale : 1.0,
                                      child: Text(
                                        _titles[4].toUpperCase(),
                                        style: TextStyle(
                                          fontSize: _boolTitles[4] ? 21 : 18,
                                          color: _boolTitles[4]
                                              ? const Color(0xffbb0000)
                                              : null,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                    onTapDown: (_) => _tapDown(_, 5),
                                    onTapUp: _tapUp,
                                    onTap: () {
                                      setState(() {
                                        _boolTitles[0] = false;
                                        _boolTitles[1] = false;
                                        _boolTitles[2] = false;
                                        _boolTitles[3] = false;
                                        _boolTitles[4] = false;
                                        _boolTitles[5] = true;
                                        _boolTitles[6] = false;
                                        _boolTitles[7] = false;
                                      });
                                      _slideAnimationController.reverse();
                                      _animationController.reverse();
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _getNews('category=${_titles[5]}');
                                      });
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _slideAnimationController.forward();
                                      });
                                    },
                                    child: Transform.scale(
                                      scale: _tappedIndex == 5 ? _scale : 1.0,
                                      child: Text(
                                        _titles[5].toUpperCase(),
                                        style: TextStyle(
                                          fontSize: _boolTitles[5] ? 21 : 18,
                                          color: _boolTitles[5]
                                              ? const Color(0xffbb0000)
                                              : null,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                    onTapDown: (_) => _tapDown(_, 6),
                                    onTapUp: _tapUp,
                                    onTap: () {
                                      setState(() {
                                        _boolTitles[0] = false;
                                        _boolTitles[1] = false;
                                        _boolTitles[2] = false;
                                        _boolTitles[3] = false;
                                        _boolTitles[4] = false;
                                        _boolTitles[5] = false;
                                        _boolTitles[6] = true;
                                        _boolTitles[7] = false;
                                      });
                                      _slideAnimationController.reverse();
                                      _animationController.reverse();
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _getNews('category=${_titles[6]}');
                                      });
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _slideAnimationController.forward();
                                      });
                                    },
                                    child: Transform.scale(
                                      scale: _tappedIndex == 6 ? _scale : 1.0,
                                      child: Text(
                                        _titles[6].toUpperCase(),
                                        style: TextStyle(
                                          fontSize: _boolTitles[6] ? 21 : 18,
                                          color: _boolTitles[6]
                                              ? const Color(0xffbb0000)
                                              : null,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: GestureDetector(
                                    onTapDown: (_) => _tapDown(_, 7),
                                    onTapUp: _tapUp,
                                    onTap: () {
                                      setState(() {
                                        _boolTitles[0] = false;
                                        _boolTitles[1] = false;
                                        _boolTitles[2] = false;
                                        _boolTitles[3] = false;
                                        _boolTitles[4] = false;
                                        _boolTitles[5] = false;
                                        _boolTitles[6] = false;
                                        _boolTitles[7] = true;
                                      });
                                      _slideAnimationController.reverse();
                                      _animationController.reverse();
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _getNews('category=${_titles[7]}');
                                      });
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        _slideAnimationController.forward();
                                      });
                                    },
                                    child: Transform.scale(
                                      scale: _tappedIndex == 7 ? _scale : 1.0,
                                      child: Text(
                                        _titles[7].toUpperCase(),
                                        style: TextStyle(
                                          fontSize: _boolTitles[7] ? 21 : 18,
                                          color: _boolTitles[7]
                                              ? const Color(0xffbb0000)
                                              : null,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      _player.play(
                                          AssetSource('sounds/newspaper.mp3'));
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.leftToRight,
                                          duration:
                                              const Duration(milliseconds: 750),
                                          childCurrent: const HomePage(),
                                          child: AboutPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      _footerTitles[0],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      _player.play(
                                          AssetSource('sounds/newspaper.mp3'));
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.leftToRight,
                                          duration:
                                              const Duration(milliseconds: 750),
                                          childCurrent: const HomePage(),
                                          child: TermsOfServicePage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      _footerTitles[1],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      _player.play(
                                          AssetSource('sounds/newspaper.mp3'));
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.leftToRight,
                                          duration:
                                              const Duration(milliseconds: 750),
                                          childCurrent: const HomePage(),
                                          child: FrequentlyAskedQuestionsPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      _footerTitles[2],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  _builderHeader() => SafeArea(
        child: AnimatedBuilder(
            animation: _animator,
            builder: (_, __) {
              return Transform.translate(
                offset: Offset((_screen.width - 60) * _animator.value, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _toggleDrawer,
                        child: const Icon(
                          Icons.menu,
                          size: 40,
                        ),
                      ),
                      Opacity(
                        opacity: 1 - _animator.value,
                        child: Text(
                          _boolTitles[0]
                              ? 'HEADLINES'
                              : _boolTitles[1]
                                  ? _titles[1].toUpperCase()
                                  : _boolTitles[2]
                                      ? _titles[2].toUpperCase()
                                      : _boolTitles[3]
                                          ? _titles[3].toUpperCase()
                                          : _boolTitles[4]
                                              ? _titles[4].toUpperCase()
                                              : _boolTitles[5]
                                                  ? _titles[5].toUpperCase()
                                                  : _boolTitles[6]
                                                      ? _titles[6].toUpperCase()
                                                      : _titles[7]
                                                          .toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 24),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _slideAnimationController.reverse();
                          Future.delayed(const Duration(seconds: 2), () {
                            _boolTitles[0]
                                ? _getNews('sources=${_titles[0]}')
                                : _boolTitles[1]
                                    ? _getNews('category=${_titles[1]}')
                                    : _boolTitles[2]
                                        ? _getNews('category=${_titles[2]}')
                                        : _boolTitles[3]
                                            ? _getNews('category=${_titles[3]}')
                                            : _boolTitles[4]
                                                ? _getNews(
                                                    'category=${_titles[4]}')
                                                : _boolTitles[5]
                                                    ? _getNews(
                                                        'category=${_titles[5]}')
                                                    : _boolTitles[6]
                                                        ? _getNews(
                                                            'category=${_titles[6]}')
                                                        : _getNews(
                                                            'category=${_titles[7]}');
                          });
                          Future.delayed(const Duration(seconds: 3), () {
                            _slideAnimationController.forward();
                          });
                        },
                        child: const Icon(
                          Icons.refresh,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      );

  _buildGestureDetector() => Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.height / 4,
          child: GestureDetector(
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
          ),
        ),
      );
}
