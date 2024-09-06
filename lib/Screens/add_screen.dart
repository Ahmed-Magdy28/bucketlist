import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddbucketListScreen extends StatefulWidget {
  final int newIndex;

  const AddbucketListScreen({super.key, required this.newIndex});

  @override
  State<AddbucketListScreen> createState() => _AddbucketListScreenState();
}

class _AddbucketListScreenState extends State<AddbucketListScreen> {
  var logger = Logger();
  TextEditingController itemController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  Future<void> addData() async {
    Map<String, dynamic> data = {
      "item": itemController.text,
      "cost": costController.text,
      "image": imageUrlController.text.isEmpty
          ? "https://via.placeholder.com/150"
          : imageUrlController.text,
      "completed": false
    };
    try {
      await Dio().patch(
          'https://test101-85ff2-default-rtdb.firebaseio.com/bucketlist/${widget.newIndex}.json',
          data: data);
      if (mounted) {
        Navigator.pop(context, 'refresh');
      }
    } catch (e) {
      logger.d(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var addForm = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bucket List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: addForm,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: itemController,
                decoration: const InputDecoration(label: Text("Item")),
                validator: (value) {
                  if (value.toString().length < 5) {
                    return "Please enter more than 5 characters";
                  } else if (value == null || value.isEmpty) {
                    return "Please enter a valid item";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: costController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration:
                    const InputDecoration(label: Text("Estimated Cost")),
                validator: (value) {
                  if (value.toString().length < 5) {
                    return "Please enter more than 5 characters";
                  } else if (value == null || value.isEmpty) {
                    return "Please enter a valid item";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: imageUrlController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(label: Text("Image URL")),
                validator: (value) {
                  if (value.toString().length < 5) {
                    return "Please enter more than 5 characters";
                  } else if (value == null || value.isEmpty) {
                    return "Please enter a valid item";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          if (addForm.currentState!.validate()) {
                            addData();
                          } else {
                            logger.d("Form is not valid");
                          }
                        },
                        child: const Text("Add to Bucket List")),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
