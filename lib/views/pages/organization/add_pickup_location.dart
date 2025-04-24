import 'package:clublly/models/pickup_location.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<PickupLocationViewModel>(
      builder: (context, pickupLocationViewModel, child) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/images/pickup.png"),
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
                      TextFormField(
                        controller: _addressController,
                        maxLines: 7,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
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
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: () async {
                  final pickupLocation = PickupLocation(
                    address: _addressController.text,
                    organizationId: widget.organizationId,
                  );
                  await pickupLocationViewModel.addPickupLocation(
                    pickupLocation,
                  );

                  Navigator.of(context).pop();
                },
                child: Text('Save Location'),
              ),
            ),
          ),
        );
      },
    );
  }
}
