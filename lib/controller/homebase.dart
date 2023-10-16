import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/app_colors.dart';
import 'package:jpan_flutter/const/app_font.dart';
import 'package:jpan_flutter/const/constants.dart';
import 'package:jpan_flutter/const/historydrawerstate.dart';
import 'package:jpan_flutter/const/utils.dart';
import 'package:jpan_flutter/controller/history/history.dart';
import 'package:jpan_flutter/controller/home/home.dart';
import 'package:jpan_flutter/controller/profile/profile.dart';
import 'package:provider/provider.dart';

class HomeBase extends StatefulWidget {
  const HomeBase({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeBase();
  }
}

class _HomeBase extends State<HomeBase> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  final List _screens = [
    const Home(),
    const ReportHistory(),
    const UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<DrawerState>(builder: (context, value, child) {
      bool themeDark = value.getState;
      return Scaffold(
        body: Container(
          color: Colors.transparent,
          width: screenWidth,
          height: screenHeight,
          child: _screens[_currentIndex],
        ),
        bottomNavigationBar: !themeDark ? bottomNav() : null,
      );
    });
  }

  Widget bottomNav() {
    return BottomNavigationBar(
        elevation: 10.0,
        backgroundColor: AppColors.appWhite(),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        unselectedItemColor: AppColors.appDisabledGray(),
        selectedItemColor: AppColors.appPrimaryBlue(),
        selectedLabelStyle: AppFont.helvBold(12),
        unselectedLabelStyle: AppFont.helvMed(12),
        items: [
          BottomNavigationBarItem(
              activeIcon: const ImageIcon(
                AssetImage(Constants.assetImages + 'home_icon_active.png'),
              ),
              icon: const ImageIcon(
                AssetImage(Constants.assetImages + 'home_icon_inactive.png'),
              ),
              label: Utils.getTranslated(context, 'hombase_home')),
          BottomNavigationBarItem(
              activeIcon: const ImageIcon(
                AssetImage(
                    Constants.assetImages + 'report history_icon_active.png'),
              ),
              icon: const ImageIcon(
                AssetImage(
                    Constants.assetImages + 'report history_icon_inactive.png'),
              ),
              label: Utils.getTranslated(context, 'hombase_reporthistory')),
          BottomNavigationBarItem(
              activeIcon: const ImageIcon(
                AssetImage(Constants.assetImages + 'profile_icon_active.png'),
              ),
              icon: const ImageIcon(
                AssetImage(Constants.assetImages + 'profile_icon_inactive.png'),
              ),
              label: Utils.getTranslated(context, 'hombase_profile'))
        ]);
  }
}
