import 'package:flutter/material.dart';
import 'package:animated_hint_textfield/animated_hint_textfield.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  Widget build(BuildContext context) {
    return AnimatedTextField(
      animationType: Animationtype
          .typer, // Use Animationtype.typer for Type Write Style animations
      hintTextStyle: const TextStyle(
        color: Colors.deepPurple,
        overflow: TextOverflow.ellipsis,
      ),
      hintTexts: const [
        'Search for your favorite coffee',
        'What type of coffee would you like today?',
        'Find the best coffee near you',
      ],

      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.search),
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}
