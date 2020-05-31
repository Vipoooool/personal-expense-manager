import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    var enteredQuantity = int.parse(_quantityController.text);
    final enteredAmount = double.parse(_amountController.text);
    var enteredDate = _selectedDate;

    if (enteredQuantity < 1) {
      enteredQuantity = 1;
    }

    if (enteredDate == null) {
      enteredDate = DateTime.now();
    }

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.addTx(enteredTitle, enteredQuantity, enteredAmount, enteredDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: bodyHeight * 0.60,
          color: Colors.indigo[100],
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                height: bodyHeight * 0.10,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Item'),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
                ),
              ),
              Container(
                height: bodyHeight * 0.10,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Unit Price'),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                  // onChanged: (val) => amountInput = val,
                ),
              ),
              Container(
                height: bodyHeight * 0.10,
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                ),
              ),
              Container(
                height: bodyHeight * 0.10,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'Default Date: ${DateFormat.yMd().format(DateTime.now())}'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    FlatButton(
                      color: Colors.orangeAccent[100],
                      onPressed: _presentDatePicker,
                      child: const Text(
                        'Choose date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(
                height: bodyHeight * 0.05,
                child: RaisedButton(
                  color: Colors.lightBlueAccent,
                  child: const Text('Add Transaction'),
                  textColor: Colors.purple,
                  onPressed: _submitData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
