import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:price_calculate/presentation/some_data/some_data.dart';

class SomeData extends StatefulWidget {
  @override
  _SomeDataState createState() => _SomeDataState();
}

class _SomeDataState extends State<SomeData> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final fetchedCategories = await _firebaseService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      // Handle error (e.g., show a Snackbar)
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma\'lumotlar', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
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
                return MouseRegion(
                  onEnter: (_) => _showInkEffect(index),
                  onExit: (_) => _hideInkEffect(index),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailScreen(category: categories[index]),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(categories[index].icon, size: 50, color: Colors.teal),
                          const SizedBox(height: 6.0),
                          Flexible(
                            child: Text(
                              categories[index].name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
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

  void _showInkEffect(int index) {
    // Add your ink effect logic here
  }

  void _hideInkEffect(int index) {
    // Add your ink effect logic here
  }
}


class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) {
      return Category(
        name: doc['name'],
        icon: Icons.category, // Change this based on your data structure
        details: List<String>.from(doc['details']),
      );
    }).toList();
  }
}

