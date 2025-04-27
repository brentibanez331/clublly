import 'dart:io';

import 'package:clublly/models/category.dart';
import 'package:clublly/models/product_variant.dart';
import 'package:clublly/models/product_variant_data.dart';
import 'package:clublly/services/camera_service.dart';
import 'package:clublly/utils/colors.dart';
import 'package:clublly/viewmodels/category_view_model.dart';
import 'package:clublly/viewmodels/product_viewmodel.dart';
import 'package:clublly/views/pages/organization/add_product_preview.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  final int organizationId;

  const AddProduct({super.key, required this.organizationId});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _basePriceController = TextEditingController();
  final TextEditingController _baseStockController = TextEditingController();
  String? _selectedCategory;

  bool enableSizes = false;
  bool enableColors = false;

  final TextEditingController _newSizeController = TextEditingController();
  final TextEditingController _newColorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<CategoryViewModel, ProductViewModel>(
      builder: (context, categoryViewModel, productViewModel, child) {
        if (categoryViewModel.categories.isEmpty) {
          categoryViewModel.fetchCategories();
        }

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Add Product"),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: () {
                  bool hasVariants = productViewModel.variants.isNotEmpty;

                  productViewModel.buildProduct(
                    _nameController.text,
                    _descriptionController.text,
                    hasVariants ? 0 : double.parse(_basePriceController.text),
                    hasVariants ? 0 : int.parse(_baseStockController.text),
                    widget.organizationId,
                    int.parse(_selectedCategory!),
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddProductPreview(),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
                child: Text('DONE'),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Information',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Please provide all required information to publish your product on Clublly.',
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(height: 12),
                      Text('Product Name', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          // hintText: 'Complete Name',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Organization name is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      Text('Description', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 7,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: '100% Cotton; Soft-to-touch; Amazing Color',
                        ),
                      ),
                      SizedBox(height: 12),
                      Text("Category", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        value: _selectedCategory,
                        items:
                            categoryViewModel.categories.isNotEmpty
                                ? categoryViewModel.categories
                                    .map<DropdownMenuItem<String>>(
                                      (Category category) =>
                                          DropdownMenuItem<String>(
                                            value: category.id.toString(),
                                            child: Text(category.name),
                                          ),
                                    )
                                    .toList()
                                : [
                                  const DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('Loading Categories...'),
                                  ),
                                ],

                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },

                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a category';
                          }

                          return null;
                        },
                      ),

                      // DropdownButtonFormField(items: categoryViewModel.categories.isNotEmpty ? categoryViewModel.categories.map<DropdownMenuItem<String>>(Category category) => DropdownMenuItem<String>(value: category.id), onChanged: onChanged)
                      SizedBox(height: 12),

                      if (!enableSizes && !enableColors) ...[
                        Text('Base Price', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: _basePriceController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value != '') {
                                if (int.parse(value) < 1) {
                                  _baseStockController.text = '1';
                                }
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Organization name is required";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                        Text('Base Quantity', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        SizedBox(
                          width: 100,
                          child: TextFormField(
                            controller: _baseStockController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value != '') {
                                if (int.parse(value) < 1) {
                                  _baseStockController.text = '1';
                                }
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              // hintText: 'Complete Name',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Organization name is required";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],

                      SizedBox(height: 32),
                      Text(
                        'Options',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Adding variants will remove the base price and quantity and require you to add a price and stock for each variant.',
                        style: TextStyle(color: Colors.black54),
                      ),

                      _buildOptionSection(
                        'Size',
                        enableSizes,
                        productViewModel.sizeValues,
                        _newSizeController,
                        () => setState(() => enableSizes = true),
                        (value) {
                          setState(() {
                            productViewModel.addValueToSizes(value);
                            _newSizeController.clear();
                            productViewModel.regenerateVariants(
                              enableSizes,
                              enableColors,
                            );
                          });
                        },
                        (index) {
                          setState(() {
                            productViewModel.removeValueFromSizes(index);
                            productViewModel.regenerateVariants(
                              enableSizes,
                              enableColors,
                            );
                          });
                        },
                        productViewModel.regenerateVariants,
                        productViewModel.clearSizeOrColor,
                      ),

                      if (enableSizes) SizedBox(height: 16),
                      // if (enableSizes) Text("Selections enabled"),
                      _buildOptionSection(
                        'Color',
                        enableColors,
                        productViewModel.colorValues,
                        _newColorController,
                        () => setState(() => enableColors = true),
                        (value) {
                          setState(() {
                            productViewModel.addValueToColors(value);
                            _newColorController.clear();
                            productViewModel.regenerateVariants(
                              enableSizes,
                              enableColors,
                            );
                          });
                        },
                        (index) {
                          setState(() {
                            productViewModel.removeValueFromColors(index);
                            productViewModel.regenerateVariants(
                              enableSizes,
                              enableColors,
                            );
                          });
                        },
                        productViewModel.regenerateVariants,
                        productViewModel.clearSizeOrColor,
                      ),

                      SizedBox(height: 24),

                      if (productViewModel.variants.isNotEmpty) ...[
                        Text(
                          'Variants',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Add custom price and stock for your variants.',
                          style: TextStyle(color: Colors.black54),
                        ),
                        SizedBox(height: 12),
                        _buildVariantsTable(productViewModel.variants),
                      ],

                      SizedBox(height: 32),
                      Text(
                        'IMAGES',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Please upload images of the actual product appearance.',
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(height: 10),
                      Text('Cover Image', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      InkWell(
                        onTap: () {
                          productViewModel.pickThumbnail();
                        },
                        child:
                            productViewModel.thumbnail != null
                                ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(19),
                                      child: Image.file(
                                        productViewModel.thumbnail!,
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black54,
                                        radius: 18,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            productViewModel.clearThumbnail();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : DottedBorder(
                                  dashPattern: [6, 3],
                                  radius: Radius.circular(10),
                                  borderType: BorderType.RRect,
                                  child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.upload),
                                          Text("Upload Thumbnail"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                      ),
                      Text(
                        'This will be the image shown in your product card',
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      ),

                      SizedBox(height: 16),

                      Text('Additional Photos', style: TextStyle(fontSize: 16)),
                      Text(
                        'You can add upto 10 additional images',
                        style: TextStyle(fontSize: 14, color: Colors.black45),
                      ),
                      SizedBox(height: 4),

                      if (productViewModel.productImages.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: productViewModel.productImages.length,
                              itemBuilder: (context, index) {
                                final productImage =
                                    productViewModel.productImages[index];

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          height: 200,
                                          width: 200,
                                          child: Image.file(
                                            File(productImage.path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black54,
                                          radius: 18,
                                          child: Text(
                                            (index + 1).toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black54,
                                          radius: 18,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              productViewModel
                                                  .removeProductImage(index);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                      if (productViewModel.productImages.isNotEmpty)
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "${productViewModel.productImages.length}/10",
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                        ),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.secondary),
                          ),
                          onPressed:
                              productViewModel.productImages.length >= 10
                                  ? null
                                  : () {
                                    productViewModel.pickProductImages();
                                  },
                          child: Text(
                            "Add More",
                            style: TextStyle(color: AppColors.secondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionSection(
    String optionName,
    bool isEnabled,
    List<String> values,
    TextEditingController controller,
    VoidCallback onEnable,
    Function(String) onAdd,
    Function(int) onRemove,
    Function(bool, bool) regenerateVariants,
    Function(String) clearSizeOrColor,
  ) {
    if (!isEnabled) {
      return TextButton(
        onPressed: onEnable,
        child: Text(
          'Add $optionName',
          style: TextStyle(color: AppColors.secondary),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Text(
              '$optionName: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.close, size: 18),
              onPressed: () {
                setState(() {
                  if (optionName == 'Size') {
                    enableSizes = false;
                    // sizeValues.clear();
                    clearSizeOrColor('Size');
                  } else {
                    enableColors = false;
                    clearSizeOrColor('Color');
                  }
                  regenerateVariants(enableSizes, enableColors);
                });
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...values.asMap().entries.map((entry) {
              return InputChip(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: AppColors.secondary.withValues(alpha: 0.05),
                label: Text(entry.value),
                onDeleted: () => onRemove(entry.key),
              );
            }),
            SizedBox(
              width: 120,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  hintText: '${optionName.toLowerCase()}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add, size: 18),
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        onAdd(controller.text);
                      }
                    },
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    onAdd(value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVariantsTable(List<ProductVariantData> variants) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // boxShadow: [
          //   BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 10),
          // ],
        ),
        child: DataTable(
          columnSpacing: 20,

          columns: [
            if (enableSizes) DataColumn(label: Expanded(child: Text('Size'))),
            if (enableColors) DataColumn(label: Expanded(child: Text('Color'))),
            DataColumn(label: Expanded(child: Text('Price'))),
            DataColumn(label: Expanded(child: Text('Stock'))),
          ],
          rows:
              variants.map((variant) {
                return DataRow(
                  // color: if(),
                  cells: [
                    if (enableSizes) DataCell(Text(variant.size ?? '-')),
                    if (enableColors) DataCell(Text(variant.color ?? '-')),
                    DataCell(
                      SizedBox(
                        width: 80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: variant.priceController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: variant.stockController,
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
