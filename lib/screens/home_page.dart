import 'package:clothes_app/screens/ItemDetail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'bar.dart';  // Importer le widget Bar


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> _clothingItems = [];
  int _currentIndex = 0;  // Pour suivre la page active

  @override
  void initState() {
    super.initState();
    _fetchClothingItems();
  }
  void _fetchClothingItems() async {
    final snapshot = await _database.child('clothes').get();
    if (snapshot.exists) {
      final items = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        _clothingItems = items.entries.map((entry) {
          return {
            'id': entry.key,
            ...Map<String, dynamic>.from(entry.value as Map),
          };
        }).toList();
      });
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Vous pouvez gérer la navigation en fonction de l'index sélectionné ici
    if (index == 1) {
      // Naviguer vers la page Panier
    } else if (index == 2) {
      // Naviguer vers la page Profil
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'BLACK&WHITE',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 139, 139, 135),
        child: _clothingItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _clothingItems.length,
              itemBuilder: (context, index) {
                final item = _clothingItems[index];
                return GestureDetector(
                  onTap: () {
                    print('Item clicked: ${item['title']}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                            builder: (context) => ItemDetailPage(itemId: item['id']),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(
                        item['image'] ?? '', 
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading image: ${item['image']}');
                          return const Icon(Icons.image_not_supported);
                        },
                      ),
                      title: Text(item['title'] ?? 'No Title'),
                      subtitle: Text('Taille: ${item['size'] ?? 'N/A'}\nPrix: ${item['price'] ?? 'N/A'} MAD'),
                    ),
                  ),
                );
              },
            ),
      ),      bottomNavigationBar: Bar(  // Utiliser le widget Bar
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}