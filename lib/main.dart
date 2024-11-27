import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const platform = MethodChannel('com.example.cross14/hello');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = 'No message received';
  String _imagePath = '';

  // Метод для отримання повідомлення від нативного коду
  Future<void> _getMessageFromNative() async {
    try {
      final String message = await MyApp.platform.invokeMethod('getHelloMessage');
      setState(() {
        _message = message;
      });
    } on PlatformException catch (e) {
      setState(() {
        _message = "Failed to get message: '${e.message}'.";
      });
    }
  }

  // Метод для зйомки фото
  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Native Method Channel Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Дві кнопки вгорі
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _getMessageFromNative,
                  child: Text("Get message from native code"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Зменшено радіус
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _takePhoto,
                  child: Text("Take a photo"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Зменшено радіус
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Повідомлення з нативного коду
            Text(
              _message,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            // Якщо зображення є, відображаємо його
            if (_imagePath.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.file(
                    File(_imagePath),
                    width: double.infinity,  // Зображення на весь екран
                    height: double.infinity, // Зображення на весь екран
                    fit: BoxFit.contain,  // Зображення не обрізається
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
