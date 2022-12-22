import 'package:flutter/material.dart';
import 'package:student_list/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nimController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<Map<String, dynamic>> student = [];
  void refreshStudent() async {
    final data = await SQLHelper.getStudent();
    setState(() {
      student = data;
    });
  }

  @override
  void initState() {
    refreshStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Student List'),
          actions: [
            IconButton(
                onPressed: () {
                  modalDeleteAll();
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        body: ListView.builder(
          itemCount: student.length,
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(student[index]['name']),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            modalFormUpdate(student[index]['id']);
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            modalDelete(student[index]['id']);
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  )
                ],
              ),
              subtitle: Column(
                children: [
              Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'NIM ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(student[index]['nim'])
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Email ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(student[index]['email'])
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Phone ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(student[index]['phone'])
                    ],
                  ),
                ],
              )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            modalFormCreate();
          },
          child: const Icon(Icons.person_add),
        ),
      ),
    );
  }

  Future<void> tambahStudent() async {
    await SQLHelper.tambahStudent(nameController.text, nimController.text,
        phoneController.text, emailController.text);
    refreshStudent();
  }

  Future<void> ubahStudent(int id) async {
    await SQLHelper.ubahStudent(id, nameController.text, nimController.text,
        phoneController.text, emailController.text);
    refreshStudent();
  }

  Future<void> hapusStudent(int id) async {
    await SQLHelper.hapusStudent(id);
    refreshStudent();
  }

  Future<void> hapusSemuaStudent() async {
    await SQLHelper.hapusSemuaStudent();
    refreshStudent();
  }

  void modalFormCreate() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Create Student'),
            content: Form(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: "Student Name"),
                    keyboardType: TextInputType.text,
                  ),
                  TextField(
                    controller: nimController,
                    decoration: const InputDecoration(hintText: "NIM"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(hintText: "Phone"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: "Email"),
                    keyboardType: TextInputType.text,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            tambahStudent();
                            nimController.text = '';
                            nameController.text = '';
                            phoneController.text = '';
                            emailController.text = '';
                            refreshStudent();
                            Navigator.pop(context);
                          },
                          child: const Text('CREATE')),
                      ElevatedButton(
                          onPressed: () {
                            nimController.text = '';
                            nameController.text = '';
                            phoneController.text = '';
                            emailController.text = '';
                            refreshStudent();
                            Navigator.pop(context);
                          },
                          child: const Text('CANCEL'))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void modalFormUpdate(int id) async {
    final dataStudent = student.firstWhere((element) => element['id'] == id);
    nameController.text = dataStudent['name'];
    nimController.text = dataStudent['nim'];
    phoneController.text = dataStudent['phone'];
    emailController.text = dataStudent['email'];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Update Student Information'),
            content: Form(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: "Student Name"),
                    keyboardType: TextInputType.text,
                  ),
                  TextField(
                    controller: nimController,
                    decoration: const InputDecoration(hintText: "NIM"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(hintText: "Phone"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: "Email"),
                    keyboardType: TextInputType.text,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            ubahStudent(id);
                            nimController.text = '';
                            nameController.text = '';
                            phoneController.text = '';
                            emailController.text = '';
                            refreshStudent();
                            Navigator.pop(context);
                          },
                          child: const Text('UPDATE')),
                      ElevatedButton(
                          onPressed: () {
                            nimController.text = '';
                            nameController.text = '';
                            phoneController.text = '';
                            emailController.text = '';
                            refreshStudent();
                            Navigator.pop(context);
                          },
                          child: const Text('CANCEL'))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void modalDelete(int id) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Are You Sure, You Wanted to delete this student'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    hapusStudent(id);
                    Navigator.pop(context);
                  },
                  child: const Text('YES')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('NO')),
            ],
          );
        });
  }

  void modalDeleteAll() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Are You Sure, You Wanted to delete all student'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    hapusSemuaStudent();
                    Navigator.pop(context);
                  },
                  child: const Text('YES')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('NO')),
            ],
          );
        });
  }
}
