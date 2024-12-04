import 'package:flutter/material.dart';
import 'package:infrun/common/layout/default_layout.dart';
import 'package:infrun/restaurant/view/restaurant_screen.dart';

import '../const/colors.dart';

class RootTab extends StatefulWidget{
  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin{
  // late 키워드로
  late TabController controller;
  int naviIndex = 0;

  @override
  void initState() {
    super.initState();
    // Animation 과 관련된 vsync 파라미터ㅗ의 경우는 mixin 을 넣어줘야한다.
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }

  void tabListener(){
    setState(() {
      naviIndex = controller.index;
    });
  }


  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.shifting,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: naviIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '프로필'
          ),
        ],
      ),
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              RestaurantScreen(),
              Center(child: Container(child: Text('음식'),),),
              Center(child: Container(child: Text('주문'),),),
              Center(child: Container(child: Text('프로필'),),),
            ],
          )
      ),
    );
  }
}