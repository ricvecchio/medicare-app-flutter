import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Medicamento {
  final String nome;
  final String descricao;
  final IconData icone;
  final String detalhada;
  final String tipo;

  Medicamento({
    required this.nome,
    required this.descricao,
    required this.icone,
    required this.detalhada,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'icone': icone.codePoint,
      'detalhada': detalhada,
      'tipo': tipo,
    };
  }

  factory Medicamento.fromMap(Map<String, dynamic> map) {
    return Medicamento(
      nome: map['nome'],
      descricao: map['descricao'],
      icone: map['icone'] is int
          ? IconData(map['icone'],
              fontFamily: 'MaterialIcons') // Usa o codePoint diretamente
          : _getIconFromName(map['icone']), // Converte a String para IconData
      detalhada: map['detalhada'],
      tipo: map['tipo'],
    );
  }
}

// Converte o nome do ícone para um IconData constante
IconData _getIconFromName(String iconName) {
  switch (iconName) {
    case 'home':
      return Icons.home;
    case 'alarm':
      return Icons.alarm;
    case 'medical_services':
      return Icons.medical_services;
    // Adicione outros ícones usados no app
    default:
      return Icons.help; // Ícone padrão caso o nome não seja encontrado
  }
}

class ListMedicine extends StatefulWidget {
  @override
  _ListMedicineState createState() => _ListMedicineState();
}

class _ListMedicineState extends State<ListMedicine> {
  List<Medicamento> todosMedicamentos = [];
  List<Medicamento> medicamentosFiltrados = [];
  late String tipoMedicamento;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.settings.arguments != null) {
      tipoMedicamento = ModalRoute.of(context)!.settings.arguments as String;
      _loadMedicamentos(); // Sempre recarregar ao alterar a rota
    }
  }

  _loadMedicamentos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedMedicamentos = prefs.getString('medicamentos');

    if (savedMedicamentos != null) {
      List<dynamic> decoded = json.decode(savedMedicamentos);
      setState(() {
        todosMedicamentos =
            decoded.map((item) => Medicamento.fromMap(item)).toList();
        medicamentosFiltrados = todosMedicamentos
            .where((med) => med.tipo == tipoMedicamento)
            .toList();
      });
    } else {
      // Não faz nada se não houver medicamentos armazenados
      setState(() {
        todosMedicamentos = [];
        medicamentosFiltrados = [];
      });
    }
  }

  _saveMedicamentos() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> mappedMedicamentos =
        todosMedicamentos.map((e) => e.toMap()).toList();
    String encodedMedicamentos = json.encode(mappedMedicamentos);
    await prefs.setString('medicamentos', encodedMedicamentos);
  }

  String _getPageTitle(String tipo) {
    switch (tipo) {
      case 'A':
        return 'Sem Tarja: Medicamentos de baixo risco isentos de prescrição médica (MIPs)';
      case 'B':
        return 'Tarja Amarela: Medicamentos para venda sob prescrição médica, mas considerados de menor risco, com controle moderado';
      case 'C':
        return 'Tarja Vermelha: Medicamentos que exigem receita médica e são considerados de risco maior, porém não necessitam de retenção da receita';
      case 'D':
        return 'Tarja Preta: Medicamentos controlados que possuem potencial de causar dependência física ou psicológica, necessitam receita especial';
      default:
        return 'Medicamentos';
    }
  }

  void _addNewMedicine(BuildContext context) async {
    final newMedicine = await Navigator.pushNamed(
      context,
      '/add-medicine',
      arguments: tipoMedicamento,
    );
    if (newMedicine != null && newMedicine is Medicamento) {
      setState(() {
        todosMedicamentos.add(newMedicine);
        medicamentosFiltrados = todosMedicamentos
            .where((med) => med.tipo == tipoMedicamento)
            .toList();
      });
      _saveMedicamentos(); // Persistência após adicionar
      _loadMedicamentos(); // Recarrega a lista para refletir mudanças
    }
  }

  void _showDetails(BuildContext context, Medicamento medicamento) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                medicamento.nome,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                medicamento.descricao,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              Text(
                medicamento.detalhada,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Flexible(
          child: Text(
            _getPageTitle(tipoMedicamento),
            style: TextStyle(
                fontSize: 18), // Ajuste o tamanho da fonte se necessário
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
        backgroundColor: Colors.grey[600],
      ),
      backgroundColor: Colors.grey[300],
      body: ListView.builder(
        itemCount: medicamentosFiltrados.length,
        itemBuilder: (context, index) {
          final medicamento = medicamentosFiltrados[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 5,
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: Icon(medicamento.icone, size: 40, color: Colors.blue),
              title: Text(
                medicamento.nome,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                medicamento.descricao,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              trailing:
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                _showDetails(context, medicamento);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewMedicine(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[600],
      ),
    );
  }
}
