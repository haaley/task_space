import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

Widget TabBarWidget(past, now, future, tabControl){
  return TabBar(
    controller: tabControl,
    tabs: [
      Tab(
        icon: Badge(
            badgeColor: Colors.white,
            shape: BadgeShape.circle,
            elevation: 10.0,
            animationType: BadgeAnimationType.fade,
            badgeContent: Text(
              past.length.toString(),
              style: TextStyle(
                  color:Color.fromRGBO(0, 99, 170, 1), fontSize: 10),
            ),
            child: Text("Atas"),
            position: BadgePosition.topRight(right: -30)),
      ),
      Tab(
        icon: Badge(
            badgeColor: Colors.white,
            shape: BadgeShape.circle,
            elevation: 10.0,
            animationType: BadgeAnimationType.fade,
            badgeContent: Text(
              now.length.toString(),
              style: TextStyle(
                  color:Color.fromRGBO(0, 99, 170, 1), fontSize: 10),
            ),
            child: Text("Hoje"),
            position: BadgePosition.topRight(right: -30)),
      ),
      Tab(
        icon: Badge(
            badgeColor: Colors.white,
            shape: BadgeShape.circle,
            elevation: 10.0,
            animationType: BadgeAnimationType.fade,
            badgeContent: Text(
              future.length.toString(),
              style: TextStyle(
                  color:Color.fromRGBO(0, 99, 170, 1), fontSize: 10),
            ),
            child: Text("Futuras"),
            position: BadgePosition.topRight(right: -30)),
      ),
    ],
  );
}