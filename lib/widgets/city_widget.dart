import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seashell/helpers/storage_helper.dart';
import 'package:seashell/services/api_service.dart';
import 'package:weather/weather.dart';

class CityWidget extends StatefulWidget {
  const CityWidget({ required this.weather, this.cityName, Key? key}) : super(key: key);

  final List<Weather> weather;
  final String? cityName;

  @override
  _CityWidgetState createState() => _CityWidgetState();
}

class _CityWidgetState extends State<CityWidget> {

  List<dynamic> _favorites = [];

  List<Weather> _weather = [];

  bool _isFetchingData = true;

  final ApiService _provider = ApiService();

  @override
  void initState() {
    super.initState();

    _getStartup();
  }

  void _getStartup() async {
    final String favorite = await StorageHelper.readData('favorites') ?? '';

    if (favorite == '') {
      final List<dynamic> favorites = [];

      StorageHelper.saveData('favorites', json.encode(favorites));

      setState(() {
        _favorites = favorites;
      });
    } else {
      final List<dynamic> favorites = json.decode(favorite);

      StorageHelper.saveData('favorites', json.encode(favorites));

      setState(() {
        _favorites = favorites;
      });
    }

    if (widget.weather.isEmpty && widget.cityName != '' && mounted) {
      setState(() {
        _isFetchingData = true;
      });

      var results = await _provider.getCityWeatherByName(widget.cityName!);

      setState(() {
        _weather = results;
        _isFetchingData = false;
      });
    } else {
      setState(() {
        _isFetchingData = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toggleFavorites(String cityName) async {
    final String favorite = await StorageHelper.readData('favorites') ?? '';

    if (favorite == '') {
      final List<dynamic> favorites = [cityName];

      StorageHelper.saveData('favorites', json.encode(favorites));

      setState(() {
        _favorites = favorites;
      });
    } else {
      final List<dynamic> favorites = json.decode(favorite);

      if (favorites.contains(cityName)) {
        favorites.remove(cityName);
      } else {
        favorites.add(cityName);
      }

      StorageHelper.saveData('favorites', json.encode(favorites));

      setState(() {
        _favorites = favorites;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_isFetchingData) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 260.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            SizedBox(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                strokeWidth: 2.0,
              ),
            ),
          ],
        ),
      );
    } else {
      if (widget.weather.isEmpty && widget.cityName == '') {
        return const Text(
            'Could not find a match!'
        );
      }

      return Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        widget.weather.isEmpty ? _weather[0].areaName! : widget.weather[0].areaName!
                    ),
                    Text(
                        widget.weather.isEmpty ? _weather[0].temperature!.fahrenheit!.toStringAsPrecision(2) : widget.weather[0].temperature!.fahrenheit!.toStringAsPrecision(2)
                    ),
                    Text(
                        widget.weather.isEmpty ? _weather[0].tempMax!.fahrenheit!.toStringAsPrecision(2) : widget.weather[0].tempMax!.fahrenheit!.toStringAsPrecision(2)
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                      icon: Icon(
                          widget.weather.isEmpty ? _favorites.contains(widget.cityName!) ? Icons.favorite : Icons.favorite_border : _favorites.contains(widget.weather[0].areaName!) ? Icons.favorite : Icons.favorite_border
                      ),
                      onPressed: () {
                        widget.weather.isEmpty ? _toggleFavorites(widget.cityName!) : _toggleFavorites(widget.weather[0].areaName!);
                      }
                  )
                ],
              )
            ]
        ),
      );
    }
  }
}