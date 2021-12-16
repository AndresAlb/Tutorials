import 'models/models.dart';

abstract class Repository
{
  // Find recipes and ingredients

  List<Recipe> findAllRecipes();

  Recipe findRecipeById(int id);

  List<Ingredient> findAllIngredients();

  List<Ingredient> findRecipeIngredients(int recipeId);

  // Insert recipes and ingredients

  int insertRecipe(Recipe recipe);

  List<int> insertIngredients(List<Ingredient> ingredients);

  // Delete recipes and ingredients

  void deleteRecipe(Recipe recipe);

  void deleteIngredient(Ingredient ingredient);

  void deleteIngredients(List<Ingredient> ingredients);

  void deleteRecipeIngredients(int recipeId);

  // Initialize and close the repository

  Future init();

  void close();

}
