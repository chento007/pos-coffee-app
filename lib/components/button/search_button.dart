import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final ValueChanged<String> onChanged; // Callback for handling text changes
  final String? hintText; // Optional hint text
  
  const SearchButton({
    Key? key,
    required this.onChanged,
    this.hintText = 'Search',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300, // Fixed width
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
