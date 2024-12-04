import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Conversion App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _temperatureController = TextEditingController();
  String _conversionType = 'Fahrenheit to Celsius';
  double _convertedValue = 0.0;
  final List<String> _history = [];
  bool _isDarkMode = false;

  void _convertTemperature() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        try {
          double inputTemperature = double.parse(_temperatureController.text);
          if (_conversionType == 'Fahrenheit to Celsius') {
            _convertedValue = (inputTemperature - 32) * 5 / 9;
            _history.add(
                'F to C: ${inputTemperature.toStringAsFixed(1)} => ${_convertedValue.toStringAsFixed(2)}');
          } else {
            _convertedValue = inputTemperature * 9 / 5 + 32;
            _history.add(
                'C to F: ${inputTemperature.toStringAsFixed(1)} => ${_convertedValue.toStringAsFixed(2)}');
          }
          _temperatureController.clear();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Invalid input')),
          );
        }
      });
    }
  }

  void _reset() {
    setState(() {
      _temperatureController.clear();
      _convertedValue = 0.0;
      _history.clear();
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Conversion App'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Enter temperature:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _temperatureController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Temperature',
                  filled: true,
                  fillColor: _isDarkMode ? Colors.grey[800] : Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a temperature value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _conversionType,
                onChanged: (value) {
                  setState(() {
                    _conversionType = value!;
                  });
                },
                items: [
                  'Fahrenheit to Celsius',
                  'Celsius to Fahrenheit',
                ].map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a conversion type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _convertTemperature,
                child: const Text('Convert'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Result:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
                child: SelectableText(
                  _convertedValue.toStringAsFixed(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'History:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _history[index],
                        style: TextStyle(
                            color: _isDarkMode ? Colors.white : Colors.black),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _reset,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red, // Change button color to red for reset
                ),
                child: Text('Reset'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: _isDarkMode ? Colors.black : Colors.grey[200],
    );
  }
}
