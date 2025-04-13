import 'dart:developer';

import 'package:clublly/main.dart';
import 'package:clublly/models/department.dart';
import 'package:clublly/models/organization.dart';
import 'package:clublly/viewmodels/department_view_model.dart';
import 'package:clublly/viewmodels/organization_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddOrganization extends StatefulWidget {
  const AddOrganization({Key? key}) : super(key: key);

  @override
  _AddOrganizationState createState() => _AddOrganizationState();
}

class _AddOrganizationState extends State<AddOrganization> {
  int _index = 0;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _acronymController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedDepartmentId;

  bool loading = false;

  Future<void> saveOrganization() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
      });

      // Adding logic here
      if (_selectedDepartmentId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("You must select a department")));
        setState(() {
          _index = 1;
        });
        return;
      }

      final user = supabase.auth.currentUser;
      final userId = user?.id;
      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Session expired. Login again")));
        return;
      }

      final organization = Organization(
        name: _nameController.text,
        acronym: _acronymController.text,
        departmentId: int.parse(_selectedDepartmentId!),
        description:
            _descriptionController.text.isEmpty
                ? 'N/A'
                : _descriptionController.text,
        ownerId: supabase.auth.currentUser!.id,
      );

      try {
        await Provider.of<OrganizationViewModel>(
          context,
          listen: false,
        ).addOrganization(organization);

        await Provider.of<OrganizationViewModel>(
          context,
          listen: false,
        ).fetchOrganizationsByUser(organization.ownerId);
      } catch (error) {
        log(error.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding organization: $error")),
        );
      } finally {
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
      }
    }
  }

  Widget controlsBuilder(context, details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          if (details.currentStep < 3)
            ElevatedButton(
              onPressed: details.onStepContinue,
              child: Text('Next'),
            ),

          if (details.currentStep == 3)
            ElevatedButton(onPressed: saveOrganization, child: Text('Confirm')),

          SizedBox(width: 8),
          if (details.currentStep > 0)
            OutlinedButton(
              onPressed: details.onStepCancel,
              child: Text('Back'),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _acronymController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DepartmentViewModel(),
      child: Consumer<DepartmentViewModel>(
        builder: (context, departmentViewModel, child) {
          if (departmentViewModel.departments.isEmpty) {
            departmentViewModel.fetchDepartments();
          }

          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Apply for your Organization',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close_rounded),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      Expanded(
                        child: Stepper(
                          elevation: 0,
                          type: StepperType.horizontal,
                          currentStep: _index,
                          physics: ClampingScrollPhysics(),
                          stepIconMargin: EdgeInsets.zero,
                          controlsBuilder: controlsBuilder,
                          onStepCancel: () {
                            if (_index > 0) {
                              setState(() {
                                _index -= 1;
                              });
                            }
                          },
                          onStepContinue: () {
                            if (_index < 3) {
                              setState(() {
                                _index += 1;
                              });
                            }
                          },
                          onStepTapped: (int index) {
                            setState(() {
                              _index = index;
                            });
                          },
                          steps: [
                            Step(
                              title: const SizedBox.shrink(),
                              label: const Text('Profile'),
                              isActive: _index >= 0,
                              state:
                                  _index >= 1
                                      ? StepState.complete
                                      : StepState.disabled,
                              content: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Organization Name',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Complete Name',
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return "Organization name is required";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Acronym',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    TextFormField(
                                      controller: _acronymController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'CSS - USLS',
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Acronym is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Step(
                              title: const SizedBox.shrink(),
                              label: const Text('Logo'),
                              isActive: _index >= 1,
                              state:
                                  _index >= 2
                                      ? StepState.complete
                                      : StepState.disabled,
                              content: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Upload Logo',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Your logo will make it easier for students to identify you!",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        log('Tap if you can hear');
                                      },
                                      child: Container(
                                        height: 330,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                0.3,
                                              ), // Softer shadow
                                              spreadRadius: 4,
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          border: Border.all(
                                            color:
                                                Colors
                                                    .grey[300]!, // Light grey border
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.cloud_upload_outlined),
                                              SizedBox(height: 8),
                                              Text(
                                                'Select image to upload',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Supported Format: PNG, JPG, JPEG',
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Step(
                              title: const SizedBox.shrink(),
                              label: const Text('Product'),
                              isActive: _index >= 2,
                              state:
                                  _index >= 3
                                      ? StepState.complete
                                      : StepState.disabled,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Department',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 4),
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    value: _selectedDepartmentId,

                                    items:
                                        departmentViewModel
                                                .departments
                                                .isNotEmpty
                                            ? departmentViewModel.departments
                                                .map<DropdownMenuItem<String>>(
                                                  (Department department) =>
                                                      DropdownMenuItem<String>(
                                                        value:
                                                            department.id
                                                                .toString(),
                                                        child: Text(
                                                          department.name,
                                                        ),
                                                      ),
                                                )
                                                .toList()
                                            : [
                                              const DropdownMenuItem<String>(
                                                value: '',
                                                child: Text(
                                                  'Loading Departments...',
                                                ),
                                              ),
                                            ],
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedDepartmentId = newValue;
                                      });
                                    },
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a department';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Text(
                                        'About ',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Flexible(
                                        child: Text(
                                          _acronymController.text,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  TextFormField(
                                    controller: _descriptionController,
                                    maxLines: 7,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText:
                                          'Anything that describes your club',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Step(
                              title: const SizedBox.shrink(),
                              label: const Text('Confirm'),
                              isActive: _index >= 3,
                              content: Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Organization Name',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _nameController.text,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Acronym',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _acronymController.text,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Department',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      departmentViewModel.departments
                                          .firstWhere(
                                            (department) =>
                                                department.id.toString() ==
                                                _selectedDepartmentId,
                                            orElse:
                                                () => Department(
                                                  id: -1,
                                                  name: 'Department Not Found',
                                                  createdAt: '',
                                                ),
                                          )
                                          .name,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Description',
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _descriptionController.text.isEmpty
                                          ? 'N/A'
                                          : _descriptionController.text,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: 32),

                                    // Flexible(child: Text(_descriptionController.text)),
                                    RichText(
                                      text: TextSpan(
                                        text: 'By registering ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: _nameController.text,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(text: ' or '),
                                          TextSpan(
                                            text: _acronymController.text,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ', you agree with our ',
                                          ),
                                          TextSpan(
                                            text: 'Terms and Conditions',
                                            style: TextStyle(
                                              color: Colors.blue[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
