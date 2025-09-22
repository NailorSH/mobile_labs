import 'package:flutter/cupertino.dart';
import 'package:lab4/model/lab.dart';
import 'demo.dart';
import 'variant.dart';

class Lab4TabsScreen extends StatelessWidget {
  final Lab lab;

  const Lab4TabsScreen({super.key, required this.lab});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.play_circle),
            label: 'Demo',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_stack_3d_up),
            label: 'Variant',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const Lab4DemoScreen();
          case 1:
            return const Lab4VariantScreen();
          default:
            return const Lab4DemoScreen();
        }
      },
    );
  }
}


