import 'package:flutter/material.dart';
import 'recipe.dart';
import 'recipe_detail.dart';

void main() {
  runApp(const RecipesApp());
}

class RecipesApp extends StatelessWidget {
  const RecipesApp({Key? key}) : super(key: key);

  // 1 The build() method is the entry point for composing together other
  // widgets to make a new widget
  @override
  Widget build(BuildContext context) {
    // 2 A theme determines visual aspects like color
    final ThemeData theme = ThemeData();
    // 3 MaterialApp uses Material Design and is the widget that will be
    // included in RecipeApp
    return MaterialApp(
      // 4 Title of the app is a description that the device uses to identify the app
      title: 'Recipe Calculator',
      // 5
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.grey,
          secondary: Colors.black,
        ),
      ),
      // 6 Still uses the same MyHomePage widget as before, but now,
      // you’ve updated the title and displayed it on the device
      home: const MyHomePage(title: 'Recipe Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // 1 A Scaffold provides the high-level structure for a screen
    return Scaffold(
      // 2
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // 3 SafeArea keeps the app from getting too close to the
      // operating system interfaces such as the notch or interactive areas
      // like the Home Indicator at the bottom of some iOS screens.
      body: SafeArea(

        child: ListView.builder(
            itemCount: Recipe.samples.length,
            itemBuilder: (BuildContext context, int index)
            {
              return GestureDetector(
                onTap: ()
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)
                      {
                        return RecipeDetail(recipe: Recipe.samples[index]);
                      })
                  );
                },
                child: buildRecipeCard(Recipe.samples[index]),
              );
            },
        ),
      ),
    );
  }

  Widget buildRecipeCard(Recipe recipe) {
    return Card(
      // 1
      elevation: 2.0,
      // 2
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      // 3
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // 4
        child: Column(
          children: <Widget>[
            Image(image: AssetImage(recipe.imageURL)),
            // 5
            const SizedBox(
              height: 14.0,
            ),
            // 6
            Text(
              recipe.label,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                fontFamily: 'Palatino',
              ),
            )
          ],
        ),
      ),
    );
  }

}

