import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:analog_clock/analog_clock.dart';
import 'dart:math' as math;

class HomeHeaderDeligate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 250;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double avialableSpace = maxExtent - shrinkOffset;
    double screenWidth = MediaQuery.of(context).size.width;
    double percentSpace = avialableSpace / maxExtent;
    return Container(      
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Transform.rotate(
            angle: math.pi / 24 * percentSpace,
            child: Transform.scale(
              alignment: Alignment.bottomCenter,
              scale: 1 +percentSpace,
              child: Container(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),

          Positioned(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: AnalogClock(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.transparent,
                    shape: BoxShape.circle),
                width: 35 + screenWidth * 0.35 * percentSpace,
                height: 35 + avialableSpace * 0.60,
                isLive: true,
                hourHandColor: Colors.black,
                minuteHandColor: Colors.black,
                showSecondHand: false,
                numberColor: Colors.black87,
                showNumbers: true,
                textScaleFactor: 1.4,
                showTicks: true,
                showDigitalClock: false,
              ),
            ),
            left: ((screenWidth - screenWidth / 2) / 2) * percentSpace,
            bottom: (avialableSpace - avialableSpace * 0.60 - 10) / 2,
          ),
          Container(
            padding: EdgeInsets.all(15.0),
            alignment: Alignment.bottomCenter,
            child: Text("Next alram in 2hrs 30mins"),
          ),
        ],
      ),
      
    );
  }
}
