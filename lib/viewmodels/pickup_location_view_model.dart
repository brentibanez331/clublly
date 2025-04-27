import 'dart:developer';

import 'package:clublly/models/pickup_location.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PickupLocationViewModel extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<PickupLocation> _pickupLocations = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int? _currentOrganizationId;
  bool _isLoadingOrganizationLocations = false;

  List<PickupLocation> get pickupLocations => _pickupLocations;
  bool get isLoading => _isLoading;

  Future<void> addPickupLocation(PickupLocation pickupLocation) async {
    try {
      await supabase.from('pickupLocations').insert(pickupLocation.toMap());

      await fetchLocationsByOrganization(_currentOrganizationId!);
    } catch (error) {
      log("Error adding pickup location: $error");
    }
  }

  Future<void> fetchLocationsByOrganization(int organizationId) async {
    try {
      _isLoadingOrganizationLocations = true;
      _currentOrganizationId = organizationId;

      final response = await supabase
          .from('pickupLocations')
          .select('*, organizations(name)')
          .eq('organization_id', organizationId)
          .filter('deleted_at', 'is', null)
          .order('address', ascending: true);

      log(response.toString());

      _pickupLocations =
          (response as List)
              .map((item) => PickupLocation.fromMap(item))
              .toList();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Failed to fetch pickup locations: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLocation(PickupLocation pickupLocation) async {
    try {
      await supabase
          .from('pickupLocations')
          .update({
            'address': pickupLocation.address,
            'description': pickupLocation.description,
          })
          .eq('id', pickupLocation.id!);

      await fetchLocationsByOrganization(_currentOrganizationId!);
      notifyListeners();
    } catch (error) {
      log("Error updating pickup location: ${error}");
    }
  }

  Future<void> softDeleteLocation(int pickupLocationId) async {
    try {
      await supabase
          .from('pickupLocations')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', pickupLocationId);

      await fetchLocationsByOrganization(_currentOrganizationId!);
      notifyListeners();
    } catch (error) {
      log("Error deleting pickup location: ${error}");
    }
  }
}
