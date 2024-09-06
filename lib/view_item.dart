import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ViewItemScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String cost;
  final int index;
  const ViewItemScreen(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.cost,
      required this.index});

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  var logger = Logger();

  Future<void> deleteItem() async {
    Navigator.pop(context);
    try {
      await Dio().delete(
          'https://test101-85ff2-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json');
      if (mounted) {
        Navigator.pop(context, 'refresh');
      }
    } catch (e) {
      logger.d(e);
    }
  }

  Future<void> markAsCompletedItem() async {
    Map<String, dynamic> data = {"completed": true};
    try {
      await Dio().patch(
          'https://test101-85ff2-default-rtdb.firebaseio.com/bucketlist/${widget.index}.json',
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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            PopupMenuButton(onSelected: (value) {
              if (value == 1) {
                markAsCompletedItem();
              } else if (value == 2) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete'),
                        content: const Text(
                            'Are you sure you want to delete this item?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                deleteItem();
                              },
                              child: const Text('Delete')),
                        ],
                      );
                    });
              } else {
                // do nothing
              }
            }, itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.check),
                        Text('Mark as Completed'),
                      ],
                    )),
                const PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        Text('Delete'),
                      ],
                    )),
              ];
            })
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ));
  }
}
