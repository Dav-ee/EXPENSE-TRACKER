import '../widgets/round_icon.dart';
import 'package:flutter/material.dart';

class AmounBox extends StatelessWidget {
  const AmounBox({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.amount,
  }) : super(key: key);
  final IconData icon;
  final Color iconColor;
  final String title;
  final String amount;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundIcon(icon: icon, color: iconColor),
        const SizedBox(
          width: 10.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
            Text(
              'KES $amount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
