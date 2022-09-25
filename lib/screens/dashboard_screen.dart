import 'package:admin_panel/consts/const..dart';
import 'package:admin_panel/controllers/menu_controller.dart';
import 'package:admin_panel/inner_screen/add_prod.dart';
import 'package:admin_panel/services/utils.dart';
import 'package:admin_panel/widgets/buttons.dart';
import 'package:admin_panel/widgets/grid_product_widget.dart';
import 'package:admin_panel/widgets/header.dart';
import 'package:admin_panel/widgets/order_list.dart';
import 'package:admin_panel/widgets/responsive.dart';
import 'package:admin_panel/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;
    final menuProvider = Provider.of<MenuController>(context);
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              fct: () {
                menuProvider.controlDashboardMenu();
              },
              title: 'Dashboard',
            ),
            const SizedBox(
              height: 20,
            ),
            TextWidget(
              text: 'Latest Products',
              color: color, textSize: 18,
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ButtonsWidget(
                      onPressed: () {},
                      text: 'View All',
                      icon: Icons.store,
                      backgroundColor: Colors.blue),
                  const Spacer(),
                  ButtonsWidget(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadProductForm(),
                          ),
                        );
                      },
                      text: 'Add product',
                      icon: Icons.add,
                      backgroundColor: Colors.blue),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // flex: 5,
                  child: Column(
                    children: [
                      Responsive(
                        mobile: ProductsGrid(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                          size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                        ),
                        desktop: ProductsGrid(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                        ),
                      ),
                      OrderList(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}