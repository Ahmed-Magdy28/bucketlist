import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> bucketlist = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final Response response = await Dio().get(
          'https://test101-85ff2-default-rtdb.firebaseio.com/bucketlist.json');
      bucketlist = response.data;
      isLoading = false;

      setState(() {});
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Error: Unable to Fetch Data"),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bucket List'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                  onPressed: () {
                    getData();
                  },
                  icon: const Icon(Icons.refresh)),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            getData();
          },
          child: isLoading
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text("Is Loading")),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                )
              : ListView.builder(
                  itemCount: bucketlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, dynamic> item = bucketlist[index];
                    final String imageUrl = item['image'] ?? "No Image";
                    final String itemName = item['item'] ?? "unknown";
                    final String cost = item['cost']?.toString() ?? "0";
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(imageUrl)),
                        title: Text(itemName),
                        trailing: Text(cost),
                      ),
                    );
                  }),
        ));
  }
}
