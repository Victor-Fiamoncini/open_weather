import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ForecastItem extends StatelessWidget {
  const ForecastItem({this.daysFromNow});

  final int daysFromNow;

  @override
  Widget build(BuildContext context) {
    final oneDarFromNow = DateTime.now().add(Duration(days: daysFromNow));
    final formattedDate = DateFormat.E().format(oneDarFromNow);

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(205, 212, 228, 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            formattedDate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
