import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Transaction {
  final int id;
  final String title;
  final int quantity;
  final double amount;
  final DateTime date;

  Transaction({
    this.id,
    this.quantity,
    @required this.title,
    @required this.amount,
    @required this.date,
  });

  Map<String, dynamic> toMap() {
    return {'title': title, 'quantity': quantity, 'amount': amount, 'date': date.toString()};
  }
}

class TransactionDbManager {
  final tx1 = Transaction(
      title: 'New Shoes',
      quantity: 2,
      amount: 69.99,
      date: DateTime.now(),
    );
  final tx2 = Transaction(
      title: 'Weekly Groceries',
      quantity: 1,
      amount: 16.53,
      date: DateTime.now(),
    );
  
  Database _db;

  // initialize database
  Future _openDb() async {
    if (_db == null) {
      _db = await openDatabase(join(await getDatabasesPath(), 'transaction.db'), version: 1, onCreate: _createDB);
    }
  }

  Future<void> _createDB(Database db, int version) async {
    return await db.execute("CREATE TABLE transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, quantity INTEGER DEFAULT 1, amount FLOAT, date TEXT)");
  }

  Future<int> saveTransaction(Transaction tx) async {
    await _openDb();
    // await _db.insert('transactions', tx1.toMap());
    // await _db.insert('transactions', tx2.toMap());
    return await _db.insert('transactions', tx.toMap());

  }

  Future<List<Transaction>> getTransactionList() async {
    await _openDb();
    final List<Map<String, dynamic>> transactions = await _db.query('transactions');
    // print("**************************transactions*************************************************");
    // print(transactions);
    // print("*****************************transactions**********************************************");
    return List.generate(transactions.length, (i) {
      return Transaction(
          id: transactions[i]['id'], title: transactions[i]['title'], quantity: transactions[i]['quantity'], amount: transactions[i]['amount'], date: DateTime.parse(transactions[i]['date']));
    });
  }

  Future<int> deleteTransaction(Transaction tx) async {
    await _openDb();
    return await _db.delete('transactions', where: 'id = ?', whereArgs: [tx.id]);
  }

  Future close() async {
    await _openDb();
    return _db.close();
  }
}