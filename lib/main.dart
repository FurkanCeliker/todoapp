import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/data/local_storage.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/pages/home_page.dart';

final locator = GetIt.instance; // get_it paketinin GetIt.instance özelliğini kullanarak tanımı yaptık. 
void setup(){
  locator.registerSingleton<LocalStorage>(HiveLocalStorage()); // kullanacağımız yöntemin tanımlarını yaptık.
}
Future<void> setupHive() async{
   await Hive.initFlutter(); // hive veritabanı işlemi
   Hive.registerAdapter(TaskAdapter());  // hive veritabanı işlemi
   var taskBox = await Hive.openBox<Task>('tasks');
   taskBox.values.forEach((element) {
     if(element.createdAt!=DateTime.now().day){
       taskBox.delete(element.id);
     }
   });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // uzun sürmesini beklediğini işlemler varsa kullanıyorz.--hive veritabanı işlemi
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.white));
   await setupHive();
   setup(); // burada çağırıyorum ki nesne oluşturulsun.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      
        
        primarySwatch: Colors.blue,
      ),
      home:  HomePage(),
    );
  }
}

