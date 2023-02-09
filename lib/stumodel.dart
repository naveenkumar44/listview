import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    fetchPostData();
  }

  Future<void> fetchPostData() async {
    var response = await http.post(
        Uri.parse(
            'http://api.foodduke.com/public/api/get-delivery-restaurants'),
        body: {
          'latitude': '11.0248318',
          'longitude': '77.0120532',
        });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      debugPrint(data.toString());
      setState(() {
        _posts = data;
      });
    } else {
      const CircularProgressIndicator();
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Api Integaration'),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 50,
                        width: 50,
                        color: Colors.white,
                        child:
                            Image(image: NetworkImage(_posts[index]['image'])),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Text(_posts[index]['name'],
                        style: TextStyle(fontSize: 10, color: Colors.white)),
                  ],
                ),
                Text(_posts[index]['price_range'],
                    style: TextStyle(fontSize: 10, color: Colors.white)),
                Text(_posts[index]['delivery_time'],
                    style: TextStyle(fontSize: 10, color: Colors.white)),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(_posts[index]['description'],
                      style: TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
