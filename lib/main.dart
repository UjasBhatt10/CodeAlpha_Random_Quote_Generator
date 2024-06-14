import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import 'package:http/http.dart' as http;

void main() {
  runApp(const RandomQuoteApp());
}

class RandomQuoteApp extends StatelessWidget {
  const RandomQuoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Random Quote Generator',
      home: RandomQuoteScreen(),
    );
  }
}

class RandomQuoteScreen extends StatefulWidget {
  const RandomQuoteScreen({Key? key}) : super(key: key);

  @override
  State<RandomQuoteScreen> createState() => _RandomQuoteScreenState();
}

class _RandomQuoteScreenState extends State<RandomQuoteScreen> {
  String _quote = 'Tap the button to get a random quote';
  Color _backgroundColor = Colors.blueAccent; // Default background color

  // Function to get a random quote from the quotable API
  Future<void> _getRandomQuote() async {
    final response =
        await http.get(Uri.parse('https://api.quotable.io/random'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _quote = data['content'];
        _setRandomBackgroundColor(); // Change background color
      });
    } else {
      setState(() {
        _quote = 'Failed to load a quote';
      });
    }
  }

  // Function to set a random background color
  void _setRandomBackgroundColor() {
    // Generate random RGB values
    final Random random = Random();
    _backgroundColor = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  // Function to copy quote to clipboard
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _quote));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quote copied to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Random Quote Generator',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent, // Custom app bar color
      ),
      body: GestureDetector(
        onTap: _copyToClipboard,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _backgroundColor.withOpacity(0.8),
                _backgroundColor.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          _quote,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy),
                        color: Colors.white,
                        onPressed: _copyToClipboard,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: _getRandomQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Get Random Quote',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
