import 'package:flutter/material.dart';

class ClassificationMedicine extends StatefulWidget {
  @override
  _ClassificationMedicineState createState() => _ClassificationMedicineState();
}

class _ClassificationMedicineState extends State<ClassificationMedicine> {
  String _selectedCategory = ''; // Categoria selecionada

  final List<Map<String, String>> _categories = [
    {'label': 'Sem Tarja', 'value': 'A'},
    {'label': 'Tarja Amarela', 'value': 'B'},
    {'label': 'Tarja Vermelha', 'value': 'C'},
    {'label': 'Tarja Preta', 'value': 'D'},
  ];

  @override
  Widget build(BuildContext context) {
    // Obtendo o tamanho da tela
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Classificação dos Medicamentos'),
        ),
        backgroundColor: Colors.grey[600],
      ),
      body: Stack(
        children: [
          // Imagem de fundo responsiva
          Positioned.fill(
            child: Image.asset(
              'images/tarjas.jpg',
              fit: screenWidth > 600
                  ? BoxFit.cover
                  : BoxFit.fitHeight, // Ajuste para telas maiores ou menores
              alignment: Alignment.center,
            ),
          ),
          // Centralizar botões na parte inferior
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double maxWidth = constraints.maxWidth > 600
                        ? 600
                        : constraints
                            .maxWidth; // Limita a largura em telas maiores
                    return Center(
                      child: SizedBox(
                        width: maxWidth,
                        height: 50, // Altura dos botões
                        child: ListView.builder(
                          scrollDirection:
                              Axis.horizontal, // Rolagem horizontal
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ChoiceChip(
                                label: Text(
                                  category['label']!,
                                  style: TextStyle(
                                    color:
                                        _selectedCategory == category['value']
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                                selected:
                                    _selectedCategory == category['value'],
                                onSelected: (isSelected) {
                                  setState(() {
                                    _selectedCategory =
                                        isSelected ? category['value']! : '';
                                  });
                                  if (isSelected) {
                                    Navigator.pushNamed(
                                      context,
                                      '/list-medicine',
                                      arguments: category['value'],
                                    );
                                  }
                                },
                                selectedColor: Colors.grey[600],
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
