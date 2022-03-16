import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:seashell/screens/favorites/favorites_screen.dart';
import 'package:seashell/services/api_service.dart';
import 'package:seashell/widgets/city_widget.dart';
import 'package:weather/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Timer? _debouncer;

  late TextEditingController _searchBarField;

  List<Weather> _weather = [];

  final ApiService _provider = ApiService();

  bool _isFetchingData = false;

  @override
  initState() {
    super.initState();
    _searchBarField = TextEditingController();
  }




  //
  // _onSearchChanged(String query) {
  //   if (_debouncer?.isActive ?? false) _debouncer!.cancel();
  //   _debouncer = Timer(const Duration(milliseconds: 500), () {
  //     // do something with query
  //   });
  // }

  // make api call to fetch data
  void _getWeatherByCity(String value) async {
    bool hasError = false;

    setState(() {
      _isFetchingData = true;
    });

    var results = await _provider.getCityWeatherByName(value).onError((error, stackTrace) => {
      hasError = true
    });



    if (!hasError) {
      setState(() {
        _weather = results;
        _isFetchingData = false;
      });
    } else {
      setState(() {
        _weather = [];
        _isFetchingData = false;
      });
    }
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    _searchBarField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            children: [
              TextFormField(
                onChanged: (String value) async {
                  // _validatePhoneNumber();
                },
                controller: _searchBarField,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.text,
                maxLength: 50,
                onFieldSubmitted: (value) {
                  _getWeatherByCity(value);
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.close
                    ),
                    onPressed: () {
                      setState(() {
                        _searchBarField.text = '';
                      });
                    },
                  ),
                  counterText: '',
                  fillColor: const Color(0xffadb795),
                  focusColor: const Color(0xffadb795),
                  hoverColor: const Color(0xffadb795),
                  labelText: 'City Name',
                  helperText: '',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffadb795),
                    ),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffadb795),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffadb795),
                    ),
                  ),
                ),
              ),

              _isFetchingData ? SizedBox(
                width: MediaQuery.of(context).size.width,
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
              ) : CityWidget(weather: _weather, cityName: ''),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FavoritesScreen(
                        weather: [],
                      )
                    )
                  );
                },
                child: const Text('Go To Favorites'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

