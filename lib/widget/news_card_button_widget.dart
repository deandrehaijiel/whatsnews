import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:zwidget/zwidget.dart';

class NewsCardButtonWidget extends StatelessWidget {
  final Function onTap;
  final Widget child;

  const NewsCardButtonWidget({
    required this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZWidget.forwards(
      alignment: const Alignment(7, 11),
      layers: 3,
      depth: 60,
      midChild: Container(),
      topChild: GestureDetector(
        onTap: () => onTap(),
        child: child,
      ),
    );
  }
}

//swipe card to the right side
Widget swipeRightButton(AppinioSwiperController controller) {
  return NewsCardButtonWidget(
    onTap: () => controller.swipeRight(),
    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.black,
          width: 5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            spreadRadius: -10,
            blurRadius: 20,
            offset: const Offset(0, 20), // changes position of shadow
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.arrow_forward,
        color: Colors.black,
        size: 40,
      ),
    ),
  );
}

//swipe card to the left side
Widget swipeLeftButton(AppinioSwiperController controller) {
  return NewsCardButtonWidget(
    onTap: () => controller.unswipe(),
    child: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Colors.black,
          width: 5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            spreadRadius: -10,
            blurRadius: 20,
            offset: const Offset(0, 20), // changes position of shadow
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.arrow_back,
        color: Colors.black,
        size: 40,
      ),
    ),
  );
}
