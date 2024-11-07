import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart'; // Import for web

class SomeData extends StatelessWidget {
  final List<Category> categories = [
    Category(name: 'Hodimlar', details: []),
    Category(name: 'Stansiya narxlari', details: []),
    Category(name: 'Avtomobil kWh', details: []),
    Category(name: 'Boshqa xizmatlar', details: []),
  ];

  // Category icons
  final List<IconData> categoryIcons = [
    Icons.contact_mail_sharp,
    Icons.ev_station,
    Icons.local_car_wash,
    Icons.more
  ];

  SomeData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('Ma\'lumotlar', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            int crossAxisCount = width < 600 ? 2 : 4;

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailScreen(category: categories[index]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(categoryIcons[index], size: 50, color: Colors.teal),
                        const SizedBox(height: 6.0),
                        Text(categories[index].name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class Category {
  final String name;
  final List<String> details;

  Category({required this.name, required this.details});
}

class CategoryDetailScreen extends StatefulWidget {
  final Category category;

  CategoryDetailScreen({super.key, required this.category});

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final TextEditingController dataController = TextEditingController();
  late List<String> _categoryDetails;

  @override
  void initState() {
    super.initState();
    _categoryDetails = widget.category.details;
    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    SharedPreferences prefs;

    // Handle the initialization of shared_preferences depending on the platform (mobile or web)
    if (kIsWeb) {
      prefs = await SharedPreferences.getInstance();
    } else {
      prefs = await SharedPreferences.getInstance();
    }

    List<String>? storedData = prefs.getStringList(widget.category.name);
    if (storedData != null) {
      setState(() {
        _categoryDetails = storedData;
      });
    } else {
      _fetchDataFromFirebase(widget.category.name);
    }
  }

  Future<void> _fetchDataFromFirebase(String categoryName) async {
    try {
      var docRef = FirebaseFirestore.instance.collection('categories').doc(categoryName);
      var docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;
        List<String> fetchedDetails = List<String>.from(data['details'] ?? []);

        if (!listEquals(fetchedDetails, _categoryDetails)) {
          setState(() {
            _categoryDetails = fetchedDetails;
          });

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList(widget.category.name, fetchedDetails); // Save to SharedPreferences
        }
      }
    } catch (e) {
      print('Error fetching data from Firebase: $e');
    }
  }

  Future<void> _uploadDataToFirebase(String categoryName, String newData) async {
    try {
      var docRef = FirebaseFirestore.instance.collection('categories').doc(categoryName);
      var docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({
          'details': FieldValue.arrayUnion([newData]),
        });
      } else {
        await docRef.set({
          'details': [newData],
        });
      }

      _fetchDataFromFirebase(categoryName);
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  Future<void> _deleteDataFromFirebase(String categoryName, String dataToDelete) async {
    try {
      var docRef = FirebaseFirestore.instance.collection('categories').doc(categoryName);
      var docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({
          'details': FieldValue.arrayRemove([dataToDelete]),
        });
      }

      _fetchDataFromFirebase(categoryName);
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  Future<void> _updateDataInFirebase(String categoryName, String oldData, String newData) async {
    try {
      var docRef = FirebaseFirestore.instance.collection('categories').doc(categoryName);
      var docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({
          'details': FieldValue.arrayRemove([oldData]),
        });
        await docRef.update({
          'details': FieldValue.arrayUnion([newData]),
        });
      }

      _fetchDataFromFirebase(categoryName);
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add New Data'),
                    content: TextField(
                      controller: dataController,
                      decoration: const InputDecoration(hintText: 'Enter new data'),
                      onSubmitted: (value) {
                        if (dataController.text.isNotEmpty) {
                          _uploadDataToFirebase(widget.category.name, dataController.text);
                          Navigator.pop(context);
                        }
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (dataController.text.isNotEmpty) {
                            _uploadDataToFirebase(widget.category.name, dataController.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _categoryDetails.isEmpty ? 1 : _categoryDetails.length,
          itemBuilder: (context, index) {
            if (_categoryDetails.isEmpty) {
              return  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/3.2,),
                  const CircularProgressIndicator(),
                ],
              );
            }

            return InkWell(
              onTap: () {
                // Edit data
                dataController.text = _categoryDetails[index];
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Edit Data'),
                      content: TextField(
                        controller: dataController,
                        decoration: const InputDecoration(hintText: 'Edit data'),
                        onSubmitted: (value) {
                          if (dataController.text.isNotEmpty && dataController.text != _categoryDetails[index]) {
                            _updateDataInFirebase(widget.category.name, _categoryDetails[index], dataController.text);
                            Navigator.pop(context);
                          }
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (dataController.text.isNotEmpty && dataController.text != _categoryDetails[index]) {
                              _updateDataInFirebase(widget.category.name, _categoryDetails[index], dataController.text);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Data'),
                      content: const Text('Are you sure you want to delete this data?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteDataFromFirebase(widget.category.name, _categoryDetails[index]);
                            Navigator.pop(context);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _categoryDetails[index],
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
