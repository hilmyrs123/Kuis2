import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

class JenisPinjaman {
  String id;
  String namaPinjaman;
  JenisPinjaman({required this.id, required this.namaPinjaman}); //konstruktor
}

class ListJenisPinjaman extends ChangeNotifier {
  String selectedPinjaman = "1";

  List<JenisPinjaman> listJenisPinjaman = <JenisPinjaman>[];

  ListJenisPinjaman({required this.listJenisPinjaman}) {
    fetchData();
  }

  void setSelectedPinjaman(String jenis) {
    selectedPinjaman = jenis;
    fetchData();
  }

  void setFromJson(List<dynamic> json) {
    listJenisPinjaman.clear();
    for (var val in json) {
      var id = val["id"];
      var namaPinjaman = val["nama"][0];
      listJenisPinjaman.add(JenisPinjaman(id: id, namaPinjaman: namaPinjaman));
      notifyListeners();
    }
  }

  void fetchData() async {
    String url =
        "http://178.128.17.76:8000/jenis_pinjaman/search?id=$selectedPinjaman";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider<ListJenisPinjaman>(
      create: (context) => ListJenisPinjaman(listJenisPinjaman: []),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

//pilihan dropdown
  final List<DropdownMenuItem<String>> pilihan = [
    const DropdownMenuItem<String>(
      child: Text("Pilih jenis pinjaman"),
    ),
    const DropdownMenuItem<String>(
      value: "1",
      child: Text("Jenis Pinjaman 1"),
    ),
    const DropdownMenuItem<String>(
      value: "2",
      child: Text("Jenis Pinjaman 2"),
    ),
    const DropdownMenuItem<String>(
      value: "3",
      child: Text("Jenis Pinjaman 3"),
    )
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App P2P',
      home: Scaffold(
          appBar: AppBar(
            title: Text('My App P2P'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              //nama
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      '2106000, Sabila Rosad; 2100187, Muhammad Hilmy Rasyad Sofyan; Saya berjanji tidak akan berbuat curang data atau membantu orang lain berbuat curang')),
              //dropdown
              Consumer<ListJenisPinjaman>(
                builder: (context, model, child) {
                  return DropdownButton<String>(
                    value: model.selectedPinjaman,
                    onChanged: (String? newValue) {
                      model.setSelectedPinjaman(newValue!);
                    },
                    items: pilihan,
                  );
                },
              ),
              Expanded(
                child: Consumer<ListJenisPinjaman>(
                  builder: (context, model, child) {
                    if (model.listJenisPinjaman.isNotEmpty) {
                      return ListView.builder(
                        itemCount: model.listJenisPinjaman.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(border: Border.all()),
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  model.listJenisPinjaman[index].id,
                                ),
                                Text(
                                  model.listJenisPinjaman[index].namaPinjaman,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }
}
