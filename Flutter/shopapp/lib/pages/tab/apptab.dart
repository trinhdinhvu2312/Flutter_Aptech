import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodapp/bloc/cubits/app_config_cubit.dart';
import 'package:foodapp/bloc/models/app_config.dart';
import 'package:foodapp/pages/tab/orders/orders.dart';
import 'package:foodapp/pages/tab/favorites/favorites.dart';
import 'package:foodapp/pages/tab/home/home.dart';
import 'package:foodapp/pages/tab/profile/profile.dart';
import 'package:foodapp/utils/app_colors.dart';

class AppTab extends StatefulWidget {
  @override
  _AppTabState createState() => _AppTabState();
}

class _AppTabState extends State<AppTab> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
    context.read<AppConfigCubit>().updateSelectedTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Remove the top app bar
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          Home(),
          Favorites(),
          Orders(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BlocBuilder<AppConfigCubit, AppConfig>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed, // Ensure all tabs are visible
            currentIndex: state.selectedTabIndex,
            selectedItemColor: AppColors.primaryColor,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}
