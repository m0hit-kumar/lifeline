import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({Key? key}) : super(key: key);

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class PeopleModel {
  final int number;
  final String name;
  PeopleModel({required this.number, required this.name});
}

class _MyMainPageState extends State<MyMainPage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  List<PeopleModel> EmergencyContactList = [];
  void addItemToList(PeopleModel item) {
    setState(() {
      EmergencyContactList.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Contact"),
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a number',
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    print(EmergencyContactList);
                    EmergencyContactList.add(PeopleModel(
                        name: name.text, number: int.parse(phone.text)));

                    for (var i in EmergencyContactList) {
                      print(i.name);
                    }
                  },
                  child: const Text("Add to contacts")),
              const Align(
                  alignment: Alignment.center,
                  child: Text("Conatacts in your emregency List")),
              SingleChildScrollView(
                child: SizedBox(
                  height: 500,
                  child: ListView.builder(
                    itemCount: EmergencyContactList.length,
                    itemBuilder: (BuildContext context, int index) {
                      for (var i in EmergencyContactList) {
                        print("hgkjl");
                        print(i.name);
                      }
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Text("${index + 1}"),
                        ),
                        subtitle: Text("${EmergencyContactList[index].number}"),
                        title: Text(
                          EmergencyContactList[index].name,
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
