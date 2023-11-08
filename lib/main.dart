// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  //now we starting working with  hive

  //its going to get appropriate document directory from the file system.and its to be saved in the directory.
  Directory directory = await getApplicationDocumentsDirectory();
  //open hive
  Hive.init(directory.path);
  await Hive.openBox<String>('person');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Box<String> personBox;
  final _idController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    personBox = Hive.box<String>('person');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: AppBar(
        title: Text('HIVE CRUD'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: personBox.listenable(),
                  builder: (context, Box<String> person, _) {
                    return ListView.separated(

                      itemCount: person.keys.length,
                      separatorBuilder: (_, i) => const Divider(),
                      itemBuilder: (ctx, i) {

                        final key = person.keys.toList()[i];
                        final value = person.get(key);

                        return ListTile(
                          title: Text(value.toString()),
                          subtitle: Text(key),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //create section
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: SizedBox(
                              height: 230,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        label: Text('key'),
                                      ),
                                      controller: _idController,
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        label: Text('value'),
                                      ),
                                      controller: _nameController,
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                        onPressed: () {
                                          final key = _idController.text;
                                          final value = _nameController.text;

                                          personBox.put(key, value);
                                          // _idController.clear();
                                          // _nameController.clear();
                                          Navigator.pop(context);
                                        },
                                        child: Text('SUBMIT')),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: const Text('CREATE'),
                ),

                //update section
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return Dialog(
                          child: SizedBox(height: 230,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      label: Text('key'),
                                    ),
                                    controller: _idController,
                                  ),

                                  TextField(
                                    decoration: InputDecoration(
                                      label: Text('value'),
                                    ),
                                    controller: _nameController,
                                  ),

                                  SizedBox(height: 16),
                                  ElevatedButton(onPressed: () {
                                    final key = _idController.text;
                                    final value =_nameController.text;

                                    personBox.put(key, value);
                                    _idController.clear();
                                    _nameController.clear();
                                    Navigator.pop(context);
                                  },
                                      child: Text('SUBMIT'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                      },
                    );
                  },
                  child: const Text('UPDATE'),
                ),




                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: SizedBox(
                              height: 230,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                        label: Text('key'),
                                      ),
                                      controller: _idController,
                                    ),

                                    SizedBox(height: 16),
                                    ElevatedButton(
                                        onPressed: () {
                                          final key = _idController.text;
                                          personBox.delete(key);

                                          _idController.clear();

                                          Navigator.pop(context);
                                        },
                                        child: Text('DELETE')),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: const Text('DELETE'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
