import 'dart:developer';

import 'package:clublly/models/department.dart';
import 'package:clublly/models/organization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DepartmentViewModel extends ChangeNotifier {
  List<Department> departments = [];
  final supabase = Supabase.instance.client;

  Future<void> fetchDepartments() async {
    try {
      final data = await supabase.from('departments').select();
      departments =
          (data as List)
              .map(
                (recipePurchasesMap) => Department.fromMap(recipePurchasesMap),
              )
              .toList();
      log(departments.toString());
    } catch (error) {
      print('Error fetching departments: $error');
    }
  }

  // Future<void> addOrganization(Organization organization) async {
  //   try {
  //     await supabase.from('organization').insert(organization.toMap());
  //   } catch (error) {
  //     print('Error adding organization: $error');
  //   }
  // }
}
