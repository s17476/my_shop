import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(
                  EditProduct.routeName,
                  arguments: product,
                )
                    .then(
                  (value) {
                    if (value != null) {
                      final editedProductTitle = (value as Product).title;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$editedProductTitle edited.',
                          ),
                        ),
                      );
                    }
                  },
                );
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                var confirm = showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text(
                      'Douou want to remove the item from the list?',
                    ),
                    elevation: 5,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text(
                          'No',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ).then((value) {
                  if (value) {
                    Provider.of<Products>(context, listen: false)
                        .deleteProduct(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('${product.title} is removed from the list.'),
                      ),
                    );
                  }
                });
              },
              icon: const Icon(
                Icons.delete,
              ),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
