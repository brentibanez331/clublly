import 'dart:developer';

import 'package:clublly/models/organization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrganizationViewModel extends ChangeNotifier {
  List<Organization> organizations = [];
  Organization? selectedOrganization;

  final supabase = Supabase.instance.client;

  Future<bool> addOrganization(Organization organization) async {
    try {
      log(organization.toString());
      final data =
          await supabase
              .from('organizations')
              .upsert(organization.toMap())
              .select();
      // await supabase.from('organizations').insert(organization.toMap());

      await supabase.from('usersToOrganizations').insert({
        "user_id": data[0]["owner_id"],
        "organization_id": data[0]["id"],
      });

      await fetchOrganizationsByUser(organization.ownerId);
      return true;
    } catch (error) {
      print('Error adding organization: $error');
      return false;
    }
  }

  Future<void> fetchOrganizationsByUser(String userId) async {
    try {
      final data = await supabase
          .from('organizations')
          .select()
          .eq('owner_id', userId);

      organizations =
          (data as List)
              .map((organizationMap) => Organization.fromMap(organizationMap))
              .toList();

      if (organizations.isNotEmpty) {
        selectedOrganization = organizations[0];
      }

      notifyListeners();
    } catch (error) {
      log('Error fetching organizations: $error');
    }
  }
}
