import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'dart:async';

class News extends StatelessWidget {
  const News({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Scaffold(
          body: Center(
            child: GetNews(),
          ),
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/LOGO.png"),
                      fit: BoxFit.contain
                  )
              ),
              child: Text('Krial Education'),
            ),
            ListTile(
              title: const Text('Продукция'),
              onTap: () {
                // Update the state of the app
                Navigator.pushNamed(context, '/products');
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Стадии сделки'),
              onTap: () {
                // Update the state of the app
                Navigator.pushNamed(context, '/sales');
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Новости'),
              onTap: () {
                // Update the state of the app
                Navigator.pushNamed(context, '/news');
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GetNews extends StatefulWidget{
  const GetNews({super.key});

  @override
  State<StatefulWidget> createState() => _NewsState();
}

Future<List> getData() async{
  http.Response response = await http.get(Uri.parse("https://bbgl.ru/news"));
  dom.Document document = parser.parse(response.body);
  //final response = http.Client().get(Uri.parse("https://bbgl.ru/news"));
  List<Event> events = <Event>[];
  List <dom.Element> newsBlocks = document.getElementsByClassName("one-new");
  for (final el in newsBlocks){
    events.add(Event(el.getElementsByClassName("title").first.text, el.getElementsByClassName("description").first.text));
  }
  print(events.toString());
  return events;
}
class Event{
  late final String title;
  late final String description;

  Event(String tit, String desc){
    title = tit;
    description = desc.split("\n")[1].split("Читать").first;
  }
  String get_title(){
    var temp = this.title.replaceAll(' ', '');
    return temp;
  }
  String get_desc(){
    return description;
  }
  @override
  String toString() {
    //this.description = this.description.split("\n").first;
    String res = this.title.trim() + "\n" + this.description.trim();
    return res;
  }
}
class _NewsState extends State<GetNews>{
  late Future<List> events;
  @override
  void initState(){
    super.initState();
    events = getData();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List>(
          future: events,
          builder: (context, snapshot){
            if (snapshot.hasData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10, bottom:15,left: 15, right:10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Color.fromRGBO(113, 184, 226, 80),
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, bottom:15,left: 25, right:10),
                                child: Text(
                                  snapshot.data![index].toString(),
                                  style: const TextStyle(fontSize: 20, fontFamily: 'Ermilov'),
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }
      ),
    );
  }
}

class EventViewItem extends StatelessWidget{
  final String title;
  final String desc;
  const EventViewItem({
    super.key,
    required this.title,
    required this.desc,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(title),
            Text(desc),
          ],
        )
    );
  }

}