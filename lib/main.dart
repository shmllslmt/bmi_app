import 'package:flutter/material.dart';
import 'input_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'firebase_options.dart';
import 'diagnostic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData.dark(),
      home: const BMICalculator(),
    );
  }
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  int weight = 50;
  int height = 150;

  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
    generationConfig: GenerationConfig(temperature: 0.7),
  );

  String diagnostic = '';

  double calculateBMI() {
    return weight / ((height / 100) * (height / 100));
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Normal';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  Color getBMICategoryColor(double bmi) {
    if (bmi < 18.5) {
      return Colors.blue;
    } else if (bmi < 25) {
      return Colors.green;
    } else if (bmi < 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  Future<void> _generateDiagnostic(String prompt) async {
    final response = await model.generateContent([Content.text(prompt)]);
    setState(() {
      diagnostic = response.text ?? '';
      debugPrint('Diagnostic: $diagnostic');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                child: InputCard(
                  label: 'Weight (kg)',
                  value: weight,
                  onLeftPressed: () => setState(() => weight--),
                  onRightPressed: () => setState(() => weight++),
                ),
              ),
              Flexible(
                child: InputCard(
                  label: 'Height (cm)',
                  value: height,
                  onLeftPressed: () => setState(() => height--),
                  onRightPressed: () => setState(() => height++),
                ),
              ),
            ],
          ),
          Flexible(
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: Text('Your BMI is')),
                  Center(
                    child: Text(
                      calculateBMI().toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      getBMICategory(calculateBMI()),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: getBMICategoryColor(calculateBMI()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
          MaterialButton(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const Center(child: CircularProgressIndicator());
                },
              );

              String prompt =
                  """
                A user has the following BMI information:

                BMI: ${calculateBMI().toStringAsFixed(1)}

                Return the response ONLY in valid JSON format.

                Structure:

                {
                "bmi_category": "",
                "summary": "",
                "health_risks": [],
                "recommendations": {
                  "diet": [],
                  "exercise": [],
                  "lifestyle": []
                }
                }

                Do not include markdown formatting.
                Do not include explanation outside the JSON.
                """;
              await _generateDiagnostic(prompt);

              if (mounted) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DiagnosticScreen(diagnostic: diagnostic),
                  ),
                );
              }
            },
            color: Colors.pink,
            height: 70,
            child: const Text(
              'VIEW DIAGNOSTIC',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
