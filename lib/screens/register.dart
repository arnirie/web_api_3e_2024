import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final api = 'psgc.gitlab.io';
  Map<String, String> regions = {};
  Map<String, String> provinces = {};
  Map<String, String> cities = {};
  bool isRegionsLoaded = false;
  bool isProvincesLoaded = false;
  bool isCitiesLoaded = false;
  var provinceController = TextEditingController();
  var citiesController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRegions();
  }

  void callAPI() async {
    var url = Uri.https('psgc.gitlab.io', 'api/island-groups/');
    var response = await http.get(url); //get request
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      print(data[0]['name']);
    }
  }

  //key: value
  Future<void> loadRegions() async {
    var url = Uri.https(api, 'api/regions/');
    var response = await http.get(url); //get request
    // print(response.body);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      //each item data list
      data.forEach((element) {
        var map = element as Map;
        print(map['regionName']);
        //"150000000":"Bangsamoro Autonomous Region in Muslim Mindanao"
        regions.addAll({map['code']: map['regionName']});
      });
    }
    setState(() {
      isRegionsLoaded = true;
    });
  }

  Future<void> loadProvinces(String regionCode) async {
    provinces.clear();
    citiesController.clear();
    var url = Uri.https(api, 'api/regions/$regionCode/provinces/');
    var response = await http.get(url); //get request
    // print(response.body);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      //each item data list
      data.forEach((element) {
        var map = element as Map;
        print(map['regionName']);
        //"150000000":"Bangsamoro Autonomous Region in Muslim Mindanao"
        provinces.addAll({map['code']: map['name']});
      });
    }
    setState(() {
      isProvincesLoaded = true;
    });
  }

  Future<void> loadCities(String provinceCode) async {
    citiesController.clear();
    cities.clear();
    var url =
        Uri.https(api, 'api/provinces/$provinceCode/cities-municipalities/');
    var response = await http.get(url); //get request
    // print(response.body);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      //each item data list
      data.forEach((element) {
        var map = element as Map;
        print(map['regionName']);
        //"150000000":"Bangsamoro Autonomous Region in Muslim Mindanao"
        cities.addAll({map['code']: map['name']});
      });
    }
    setState(() {
      isCitiesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const screenPadding = 12.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenPadding),
        child: Column(
          children: [
            if (isRegionsLoaded)
              DropdownMenu(
                width: width - screenPadding * 2,
                dropdownMenuEntries: regions.entries.map((entry) {
                  return DropdownMenuEntry(
                    value: entry.key,
                    label: entry.value,
                  );
                }).toList(),
                onSelected: (value) {
                  print(value);
                  provinceController.clear();
                  loadProvinces(value ?? '');
                },
              )
            else
              Center(
                child: CircularProgressIndicator(),
              ),
            if (isProvincesLoaded)
              DropdownMenu(
                controller: provinceController,
                width: width - screenPadding * 2,
                dropdownMenuEntries: provinces.entries
                    .map(
                      (entry) => DropdownMenuEntry(
                          value: entry.key, label: entry.value),
                    )
                    .toList(),
                onSelected: (value) {
                  loadCities(value ?? '');
                },
              ),
            if (isCitiesLoaded)
              DropdownMenu(
                controller: citiesController,
                width: width - screenPadding * 2,
                dropdownMenuEntries: cities.entries
                    .map(
                      (entry) => DropdownMenuEntry(
                          value: entry.key, label: entry.value),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
