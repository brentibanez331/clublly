import 'dart:convert';
import 'dart:developer';

import 'package:clublly/utils/colors.dart';
import 'package:clublly/viewmodels/product_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductPreview extends StatefulWidget {
  const AddProductPreview({Key? key}) : super(key: key);

  @override
  _AddProductPreviewState createState() => _AddProductPreviewState();
}

class _AddProductPreviewState extends State<AddProductPreview> {
  String? selectedSize;
  String? selectedColor;
  double? displayPrice;
  bool? hasVariants;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, productViewModel, child) {
        if (selectedSize == null && productViewModel.sizeValues.isNotEmpty) {
          selectedSize = productViewModel.sizeValues[0];
        }

        hasVariants = productViewModel.variants.isNotEmpty;

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
                            width: MediaQuery.sizeOf(context).width,
                            child: Image.file(
                              productViewModel.thumbnail!,
                              fit: BoxFit.cover,
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
                                    productViewModel.productToAdd!.name,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 50),
                                Text(
                                  "₱${hasVariants! ? getDisplayPrice(productViewModel) : productViewModel.productToAdd!.basePrice.toStringAsFixed(2)}",
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
                            Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(productViewModel.productToAdd!.description),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      "This is a preview of your product to customers",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black87),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Back to Edit",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.black87,
                            ),
                            onPressed: () async {
                              // productViewModel.dummyFunc();
                              await productViewModel.addProduct();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text("CONFIRM"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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

  String getDisplayPrice(ProductViewModel productViewModel) {
    if (!hasVariants!) {
      return productViewModel.productToAdd!.basePrice.toStringAsFixed(2);
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
    return (viewModel.productToAdd?.basePrice ?? 0.0) as double;
  }

  return lowestPrice;
}
