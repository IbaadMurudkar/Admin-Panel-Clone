import 'package:admin_panel/inner_screen/edit_prod.dart';
import 'package:admin_panel/services/utils.dart';
import 'package:admin_panel/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/global_methods.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  String title = '';
  String productCat = '';
  String? imageUrl;
  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPiece = false;


  @override
  void initState() {
    getProductData();
    super.initState();
  }

  Future<void> getProductData() async {

    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      if (productsDoc == null) {
        return;
      } else {
        setState(() {
          title = productsDoc.get('title');
          productCat = productsDoc.get('productCategoryName');
          imageUrl = productsDoc.get('imageUrl');
          price = productsDoc.get('price');
          salePrice = productsDoc.get('salePrice');
          isOnSale = productsDoc.get('isOnSale');
          isPiece = productsDoc.get('isPiece');
        });
      }
    } catch (error) {


      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {

    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.6),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditProductScreen(
                      id: widget.id,
                      title: title,
                      price: price,
                      salePrice: salePrice,
                      productCat: productCat,
                      imageUrl: imageUrl == null
                          ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
                          : imageUrl!,
                      isOnSale: isOnSale,
                      isPiece: isPiece,
                    )));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        flex: 3,
                        child: Image.network(
                          imageUrl == null
                              ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS45JdpeeUDhpp0-3y8ZGfgcQB93k532C0lYQ&usqp=CAU'
                              : imageUrl!,
                          height: size.width * 0.12,
                          fit: BoxFit.fill,
                        )),
                    const Spacer(),
                    PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {},
                                value: 1,
                                child: const Text('Edit'),
                              ),
                              PopupMenuItem(
                                onTap: () {},
                                value: 2,
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ])
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    TextWidget(
                        text: isOnSale
                            ? '\$${salePrice.toStringAsFixed(2)}'
                            : '\$$price',
                        color: color,
                        textSize: 18),
                    const SizedBox(
                      width: 7,
                    ),
                    Visibility(
                        visible: isOnSale,
                        child: Text(
                          "\$$price",
                          style: TextStyle(
                              fontSize: 15,
                              color: color,
                              decoration: TextDecoration.lineThrough),
                        )),
                    const Spacer(),
                    TextWidget(
                        text: isPiece ? 'Piece' : '1KG',
                        color: color,
                        textSize: 18),
                    const SizedBox(
                      height: 2,
                    ),
                  ],
                ),
                TextWidget(
                  text: title,
                  color: color,
                  textSize: 24,
                  isTitle: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
