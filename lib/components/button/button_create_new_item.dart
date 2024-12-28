import 'package:coffee_app/core/values/color_const.dart';
import 'package:flutter/material.dart';

class ButtonCreateNewItem extends StatelessWidget {
  final void Function() onPressed;
  const ButtonCreateNewItem({
    super.key,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          color: ColorConstant.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create",
              style: TextStyle(color: Colors.white),
            ),
            Icon(
              Icons.add,
              color: Colors.white,
            )
          ],
        )),
      ),
    );
  }
}
