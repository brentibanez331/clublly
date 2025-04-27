import 'dart:developer';

import 'package:clublly/models/pickup_location.dart';
import 'package:clublly/utils/colors.dart';
import 'package:clublly/viewmodels/pickup_location_view_model.dart';
import 'package:clublly/views/pages/organization/add_pickup_location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationLocations extends StatefulWidget {
  final int organizationId;

  const OrganizationLocations({Key? key, required this.organizationId})
    : super(key: key);

  @override
  _OrganizationLocationsState createState() => _OrganizationLocationsState();
}

class _OrganizationLocationsState extends State<OrganizationLocations> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PickupLocationViewModel>(
      builder: (context, pickupLocationViewModel, child) {
        if (pickupLocationViewModel.pickupLocations.isEmpty) {
          pickupLocationViewModel.fetchLocationsByOrganization(
            widget.organizationId,
          );
        }

        return RefreshIndicator(
          onRefresh:
              () => pickupLocationViewModel.fetchLocationsByOrganization(
                widget.organizationId,
              ),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PICK-UP LOCATIONS",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pickupLocationViewModel.pickupLocations.length,
                      itemBuilder: (context, index) {
                        final pickupLocation =
                            pickupLocationViewModel.pickupLocations[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: InkWell(
                            onTap: () {
                              showEditLocation(pickupLocation);
                            },
                            onLongPress: () {
                              showOptions(pickupLocation);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.65,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: AppColors.secondary,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              pickupLocation.address,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(pickupLocation.description!),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.edit),
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
            floatingActionButton: SizedBox(
              width: 120,
              height: 48,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => AddPickupLocation(
                            organizationId: widget.organizationId,
                          ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showEditLocation(PickupLocation pickupLocation) {
    final PickupLocationViewModel pickupLocationViewModel =
        Provider.of<PickupLocationViewModel>(
          context,
          listen: false,
        ); // Get ViewModel

    final TextEditingController _addressController = TextEditingController(
      text: pickupLocation.address,
    );
    final TextEditingController _descriptionController = TextEditingController(
      text: pickupLocation.description,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext builder) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 8),
                        Text(
                          "Edit Pickup Location",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      child: Text(
                        "Save",
                        style: TextStyle(color: AppColors.secondary),
                      ),
                      onPressed: () {
                        final newPickupLocation = PickupLocation(
                          id: pickupLocation.id,
                          address: _addressController.text,
                          description: _descriptionController.text,
                          organizationId: pickupLocation.organizationId,
                        );

                        try {
                          pickupLocationViewModel.updateLocation(
                            newPickupLocation,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Location updated!')),
                          );

                          Navigator.pop(context);
                        } catch (e) {
                          log("Error updating location: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update location.'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text("Address", style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                TextField(
                  autofocus: true,
                  controller: _addressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text("Additional Details", style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  maxLines: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showOptions(PickupLocation pickupLocation) {
    final PickupLocationViewModel pickupLocationViewModel =
        Provider.of<PickupLocationViewModel>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: double.infinity,
          child: IntrinsicHeight(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    showEditLocation(pickupLocation);
                  },
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Or your desired radius
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined),
                        SizedBox(width: 8),
                        Text("Edit", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4),
                InkWell(
                  onTap: () async {
                    log("Deleting pickup location");
                    await pickupLocationViewModel.softDeleteLocation(
                      pickupLocation.id!,
                    );
                    Navigator.pop(context);
                  },
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Or your desired radius
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: AppColors.danger),
                        SizedBox(width: 8),
                        Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.danger,
                          ),
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
    );
  }
}
