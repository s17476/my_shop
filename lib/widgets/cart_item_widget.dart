import 'package:flutter/material.dart';
import 'package:my_shop/models/cart_item.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(cartItem.product.id);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Douou want to remove the item from the cart?'),
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
        );
      },
      key: ValueKey(cartItem.id),
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).errorColor,
          border: Border.all(
            color: Theme.of(context).errorColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(3),
          ),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(cartItem.product.imageUrl),
            ),
            title: Text(cartItem.product.title),
            subtitle:
                Text('Total: \$${cartItem.product.price * cartItem.quantity}'),
            trailing:
                Text('\$${cartItem.product.price}  x  ${cartItem.quantity}'),
          ),
        ),
      ),
    );
  }
}
