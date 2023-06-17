import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigation({super.key, required this.currentIndex});

  void onItemTapped(BuildContext context, int index) {
    // context.go('');
    switch (index) {
      case 0:
        context.go('/inicio/0');
        break;

      case 1:
        context.go('/inicio/1');
        break;

      case 2:
        context.go('/inicio/2');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (value) => onItemTapped(context, value),
            elevation: 0,
            selectedItemColor: colors.secondary,
            unselectedItemColor: colors.primary,
            selectedIconTheme: const IconThemeData(size: 30),
            showUnselectedLabels: false,
            showSelectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined), label: '---'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.workspace_premium), label: '---'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.sports_esports_outlined), label: '---'),
            ]),
      ),
    );
  }
}
