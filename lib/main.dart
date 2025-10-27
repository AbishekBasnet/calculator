import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _previousValue = '';
  String _currentOperation = '';
  bool _waitingForOperand = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadLastValue();
  }

  // Load the last saved value from SharedPreferences
  Future<void> _loadLastValue() async {
    final prefs = await SharedPreferences.getInstance();
    final lastValue = prefs.getString('calculator_last_value');
    if (lastValue != null && lastValue.isNotEmpty) {
      setState(() {
        _display = lastValue;
      });
    }
  }

  // Save the current display value to SharedPreferences
  Future<void> _saveLastValue() async {
    final prefs = await SharedPreferences.getInstance();
    if (!_isError && _display != 'ERROR' && _display != 'OVERFLOW') {
      await prefs.setString('calculator_last_value', _display);
    }
  }

  // Format display to ensure it fits in 8 characters (alphanumeric display spec)
  String _formatDisplay(String value) {
    if (value.length <= 8) {
      return value;
    }
    
    // If it's longer than 8 characters, it should be an overflow
    return 'OVERFLOW';
  }

  void _onDigitPressed(String digit) {
    if (_isError) {
      _clear();
    }

    setState(() {
      if (_waitingForOperand) {
        _display = digit;
        _waitingForOperand = false;
      } else {
        // Ensure we don't exceed 8 characters for the alphanumeric display
        if (_display.length < 8) {
          _display = _display == '0' ? digit : _display + digit;
        }
        // If trying to add more digits, just ignore (calculator behavior)
      }
    });
    _saveLastValue();
  }

  void _onOperationPressed(String operation) {
    if (_isError) return;

    if (_previousValue.isNotEmpty && !_waitingForOperand) {
      _calculate();
    }

    setState(() {
      _previousValue = _display;
      _currentOperation = operation;
      _waitingForOperand = true;
    });
  }

  void _calculate() {
    if (_previousValue.isEmpty || _currentOperation.isEmpty) return;

    double prev = double.tryParse(_previousValue) ?? 0;
    double current = double.tryParse(_display) ?? 0;
    double result = 0;

    switch (_currentOperation) {
      case '+':
        result = prev + current;
        break;
      case '-':
        result = prev - current;
        break;
      case '*':
        result = prev * current;
        break;
      case '/':
        if (current == 0) {
          setState(() {
            _display = 'ERROR';
            _isError = true;
          });
          return;
        }
        result = prev / current;
        break;
    }

    // Check for overflow (8 digits max)
    if (result.abs() >= 100000000) {
      setState(() {
        _display = 'OVERFLOW';
        _isError = true;
      });
    } else {
      String resultString = result.toString();
      // Handle decimal places to fit in 8 digits
      if (resultString.contains('.')) {
        if (resultString.length > 8) {
          // Try to show as integer if possible
          if (result == result.truncate()) {
            resultString = result.truncate().toString();
          } else {
            // Limit decimal places to fit in 8 digits
            int intPart = result.truncate().toString().length;
            int decimals = min(6 - intPart, 6);
            if (decimals > 0) {
              resultString = result.toStringAsFixed(decimals);
              // Remove trailing zeros
              resultString = resultString.replaceAll(RegExp(r'0*$'), '');
              resultString = resultString.replaceAll(RegExp(r'\.$'), '');
            } else {
              resultString = result.truncate().toString();
            }
          }
        }
      }
      
      if (resultString.length > 8) {
        setState(() {
          _display = 'OVERFLOW';
          _isError = true;
        });
      } else {
        setState(() {
          _display = _formatDisplay(resultString);
          _previousValue = '';
          _currentOperation = '';
          _waitingForOperand = true;
        });
        _saveLastValue();
      }
    }
  }

  void _clear() {
    setState(() {
      _display = '0';
      _previousValue = '';
      _currentOperation = '';
      _waitingForOperand = false;
      _isError = false;
    });
    _saveLastValue();
  }

  void _clearEntry() {
    setState(() {
      _display = '0';
      _isError = false;
    });
    _saveLastValue();
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
    double flex = 1,
  }) {
    return Expanded(
      flex: flex.toInt(),
      child: Container(
        margin: const EdgeInsets.all(2),
        height: 70,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.grey[200],
            foregroundColor: textColor ?? Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Display - 8-digit alphanumeric display
          Container(
            width: double.infinity,
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: Text(
              _display,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontFamily: 'monospace',
                letterSpacing: 2.0,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
          
          // Button Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // Row 1: 7, 8, 9, /
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          text: '7',
                          onPressed: () => _onDigitPressed('7'),
                        ),
                        _buildButton(
                          text: '8',
                          onPressed: () => _onDigitPressed('8'),
                        ),
                        _buildButton(
                          text: '9',
                          onPressed: () => _onDigitPressed('9'),
                        ),
                        _buildButton(
                          text: '/',
                          onPressed: () => _onOperationPressed('/'),
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  
                  // Row 2: 4, 5, 6, *
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          text: '4',
                          onPressed: () => _onDigitPressed('4'),
                        ),
                        _buildButton(
                          text: '5',
                          onPressed: () => _onDigitPressed('5'),
                        ),
                        _buildButton(
                          text: '6',
                          onPressed: () => _onDigitPressed('6'),
                        ),
                        _buildButton(
                          text: '*',
                          onPressed: () => _onOperationPressed('*'),
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  
                  // Row 3: 1, 2, 3, -
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          text: '1',
                          onPressed: () => _onDigitPressed('1'),
                        ),
                        _buildButton(
                          text: '2',
                          onPressed: () => _onDigitPressed('2'),
                        ),
                        _buildButton(
                          text: '3',
                          onPressed: () => _onDigitPressed('3'),
                        ),
                        _buildButton(
                          text: '-',
                          onPressed: () => _onOperationPressed('-'),
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  
                  // Row 4: CE, 0, C, +
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          text: 'CE',
                          onPressed: _clearEntry,
                          backgroundColor: Colors.red[300],
                          textColor: Colors.white,
                        ),
                        _buildButton(
                          text: '0',
                          onPressed: () => _onDigitPressed('0'),
                        ),
                        _buildButton(
                          text: 'C',
                          onPressed: _clear,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        ),
                        _buildButton(
                          text: '+',
                          onPressed: () => _onOperationPressed('+'),
                          backgroundColor: Colors.orange,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  
                  // Row 5: = button (full width)
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          text: '=',
                          onPressed: _calculate,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          flex: 4,
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
    );
  }
}