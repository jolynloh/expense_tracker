import 'package:flutter/material.dart';

import 'package:expense_tracker/model/expense.dart';

class NewEditExpense extends StatefulWidget {
  const NewEditExpense(
      {super.key,
      this.onSaveExpense,
      this.onEditExpense,
      this.expenseToEdit,
      this.expenseToEditIndex});

  final void Function(Expense)? onSaveExpense;
  final void Function(Expense, int)? onEditExpense;
  final Expense? expenseToEdit;
  final int? expenseToEditIndex;

  @override
  State<NewEditExpense> createState() {
    return _NewEditExpenseState();
  }
}

class _NewEditExpenseState extends State<NewEditExpense> {
  TextEditingController? _titleController;
  TextEditingController? _amountController;
  DateTime? _selectedDate;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expenseToEdit?.title);
    _amountController = TextEditingController(text: widget.expenseToEdit?.amount.toString());
    _selectedDate = widget.expenseToEdit?.date;
    _selectedCategory = widget.expenseToEdit == null ? Category.leisure : widget.expenseToEdit!.category;
  }

  @override
  void dispose() {
    _titleController!.dispose();
    _amountController!.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController!.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController!.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    if (widget.onSaveExpense != null) {
      widget.onSaveExpense!(
        Expense(
          title: _titleController!.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory!,
        ),
      );
    } else if (widget.onEditExpense != null) {
      widget.onEditExpense!(
        Expense(
          title: _titleController!.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory!,
        ),
        widget.expenseToEditIndex!,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '\$ ',
                        label: Text('Amount'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : formatter.format(_selectedDate!),
                        ),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitExpenseData,
                    child: const Text('Save Expense'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
