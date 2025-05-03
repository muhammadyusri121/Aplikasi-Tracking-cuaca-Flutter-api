import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Result extends StatefulWidget {
  final String place;

  const Result({super.key, required this.place});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late Future<Map<String, dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = getDataDariAPI();
  }

  Future<Map<String, dynamic>> getDataDariAPI() async {
    final apiKey = '603662d6943ea5b81e5849000902424d';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal memuat data cuaca untuk ${widget.place}');
    }
  }

  String formatWaktu(int timestamp, int timezoneOffset) {
    final time = DateTime.fromMillisecondsSinceEpoch(
      (timestamp + timezoneOffset) * 1000,
      isUtc: true,
    );
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String getEmoji(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
        return '🌧️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
        return '🌫️';
      default:
        return '🌍';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(214, 195, 228, 227),
      appBar: AppBar(
        title: const Text(
          'Hasil Tracking',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 111, 190, 255),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                futureData = getDataDariAPI();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak tersedia."));
          }

          final data = snapshot.data!;
          final weather = data['weather'][0];
          final sunrise = formatWaktu(data['sys']['sunrise'], data['timezone']);
          final sunset = formatWaktu(data['sys']['sunset'], data['timezone']);
          final emoji = getEmoji(weather['main']);

          return Center(
            child: SingleChildScrollView(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: 1.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$emoji ${weather['main']}',
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 10),
                    Image.network(
                      'https://openweathermap.org/img/wn/${weather['icon']}@2x.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Kota: ${data['name']}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Suhu: ${data['main']['temp']} °C',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Terasa Seperti: ${data['main']['feels_like']} °C',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Kelembaban: ${data['main']['humidity']}%',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Deskripsi: ${weather['description']}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Kecepatan Angin: ${data['wind']['speed']} m/s',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Awan: ${data['clouds']['all']}%',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Matahari Terbit: $sunrise',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Matahari Terbenam: $sunset',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Kembali'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
