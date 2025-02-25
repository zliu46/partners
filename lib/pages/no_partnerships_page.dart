import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:partners/widgets/create_partnership_dialog.dart';
import 'package:partners/widgets/join_with_code_dialog.dart';

class NoPartnershipsPage extends StatelessWidget {
  const NoPartnershipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WELCOME TO PARTNERS',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'PLEASE CREATE OR JOIN A PARTNERSHIP TO CONTINUE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed:(() {
                  showJoinWithCodeDialog(context);
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
                child: Text(
                  'JOIN PARTNERSHIP WITH CODE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),
              OutlinedButton(
                onPressed: (() {
                  showCreatePartnershipDialog(context);
                }),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
                child: Text(
                  'CREATE NEW PARTNERSHIP',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
