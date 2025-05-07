import 'dart:developer';

import 'package:clublly/main.dart';
import 'package:clublly/utils/colors.dart';
import 'package:clublly/viewmodels/carts_view_model.dart';
import 'package:clublly/viewmodels/order_view_model.dart';
import 'package:clublly/views/pages/order_page.dart';
import 'package:clublly/views/pages/product_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final user = supabase.auth.currentUser;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartViewModel>(
        context,
        listen: false,
      ).fetchCartsByUser(user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, child) {
        return RefreshIndicator(
          onRefresh: () => cartViewModel.fetchCartsByUser(user!.id),
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "YOUR CART",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemCount: cartViewModel.carts.length,
                      itemBuilder: (context, index) {
                        final cart = cartViewModel.carts[index];

                        String? thumbnailUrl;
                        if (cart.product!.thumbnailUrl != null) {
                          thumbnailUrl = supabase.storage
                              .from('products')
                              .getPublicUrl(cart.product!.thumbnailUrl!);
                        } else {
                          thumbnailUrl = null;
                        }

                        String? logoUrl;
                        if (cart.product!.organizationLogo != null) {
                          logoUrl = supabase.storage
                              .from('logos')
                              .getPublicUrl(cart.product!.organizationLogo!);
                        } else {
                          logoUrl = null;
                        }

                        return Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProductPreview(
                                        productId: cart.productId,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          logoUrl!,
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null)
                                              return child;
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
                                              color: Colors.grey[300],
                                              child: Icon(Icons.error),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "${cart.product!.organizationAcronym}",
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          thumbnailUrl!,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null)
                                              return child;
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
                                              color: Colors.grey[300],
                                              child: Icon(Icons.error),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      SizedBox(
                                        height: 100,
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
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(
                                                        context,
                                                      ).width *
                                                      0.5,
                                                  child: Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    cart.product!.name,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 4),

                                                Builder(
                                                  builder: (context) {
                                                    // If no product variant or no option values
                                                    if (cart.productVariant ==
                                                            null ||
                                                        cart
                                                                .productVariant!
                                                                .productVariantOptionValues ==
                                                            null ||
                                                        cart
                                                            .productVariant!
                                                            .productVariantOptionValues!
                                                            .isEmpty) {
                                                      return SizedBox.shrink(); // Return empty widget
                                                    }

                                                    // Get all option values
                                                    final optionValues =
                                                        cart
                                                            .productVariant!
                                                            .productVariantOptionValues!;

                                                    // Build list of variant texts
                                                    List<String> variantTexts =
                                                        [];
                                                    for (var option
                                                        in optionValues) {
                                                      if (option.optionValues !=
                                                          null) {
                                                        variantTexts.add(
                                                          option
                                                              .optionValues
                                                              .value,
                                                        );
                                                      }
                                                    }

                                                    // If no variants to display
                                                    if (variantTexts.isEmpty) {
                                                      return SizedBox.shrink();
                                                    }

                                                    // Join the variant texts with commas or spaces
                                                    return Text(
                                                      variantTexts.join(' / '),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black54,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Text("Qty. ${cart.quantity}"),
                                              ],
                                            ),
                                            Text(
                                              "₱${cart.totalPrice.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.secondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: AppColors.secondary,
                                            ),
                                          ),
                                          onPressed: () {
                                            cartViewModel.deleteCartItem(
                                              cart.id!,
                                              user!.id,
                                            );
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),

                                      Expanded(
                                        flex: 3,
                                        child: FilledButton(
                                          style: FilledButton.styleFrom(
                                            backgroundColor:
                                                AppColors.secondary,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        OrderPage(cart: cart),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.sell),
                                              SizedBox(width: 4),
                                              Text("Check out"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
