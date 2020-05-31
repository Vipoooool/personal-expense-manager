import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Card(
          color: Theme.of(context).splashColor,
          shadowColor: Theme.of(context).primaryColorDark,
          margin: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 5,
          ),
          elevation: 5,
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Text(
                    'Rs ${(transactions[index].amount * transactions[index].quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      transactions[index].quantity.toString(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                  minRadius: 15,
                  backgroundColor: Colors.lightBlueAccent,
                ),
              ],
            ),
            subtitle: Text(
              DateFormat.yMMMEd().format(transactions[index].date),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.deepOrangeAccent[200],
              onPressed: () => deleteTx(transactions[index]),
            ),
          ),
        );
      },
      itemCount: transactions.length,
    );
  }
}
