import 'dart:developer';

import 'package:clublly/main.dart';
import 'package:clublly/viewmodels/organization_view_model.dart';
import 'package:clublly/views/pages/add_organization.dart';
import 'package:clublly/views/pages/organization/organization_page.dart';
import 'package:clublly/views/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:clublly/views/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = supabase.auth.currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrganizationViewModel>(
        context,
        listen: false,
      ).fetchOrganizationsByUser(user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileImageUrl = user?.userMetadata?['avatar_url'];
    final fullName = user?.userMetadata?['full_name'];

    return Consumer<OrganizationViewModel>(
      builder: (context, organizationViewModel, child) {
        if (organizationViewModel.organizations.isEmpty) {
          organizationViewModel.fetchOrganizationsByUser(user!.id);
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: 90,
            title: Row(
              children: [
                if (profileImageUrl != null)
                  ClipOval(
                    child: Image.network(
                      profileImageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fullName ?? '', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 4),
                    InkWell(
                      borderRadius: BorderRadius.circular(99),
                      onTap: () {
                        log('Pressed profile edit');
                      },
                      child: Row(
                        children: [
                          Text('My Profile', style: TextStyle(fontSize: 14)),
                          SizedBox(width: 4),
                          Icon(
                            Icons.edit_outlined,
                            color: Colors.black54,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                icon: Icon(Icons.settings_outlined),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddOrganization(),
                      ),
                    );
                  },
                  child: Text("Create Organization"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: organizationViewModel.organizations.length,
                    itemBuilder: (context, index) {
                      final organization =
                          organizationViewModel.organizations[index];

                      String? imageUrl;
                      if (organization.logoPath != null) {
                        imageUrl = supabase.storage
                            .from('logos')
                            .getPublicUrl(organization.logoPath!);
                      } else {
                        imageUrl = null;
                      }

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => OrganizationPage(
                                    organization: organization,
                                  ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              CircleAvatar(
                                child: Image.network(
                                  imageUrl!,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                      ),
                                    );
                                  },

                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 100,
                                      width: 100,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.error),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(organization.name),
                            ],
                          ),
                          // subtitle: Text(organization.acronym),
                        ),
                      );
                    },
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
