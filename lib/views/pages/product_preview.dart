import 'dart:developer';

import 'package:clublly/main.dart';
import 'package:clublly/models/carts.dart';
import 'package:clublly/models/organization.dart';
import 'package:clublly/models/product.dart';
import 'package:clublly/utils/colors.dart';
import 'package:clublly/viewmodels/carts_view_model.dart';
import 'package:clublly/viewmodels/organization_view_model.dart';
import 'package:clublly/viewmodels/product_viewmodel.dart';
import 'package:clublly/views/pages/organization/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPreview extends StatefulWidget {
  final int productId;

  const ProductPreview({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductPreviewState createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> {
  String? selectedSize;
  String? selectedColor;
  double? displayPrice;
  bool? hasVariants;
  bool? ownedByUser;

  int orderQuantity = 1;

  @override
  void initState() {
    super.initState();
    // Fetch the product when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductViewModel>(
        context,
        listen: false,
      ).fetchSingleProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProductViewModel, OrganizationViewModel, CartViewModel>(
      builder: (
        context,
        productViewModel,
        organizationViewModel,
        cartViewModel,
        child,
      ) {
        if (productViewModel.isLoadingSelectedProduct) {
          log("Product is Loading");
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (productViewModel.selectedProduct == null) {
          log("Product is not found");
          return const Center(child: Text('Product not found'));
        }

        // Cause of error
        // if (productViewModel.selectedProduct == null) {
        //   log("Fetching product");
        //   productViewModel.fetchSingleProduct(widget.productId);
        // }

        if (selectedSize == null && productViewModel.sizeValues.isNotEmpty) {
          selectedSize = productViewModel.sizeValues[0];
        }

        final Product product = productViewModel.selectedProduct!;

        String? logoUrl;
        if (product.organizationLogo != null) {
          logoUrl = supabase.storage
              .from('logos')
              .getPublicUrl(product.organizationLogo!);
        } else {
          logoUrl = null;
        }

        hasVariants = productViewModel.variants.isNotEmpty;
        ownedByUser = checkProductBelongsToUser(
          product.organizationId,
          organizationViewModel.organizations,
        );

        String? thumbnailUrl;
        if (product.thumbnailUrl!.isNotEmpty) {
          thumbnailUrl = supabase.storage
              .from('products')
              .getPublicUrl(product.thumbnailUrl!);
        } else {
          thumbnailUrl = null;
        }

        List<String> otherImagesUrl = [];
        if (product.additionalImages != null) {
          for (var img in product.additionalImages!) {
            final imgUrl = supabase.storage.from('products').getPublicUrl(img);

            otherImagesUrl.add(imgUrl);
          }
        }

        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).width * 1.15,
                            width: double.infinity,

                            // Replace this with carousel
                            child: Image.network(
                              thumbnailUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                  ),
                                );
                              },

                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 100,
                                  width: 100,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.error),
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 46),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(
                                  8,
                                ), // Adjust padding as needed
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.black45,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    productViewModel.selectedProduct!.name,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 50),
                                Text(
                                  "₱${hasVariants! ? getDisplayPrice(productViewModel) : productViewModel.selectedProduct!.basePrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            if (productViewModel.sizeValues.isNotEmpty) ...[
                              SizedBox(height: 24),
                              Text(
                                "Size",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Wrap(
                                spacing: 5,
                                children: [
                                  ...productViewModel.sizeValues
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                        return ChoiceChip(
                                          backgroundColor: AppColors.secondary
                                              .withValues(alpha: 0.05),
                                          selectedColor: AppColors.secondary
                                              .withValues(alpha: 0.2),
                                          label: Text(entry.value),
                                          selected: entry.value == selectedSize,
                                          onSelected: (bool selected) {
                                            setState(() {
                                              selectedSize =
                                                  selected ? entry.value : null;
                                            });
                                          },
                                        );
                                      }),
                                ],
                              ),
                            ],

                            if (productViewModel.colorValues.isNotEmpty) ...[
                              SizedBox(height: 16),
                              Text(
                                "Colors",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Wrap(
                                spacing: 5,
                                children: [
                                  ...productViewModel.colorValues
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                        final bool
                                        isEnabled = checkStockForColor(
                                          productViewModel,
                                          entry.value,
                                          selectedSize, // Consider selected size if available
                                        );

                                        return ChoiceChip(
                                          label: Text(entry.value),
                                          selected:
                                              entry.value == selectedColor,
                                          onSelected:
                                              !isEnabled
                                                  ? null
                                                  : (bool selected) {
                                                    setState(() {
                                                      selectedColor =
                                                          selected
                                                              ? entry.value
                                                              : null;
                                                    });
                                                  },
                                        );
                                      }),
                                ],
                              ),
                            ],
                            SizedBox(height: 24),

                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipOval(
                                        child: Image.network(
                                          width: 40,
                                          height: 40,
                                          logoUrl!,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null) {
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
                                              height: 40,
                                              width: 40,
                                              color: Colors.grey[300],
                                              child: Icon(Icons.error),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8),

                                      SizedBox(
                                        height: 39,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width:
                                                  MediaQuery.sizeOf(
                                                    context,
                                                  ).width *
                                                  0.4,
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                product.organizationName!,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  height: 1,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              product.organizationAcronym!,
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    child: Text(
                                      "View Shop",

                                      style: TextStyle(
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 12),

                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    productViewModel
                                        .selectedProduct!
                                        .description,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child:
                      !ownedByUser!
                          ? Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: OutlinedButton(
                                  onPressed: () {
                                    orderQuantity = 1;

                                    showAddCartDialog(
                                      productViewModel,
                                      cartViewModel,
                                      thumbnailUrl!,
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        color: AppColors.secondary,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Add to cart",
                                        style: TextStyle(
                                          color: AppColors.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: FilledButton(
                                  onPressed: () {},
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                  ),
                                  child: Text("BUY NOW"),
                                ),
                              ),
                            ],
                          )
                          : FilledButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          EditProduct(product: product),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                            ),
                            child: Text("Edit Product"),
                          ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showAddCartDialog(
    ProductViewModel productViewModel,
    CartViewModel cartViewModel,
    String thumbnailUrl,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            thumbnailUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₱ ${hasVariants! ? getDisplayPrice(productViewModel) : productViewModel.selectedProduct!.basePrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            // Display stock here
                            Text(
                              "Stock: ${hasVariants! ? getDisplayStock(productViewModel) : productViewModel.selectedProduct!.baseStock.toString()}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Quantity"),
                        Row(
                          children: [
                            IconButton.outlined(
                              style: IconButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (orderQuantity > 1) {
                                  setState(() {
                                    orderQuantity -= 1;
                                  });
                                }
                              },
                              icon: Icon(Icons.remove),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                orderQuantity.toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            IconButton.outlined(
                              style: IconButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                final stockString =
                                    hasVariants!
                                        ? getDisplayStock(productViewModel)
                                        : productViewModel
                                            .selectedProduct!
                                            .baseStock
                                            .toString();
                                final stock = int.parse(stockString);
                                if (orderQuantity < stock) {
                                  setState(() {
                                    orderQuantity += 1;
                                  });
                                }
                              },
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                        ),
                        onPressed: () {
                          final priceString =
                              hasVariants!
                                  ? getDisplayPrice(productViewModel)
                                  : productViewModel.selectedProduct!.basePrice
                                      .toStringAsFixed(2);

                          final price = double.parse(priceString);

                          final variantId = getVariantId(productViewModel);

                          final user = supabase.auth.currentUser;
                          final userId = user?.id;
                          if (userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Session expired. Login again"),
                              ),
                            );
                            return;
                          }

                          final cart = Carts(
                            id: variantId,
                            userId: userId,
                            productId: productViewModel.selectedProduct!.id!,
                            productVariantId: hasVariants! ? variantId : null,
                            quantity: orderQuantity,
                            totalPrice: orderQuantity * price,
                          );
                          cartViewModel.addToCart(cart);

                          Navigator.of(context).pop();
                        },
                        child: Text("Add to Cart"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool checkProductBelongsToUser(
    int organizationId,
    List<Organization> organizations,
  ) {
    return organizations.any((org) => org.id == organizationId);
  }

  bool checkStockForSize(
    ProductViewModel productViewModel,
    String size,
    String? color,
  ) {
    for (var variant in productViewModel.variants) {
      if (variant.size == size &&
          (color == null ||
              variant.color ==
                  color) && // Color check or ignore if color is null
          int.tryParse(variant.stockController.text) != 0) {
        return true;
      }
    }
    return false;
  }

  bool checkStockForColor(
    ProductViewModel productViewModel,
    String color,
    String? size,
  ) {
    for (var variant in productViewModel.variants) {
      if (variant.color == color &&
          (size == null ||
              variant.size == size) && // Size check or ignore if size is null
          int.tryParse(variant.stockController.text) != 0) {
        return true;
      }
    }
    return false;
  }

  int getVariantId(ProductViewModel productViewModel) {
    if (!hasVariants!) {
      return 0;
    }

    if (selectedSize != null && selectedColor != null) {
      for (var variant in productViewModel.variants) {
        if (variant.size == selectedSize && variant.color == selectedColor) {
          return variant.id!;
        }
      }
      return 0; // Or handle the case where no matching variant is found
    } else if (selectedSize != null) {
      for (var variant in productViewModel.variants) {
        if (variant.size == selectedSize) {
          return variant.id!; // return the first matching ID
        }
      }
      return 0; // Or handle the case appropriately
    } else if (selectedColor != null) {
      for (var variant in productViewModel.variants) {
        if (variant.color == selectedColor) {
          return variant.id!; // return the first matching ID
        }
      }
      return 0;
    }

    return 0;
  }

  String getDisplayPrice(ProductViewModel productViewModel) {
    if (!hasVariants!) {
      return productViewModel.selectedProduct!.basePrice.toStringAsFixed(2);
    }

    // If both size and color are selected, find that specific variant
    if (selectedSize != null && selectedColor != null) {
      for (var variant in productViewModel.variants) {
        if (variant.size == selectedSize && variant.color == selectedColor) {
          return double.tryParse(
            variant.priceController.text,
          )!.toStringAsFixed(2);
        }
      }
    }
    // If only size is selected, find lowest price for that size
    else if (selectedSize != null) {
      double lowestPrice = double.infinity;
      for (var variant in productViewModel.variants) {
        if (variant.size == selectedSize) {
          double price =
              double.tryParse(variant.priceController.text) ?? double.infinity;
          if (price < lowestPrice) {
            lowestPrice = price;
          }
        }
      }
      if (lowestPrice != double.infinity) {
        return lowestPrice.toStringAsFixed(2);
      }
    }
    // If only color is selected, find lowest price for that color
    else if (selectedColor != null) {
      double lowestPrice = double.infinity;
      for (var variant in productViewModel.variants) {
        if (variant.color == selectedColor) {
          double price =
              double.tryParse(variant.priceController.text) ?? double.infinity;
          if (price < lowestPrice) {
            lowestPrice = price;
          }
        }
      }
      if (lowestPrice != double.infinity) {
        return lowestPrice.toStringAsFixed(2);
      }
    }

    // If nothing is selected or no matching variant, find overall lowest price
    return findLowestPriceVariant(productViewModel).toStringAsFixed(2);
  }

  String getDisplayStock(ProductViewModel productViewModel) {
    if (!hasVariants!) {
      return productViewModel.selectedProduct!.baseStock.toString();
    }

    // If both size and color are selected, find that specific variant
    if (selectedSize != null && selectedColor != null) {
      for (var variant in productViewModel.variants) {
        if (variant.size == selectedSize && variant.color == selectedColor) {
          return int.tryParse(variant.stockController.text)!.toString();
        }
      }
    } else if (selectedSize != null) {
      int lowestStock = 9999;
      for (var variant in productViewModel.variants) {
        if (variant.size == selectedSize) {
          int stock = int.tryParse(variant.stockController.text) ?? 0;
          if (stock < lowestStock) {
            lowestStock = stock;
          }
        }
      }
      if (lowestStock != double.infinity) {
        return lowestStock.toString();
      }
    }
    // If only color is selected, find lowest price for that color
    else if (selectedColor != null) {
      int lowestStock = 9999;
      for (var variant in productViewModel.variants) {
        if (variant.color == selectedColor) {
          int stock = int.tryParse(variant.priceController.text) ?? 0;
          if (stock < lowestStock) {
            lowestStock = stock;
          }
        }
      }
      if (lowestStock != double.infinity) {
        return lowestStock.toString();
      }
    }

    // If nothing is selected or no matching variant, find overall lowest price
    return "0";
  }
}

double findLowestPriceVariant(ProductViewModel viewModel) {
  double lowestPrice = double.infinity;

  for (var variant in viewModel.variants) {
    double price =
        double.tryParse(variant.priceController.text) ?? double.infinity;
    if (price < lowestPrice) {
      lowestPrice = price;
    }
  }

  // If no variants or all had parsing issues, return base price
  if (lowestPrice == double.infinity) {
    return (viewModel.selectedProduct?.basePrice ?? 0.0) as double;
  }

  return lowestPrice;
}
