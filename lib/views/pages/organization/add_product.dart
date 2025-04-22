import 'dart:io';

import 'package:clublly/models/category.dart';
import 'package:clublly/services/camera_service.dart';
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
              backgroundColor: Colors.white,
              elevation: 1,
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  productViewModel.buildProduct(
                    _nameController.text,
                    _descriptionController.text,
                    double.parse(_basePriceController.text),
                    int.parse(_baseStockController.text),
                    widget.organizationId,
                    int.parse(_selectedCategory!),
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddProductPreview(),
                    ),
                  );
                },
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
                        'PRODUCT',
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Product Name', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
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
                          border: OutlineInputBorder(),
                          hintText: '100% Cotton; Soft-to-touch; Amazing Color',
                        ),
                      ),
                      SizedBox(height: 12),
                      Text("Category", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
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
                            border: OutlineInputBorder(),
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
                            border: OutlineInputBorder(),
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
                      SizedBox(height: 24),
                      // Text(
                      //   'OPTIONS',
                      //   style: TextStyle(
                      //     color: Colors.black38,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // TextButton(child: Text('Add Sizes'), onPressed: () {}),
                      // TextButton(child: Text('Add Colors'), onPressed: () {}),
                      // SizedBox(height: 24),
                      Text(
                        'IMAGES',
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
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
                        child: ElevatedButton(
                          onPressed:
                              productViewModel.productImages.length >= 10
                                  ? null
                                  : () {
                                    productViewModel.pickProductImages();
                                  },
                          child: Text("Add More"),
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
}
