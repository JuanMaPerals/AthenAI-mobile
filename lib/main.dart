import 'package:flutter/material.dart';
import 'app/persalone_app.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize preferences storage before running the app
  await ServiceLocator().initPreferencesStorage();
  
  runApp(const PersalOneApp());
}
