import 'dart:core';
import 'dart:async';

import 'repository.dart';
import 'models/models.dart';

class MemoryRepository extends Repository
{
  final List<Recipe> _currentRecipes = <Recipe>[];
  final List<Ingredient> _currentIngredients = <Ingredient>[];

  Stream<List<Recipe>>? _recipeStream;
  Stream<List<Ingredient>>? _ingredientStream;

  final StreamController _recipeStreamController =
  StreamController<List<Recipe>>();
  final StreamController _ingredientStreamController =
  StreamController<List<Ingredient>>();

  // Check to see if you already have the stream. If not, call the stream
  // method, which creates a new stream, then return it.
  @override
  Stream<List<Recipe>> watchAllRecipes()
  {
    if (_recipeStream == null)
    {
      _recipeStream = _recipeStreamController.stream as Stream<List<Recipe>>;
    }

    return _recipeStream!;
  }

  // Check to see if you already have the stream. If not, call the stream
  // method, which creates a new stream, then return it.
  @override
  Stream<List<Ingredient>> watchAllIngredients()
  {
    if (_ingredientStream == null)
    {
      _ingredientStream =
      _ingredientStreamController.stream as Stream<List<Ingredient>>;
    }

    return _ingredientStream!;
  }

  @override
  Future<List<Recipe>> findAllRecipes()
  {
    return Future.value(_currentRecipes);
  }

  @override
  Future<Recipe> findRecipeById(int id)
  {
    return Future.value(
        _currentRecipes.firstWhere((recipe) => recipe.id == id));
  }

  @override
  Future<List<Ingredient>> findAllIngredients()
  {
    return Future.value(_currentIngredients);
  }

  @override
  Future<List<Ingredient>> findRecipeIngredients(int recipeId)
  {
    final recipe =
        _currentRecipes.firstWhere((recipe) => recipe.id == recipeId);
    final recipeIngredients = _currentIngredients
        .where((ingredient) => ingredient.recipeId == recipe.id)
        .toList();

    return Future.value(recipeIngredients);
  }

  @override
  Future<int> insertRecipe(Recipe recipe)
  {
    // Insert the recipe to the list of recipes
    _currentRecipes.add(recipe);

    // Add the modified list of recipes to the Stream
    _recipeStreamController.sink.add(_currentRecipes);

    if (recipe.ingredients != null)
    {
      insertIngredients(recipe.ingredients!);
    }

    return Future.value(0);
  }


  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients)
  {
    if (ingredients.length != 0)
    {
      // Insert the new ingredients to the list of ingredients
      _currentIngredients.addAll(ingredients);

      // Add the modified list of ingredients to the Stream
      _ingredientStreamController.sink.add(_currentIngredients);
    }

    return Future.value(<int>[]);
  }

  @override
  Future<void> deleteRecipe(Recipe recipe)
  {
    // Remove the recipe from the list of recipes
    _currentRecipes.remove(recipe);

    // Add the modified list of recipes to the Stream
    _recipeStreamController.sink.add(_currentRecipes);

    if (recipe.id != null)
    {
      deleteRecipeIngredients(recipe.id!);
    }

    // Return a void Future
    return Future.value();
  }

  @override
  Future<void> deleteIngredient(Ingredient ingredient)
  {
    // Remove the ingredient from the list of ingredients
    _currentIngredients.remove(ingredient);

    // Add the modified list of ingredients to the Stream
    _ingredientStreamController.sink.add(_currentIngredients);

    return Future.value();
  }

  @override
  Future<void> deleteIngredients(List<Ingredient> ingredients)
  {
    // Remove the ingredients from the list of ingredients
    _currentIngredients
        .removeWhere((ingredient) => ingredients.contains(ingredient));

    // Add the modified list of ingredients to the Stream
    _ingredientStreamController.sink.add(_currentIngredients);

    return Future.value();
  }

  @override
  Future<void> deleteRecipeIngredients(int recipeId)
  {
    _currentIngredients
        .removeWhere((ingredient) => ingredient.recipeId == recipeId);

    _ingredientStreamController.sink.add(_currentIngredients);

    return Future.value();
  }

  @override
  Future init() { return Future.value(); }

  @override
  void close()
  {
    _recipeStreamController.close();
    _ingredientStreamController.close();
  }

}
