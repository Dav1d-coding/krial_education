import 'package:flutter/material.dart';


class DGY extends StatelessWidget {
  const DGY({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: DGYLayout(),
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
                color: Colors.blue,
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

class DGYLayout extends StatelessWidget{
  const DGYLayout({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column_Data(),
    );
  }
}

class Column_Data extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topText(),
        getDgyImage(),
        getMainText(),
        getTypesImage(),
        getPower(context),
        getQuestionsForTest(),
      ],
    );
  }
  Widget topText() {
    return const Padding(
      padding: EdgeInsets.only(top: 0, bottom:10, left:10, right:10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Что такое ДГУ?',
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 30, fontFamily: 'Ermilov'),
        ),
      ),
    );
    return const Align(
      alignment: Alignment.topLeft,
      child: Text(
        'Что такое ДГУ?',
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 30, fontFamily: 'Ermilov'),
      ),
    );
  }

  Widget getDgyImage() {
    return Align(
      alignment: Alignment.topLeft,
      child: Image.asset('assets/images/what_is_dgy.png'),
    );
  }
  Widget getMainText() {
    return const Padding(
      padding: EdgeInsets.only(top: 0, bottom:10, left:15, right:10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Электромеханическое устройство, состоящее из дизельного  двигателя, электрогенератора и схемыуправления',
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 20, fontFamily: 'Ermilov'),
        ),
      ),
    );
  }

  Widget getTypesImage() {
    return Align(
      alignment: Alignment.topLeft,
      child: Image.asset('assets/images/uses.png'),
    );
  }

  Widget getPower(BuildContext context) {
    return Column(
      children: [
        const Text('Как выбрать мощность', style: TextStyle(fontSize: 30, fontFamily: 'Ermilov'),),
        Image.asset('assets/images/power.png'),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Image.asset('assets/images/AVR.png'),),
        const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text('Варианты исполнения ДГУ', style: TextStyle(fontSize: 30, fontFamily: 'Ermilov')),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset('assets/images/dgy_open.png'),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset('assets/images/dgy.png'),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset('assets/images/dgy.png'),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getQuestionsForTest() {
    return Center(
      child: Column(
        children: [
          Quest('Какова оптимальная рабочая мощность ДГУ','70%')
        ],
      ),
    );
  }
}

class Quest extends StatefulWidget{
  String quest;
  String answ;

  Quest(this.quest, this.answ, {super.key});

  @override
  State<StatefulWidget> createState() => QuestState();

}
class QuestState extends State<Quest>{
  late TextEditingController controller;
  Color _colorContainer = Colors.blueAccent;
  Color _colorText = Colors.blueAccent;
  Color _colorQuest = Colors.white;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: _colorContainer,
            borderRadius: BorderRadius.circular(10)
          ),
          duration: const Duration(seconds: 2),
          child: Column(
              children:[
                const Text(
                  'Вопросы для самопроверки',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Оптимальная мощность ДГУ состоавляет?',
                  style: TextStyle(color: _colorQuest),
                ),
                Text(
                  'Ответ : 70%',
                  style: TextStyle(color: _colorText),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: (){
                      setState((){
                          _colorText = _colorQuest;
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: const Text('Проверить'),
                  ),
                )
              ]
          ),
        ),
      );
  }
}

