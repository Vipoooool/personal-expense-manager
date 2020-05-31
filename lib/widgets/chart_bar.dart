import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctofTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctofTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
      return Column(
        children: <Widget>[
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Column(children: <Widget>[
                const Text(
                  'Rs',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${spendingAmount.toStringAsFixed(0)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ]))),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 20,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctofTotal,
                  child: Container(
                      decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      );
    });
  }
}
