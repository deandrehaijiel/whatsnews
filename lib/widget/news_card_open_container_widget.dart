import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class NewsCardOpenContainer extends StatelessWidget {
  final Widget openBuilder;
  final Widget closedBuidler;

  const NewsCardOpenContainer(
      {super.key, required this.openBuilder, required this.closedBuidler});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      closedElevation: 10,
      openElevation: 10,
      openBuilder: (BuildContext context, VoidCallback _) {
        return openBuilder;
      },
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return closedBuidler;
      },
    );
  }
}
