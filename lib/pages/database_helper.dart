import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final clientId = auth.ClientId(
    dotenv.env['GOOGLE_OAUTH_CLIENT_ID']!,
    dotenv.env['GOOGLE_OAUTH_CLIENT_SECRET']!
  );

  static final scopes = [drive.DriveApi.driveFileScope];

  DatabaseHelper._init();

  // إضافة موظف مع رفع الصورة
  Future<void> addEmployeeWithImage(File imageFile, Map<String, dynamic> employee) async {
    try {
      String imageUrl = await uploadImageToGoogleDrive(imageFile);
      employee['imageUrl'] = imageUrl;
      await _firestore.collection('employees').add(employee);
      print('Employee added successfully');
    } catch (e) {
      print('Error adding employee: $e');
      rethrow;
    }
  }

  // إضافة موظف بدون رفع الصورة
  Future<void> addEmployee(Map<String, dynamic> employee) async {
    try {
      await _firestore.collection('employees').add(employee);
      print('Employee added successfully');
    } catch (e) {
      print('Error adding employee: $e');
      rethrow;
    }
  }

  // وظيفة رفع الصورة إلى Google Drive
  Future<String> uploadImageToGoogleDrive(File imageFile) async {
    try {
      final authClient = await auth.clientViaUserConsent(clientId, scopes, (url) {
        print('Please go to the following URL and grant access:');
        print('  => $url');
        print('Then enter the displayed code');
      });

      final driveApi = drive.DriveApi(authClient);
      var fileToUpload = drive.File();
      fileToUpload.name = imageFile.path.split('/').last;

      var response = await driveApi.files.create(
        fileToUpload,
        uploadMedia: drive.Media(imageFile.openRead(), imageFile.lengthSync()),
      );

      print('Upload complete. File ID: ${response.id}');
      return response.webViewLink ?? '';
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  // جلب بيانات الموظفين
  Future<List<Map<String, dynamic>>> getEmployees() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('employees').get();
      List<Map<String, dynamic>> employees = querySnapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>
      }).toList();
      print('Employees fetched successfully');
      return employees;
    } catch (e) {
      print('Error fetching employees: $e');
      rethrow;
    }
  }

  // تحديث بيانات الموظف
  Future<void> updateEmployee(String id, Map<String, dynamic> employee) async {
    try {
      await _firestore.collection('employees').doc(id).update(employee);
      print('Employee updated successfully');
    } catch (e) {
      print('Error updating employee: $e');
      rethrow;
    }
  }

  // حذف الموظف
  Future<void> deleteEmployee(String id) async {
    try {
      await _firestore.collection('employees').doc(id).delete();
      print('Employee deleted successfully');
    } catch (e) {
      print('Error deleting employee: $e');
      rethrow;
    }
  }
}
