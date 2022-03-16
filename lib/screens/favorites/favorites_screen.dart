import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:seashell/helpers/storage_helper.dart';
import 'package:seashell/services/api_service.dart';
import 'package:seashell/widgets/city_widget.dart';
import 'package:weather/weather.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({ required this.weather, Key? key}) : super(key: key);

  final List<Weather> weather;

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  final ApiService _provider = ApiService();

  List<dynamic> _favorites = [];

  bool _isFetchingData = false;

  @override
  initState() {
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                      itemCount: _favorites.length,
                      itemBuilder: (_, i) {
                        return Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: CityWidget(
                            cityName: _favorites[i],
                            weather: [],
                          ),
                        );
                      }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

