import 'package:aplication2/pages/result.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController placeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        backgroundColor: const Color.fromARGB(214, 195, 228, 227),
        appBar: AppBar(
          title: const Text(
            'Aplikasi Tracking Cuaca',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 111, 190, 255),
          centerTitle: true,
        ),

        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Masukkan Nama Kota',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Kota',
                    hintText: 'ex: Sampang',
                  ),

                  controller: placeController,
                ),

                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    final input = placeController.text.trim();
                    if (input.isEmpty) {
                      // Tampilkan popup jika kosong
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Peringatan'),
                              content: const Text(
                                'Mohon isi nama kota terlebih dahulu.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Oke'),
                                ),
                              ],
                            ),
                      );
                    } else {
                      // Lanjut ke halaman Result jika tidak kosong
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Result(place: input),
                        ),
                      );
                    }
                  },

                  child: const Text('Cari'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
