import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShopFormPage extends StatefulWidget {
  const ShopFormPage({super.key});

  @override
  State<ShopFormPage> createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  DateTime? date;
  String? dateError;

  void onSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (date == null) {
      setState(() {
        dateError = "Please select a date";
      });
      return;
    }
    final name = nameController.text;
    final price = int.tryParse(priceController.text)!;
    final desc = descController.text;
    showDialog(
        context: context,
        builder: (context) => productPopUp(name, price, desc, context));
  }

  AlertDialog productPopUp(
      String name, int price, String desc, BuildContext context) {
    return AlertDialog(
      title: const Text("Product Details"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name: $name"),
          Text("Price: $price"),
          Text("Description: $desc"),
          Text("Date: ${DateFormat('d MMMM yyyy').format(date!)}"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: const Text("Confirm"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Product Form',
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Product Name",
                    labelText: "Product Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Price",
                    labelText: "Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Price cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Price must be a number!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(
                    hintText: "Description",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Description cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: date == null
                        ? "No date selected"
                        : DateFormat('d MMMM yyyy').format(date!),
                  ),
                  decoration: InputDecoration(
                    hintText: "Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2024),
                        );
                        setState(() {
                          date = selectedDate;
                        });
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                if (dateError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    dateError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () => onSave(context),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
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
