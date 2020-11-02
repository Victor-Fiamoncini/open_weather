import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ForecastItem extends StatelessWidget {
  const ForecastItem({
    this.daysFromNow,
    this.abbrevation,
    this.minTemperature,
    this.maxTemperature,
  });

  final int daysFromNow;
  final String abbrevation;
  final int minTemperature;
  final int maxTemperature;

  @override
  Widget build(BuildContext context) {
    final oneDarFromNow = DateTime.now().add(Duration(days: daysFromNow));
    final formattedWeekDay = DateFormat.E().format(oneDarFromNow);
    final formattedMonthDayWithMonth = DateFormat.MMMd().format(oneDarFromNow);

    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(205, 212, 228, 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                formattedWeekDay,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              Text(
                formattedMonthDayWithMonth,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              Text(
                'High $maxTemperature °C',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                'High $minTemperature °C',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
