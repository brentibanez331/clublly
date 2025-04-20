// views/product_page.dart
import 'package:clublly/views/pages/single_product_page.dart';
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
    return ChangeNotifierProvider(
      create: (_) => ProductViewModel()..fetchProducts(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1, // Small elevation for subtle shadow
          titleSpacing: 0, // Reduce space to fit search bar
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'Shop',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                      ),
                      onChanged: (value) {
                        // Implement search functionality
                        // You could add this to your view model
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.black87),
              onPressed: () {
                // Handle filter action
              },
            ),
          ],
        ),
        body: Consumer<ProductViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.errorMessage.isNotEmpty) {
              return Center(child: Text('Error: ${viewModel.errorMessage}'));
            }

            final products =
                viewModel.products.map((product) {
                  // Override imagePath for testing
                  product.imagePath = 'assets/images/imgrandom_5.png';
                  return product;
                }).toList();

            if (products.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            return RefreshIndicator(
              onRefresh: () => viewModel.fetchProducts(),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductContainer(context, product);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductContainer(BuildContext context, Product product) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SingleProductPage(product: product),
          ),
        );
      },
      borderRadius: BorderRadius.circular(
        10,
      ), // Match the container's border radius
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10,
          ), // Increased border radius for more rounded edges
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container with rounded top edges
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.grey),
                child: _buildProductImage(product),
              ),
            ),

            // Product details container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Price
                    Text(
                      '\$${product.basePrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),

                    // Stock indicator
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                product.baseStock > 0
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.baseStock > 0
                              ? 'In stock: ${product.baseStock}'
                              : 'Out of stock',
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                product.baseStock > 0
                                    ? Colors.black54
                                    : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    if (product.imagePath != null && product.imagePath!.isNotEmpty) {
      if (product.imagePath!.startsWith('http')) {
        // Load from network if it's a URL
        return Image.network(
          product.imagePath!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage();
          },
        );
      } else if (product.imagePath!.startsWith('assets/')) {
        // Load from assets folder
        return Image.asset(
          product.imagePath!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage();
          },
        );
      }
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(Icons.image, size: 50, color: Colors.grey[500]),
      ),
    );
  }
}
