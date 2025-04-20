import 'dart:developer';
import 'dart:io';

import 'package:clublly/models/organization.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class OrganizationViewModel extends ChangeNotifier {
  List<Organization> organizations = [];
  Organization? selectedOrganization;
  File? _logoFile;
  bool isUploadingLogo = false;
  final ImagePicker _picker = ImagePicker();

  final supabase = Supabase.instance.client;

  File? get logoFile => _logoFile;

  Future<void> pickLogoImage() async {
    log("THIS SHIT IS RUNNING");
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        _logoFile = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  // New function to clear selected image
  void clearLogoImage() {
    _logoFile = null;
    notifyListeners();
  }

  Future<bool> addOrganization(Organization organization) async {
    try {
      String? logoPath;

      if (_logoFile != null) {
        isUploadingLogo = true;
        notifyListeners();

        final uuid = Uuid().v4();
        final fileName = path.basename(_logoFile!.path);
        final storageFilePath = '$uuid/$fileName';

        await supabase.storage
            .from('logos')
            .upload(
              storageFilePath,
              _logoFile!,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: false,
              ),
            );

        logoPath = storageFilePath;
        isUploadingLogo = false;
        notifyListeners();
      }

      final updatedOrganization = Organization(
        id: organization.id,
        name: organization.name,
        acronym: organization.acronym,
        departmentId: organization.departmentId,
        description: organization.description,
        ownerId: organization.ownerId,
        logoPath: logoPath,
      );

      log(updatedOrganization.toString());
      final data =
          await supabase
              .from('organizations')
              .upsert(updatedOrganization.toMap())
              .select();

      await supabase.from('usersToOrganizations').insert({
        "user_id": data[0]["owner_id"],
        "organization_id": data[0]["id"],
      });

      await fetchOrganizationsByUser(organization.ownerId);
      return true;

      // await supabase.from('organizations').insert(organization.toMap());
    } catch (error) {
      isUploadingLogo = false;
      notifyListeners();
      print('Error adding organization: $error');
      return false;
    } finally {
      clearLogoImage();
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
