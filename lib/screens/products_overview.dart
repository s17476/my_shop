import 'package:flutter/material.dart';
import 'package:my_shop/models/product.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/widgets/product_grid.dart';
import 'package:my_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => const [
                    PopupMenuItem(
                      child: Text('Only Favorites'),
                      value: FilterOptions.favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.all,
                    ),
                  ])
        ],
      ),
      body: ProductsGrid(
        showFavorites: _showOnlyFavorites,
      ),
    );
  }
}
