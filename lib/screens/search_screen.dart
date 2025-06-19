import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chefsmart/core/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  List<String> _availableIngredients = [];
  final List<String> _selectedIngredients = [];
  String? _selectedIngredient;
  List<String> _missingIngredients = [];
  String _recetaEncontrada = "";
  bool _isLoading = true; // <-- Añadido

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await _loadIngredients();
    await _loadRecetas();
    setState(() {
      _isLoading = false;
    });
  }

  // 🔄 **Carga ingredientes desde Firebase**
  Future<void> _loadIngredients() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('ingredientes').get();
    setState(() {
      _availableIngredients =
          snapshot.docs.map((doc) => doc['nombre'].toString()).toList();
    });
  }

  // 🔄 **Carga recetas desde Firebase**
  Future<void> _loadRecetas() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('recetas').get();
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        debugPrint(
          "Receta encontrada: ${doc['titulo']} - Ingredientes: ${doc['ingredientes']}",
        );
      }
    } else {
      debugPrint("No se encontraron recetas en Firebase.");
    }
  }

  // 🔍 **Compara ingredientes con recetas en Firebase**
  Future<void> _searchMissingIngredients() async {
    if (_selectedIngredients.isEmpty) return;

    final snapshot =
        await FirebaseFirestore.instance.collection('recetas').get();
    List<String> ingredientesFaltantes = [];
    String recetaEncontrada = "";

    for (var doc in snapshot.docs) {
      if (doc.data().containsKey('ingredientes')) {
        List<String> ingredientesReceta = List<String>.from(
          doc['ingredientes'],
        );

        int coincidencias =
            ingredientesReceta
                .where((i) => _selectedIngredients.contains(i))
                .length;

        if (coincidencias > 0) {
          ingredientesFaltantes =
              ingredientesReceta
                  .where((i) => !_selectedIngredients.contains(i))
                  .toList();
          recetaEncontrada = doc['titulo'];
          break;
        }
      }
    }

    setState(() {
      _missingIngredients = ingredientesFaltantes;
      _recetaEncontrada = recetaEncontrada;
    });

    debugPrint(
      _recetaEncontrada.isNotEmpty
          ? "Receta encontrada: $_recetaEncontrada"
          : "No se encontró una receta.",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar Recetas"),
        backgroundColor: AppColors.primary,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchField(
              "Título",
              "Ejemplo: Arepas",
              _titleController,
              Icons.fastfood,
            ),
            const SizedBox(height: 16),
            _buildSearchField(
              "Región",
              "Ejemplo: Antioquia",
              _regionController,
              Icons.location_on,
            ),
            const SizedBox(height: 16),
            _buildIngredientSelector(),
            const SizedBox(height: 16),
            _buildSelectedIngredients(),
            const SizedBox(height: 16),
            _buildSearchButton(),
            _buildMissingIngredients(),
          ],
        ),
      ),
    );
  }

  // ✅ **Campo de búsqueda**
  Widget _buildSearchField(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(),
            prefixIcon: Icon(icon),
          ),
        ),
      ],
    );
  }

  // ✅ **Selector de ingredientes**
  Widget _buildIngredientSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selecciona un ingrediente",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<String>(
          value: _selectedIngredient,
          items:
              _availableIngredients
                  .where(
                    (ingredient) => !_selectedIngredients.contains(ingredient),
                  )
                  .map(
                    (ingredient) => DropdownMenuItem(
                      value: ingredient,
                      child: Text(ingredient),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() => _selectedIngredient = value);
          },
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            if (_selectedIngredient != null &&
                !_selectedIngredients.contains(_selectedIngredient)) {
              setState(() {
                _selectedIngredients.add(_selectedIngredient!);
                _selectedIngredient = null;
              });
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text(
            "Agregar Ingrediente",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ✅ **Lista de ingredientes seleccionados**
  Widget _buildSelectedIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ingredientes seleccionados:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (_selectedIngredients.isNotEmpty)
          Wrap(
            spacing: 8,
            children:
                _selectedIngredients.map((ingredient) {
                  return Chip(
                    label: Text(ingredient),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        _selectedIngredients.remove(ingredient);
                      });
                    },
                  );
                }).toList(),
          )
        else
          const Text(
            "No hay ingredientes seleccionados",
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
  }

  // ✅ **Botón para buscar recetas**
  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: _searchMissingIngredients,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      child: const Text("Buscar Receta", style: TextStyle(color: Colors.white)),
    );
  }

  // ✅ **Lista de ingredientes faltantes**
  Widget _buildMissingIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_recetaEncontrada.isNotEmpty)
          Text(
            "Receta encontrada: $_recetaEncontrada",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 8),
        if (_missingIngredients.isNotEmpty)
          Wrap(
            spacing: 8,
            children:
                _missingIngredients.map((ingredient) {
                  return Chip(
                    label: Text(ingredient),
                    backgroundColor: Colors.redAccent,
                  );
                }).toList(),
          )
        else
          const Text(
            "Todos los ingredientes están presentes o no hay coincidencias.",
            style: TextStyle(color: Colors.green),
          ),
      ],
    );
  }
}
