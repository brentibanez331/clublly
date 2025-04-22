import 'package:clublly/models/product.dart';
import 'package:flutter/material.dart';

class FirstProductPage extends StatefulWidget {
  final Product product;

  const FirstProductPage({super.key, required this.product});

  @override
  _FirstProductPageState createState() => _FirstProductPageState();
}

class _FirstProductPageState extends State<FirstProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           // Product Image with overlayed back button
            Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    double size = constraints.maxWidth; 

                    return Container(
                      height: size,
                      width: size,
                      color: Colors.grey[200],
                      child: _buildProductImage(widget.product),
                    );
                  },
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Price
                  Text(
                    '\₱${widget.product.basePrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Description Text
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Description",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //Product name
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),
                  
                  // Description 
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Seller (Organization) Information
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.store, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Seller: ${widget.product.organizationName ?? "Organization #${widget.product.organizationId}"}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
     bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.transparent, 
          border: Border(), 
          boxShadow: [], 
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Buy Now logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, 
                  foregroundColor: const Color.fromARGB(209, 156, 156, 156),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Buy Now'),
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
        return Image.network(
          product.imagePath!,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage();
          },
        );
      } else if (product.imagePath!.startsWith('assets/')) {
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
        child: Icon(Icons.image, size: 80, color: Colors.grey[500]),
      ),
    );
  }
}
