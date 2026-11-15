import "package:flutter/material.dart";

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _currentIndex = 0;
  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "test",
      home: Scaffold(
        appBar: AppBar(
          title: [
            Text("Accueil"),
            Text("Evenement"),
            Text("Formulaire"),
          ][_currentIndex],
        ),
        body: [HomePageEvent(), EventPage(), AddEvents()][_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "Planning",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Formulaire"),
          ],
        ),
      ),
    );
  }
}

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final events = [
    {
      "speaker": "Moussa  Ndione",
      "subject": "La gestion de versionning avec git ",
    },
    {
      "speaker": "Aliou Tevette",
      "subject": "De l'IA a la transformation au Sénégal",
    },
    {
      "speaker": "Babacar Diouf",
      "subject": "La bonne gestion d'une application",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final nom = event["speaker"];
        final des = event["subject"];
        return Card(
          child: ListTile(
            leading: FlutterLogo(),
            title: Text('$nom'),
            subtitle: Text('$des'),
            trailing: Icon(Icons.more_horiz),
          ),
        );
      },
    );
  }
}

class HomePageEvent extends StatefulWidget {
  const HomePageEvent({super.key});

  @override
  State<HomePageEvent> createState() => _HomePageEventState();
}

class _HomePageEventState extends State<HomePageEvent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "ASUNCONF 2022",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Headline',
            ),
          ),
          Text(
            "Bienvenue sur mon application de salon virtuel, une salon dedié au monde informatique du Sénégal. Restez connecter pour ne rien rater",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.all(20)),
          ElevatedButton.icon(
            style: ButtonStyle(
              padding: MaterialStatePropertyAll(EdgeInsets.all(20)),
              backgroundColor: MaterialStatePropertyAll(Colors.green),
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(pageBuilder: (_, __, ___) => EventPage()),
              );
            },
            label: Text("Découvrir"),
            icon: Icon(Icons.calendar_month),
          ),
        ],
      ),
    );
  }
}

class AddEvents extends StatefulWidget {
  const AddEvents({super.key});

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  final _formkey = GlobalKey<FormState>();
  final nameConfController = TextEditingController();
  final speakConfController = TextEditingController();
  String selectedConfType = "talk";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameConfController.dispose();
    speakConfController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "Nom du Conférencier",
                hintText: "Entrer un nom ",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Tu dois remplir ce champ";
                }
                return null;
              },
              controller: nameConfController,
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Nom de speaker",
                  hintText: "Entrer lenom du speaker ",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tu dois remplir ce champ";
                  }
                  return null;
                },
                controller: speakConfController,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: DropdownButtonFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: [
                  DropdownMenuItem(value: "talk", child: Text("Talk Show")),
                  DropdownMenuItem(value: "demo", child: Text("Demo de Code")),
                  DropdownMenuItem(value: "partner", child: Text("Partner")),
                ],
                // ignore: deprecated_member_use
                value: selectedConfType,
                onChanged: (value) {
                  selectedConfType = value!;
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    final confName = nameConfController.text;
                    final confSpeak = speakConfController.text;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Envoi en cour ......")),
                    );
                    // ignore: avoid_print
                    print(
                      "Ajout de la conf $confName par le speaker $confSpeak",
                    );
                    // ignore: avoid_print
                    print("Type de conférence $selectedConfType");
                  }
                },
                child: Text("Envoyer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
