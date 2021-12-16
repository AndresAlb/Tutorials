import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'ui/main_screen.dart';
import 'mock_service/mock_service.dart';
import 'data/memory_repository.dart';

Future<void> main() async
{
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

void _setupLogging()
{
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget
{
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 1
    return MultiProvider(

      providers: [

        ChangeNotifierProvider<MemoryRepository>(
            // Setting lazy to false creates the repository right away instead
            // of waiting until you need it. This is useful when the repository
            // has to do some background work to start up.
            lazy: false,

            // Create your repository
            create: (_) => MemoryRepository()
        ),

        Provider(
            // Create the MockService and call create() to load the JSON files
            // (notice the .. cascade operator)
            create: (_) => MockService()..create(),
            lazy: false
        )
      ],

      child: MaterialApp(
        title: 'Recipes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
