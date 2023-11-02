import 'package:flutter/material.dart';

import 'package:expense_tracker/model/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, this.onTapExpenseItem, {super.key});

  final Expense expense;
  final void Function(Expense) onTapExpenseItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapExpenseItem(expense);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('\$${expense.amount.toStringAsFixed(2)}'),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(categoryIcons[expense.category]),
                      const SizedBox(width: 8),
                      Text(expense.formattedDate),
                    ],
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
