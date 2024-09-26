import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();

  // Add a static method to get the inventory items
  static List<Map<String, String>> getInventoryItems() {
    return _InventoryState.inventoryList;
  }
}

class _InventoryState extends State<Inventory> {
  File? _image;
  String? _expiryDate;
  bool _isLoading = false;

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _manualExpiryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  static List<Map<String, String>> inventoryList = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _isLoading = true;
      });

      String? recognizedDate = await recognizeExpiryDate(image.path);

      setState(() {
        _expiryDate = recognizedDate ?? "No expiry date found";
        _isLoading = false;
      });

      // Ask for item name after date recognition
      if (_expiryDate != null && _expiryDate != "No expiry date found") {
        await _promptItemName();
      }
    }
  }

  Future<String?> recognizeExpiryDate(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);

    List<DateTime> dates = [];

    // Extended regex pattern to recognize multiple date formats
    RegExp dateRegEx = RegExp(
        r'(\d{2}/\d{2}/\d{4}|\d{2}-\d{2}-\d{4}|\d{4}-\d{2}-\d{2}|\d{2}/\d{4}|\d{4}/\d{2}|\d{2}-\d{4}|\d{4}-\d{2}|[A-Za-z]+ \d{4})');

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        final match = dateRegEx.allMatches(line.text);
        for (var m in match) {
          String? dateStr = m.group(0);
          DateTime? parsedDate = _parseDate(dateStr!);
          if (parsedDate != null) {
            dates.add(parsedDate);
          }
        }
      }
    }

    // Sort dates and return the largest (expiry date)
    if (dates.isNotEmpty) {
      dates.sort((a, b) => a.compareTo(b));
      return DateFormat('dd/MM/yyyy').format(dates.last);
    }

    return null;
  }

  DateTime? _parseDate(String dateStr) {
    List<String> formats = [
      'dd/MM/yyyy',
      'MM/dd/yyyy',
      'yyyy-MM-dd',
      'dd-MM-yyyy',
      'MM-yyyy',
      'yyyy-MM',
      'MMMM yyyy'
    ];

    for (String format in formats) {
      try {
        DateFormat dateFormat = DateFormat(format);
        return dateFormat.parse(dateStr);
      } catch (e) {
        // Ignore and continue trying other formats
      }
    }
    return null;
  }

  Future<void> _promptItemName() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Product Name'),
          content: TextField(
            controller: _itemNameController,
            decoration: InputDecoration(
              labelText: 'Product Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                addScannedItem();
                Navigator.of(context).pop();
              },
              child: Text('Add Item'),
            ),
          ],
        );
      },
    );
  }

  void addManualItem() {
    setState(() {
      inventoryList.add({
        "name": _itemNameController.text,
        "expiryDate": _manualExpiryController.text,
        "quantity": _quantityController.text,
      });
      _itemNameController.clear();
      _manualExpiryController.clear();
      _quantityController.clear();
    });
  }

  void addScannedItem() {
    setState(() {
      if (_expiryDate != null && _itemNameController.text.isNotEmpty) {
        inventoryList.add({
          "name": _itemNameController.text,
          "expiryDate": _expiryDate!,
          "quantity": _quantityController.text,
        });
        _itemNameController.clear();
        _expiryDate = null;
        _quantityController.clear();
        _image = null;
      }
    });
  }

  void deleteItem(int index) {
    setState(() {
      inventoryList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Expiry Date Tracker'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Add New Inventory Item',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            SizedBox(height: 20),

            TextField(
              controller: _itemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _manualExpiryController,
              decoration: InputDecoration(
                labelText: 'Expiry Date (MM/YYYY or DD/MM/YYYY)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addManualItem,
              child: Text('Add Item'),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Scan Expiry Date from Image'),
            ),
            SizedBox(height: 10),

            // Display the inventory list
            Expanded(
              child: ListView.builder(
                itemCount: inventoryList.length,
                itemBuilder: (context, index) {
                  final item = inventoryList[index];
                  return ListTile(
                    title: Text('${item['name']} (Qty: ${item['quantity']})'),
                    subtitle: Text('Expiry Date: ${item['expiryDate']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => deleteItem(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
