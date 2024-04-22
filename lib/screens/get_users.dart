import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetUsersScreen extends StatefulWidget {
  const GetUsersScreen({super.key});

  @override
  State<GetUsersScreen> createState() => _GetUsersScreenState();
}

class _GetUsersScreenState extends State<GetUsersScreen> {
  Future<List<dynamic>> getUsers() async {
    List data = [];
    //http://192.168.103.130/mad/getusers.php
    var url = Uri.http('192.168.103.130', 'mad/getusers.php');
    var response = await http.get(url);
    // print(response.body);
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    }
    return data;
  }

  Future<void> register() async {
    var url = Uri.http('192.168.103.130', 'mad/register.php');
    var response = await http.post(
      url,
      body: {
        'username': 'arni',
        'userpass': '123',
        'fullname': 'arni tamayo',
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Record Inserted')),
        );
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        actions: [
          IconButton(
            onPressed: register,
            icon: Icon(Icons.app_registration),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var users = snapshot.data!;
          print(users);
          return ListView.builder(
            itemBuilder: (_, index) {
              return Card(
                child: ListTile(
                  title: Text(users[index]['fullname']),
                ),
              );
            },
            itemCount: users.length,
          );
        },
      ),
    );
  }
}
