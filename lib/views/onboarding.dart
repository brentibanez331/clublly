import 'package:clublly/views/dashboard.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  String selectedCard = "";

  @override
  Widget build(BuildContext context) {
    void _onConfirm() {
      if (selectedCard == "student") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      } else {}
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 48.0, left: 8, right: 8),
        child: Center(
          child: Column(
            children: [
              Text(
                "Select your role",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 38),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCard = "student";
                  });
                },
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.65,
                  height: 260,
                  child: Card(
                    elevation: 10,
                    shape:
                        selectedCard == "student"
                            ? RoundedRectangleBorder(
                              side: BorderSide(color: Colors.green.shade500),
                              borderRadius: BorderRadius.circular(10.0),
                            )
                            : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                    child: Column(children: [Text("I am a student")]),
                  ),
                ),
              ),
              SizedBox(height: 24),
              GestureDetector(
                // Make card tappable
                onTap: () {
                  // Handle card tap
                  setState(() {
                    selectedCard = "officer"; // Set selected card
                  });
                },
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.65,
                  height: 260,
                  child: Card(
                    elevation: 10,
                    shape:
                        selectedCard ==
                                "officer" // Check if this card is selected
                            ? RoundedRectangleBorder(
                              // If selected, apply green border
                              side: BorderSide(color: Colors.green.shade500),
                              borderRadius: BorderRadius.circular(10.0),
                            )
                            : RoundedRectangleBorder(
                              // Always have rounded borders
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                    child: Column(
                      children: [Text("I am an officer at an organization")],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 48),
              ElevatedButton(onPressed: _onConfirm, child: Text("Confirm")),
            ],
          ),
        ),
      ),
    );
  }
}
