import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/models/transaction.dart';
import 'package:personal_expense/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransansactionValues {
    const weekDays = {
      'Sun': 0,
      'Mon': 1,
      'Tue': 2,
      'Wed': 3,
      'Thu': 4,
      'Fri': 5,
      'Sat': 6
    };

    final filteredTransactions = List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.weekday == weekDay.weekday) {
          // && recentTransactions[i].date.month == weekDay.month && recentTransactions[i].date.year == weekDay.year
          totalSum +=
              recentTransactions[i].amount * recentTransactions[i].quantity;
        }
      }
      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    });

    filteredTransactions.sort((m1, m2) => weekDays[(m1['day'] as String)]
        .compareTo(weekDays[m2['day'] as String]));

    return filteredTransactions;
  }

  double get totalSpending {
    return groupedTransansactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColorLight,
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransansactionValues.map((data) {
            return Expanded(
              child: ChartBar(
                  data["day"],
                  data["amount"],
                  totalSpending == 0.0
                      ? 0.0
                      : (data["amount"] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
