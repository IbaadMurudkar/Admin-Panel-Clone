import 'package:admin_panel/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/menu_controller.dart';
import '../services/utils.dart';
import '../widgets/grid_product_widget.dart';
import '../widgets/responsive.dart';
import '../widgets/side_menu.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<MenuController>().getGridScaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            const Expanded(
              child: SideMenu(),
            ),
          Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Header(
                        title: 'AllProductsScreen',
                        fct: () {
                          context
                              .read<MenuController>()
                              .controlProductsMenu();
                        }),
                    Responsive(
                        mobile: ProductsGrid(
                            crossAxisCount: size.width < 700 ? 2 : 4,
                            childAspectRatio:
                                size.width < 700 && size.width > 350
                                    ? 1.1
                                    : 0.8),
                        desktop: ProductsGrid(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                        )),
                  ],
                ),
              ))
        ],
      )),
    );
  }
}
