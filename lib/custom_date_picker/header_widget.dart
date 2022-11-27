import 'package:custom_date_picker_example/custom_date_picker/header_item.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            HeaderItem(title: 'Never Ends', isSelected: false),
            HeaderItem(title: '15 Days Later', isSelected: false),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            HeaderItem(title: '30 Days Later', isSelected: false),
            HeaderItem(title: '60 Days Later', isSelected: true),
          ],
        )
      ],
    );
  }
}
