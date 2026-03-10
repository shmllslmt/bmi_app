import 'package:flutter/material.dart';
import 'dart:convert';

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key, required this.diagnostic});

  final String diagnostic;

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  Widget buildList(List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(item.toString()),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {

    final decoded = jsonDecode(widget.diagnostic);

    final String category = decoded['bmi_category'] ?? 'Unknown';
    final String summary = decoded['summary'] ?? 'No summary available.';
    final List healthRisks = decoded['health_risks'] ?? [];
    final List diet = decoded['recommendations']['diet'] ?? [];
    final List exercise = decoded['recommendations']['exercise'] ?? [];
    final List lifestyle = decoded['recommendations']['lifestyle'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Diagnostic'),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$summary', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text('Health Risks:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              buildList(healthRisks),
              SizedBox(height: 16),
              Text('Dietary Recommendations:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              buildList(diet),
              SizedBox(height: 16),
              Text('Exercise Recommendations:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              buildList(exercise),
              SizedBox(height: 16),
              Text('Lifestyle Recommendations:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              buildList(lifestyle),
            ],
          ),
        ),
      ),
    );
  }
}
