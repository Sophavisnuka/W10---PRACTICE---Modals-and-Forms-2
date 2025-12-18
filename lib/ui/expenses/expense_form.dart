import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category selectedCategory = Category.food;
  DateTime? selectedDate;

  @override
  void dispose(){
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  void onCreate() {
    //  1 Build an expense
    String title = _titleController.text;
    double amount = double.tryParse(_amountController.text) ?? 0;
    if (title.isEmpty) {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text('Invalid input'),
          content: Text('Please input title and amount'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Back')
            ),
          ],
        )
      );
      return;
    }
    // // ignore: unused_local_variable
    Expense newExpense = Expense(
      title: title, 
      amount: amount, 
      date: selectedDate ?? DateTime.now(), 
      category: selectedCategory);
    // TODO YOUR CODE HERE
    Navigator.of(context).pop(newExpense);
  }
  
  void onCancel() {
    // Close the modal
    Navigator.pop(context);
  }
  Future<void> dateTimePicker() async {
    final DateTime? pickDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );   
    setState(() {
      selectedDate = pickDate;
    });
  }
  String get formattedDate {
    if (selectedDate == null) {
      return 'No date selected';
    }
    return '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(label: Text("Title")),
            maxLength: 50,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    label: Text("Amount"),
                    prefixText: '\$ ',
                  ),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  maxLength: 50,
                ),
              ),
              Spacer(),
              Text(
                formattedDate, style: TextStyle(fontSize: 15),
              ),
              IconButton(
                onPressed: dateTimePicker,
                icon: Icon(Icons.calendar_month),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<Category>(
                value: selectedCategory, 
                underline: SizedBox(),
                items: [
                  for(var item in Category.values)
                    DropdownMenuItem(
                      value: item,
                      child: Text(item.name),
                    )
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                }
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: onCancel, child: Text("Cancel")),
                  SizedBox(width: 20),
                  ElevatedButton(onPressed: onCreate, child: Text("Save Expenses")),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
