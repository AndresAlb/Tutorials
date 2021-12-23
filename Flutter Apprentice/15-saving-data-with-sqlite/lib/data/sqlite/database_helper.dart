import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';
import '../models/models.dart';

class DatabaseHelper
{
  // Constants for the database name and version
  static const _databaseName = 'MyRecipes.db';
  static const _databaseVersion = 1;

  // Define the names of the tables
  static const recipeTable = 'Recipe';
  static const ingredientTable = 'Ingredient';
  static const recipeId = 'recipeId';
  static const ingredientId = 'ingredientId';

  // sqlbrite database instance. late indicates the variable is non-nullable
  // and that it will be initialized after it’s been declared
  static late BriteDatabase _streamDatabase;

  // make this a singleton class
  // Make the constructor private and provide a public static instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Define lock, which you’ll use to prevent concurrent access
  static var lock = Lock();

  // only have a single app-wide reference to the database
  // Private sqflite database instance
  static Database? _database;

  // You need to create the database once, then you can access it through your
  // instance. This prevents other classes from creating multiple instances of
  // the helper and initializing the database more than once.

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async
  {
    await db.execute('''
        CREATE TABLE $recipeTable (
          $recipeId INTEGER PRIMARY KEY,
          label TEXT,
          image TEXT,
          url TEXT,
          calories REAL,
          totalWeight REAL,
          totalTime REAL
        )
        ''');

    await db.execute('''
        CREATE TABLE $ingredientTable (
          $ingredientId INTEGER PRIMARY KEY,
          $recipeId INTEGER,
          name TEXT,
          weight REAL
        )
        ''');
  }

  // This opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async
  {
    // Get the app document’s directory name, where you’ll store the database
    final documentsDirectory = await getApplicationDocumentsDirectory();

    // Create a path to the database by appending the database name to the
    // directory path
    final path = join(documentsDirectory.path, _databaseName);

    // TODO: Remember to turn off debugging before deploying app to store(s).
    Sqflite.setDebugModeOn(true);

    // Use sqflite’s openDatabase() to create and store the database file
    // in the path
    return openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Since _database is private, you need to create a getter that will
  // initialize the database
  Future<Database> get database async
  {
    // If _database is not null, it’s already been created, so you return
    // the existing one
    if (_database != null) return _database!;

    // Use lock to ensure that only one process can be in this section of
    // code at a time
    await lock.synchronized(() async
    {
      // Check to make sure the database is null
      if (_database == null)
      {
        // Lazily instantiate the db the first time it is accessed
        _database = await _initDatabase();

        // Create a BriteDatabase instance, wrapping the database
        _streamDatabase = BriteDatabase(_database!);
      }
    });

    return _database!;
  }

  // Getter for the stream database
  Future<BriteDatabase> get streamDatabase async
  {
    await database;

    // You’ll use the stream database for the stream methods in your repository,
    // as well as to insert and delete data
    return _streamDatabase;
  }

  List<Recipe> parseRecipes(List<Map<String, dynamic>> recipeList)
  {
    final recipes = <Recipe>[];

    recipeList.forEach((recipeMap) {

      final recipe = Recipe.fromJson(recipeMap);

      recipes.add(recipe);
    });

    return recipes;
  }

  List<Ingredient> parseIngredients(List<Map<String, dynamic>> ingredientList)
  {
    final ingredients = <Ingredient>[];

    ingredientList.forEach((ingredientMap) {

      final ingredient = Ingredient.fromJson(ingredientMap);

      ingredients.add(ingredient);
    });

    return ingredients;
  }

  Future<List<Recipe>> findAllRecipes() async
  {
    final db = await instance.streamDatabase;

    final recipeList = await db.query(recipeTable);

    final recipes = parseRecipes(recipeList);

    return recipes;
  }

  Stream<List<Recipe>> watchAllRecipes() async*
  {
    final db = await instance.streamDatabase;

    // yield* creates a Stream using the query
    yield* db

        .createQuery(recipeTable)

        .mapToList((row) => Recipe.fromJson(row));
  }

  Stream<List<Ingredient>> watchAllIngredients() async*
  {
    final db = await instance.streamDatabase;

    yield* db
        .createQuery(ingredientTable)
        .mapToList((row) => Ingredient.fromJson(row));
  }

  Future<Recipe> findRecipeById(int id) async
  {
    final db = await instance.streamDatabase;
    final recipeList = await db.query(recipeTable, where: 'id = $id');
    final recipes = parseRecipes(recipeList);
    return recipes.first;
  }

  Future<List<Ingredient>> findAllIngredients() async
  {
    final db = await instance.streamDatabase;
    final ingredientList = await db.query(ingredientTable);
    final ingredients = parseIngredients(ingredientList);
    return ingredients;
  }

  Future<List<Ingredient>> findRecipeIngredients(int recipeId) async
  {
    final db = await instance.streamDatabase;
    final ingredientList =
    await db.query(ingredientTable, where: 'recipeId = $recipeId');
    final ingredients = parseIngredients(ingredientList);
    return ingredients;
  }

  Future<int> insert(String table, Map<String, dynamic> row) async
  {
    final db = await instance.streamDatabase;

    return db.insert(table, row);
  }

  Future<int> insertRecipe(Recipe recipe)
  {
    return insert(recipeTable, recipe.toJson());
  }

  Future<int> insertIngredient(Ingredient ingredient)
  {
    return insert(ingredientTable, ingredient.toJson());
  }

  Future<int> _delete(String table, String columnId, int id) async
  {
    final db = await instance.streamDatabase;

    return db.delete(table, where: '$columnId = ?',whereArgs: [id]);
  }

  Future<int> deleteRecipe(Recipe recipe) async
  {
    if (recipe.id != null)
    {
      return _delete(recipeTable, recipeId, recipe.id!);
    }
    else
    {
      return Future.value(-1);
    }
  }

  Future<int> deleteIngredient(Ingredient ingredient) async
  {
    if (ingredient.id != null)
    {
      return _delete(ingredientTable, ingredientId, ingredient.id!);
    }
    else
    {
      return Future.value(-1);
    }
  }

  Future<void> deleteIngredients(List<Ingredient> ingredients)
  {
    ingredients.forEach((ingredient) {
      if (ingredient.id != null)
      {
        _delete(ingredientTable, ingredientId, ingredient.id!);
      }
    });

    return Future.value();
  }

  Future<int> deleteRecipeIngredients(int id) async
  {
    final db = await instance.streamDatabase;

    return db
        .delete(ingredientTable, where: '$recipeId = ?', whereArgs: [id]);
  }

  void close() { _streamDatabase.close(); }
}
