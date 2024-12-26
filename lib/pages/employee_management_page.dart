import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';

class EmployeeManagementPage extends StatefulWidget {
  const EmployeeManagementPage({super.key});

  @override
  EmployeeManagementPageState createState() => EmployeeManagementPageState();
}

class EmployeeManagementPageState extends State<EmployeeManagementPage> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: const Text(
            "إدارة بيانات الموظفين",
            textDirection: TextDirection.rtl,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildEmployeeList(isDesktop),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _addEmployee,
                icon: const Icon(Icons.add),
                label: const Text("إضافة موظف"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _loadEmployees() async {
    try {
      print("Starting to load employees...");
      List<Map<String, dynamic>> employees = await DatabaseHelper.instance.getEmployees();
      print("Employees loaded successfully: ${employees.length}");
      return employees;
    } catch (e) {
      print('Error fetching employees: $e');
      return [];
    }
  }

  Widget _buildEmployeeList(bool isDesktop) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadEmployees(),
      builder: (context, snapshot) {
        try {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Snapshot has error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print('No employees found');
            return const Center(child: Text('No employees found.'));
          } else {
            final employees = snapshot.data!;
            print('Employees loaded: ${employees.length}');
            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return _buildEmployeeCard(
                  employee['id'],
                  employee['name'],
                  employee['email'],
                  employee['position'],
                  employee['imageUrl'],
                  isDesktop,
                );
              },
            );
          }
        } catch (e) {
          print('Error in FutureBuilder: $e');
          return Center(child: Text('Unexpected error: $e'));
        }
      },
    );
  }

  Widget _buildEmployeeCard(String id, String name, String email, String position, String imageUrl, bool isDesktop) {
    final avatarRadius = isDesktop ? 50.0 : 30.0;
    final fontSize = isDesktop ? 18.0 : 16.0;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: avatarRadius,
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: fontSize, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    position,
                    style: TextStyle(fontSize: fontSize, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                scheduleMicrotask(() {
                  _updateEmployee(id, name, email, position, imageUrl);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                scheduleMicrotask(() {
                  _deleteEmployee(id, email);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addEmployee() async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final positionController = TextEditingController();
    XFile? image;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text("إضافة موظف", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    setState(() {
                      image = pickedFile;
                    });
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: image != null ? FileImage(File(image!.path)) : null,
                    child: image == null ? const Icon(Icons.camera_alt, size: 40) : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "الاسم",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "البريد الإلكتروني",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "كلمة المرور",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: positionController,
                  decoration: InputDecoration(
                    labelText: "الوظيفة",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty &&
                    positionController.text.isNotEmpty &&
                    image != null) {
                  try {
                    // تسجيل الموظف الجديد في Firebase Authentication
                    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    print('User created: ${userCredential.user?.uid}');

                    // رفع الصورة إلى Google Drive
                    String imageUrl = await DatabaseHelper.instance.uploadImageToGoogleDrive(File(image!.path));

                    // إضافة بيانات الموظف إلى Firestore
                    final newEmployee = {
                      'name': nameController.text,
                      'email': emailController.text,
                      'position': positionController.text,
                      'imageUrl': imageUrl,
                    };
                    await DatabaseHelper.instance.addEmployeeWithImage(File(image!.path), newEmployee);

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } on FirebaseAuthException catch (e) {
                    print('Error adding employee to Firebase Authentication: $e');
                  } catch (e) {
                    print('General error while adding employee: $e');
                  }
                } else if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty &&
                    positionController.text.isNotEmpty) {
                  try {
                    // تسجيل الموظف الجديد في Firebase Authentication
                    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    print('User created: ${userCredential.user?.uid}');

                    // إضافة بيانات الموظف إلى Firestore بدون صورة
                    final newEmployee = {
                      'name': nameController.text,
                      'email': emailController.text,
                      'position': positionController.text,
                      'imageUrl': '',
                    };
                    await DatabaseHelper.instance.addEmployee(newEmployee);

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } on FirebaseAuthException catch (e) {
                    print('Error adding employee to Firebase Authentication: $e');
                  } catch (e) {
                    print('General error while adding employee: $e');
                  }
                }
              },
              child: const Text("إضافة"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateEmployee(String id, String name, String email, String position, String imageUrl) async {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);
    final positionController = TextEditingController(text: position);
    XFile? image;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text("تعديل الموظف", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    setState(() {
                      image = pickedFile;
                    });
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: image != null ? FileImage(File(image!.path)) : NetworkImage(imageUrl),
                    child: image == null && imageUrl.isEmpty ? const Icon(Icons.camera_alt, size: 40) : null,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "الاسم",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "البريد الإلكتروني",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: positionController,
                  decoration: InputDecoration(
                    labelText: "الوظيفة",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    positionController.text.isNotEmpty) {

                  try {
                    // تحديث الصورة إذا تم اختيار صورة جديدة
                    String imageUrlToUpdate = imageUrl;
                    if (image != null) {
                      imageUrlToUpdate = await DatabaseHelper.instance.uploadImageToGoogleDrive(File(image!.path));
                    }

                    final updatedEmployee = {
                      'name': nameController.text,
                      'email': emailController.text,
                      'position': positionController.text,
                      'imageUrl': imageUrlToUpdate,
                    };
                    await DatabaseHelper.instance.updateEmployee(id, updatedEmployee);

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                    print('Employee updated successfully: ${nameController.text}');
                  } catch (e) {
                    print('Error updating employee: $e');
                  }
                }
              },
              child: const Text("تحديث"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEmployee(String id, String email) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text("تأكيد الحذف", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: const Text("هل أنت متأكد من حذف هذا الموظف؟"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // حذف بيانات الموظف من Firestore
                  await DatabaseHelper.instance.deleteEmployee(id);

                  // حذف حساب الموظف من Firebase Authentication
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null && user.email == email) {
                    await user.delete();
                  }

                  print('Employee deleted successfully from Firestore and Firebase Authentication.');

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  print('Error deleting employee: $e');
                }
              },
              child: const Text("حذف"),
            ),
          ],
        );
      },
    );
  }
}
