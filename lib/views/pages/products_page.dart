// views/product_page.dart
import 'package:clublly/main.dart';
import 'package:clublly/utils/colors.dart';
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, productViewModel, child) {
        if (productViewModel.products.isEmpty) {
          productViewModel.fetchProducts();
        }

        return Scaffold(
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
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
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
          body: RefreshIndicator(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (productViewModel.isLoadingAllProducts)
                    const Center(child: CircularProgressIndicator())
                  else if (productViewModel.errorMessage.isNotEmpty)
                    Center(child: Text(productViewModel.errorMessage))
                  else if (productViewModel.products.isEmpty)
                    Center(child: Text('No products found'))
                  else ...[
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.57,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: productViewModel.products.length,
                        itemBuilder: (context, index) {
                          final product = productViewModel.products[index];

                          String? imageUrl;
                          if (product.thumbnailUrl != null) {
                            imageUrl = supabase.storage
                                .from('products')
                                .getPublicUrl(product.thumbnailUrl!);
                          } else {
                            imageUrl = null;
                          }

                          String? logoUrl;
                          if (product.organizationLogo != null) {
                            logoUrl = supabase.storage
                                .from('logos')
                                .getPublicUrl(product.organizationLogo!);
                          } else {
                            logoUrl = null;
                          }

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageUrl!,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 180,
                                        width: double.infinity,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                          ),
                                        ),
                                      );
                                    },

                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 180,
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.error),
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 8.0,
                                    ),
                                    child: SizedBox(
                                      height: 76,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.name,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ClipOval(
                                                    child: Image.network(
                                                      width: 20,
                                                      height: 20,
                                                      logoUrl!,
                                                      loadingBuilder: (
                                                        context,
                                                        child,
                                                        loadingProgress,
                                                      ) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        return Center(
                                                          child: CircularProgressIndicator(
                                                            value:
                                                                loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                            .cumulativeBytesLoaded /
                                                                        loadingProgress
                                                                            .expectedTotalBytes!
                                                                    : null,
                                                          ),
                                                        );
                                                      },

                                                      errorBuilder: (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          height: 100,
                                                          width: 100,
                                                          color:
                                                              Colors.grey[300],
                                                          child: Icon(
                                                            Icons.error,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    product
                                                        .organizationAcronym!,
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "₱ ${product.basePrice.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.secondary,
                                                ),
                                              ),
                                              Text(
                                                '78 sold',
                                                style: TextStyle(fontSize: 12),
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
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            onRefresh: () => productViewModel.fetchProducts(),
          ),
        );
      },
    );
  }
}

  //   return ChangeNotifierProvider(
  //     create: (_) => ProductViewModel()..fetchProducts(),
  //     child: Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Colors.white,
  //         elevation: 1, // Small elevation for subtle shadow
  //         titleSpacing: 0, // Reduce space to fit search bar
  //         title: Row(
  //           children: [
  //             const Padding(
  //               padding: EdgeInsets.only(left: 16.0),
  //               child: Text(
  //                 'Shop',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(
  //                   vertical: 8.0,
  //                   horizontal: 4.0,
  //                 ),
  //                 child: Container(
  //                   height: 40,
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[100],
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                   child: TextField(
  //                     decoration: InputDecoration(
  //                       hintText: 'Search products...',
  //                       hintStyle: TextStyle(color: Colors.grey[400]),
  //                       prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
  //                       border: InputBorder.none,
  //                       contentPadding: const EdgeInsets.symmetric(
  //                         vertical: 10.0,
  //                       ),
  //                     ),
  //                     onChanged: (value) {
  //                       // Implement search functionality
  //                       // You could add this to your view model
  //                     },
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 8),
  //           ],
  //         ),
  //         actions: [
  //           IconButton(
  //             icon: const Icon(Icons.filter_list, color: Colors.black87),
  //             onPressed: () {
  //               // Handle filter action
  //             },
  //           ),
  //         ],
  //       ),
  //       body: Consumer<ProductViewModel>(
  //         builder: (context, viewModel, _) {
  //           if (viewModel.isLoading) {
  //             return const Center(child: CircularProgressIndicator());
  //           }

  //           if (viewModel.errorMessage.isNotEmpty) {
  //             return Center(child: Text('Error: ${viewModel.errorMessage}'));
  //           }

  //           final products =
  //               viewModel.products.map((product) {
  //                 // Override imagePath for testing
  //                 // product.thumbnailUrl = 'assets/images/imgrandom_5.png';
  //                 return product;
  //               }).toList();

  //           if (products.isEmpty) {
  //             return const Center(child: Text('No products found'));
  //           }

  //           return RefreshIndicator(
  //             onRefresh: () => viewModel.fetchProducts(),
  //             child: GridView.builder(
  //               padding: const EdgeInsets.all(8),
  //               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 2,
  //                 childAspectRatio: 0.75,
  //                 crossAxisSpacing: 8,
  //                 mainAxisSpacing: 8,
  //               ),
  //               itemCount: products.length,
  //               itemBuilder: (context, index) {
  //                 final product = products[index];
  //                 return _buildProductContainer(context, product);
  //               },
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildProductContainer(BuildContext context, Product product) {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => FirstProductPage(product: product),
  //         ),
  //       );
  //     },
  //     borderRadius: BorderRadius.circular(
  //       10,
  //     ), // Match the container's border radius
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(
  //           10,
  //         ), // Increased border radius for more rounded edges
  //         border: Border.all(color: Colors.grey.shade200),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Image container with rounded top edges
  //           ClipRRect(
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(10),
  //               topRight: Radius.circular(10),
  //             ),
  //             child: Container(
  //               height: 150,
  //               width: double.infinity,
  //               decoration: const BoxDecoration(color: Colors.grey),
  //               // child:
  //               // _buildProductImage(product),
  //             ),
  //           ),

  //           // Product details container
  //           Expanded(
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Product name
  //                   Text(
  //                     product.name,
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 14,
  //                     ),
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),

  //                   const Spacer(),

  //                   // Price
  //                   Text(
  //                     '\$${product.basePrice.toStringAsFixed(2)}',
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 16,
  //                       color: Colors.green,
  //                     ),
  //                   ),

  //                   // Stock indicator
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 8,
  //                         height: 8,
  //                         decoration: BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           color:
  //                               product.baseStock > 0
  //                                   ? Colors.green
  //                                   : Colors.red,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 4),
  //                       Text(
  //                         product.baseStock > 0
  //                             ? 'In stock: ${product.baseStock}'
  //                             : 'Out of stock',
  //                         style: TextStyle(
  //                           fontSize: 12,
  //                           color:
  //                               product.baseStock > 0
  //                                   ? Colors.black54
  //                                   : Colors.red,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // // Widget _buildProductImage(Product product) {
  // //   if (product.imagePath != null && product.imagePath!.isNotEmpty) {
  // //     if (product.imagePath!.startsWith('http')) {
  // //       // Load from network if it's a URL
  // //       return Image.network(
  // //         product.imagePath!,
  // //         fit: BoxFit.cover,
  // //         width: double.infinity,
  // //         errorBuilder: (context, error, stackTrace) {
  // //           return _buildPlaceholderImage();
  // //         },
  // //       );
  // //     } else if (product.imagePath!.startsWith('assets/')) {
  // //       // Load from assets folder
  // //       return Image.asset(
  // //         product.imagePath!,
  // //         fit: BoxFit.cover,
  // //         width: double.infinity,
  // //         errorBuilder: (context, error, stackTrace) {
  // //           return _buildPlaceholderImage();
  // //         },
  // //       );
  // //     }
  // //   }
  // //   return _buildPlaceholderImage();
  // // }

  // Widget _buildPlaceholderImage() {
  //   return Container(
  //     color: Colors.grey[300],
  //     child: Center(
  //       child: Icon(Icons.image, size: 50, color: Colors.grey[500]),
  //     ),
  //   );
  // }
