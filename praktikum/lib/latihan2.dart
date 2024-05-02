import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

// menampung data hasil pemanggilan API
class Activity {
  String aktivitas;
  String jenis;

// Konstruktor dengan parameter bernama 'aktivitas' dan 'jenis' yang wajib diisi
  Activity({required this.aktivitas, required this.jenis}); 

  //untuk membuat objek Activity dari data JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    // Mengembalikan objek Activity dengan data yang sesuai dari JSON
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; //menampung hasil

  // URL endpoint untuk mengambil data aktivitas dari API
  String url = "https://www.boredapi.com/api/activity";

  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: "");
  }

  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // jika server mengembalikan 200 OK (berhasil),
      // parse json
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // jika gagal (bukan  200 OK),
      // lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = init();
  }

  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData();
                });
              },
              child: const Text("Saya bosan ..."),
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas),
                      Text("Jenis: ${snapshot.data!.jenis}")
                    ]));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // default: loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}