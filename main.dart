import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _temperatureController = TextEditingController();
  String _conversionType = 'Fahrenheit to Celsius';
  double _convertedValue = 0.0;
  List<String> _history = [];

  void _convertTemperature() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        try {
          if (_conversionType == 'Fahrenheit to Celsius') {
            _convertedValue = (_temperatureController.text.isEmpty)
                ? 0.0
                : (double.parse(_temperatureController.text) - 32) * 5 / 9;
            _history.add('F to C: ${_temperatureController.text} => ${_convertedValue.toStringAsFixed(2)}');
          } else {
            _convertedValue = (_temperatureController.text.isEmpty)
                ? 0.0
                : double.parse(_temperatureController.text) * 9 / 5 + 32;
            _history.add('C to F: ${_temperatureController.text} => ${_convertedValue.toStringAsFixed(2)}');
          }
        } catch (e) {
          // handle error, e.g., show a toast message or an error dialog
          print('Error: $e');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Conversion App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Enter temperature:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _temperatureController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Temperature',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a temperature value';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _convertTemperature,
                child: Text('Convert'),
              ),
              SizedBox(height: 20),
              Text(
                'Result:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SelectableText(
                _convertedValue.toStringAsFixed(2),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'History:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_history[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}