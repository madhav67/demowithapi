import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('http://ledetspa.jaydeep.website/application/types'));

  // Appropriate action depending upon the
  // server response
  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  bool? success;
  List<Types>? types;

  Album({this.success, this.types});

  Album.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['types'] != null) {
      types = <Types>[];
      json['types'].forEach((v) {
        types!.add(Types.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (types != null) {
      data['types'] = types!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Types {
  String? id;
  String? name;
  String? description;
  String? picture;
  String? basePrice;
  List<Duration>? duration;

  Types(
      {this.id,
      this.name,
      this.description,
      this.picture,
      this.basePrice,
      this.duration});

  Types.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    picture = json['picture'];
    basePrice = json['base_price'];
    if (json['duration'] != null) {
      duration = <Duration>[];
      json['duration'].forEach((v) {
        duration!.add(Duration.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['picture'] = picture;
    data['base_price'] = basePrice;
    if (duration != null) {
      data['duration'] = duration!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Duration {
  String? time;
  String? timeFormat;
  String? isDefault;
  String? price;

  Duration({this.time, this.timeFormat, this.isDefault, this.price});

  Duration.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    timeFormat = json['time_format'];
    isDefault = json['is_default'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['time_format'] = timeFormat;
    data['is_default'] = isDefault;
    data['price'] = price;
    return data;
  }
}

class ServiceView extends StatefulWidget {
  const ServiceView({Key? key}) : super(key: key);

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  late Future<Album> futureAlbum;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarOpacity: 0.0,
        centerTitle: true,
        toolbarHeight: 80,
        title: const Text(
          "Ledet Spa",
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.menu),
          color: Colors.black,
          tooltip: 'Menu Icon',
          onPressed: () {},
        ),
      ),
      body: FutureBuilder<Album>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Types>? data = snapshot.data!.types;
            return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 4,
                        child: ListTile(
                          isThreeLine: true,
                          leading: Image.network(data![index].picture!),
                          title: Column(
                            children: [
                              Text(data[index].name!),
                              const Text("Starting At"),
                              Text(data[index].basePrice!),
                            ],
                          ),
                          subtitle: Text(data[index].description!),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DetailScreen(),
                                settings: RouteSettings(
                                  arguments: data[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
//  late Future<Types> futureAlbum2;
//  @override
//  void initState() {
//    super.initState();
//    futureAlbum2 = fetchAlbum() as Future<Types>;
//  }

  @override
  Widget build(BuildContext context) {
    final Types task = ModalRoute.of(context)?.settings.arguments as Types;
    //   final Duration task2 =
    //     ModalRoute.of(context)?.settings.arguments as Duration;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Book a Massage",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: ListTile(
                isThreeLine: true,
                leading: Image.network(task.picture!),
                title: Column(
                  children: [
                    Text(task.name!),
                    const Text("Starting At"),
                    Text(task.basePrice!),
                  ],
                ),
                subtitle: Text(task.description!),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text("Duration"),
            const SizedBox(
              height: 15,
            ),
            //    FutureBuilder<Types>(
            //    future: futureAlbum2,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //  List<Duration>? data2 = snapshot.data!.duration;
            //       return Container(
            //  child: Row(
            // children: [
            //   Text(data2.time!),
            //   Text(data2.timeFormat!),
            // ],
            //  ),
            //        );
            //      }
            //  return const CircularProgressIndicator();
            //  },
            // ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
