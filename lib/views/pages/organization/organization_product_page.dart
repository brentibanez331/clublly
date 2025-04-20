// organization_product_page.dart
import 'package:clublly/models/product.dart';
import 'package:clublly/viewmodels/product_viewmodel.dart';
import 'package:clublly/views/pages/organization/add_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationProductPage extends StatefulWidget {
  final int organizationId;

  const OrganizationProductPage({Key? key, required this.organizationId})
    : super(key: key);

  @override
  _OrganizationProductPageState createState() =>
      _OrganizationProductPageState();
}

class _OrganizationProductPageState extends State<OrganizationProductPage> {
  @override
  void initState() {
    super.initState();
    // Fetch products when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductViewModel>(
        context,
        listen: false,
      ).fetchProductsByOrganization(widget.organizationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder: (context, productViewModel, child) {
        return Scaffold(
          body: Column(
            children: [
              if (productViewModel.isLoadingOrganizationProducts)
                const Center(child: CircularProgressIndicator())
              else if (productViewModel.errorMessage.isNotEmpty)
                Center(child: Text(productViewModel.errorMessage))
              else if (productViewModel.organizationProducts.isEmpty)
                const Center(
                  child: Text("No products found for this organization"),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: productViewModel.organizationProducts.length,
                    itemBuilder: (context, index) {
                      final product =
                          productViewModel.organizationProducts[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          '\$${product.basePrice.toStringAsFixed(2)}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Navigate to edit product
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) =>
                          AddProduct(organizationId: widget.organizationId),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
