import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomBar({
    required this.selectedIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black,  
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      items: const[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home"
        ),          
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: "Hisotry"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: "Order"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Setting"
        ),
      ],
    );
  }
}
