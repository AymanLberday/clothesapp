import 'package:clothes_app/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:syna_app/services/cart_service.dart';

class ItemDetailPage extends StatefulWidget {
  final String itemId; 
  const ItemDetailPage({super.key, required this.itemId});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final DatabaseReference database = FirebaseDatabase.instance.ref(); // Référence à la bd Firebase
  Map<String, dynamic>? itemData; // stocker les données de l'article

  @override
  void initState() {
    super.initState();
    _loadItemData(); // la fctt pour charger les données de l'articlequand la page est initialisée
  }

  // charger les données de Firebase
  Future<void> _loadItemData() async {
    final snapshot = await database.child('clothes/${widget.itemId}').get(); // Récupérer les données de l'article avec l'ID spécifique
    if (snapshot.exists) {
      setState(() {
        itemData = Map<String, dynamic>.from(snapshot.value as Map); // Si les données existent, les stocker
      });
    }
  }

  // ajout l'article au panier
  void _addToCart(BuildContext context) {
    if (itemData != null) {
      print("Adding to cart: ${itemData!}"); // Debug print
      CartService.addItem(itemData!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (itemData == null) { // Si les données de l'article ne sont pas encore chargées, afficher un indicateur de chargement
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          itemData!['title'] ?? 'Détail article',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 139, 139, 135),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      itemData!['image'],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    width: 600,  // Same width as image container
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Catégorie: ${itemData!['category']}',
                          style: const TextStyle(fontSize: 18, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Taille: ${itemData!['size']}',
                          style: const TextStyle(fontSize: 18, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Marque: ${itemData!['brand']}',
                          style: const TextStyle(fontSize: 18, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Prix: ${itemData!['price']} MAD',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Retour',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _addToCart(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Ajouter au panier',
                      style: TextStyle(color: Colors.white),
                    ),
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