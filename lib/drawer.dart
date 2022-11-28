import 'package:flutter/material.dart';
import 'package:krial_education/sales.dart';
import 'package:krial_education/sales/parts.dart';
import 'news.dart';
import 'temp.dart';
import 'products/dgy.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Krial Education';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      title: appTitle,
      home: const MyHomePage(title: appTitle),
      routes: {
        '':(BuildContext context) => const MyHomePage(title: 'Krial Education',),
        '/products':(BuildContext context) => const Data(title: 'Продукция',),
        '/products/dgy':(BuildContext context) => const DGY(title: 'ДГУ',),
        '/sales':(BuildContext context) => const Sales(title: 'О продажах',),
        '/sales/parts':(BuildContext context) => const Parts(title: 'Этапы продаж',),
        '/news':(BuildContext context) => const News(title: 'Новости промышленности',),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Text('Добро пожаловать в Krial Education'),
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