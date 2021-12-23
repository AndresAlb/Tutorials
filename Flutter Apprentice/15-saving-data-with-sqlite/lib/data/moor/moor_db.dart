import 'package:moor_flutter/moor_flutter.dart';
import '../models/models.dart';

part 'moor_db.g.dart';

class MoorRecipe extends Table
{
  IntColumn get id => integer().autoIncrement()();

  TextColumn get label => text()();

  TextColumn get image => text()();

  TextColumn get url => text()();

  RealColumn get calories => real()();

  RealColumn get totalWeight => real()();

  RealColumn get totalTime => real()();
}

class MoorIngredient extends Table
{
  IntColumn get id => integer().autoIncrement()();

  IntColumn get recipeId => integer()();

  TextColumn get name => text()();

  RealColumn get weight => real()();
}

// DAO = Data Access Object
// Extend _$RecipeDatabase, which the Moor generator will create
@UseMoor(tables: [MoorRecipe, MoorIngredient], daos: [RecipeDao, IngredientDao])
class RecipeDatabase extends _$RecipeDatabase
{
  RecipeDatabase()
  // When creating the class, call the super class’s constructor. This uses the
  // built-in Moor query executor and passes the pathname of the file.
  // It also sets logging to true
      : super(FlutterQueryExecutor.inDatabaseFolder(
      path: 'recipes.sqlite', logStatements: true));

  // Set the database or schema version to 1
  @override
  int get schemaVersion => 1;
}

// This class contains the definitions of all the Moor methods we need to watch,
// find, insert and delete recipes from the database
@UseDao(tables: [MoorRecipe])
class RecipeDao extends DatabaseAccessor<RecipeDatabase> with _$RecipeDaoMixin
{
  final RecipeDatabase db;

  RecipeDao(this.db) : super(db);

  Future<List<MoorRecipeData>> findAllRecipes() => select(moorRecipe).get();

  Stream<List<Recipe>> watchAllRecipes()
  {
    return select(moorRecipe).watch().map((rows) {

      final recipes = <Recipe>[];

      rows.forEach((row) {

        final recipe = moorRecipeToRecipe(row);

        // If your list doesn't already contain the recipe, create an empty
        // ingredient list and add it to your recipes list
        if (!recipes.contains(recipe))
        {
          recipe.ingredients = <Ingredient>[];
          recipes.add(recipe);
        }

      },);
      
      return recipes;
    },);

  }

  Future<List<MoorRecipeData>> findRecipeById(int id) =>
      (select(moorRecipe)..where((tbl) => tbl.id.equals(id))).get();

  Future<int> insertRecipe(Insertable<MoorRecipeData> recipe) =>
      into(moorRecipe).insert(recipe);

  Future deleteRecipe(int id) => Future.value(
      (delete(moorRecipe)..where((tbl) => tbl.id.equals(id))).go());
}

// This class contains the definitions of all the Moor methods we need to watch,
// find, insert and delete ingredients from the database
@UseDao(tables: [MoorIngredient])
class IngredientDao extends DatabaseAccessor<RecipeDatabase>
    with _$IngredientDaoMixin
{
  final RecipeDatabase db;

  IngredientDao(this.db) : super(db);

  Future<List<MoorIngredientData>> findAllIngredients() =>
      select(moorIngredient).get();

  Stream<List<MoorIngredientData>> watchAllIngredients() =>
      select(moorIngredient).watch();

  Future<List<MoorIngredientData>> findRecipeIngredients(int id) =>
      (select(moorIngredient)..where((tbl) => tbl.recipeId.equals(id))).get();

  Future<int> insertIngredient(Insertable<MoorIngredientData> ingredient) =>
      into(moorIngredient).insert(ingredient);

  Future deleteIngredient(int id) =>
      Future.value((delete(moorIngredient)..where((tbl) =>
          tbl.id.equals(id))).go());
}

// Converts MoorRecipeData object to Recipe object
Recipe moorRecipeToRecipe(MoorRecipeData recipe)
{
  return Recipe(
      id: recipe.id,
      label: recipe.label,
      image: recipe.image,
      url: recipe.url,
      calories: recipe.calories,
      totalWeight: recipe.totalWeight,
      totalTime: recipe.totalTime
  );
}

// Converts Recipe object to Insertable Moor object
Insertable<MoorRecipeData> recipeToInsertableMoorRecipe(Recipe recipe)
{
  return MoorRecipeCompanion.insert(
      label: recipe.label ?? '',
      image: recipe.image ?? '',
      url: recipe.url ?? '',
      calories: recipe.calories ?? 0,
      totalWeight: recipe.totalWeight ?? 0,
      totalTime: recipe.totalTime ?? 0
  );
}

Ingredient moorIngredientToIngredient(MoorIngredientData ingredient)
{
  return Ingredient(
      id: ingredient.id,
      recipeId: ingredient.recipeId,
      name: ingredient.name,
      weight: ingredient.weight);
}

MoorIngredientCompanion ingredientToInsertableMoorIngredient(
    Ingredient ingredient)
{
  return MoorIngredientCompanion.insert(
      recipeId: ingredient.recipeId ?? 0,
      name: ingredient.name ?? '',
      weight: ingredient.weight ?? 0);
}

