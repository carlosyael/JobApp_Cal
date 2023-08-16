import 'package:flutter/material.dart';
import 'LiquidacionTab.dart';
import 'RegaliasTab.dart';
import 'RetencionesTab.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Employee Calculator'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Sueldo Navidad'),
              Tab(text: 'Liquidación'),
              Tab(text: 'Retenciones'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RegaliasTab(),
            LiquidacionTab(),
            RetencionesTab(),
          ],
        ),
      ),
    );
  }
}
