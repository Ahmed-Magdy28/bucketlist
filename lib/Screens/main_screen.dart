import 'package:bucketlist/Screens/add_screen.dart';
import 'package:bucketlist/Screens/view_screen.dart';
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
  bool isError = false;
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
      if (response.data is List) {
        bucketlist = response.data.where((element) => element != null).toList();
      } else {
        bucketlist = [];
      }
      isLoading = false;
      isError = false;
      setState(() {});
    } catch (e) {
      isLoading = false;
      isError = true;
      setState(() {});
    }
  }

  Widget errorWidget({required String errorText}) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error),
        const SizedBox(height: 20),
        Text(errorText),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: getData, child: const Text("Try Again"))
      ],
    ));
  }

  Widget loadingWidget() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text("Is Loading")),
        SizedBox(height: 20),
        CircularProgressIndicator(),
      ],
    );
  }

  Widget listDataWidget() {
    List<dynamic> filteredList = bucketlist
        .where((element) => !(element?["completed"] ?? false))
        .toList();

    return (filteredList.isEmpty)
        ? const Center(child: Text("All Completed"))
        : ListView.builder(
            itemCount: bucketlist.length,
            itemBuilder: (BuildContext context, int index) {
              return (bucketlist[index] is Map &&
                      !(bucketlist[index]?["completed"] ?? false))
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ViewItemScreen(
                              title: bucketlist[index]['item'] ?? "",
                              imageUrl: bucketlist[index]['image'] ?? "",
                              cost:
                                  bucketlist[index]['cost']?.toString() ?? "0",
                              index: index,
                            );
                          })).then((value) {
                            if (value == 'refresh') {
                              getData();
                            }
                          });
                        },
                        leading: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                NetworkImage(bucketlist[index]['image'] ?? "")),
                        title: Text(bucketlist[index]['item'] ?? ""),
                        trailing:
                            Text(bucketlist[index]['cost']?.toString() ?? "0"),
                      ),
                    )
                  : const SizedBox();
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddbucketListScreen(
                  newIndex: bucketlist.length,
                );
              })).then((value) {
                if (value == 'refresh') {
                  getData();
                }
              });
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.add)),
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
              ? loadingWidget()
              : isError
                  ? errorWidget(errorText: "connection error")
                  : bucketlist.isEmpty
                      ? const Center(
                          child: Text("No Data"),
                        )
                      : listDataWidget(),
        ));
  }
}
