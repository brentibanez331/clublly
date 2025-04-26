import 'package:clublly/models/pickup_location.dart';
import 'package:clublly/utils/colors.dart';
import 'package:clublly/viewmodels/pickup_location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPickupLocation extends StatefulWidget {
  final int organizationId;

  const AddPickupLocation({super.key, required this.organizationId});

  @override
  _AddPickupLocationState createState() => _AddPickupLocationState();
}

class _AddPickupLocationState extends State<AddPickupLocation> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PickupLocationViewModel>(
      builder: (context, pickupLocationViewModel, child) {
        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              forceMaterialTransparency: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            "assets/images/pickup.png",
                            width: MediaQuery.sizeOf(context).width * 0.7,
                          ),
                        ),
                      ),
                      Text(
                        'Add Pickup Location',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'This allows you and users to choose their preferred pickup location. Ensure that the location is an existing spot around the campus. Be as descriptive as possible.',
                        style: TextStyle(color: Colors.black54),
                      ),
                      SizedBox(height: 24),
                      Text('Location', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: 'Enter location here',
                          hintStyle: TextStyle(
                            // fontStyle: FontStyle.italic,
                            color: Colors.black26,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Address is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Additional Information',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 7,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText:
                              'Add more details so the customer can find you easier',
                          hintStyle: TextStyle(
                            // fontStyle: FontStyle.italic,
                            color: Colors.black26,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Address is required";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(8.0),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                ),
                onPressed: () async {
                  final pickupLocation = PickupLocation(
                    address: _addressController.text,
                    description: _descriptionController.text,
                    organizationId: widget.organizationId,
                  );

                  await pickupLocationViewModel.addPickupLocation(
                    pickupLocation,
                  );

                  Navigator.of(context).pop();
                },
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
