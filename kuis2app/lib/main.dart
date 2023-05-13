import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

class JenisPinjaman {
  String idPinjaman;
  String namaPinjaman;
  JenisPinjaman({required this.idPinjaman, required this.namaPinjaman});
}

class DetilJenisPinjaman {
  String idDetilPinjaman;
  String namaDetilPinjaman;
  String bungaDetilPinjaman;
  String syariah;
  DetilJenisPinjaman(
      {required this.idDetilPinjaman,
      required this.namaDetilPinjaman,
      required this.bungaDetilPinjaman,
      required this.syariah});
}

class ListJenisPinjaman extends Cubit<List<JenisPinjaman>> {
  String selectedPinjaman = "1";

  ListJenisPinjaman() : super([]);

  void setSelectedPinjaman(String pilihanPinjaman) {
    selectedPinjaman = pilihanPinjaman;
    fetchData();
  }

  void setFromJson(List<dynamic> json) {
    List<JenisPinjaman> listJenisPinjaman = [];
    for (var val in json) {
      var idPinjaman = val["id"];
      var namaPinjaman = val["nama"][0];
      listJenisPinjaman.add(
          JenisPinjaman(idPinjaman: idPinjaman, namaPinjaman: namaPinjaman));
    }
    emit(listJenisPinjaman);
  }

  void fetchData() async {
    String url = "http://178.128.17.76:8000/jenis_pinjaman/$selectedPinjaman";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class ListDetilJenisPinjaman extends Cubit<List<DetilJenisPinjaman>> {
  String selectedDetilPinjaman = "1";

  ListDetilJenisPinjaman() : super([]);

  void setSelectedPinjaman(String pilihanPinjaman) {
    selectedDetilPinjaman = pilihanPinjaman;
    fetchDataDetil();
  }

  void setFromJson(List<dynamic> json) {
    List<DetilJenisPinjaman> listDetilJenisPinjaman = [];
    for (var val in json) {
      var idDetilPinjaman = val["id"];
      var namaDetilPinjaman = val["nama"][0];
      var bungaDetilPinjaman = val["bunga"][0];
      var syariah = val["is_syariah"][0];
      listDetilJenisPinjaman.add(DetilJenisPinjaman(
          idDetilPinjaman: idDetilPinjaman,
          namaDetilPinjaman: namaDetilPinjaman,
          bungaDetilPinjaman: bungaDetilPinjaman,
          syariah: syariah));
    }
    emit(listDetilJenisPinjaman);
  }

  void fetchDataDetil() async {
    String url =
        "http://178.128.17.76:8000/detil_jenis_pinjaman/$selectedDetilPinjaman";
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
    MultiBlocProvider(
      providers: [
        BlocProvider<ListJenisPinjaman>(
          create: (context) => ListJenisPinjaman(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  //pilihan dropdown
  final List<DropdownMenuItem<String>> pilihanPinjaman = [
    const DropdownMenuItem<String>(
      value: "0",
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App P2P',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My App P2P'),
          centerTitle: true,
        ),
        body: Column(
          //body
          children: [
            //nama
            Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                    '2106000, Sabila Rosad; 2100187, Muhammad Hilmy Rasyad Sofyan; Saya berjanji tidak akan berbuat curang data atau membantu orang lain berbuat curang')),
            //dropdown
            DropdownButton<String>(
              value: context.watch<ListJenisPinjaman>().selectedPinjaman,
              onChanged: (String? newValue) {
                context
                    .read<ListJenisPinjaman>()
                    .setSelectedPinjaman(newValue!);
              },
              items: pilihanPinjaman,
            ),
            Expanded(
              child: BlocBuilder<ListJenisPinjaman, List<JenisPinjaman>>(
                builder: (context, state) {
                  if (state.isNotEmpty) {
                    return ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state[index].idPinjaman,
                              ),
                              Text(state[index].namaPinjaman),
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
        ),
      ),
    );
  }
}
