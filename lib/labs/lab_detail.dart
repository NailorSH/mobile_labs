import 'package:flutter/cupertino.dart';

import '../model/lab.dart';

class LabDetailScreen extends StatelessWidget {
  final Lab lab;

  const LabDetailScreen({super.key, required this.lab});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Лабораторная №${lab.number}'),
        previousPageTitle: 'Назад',
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: <Widget>[
            CupertinoListSection.insetGrouped(
              header: const Text('Информация'),
              children: <Widget>[
                CupertinoListTile(
                  title: Text('Название'),
                  trailing: Text(lab.title),
                ),
                CupertinoListTile(
                  title: Text('Номер работы'),
                  trailing: Text(lab.number.toString()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


