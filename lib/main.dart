import 'package:flutter/cupertino.dart';

import 'labs/lab1/counter.dart';
import 'labs/lab2/controller.dart';
import 'labs/lab4/lab4_tabs.dart';
import 'labs/lab_detail.dart';
import 'model/lab.dart';

void main() {
  runApp(const LabsApp());
}

class LabsApp extends StatelessWidget {
  const LabsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Лабораторные',
      home: LabsHomeScreen(),
    );
  }
}

class LabsHomeScreen extends StatelessWidget {
  const LabsHomeScreen({super.key});

  List<Lab> _buildLabs() {
    return const <Lab>[
      Lab(number: 1, title: 'Кликер'),
      Lab(number: 2, title: 'Контроллер (iOControl)'),
      Lab(number: 3, title: 'Навигация по лабам'),
      Lab(number: 4, title: 'Animation controller'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<Lab> labs = _buildLabs();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Лабораторные работы'),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: <Widget>[
            CupertinoFormSection.insetGrouped(
              children: <Widget>[
                for (final lab in labs)
                  CupertinoFormRow(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute<void>(
                            builder: (context) {
                              if (lab.number == 1) {
                                return Lab1CounterScreen(lab: lab);
                              }
                              if (lab.number == 2) {
                                return Lab2ControllerScreen(lab: lab);
                              }
                              if (lab.number == 4) {
                                return Lab4TabsScreen(lab: lab);
                              }
                              return LabDetailScreen(lab: lab);
                            },
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Лабораторная ${lab.number} — ${lab.title}'),
                          ),
                          const Icon(CupertinoIcons.right_chevron, size: 20),
                        ],
                      ),
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
