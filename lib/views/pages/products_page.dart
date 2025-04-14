// views/product_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/viewmodels/product_viewmodel.dart';
import '/models/product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);
  
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    // Provide the ViewModel directly in the page
    return ChangeNotifierProvider(
      create: (_) => ProductViewModel()..fetchProducts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
        ),
        body: Consumer<ProductViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (viewModel.errorMessage.isNotEmpty) {
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            }
            
            final products = viewModel.products;
            
            if (products.isEmpty) {
              return const Center(child: Text('No products found'));
            }
            
            return RefreshIndicator(
              onRefresh: () => viewModel.fetchProducts(),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text(product.description),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${product.basePrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('Stock: ${product.baseStock}',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      onTap: () {
                        // Navigate to product details or perform an action
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add action to create a new product
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}