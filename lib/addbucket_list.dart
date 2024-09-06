import 'package:flutter/material.dart';

class AddbucketListScreen extends StatefulWidget {
  const AddbucketListScreen({super.key});

  @override
  State<AddbucketListScreen> createState() => _AddbucketListScreenState();
}

class _AddbucketListScreenState extends State<AddbucketListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bucket List'),
      ),
      body: const Center(
        child: Text('Add Bucket List'),
      ),
    );
  }
}
