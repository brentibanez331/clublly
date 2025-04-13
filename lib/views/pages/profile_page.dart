import 'dart:developer';

import 'package:clublly/main.dart';
import 'package:clublly/viewmodels/organization_view_model.dart';
import 'package:clublly/views/pages/add_organization.dart';
import 'package:flutter/material.dart';
import 'package:clublly/views/login_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = supabase.auth.currentUser;

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.disconnect();
      await supabase.auth.signOut();
    } catch (error) {
      log('Error signing out: ${error}');
    }
  }

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
            title: const Text('Profile'),
            actions: [
              TextButton(
                onPressed: () async {
                  signOut();

                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (profileImageUrl != null)
                  ClipOval(
                    child: Image.network(
                      profileImageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  fullName ?? '',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
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

                      return ListTile(
                        title: Text(organization.name),
                        subtitle: Text(organization.acronym),
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
