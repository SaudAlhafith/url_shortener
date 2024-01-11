import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShortenURLPage(),
    );
  }
}

class ShortenURLPage extends StatefulWidget {
  @override
  _ShortenURLPageState createState() => _ShortenURLPageState();
}

class _ShortenURLPageState extends State<ShortenURLPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();
  String _shortenedUrl = '';

  void _launchURL(String url) async {
    final Uri myUrl = Uri.parse(url); // Replace with your URL
    // You can add additional checks here to ensure it's a valid URL
      bool isLaunchable = await canLaunchUrl(myUrl);
        launchUrl(myUrl);
    
  }

  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    // Optionally, show a snackbar or toast to indicate that the text has been copied
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to Clipboard')));
  }

  Future<void> shortenURL() async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:5000/shorten'),
      body: {'url': _urlController.text, 'alias': _aliasController.text},
    );

    if (response.statusCode == 200) {
      setState(() {
        _shortenedUrl = json.decode(response.body)['shortened_url'];
      });
    } else {
      print(json.decode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('URL Shortener')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _aliasController,
              decoration: const InputDecoration(
                labelText: 'Enter Alias if you want',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: shortenURL,
              child: const Text('Shorten URL'),
            ),
            const SizedBox(height: 20),
            _shortenedUrl.isNotEmpty
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Rounded corners
                      ),
                    ),
                    onPressed: () => _launchURL(_shortenedUrl), // Open the link when the button is pressed
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // To wrap content in the row
                      children: <Widget>[
                        InkWell(
                          onTap: () => _copyToClipboard(_shortenedUrl), // Copy the URL when the icon is pressed
                          child: const Icon(Icons.copy, color: Colors.white), // Copy icon
                        ),
                        const SizedBox(width: 10), // Spacing between icon and text
                        Text(
                          _shortenedUrl,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
