import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Form and Details',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ALLONE SOFTTECH'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController expectedSalaryController =
      TextEditingController();
  final TextEditingController noticePeriodController = TextEditingController();
  final TextEditingController strengthController = TextEditingController();
  final TextEditingController weaknessController = TextEditingController();
  final TextEditingController getIdController = TextEditingController();
  late String apiEndpoint;
  late String authCredentials;

  bool showDetails = false;
  Map<String, dynamic>? retrievedData;

  @override
  void initState() {
    super.initState();
    apiEndpoint = "https://sheetdb.io/api/v1/dakwo26bk4eqf";
    authCredentials =
        "Basic ${base64Encode(utf8.encode("u970726b:1xj0gasu6e1deq0y64ql"))}";
  }

  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      final id = idController.text.trim();
      final name = nameController.text.trim();
      final contactNumber = contactNumberController.text.trim();
      final expectedSalary = expectedSalaryController.text.trim();
      final noticePeriod = noticePeriodController.text.trim();
      final strength = strengthController.text.trim();
      final weakness = weaknessController.text.trim();

      final data = {
        "id": id,
        "name": name,
        "contact": contactNumber,
        "expectedsalary": expectedSalary,
        "noticeperiod": noticePeriod,
        "strength": strength,
        "weekness": weakness
      };

      final existingData = await fetchDataById(id);

      if (existingData != null) {
        final response = await http.put(Uri.parse('$apiEndpoint/id/$id'),
            headers: {
              'Authorization': authCredentials,
              'Content-Type': 'application/json',
            },
            body: json.encode(data));
        if (response.statusCode == 200) {
          showSuccessAlert('Data updated successfully');
        } else {
          showErrorAlert('Failed to update data');
        }
      } else {
        final response = await http.post(Uri.parse(apiEndpoint),
            headers: {
              'Authorization': authCredentials,
              'Content-Type': 'application/json',
            },
            body: json.encode(data));
        if (response.statusCode == 201) {
          showSuccessAlert('Data created successfully');
        } else {
          showErrorAlert('Failed to create data');
        }
      }
    }
  }

  Future<Map<String, dynamic>?> fetchDataById(String id) async {
    final response =
        await http.get(Uri.parse('$apiEndpoint/search?id=$id'), headers: {
      'Authorization': authCredentials,
    });
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      if (responseData.isNotEmpty) {
        return responseData.first;
      }
    }
    return null;
  }

  Future<void> fetchData() async {
    final id = getIdController.text.trim();
    final data = await fetchDataById(id);
    if (data != null) {
      setState(() {
        retrievedData = data;
        showDetails = true;
      });
    } else {
      showErrorAlert('Data not found');
      setState(() {
        retrievedData = data;
      });
    }
  }

  void showSuccessAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showErrorAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              widget.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Form'),
              Tab(text: 'Details'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.blue,
          ),
          backgroundColor: Colors.indigo,
        ),
        body: TabBarView(
          children: [
            Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(labelText: 'ID'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter ID';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: contactNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Contact Number'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter contact number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: expectedSalaryController,
                    decoration:
                        const InputDecoration(labelText: 'Expected Salary'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter expected salary';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: noticePeriodController,
                    decoration:
                        const InputDecoration(labelText: 'Notice Period'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter notice period';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: strengthController,
                    decoration: const InputDecoration(labelText: 'Strength'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter strength';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: weaknessController,
                    decoration: const InputDecoration(labelText: 'Weakness'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter weakness';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: submitForm,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: getIdController,
                      decoration: const InputDecoration(labelText: 'Enter ID'),
                    ),
                    ElevatedButton(
                      onPressed: fetchData,
                      child: const Text('Get'),
                    ),
                    if (showDetails && retrievedData != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Details for ID: ${retrievedData!['id']}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: retrievedData!['name'],
                        readOnly: true,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        initialValue: retrievedData!['contact'],
                        readOnly: true,
                        decoration:
                            const InputDecoration(labelText: 'Contact Number'),
                      ),
                      TextFormField(
                        initialValue: retrievedData!['expectedsalary'],
                        readOnly: true,
                        decoration:
                            const InputDecoration(labelText: 'Expected Salary'),
                      ),
                      TextFormField(
                        initialValue: retrievedData!['noticeperiod'],
                        readOnly: true,
                        decoration:
                            const InputDecoration(labelText: 'Notice Period'),
                      ),
                      TextFormField(
                        initialValue: retrievedData!['strength'],
                        readOnly: true,
                        decoration:
                            const InputDecoration(labelText: 'Strength'),
                      ),
                      TextFormField(
                        initialValue: retrievedData!['weekness'],
                        readOnly: true,
                        decoration:
                            const InputDecoration(labelText: 'Weakness'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
