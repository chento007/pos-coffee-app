import 'package:flutter/material.dart';

class DropdownEmployeeManagement extends StatelessWidget {
  final PageController pageController;

  // Constructor to accept the PageController
  const DropdownEmployeeManagement({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        "Employee Management",
        style: TextStyle(
          fontSize: 15, // Adjust the font size
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      ),
      leading: const Icon(
        Icons.people_alt,
        size: 28, // Increase icon size
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      iconColor: Colors.black, // Color of the expand/collapse icon
      collapsedIconColor: Colors.blueGrey,
      children: <Widget>[
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8), // Padding around the icon
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Circle shape around the icon
            ),
            child: const Icon(
              Icons.shopping_cart,
              size: 24, // Icon size
            ),
          ),
          title: const Text(
            "Users",
            style: TextStyle(
              fontSize: 14, // Font size of the ListTile title
              fontWeight: FontWeight.bold,
              color: Colors.black, // Text color
            ),
          ),
          subtitle: Text(
            "Manage your user list",
            style: TextStyle(
              fontSize: 12,
              color: Colors.blueGrey[500],
            ),
          ),
          onTap: () {
            pageController.jumpToPage(5);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle, 
            ),
            child: const Icon(
              Icons.person,
              size: 24, // Icon size
            ),
          ),
          title: const Text(
            "Roles",
            style: TextStyle(
              fontSize: 14, // Font size of the ListTile title
              fontWeight: FontWeight.bold,
              color: Colors.black, // Text color
            ),
          ),
          subtitle: Text(
            "Manage your roles list",
            style: TextStyle(
              fontSize: 12, // Smaller font size for the subtitle
              color: Colors.blueGrey[500],
            ),
          ),
          onTap: () {
            pageController
                .jumpToPage(6); // You can adjust the page index as needed
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}