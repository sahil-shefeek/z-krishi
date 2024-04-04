import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  //final String apiKey =
  //'YOUR_API_KEY_HERE'; // Remember to replace with your actual OpenWeatherMap API key
  final String baseUrl = 'https://open-meteo.com/';

  Future<Map<String, dynamic>> getCurrentWeather(
      double latitude, double longitude) async {
    final uri = Uri.parse(
        '$baseUrl?lat=$latitude&lon=$longitude'); // Added &units=metric to get temperature in Celsius
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load weather data. Status code: ${response.statusCode}');
    }
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();

  Future<void> _fetchAndShowWeather(BuildContext context) async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final weatherData = await _weatherService.getCurrentWeather(
          position.latitude, position.longitude);
      final temperature = weatherData['main']['temp'].toString();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Current Weather"),
          content: Text('Temperature: $temperature °C'),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to get weather data: $e"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: Navigator.of(context).pop,
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _fetchAndShowWeather(context),
          child: Text('Show Weather'),
        ),
      ),
    );
  }
}
