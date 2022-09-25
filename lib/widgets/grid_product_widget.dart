import 'package:admin_panel/services/utils.dart';
import 'package:admin_panel/widgets/products_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../consts/const..dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid(
      {Key? key,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1,
      this.isInMain = true})
      : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;
  // snapshot.data!.docs.isEmpty
  final bool isInMain;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('Your store is empty'),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            );
          }
        }
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: isInMain && snapshot.data!.docs.length > 4
                ? 4
                : snapshot.data!.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
            ),
            itemBuilder: (context, index) {
              return ProductsWidget(id: snapshot.data!.docs[index]['id']);
            });
      },
    );
  }
}
