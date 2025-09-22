import 'package:flutter/cupertino.dart';
import '../../model/lab.dart';

class Lab1CounterScreen extends StatefulWidget {
  final Lab lab;

  const Lab1CounterScreen({super.key, required this.lab});

  @override
  State<Lab1CounterScreen> createState() => _Lab1CounterScreenState();
}

class _Lab1CounterScreenState extends State<Lab1CounterScreen> {
  int counter = 0;

  void _increment() {
    setState(() {
      counter += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Лабораторная №${widget.lab.number}'),
        previousPageTitle: 'Назад',
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: <Widget>[
            CupertinoFormSection.insetGrouped(
              header: const Text('Счётчик'),
              children: <Widget>[
                CupertinoFormRow(
                  prefix: const Text('Значение'),
                  child: Text(
                    '$counter',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
                CupertinoFormRow(
                  prefix: const Icon(CupertinoIcons.add),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    onPressed: _increment,
                    child: const Text('Увеличить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


