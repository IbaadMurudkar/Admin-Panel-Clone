import 'package:admin_panel/controllers/menu_controller.dart';
import 'package:admin_panel/screens/dashboard_screen.dart';
import 'package:admin_panel/widgets/responsive.dart';
import 'package:admin_panel/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().getScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: SideMenu(),
            ),
          const Expanded(flex: 5, child: DashboardScreen())
        ],
      )),
    );
  }
}
