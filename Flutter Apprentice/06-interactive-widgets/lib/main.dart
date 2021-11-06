import 'package:flutter/material.dart';
import 'fooderlich_theme.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';

void main() {
  runApp(const Fooderlich());
}

class Fooderlich extends StatelessWidget
{
  const Fooderlich({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final theme = FooderlichTheme.light();

    return MaterialApp(
      theme: theme,
      title: 'Fooderlich',

      // Adding a MultiProvider to the Home property adds the ability to
      // accept a list of providers for Home’s descendant widgets to access
      home: MultiProvider(
        providers: [
          // This ChangeNotifierProvider creates an instance of TabManager,
          // which listens to tab index changes and notifies its listeners
          ChangeNotifierProvider(create: (context) => TabManager()),

          // This ChangeNotifierProvider creates an instance of GroceryManager,
          // which listens to changes to the list of groceries and
          // notifies its listeners
          ChangeNotifierProvider(create: (context) => GroceryManager()),

        ],
        child: const Home(),
      ),

    );
  }
}
