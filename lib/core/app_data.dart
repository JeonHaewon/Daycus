import 'package:flutter/material.dart';
import 'package:daycus/core/bottom_navigation_item.dart';


class AppData {
  const AppData._();

  static List<BottomNavigationItem> bottomNavigationItems = [
    BottomNavigationItem(const Icon(Icons.home), '홈'),
    //BottomNavigationItem(const Icon(Icons.home), '홈'),
    BottomNavigationItem(const Icon(Icons.assignment), '미션'),
    BottomNavigationItem(const Icon(Icons.camera_alt_outlined), '미션 인증'),
    BottomNavigationItem(const Icon(Icons.edit_outlined), '라벨링'),
    BottomNavigationItem(const Icon(Icons.person_outline), '마이페이지')

  ];
}