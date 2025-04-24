import 'package:clublly/views/pages/organization/add_pickup_location.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Text("PICKUP LOCATIONS"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) =>
                      AddPickupLocation(organizationId: widget.organizationId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
