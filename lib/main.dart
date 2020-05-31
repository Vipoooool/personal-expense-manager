import 'package:flutter/material.dart';
import 'package:personal_expense/widgets/chart.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenditure',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.orangeAccent,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TransactionDbManager txDbM = new TransactionDbManager();
  final List<Transaction> _userTransactions = [];

  @override
  void initState() {
    super.initState();
    _getAllTransactions();
  }

  _getAllTransactions() async {
    List items = await txDbM.getTransactionList();
    // print(
    //     "**********************************Items*****************************************");
    // print(items.toString());
    // print(
    //     "**********************************Items*****************************************");
    items.forEach((item) {
      setState(() {
        _userTransactions.add(item);
      });
    });
  }

  void _addNewTransaction(
      String txTitle, int txQty, double txAmount, DateTime txDate) async {
    final newTx = Transaction(
        title: txTitle, quantity: txQty, amount: txAmount, date: txDate);

    await txDbM.saveTransaction(newTx);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(Transaction tx) async {
    await txDbM.deleteTransaction(tx);
    setState(() {
      _userTransactions.remove(tx);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.lightBlue,
      elevation: 10,
      title: const Text(
        'Personal Expenses',
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.add_circle,
            color: Colors.orangeAccent,
            size: 30,
          ),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    final bodyHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      body: Container(
        color: Theme.of(context).canvasColor,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/npr1000.png"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: _userTransactions.isEmpty == true
            ? Container(
                child: const Center(
                  child: Text(
                    "No transactions added yet!",
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).backgroundColor,
                      height: bodyHeight * 0.30,
                      child: Chart(_userTransactions),
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      color: Theme.of(context).backgroundColor,
                      height: bodyHeight * 0.70,
                      child: TransactionList(_userTransactions, _deleteTransaction),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.blueAccent,
        ),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
