import 'dart:async';
import 'package:flutter/material.dart';

class FooderlichTab
{
  static const int explore = 0;
  static const int recipes = 1;
  static const int toBuy = 2;
}

class AppStateManager extends ChangeNotifier
{
  bool _initialized = false;
  bool _loggedIn = false;
  bool _onboardingComplete = false;
  int _selectedTab = FooderlichTab.explore;

  bool get isInitialized => _initialized;
  bool get isLoggedIn => _loggedIn;
  bool get isOnboardingComplete => _onboardingComplete;
  int get getSelectedTab => _selectedTab;

  void initializeApp()
  {
    // Sets how long the app screen will display after the user starts the app
    Timer(const Duration(milliseconds: 2000), (){
      _initialized = true;
      notifyListeners();
    });
  }

  // Mock login function
  void login(String username, String password)
  {
    _loggedIn = true;
    notifyListeners();
  }

  void completeOnboarding()
  {
    _onboardingComplete = true;
    notifyListeners();
  }

  void goToTab(index)
  {
    _selectedTab = index;
    notifyListeners();
  }

  void goToRecipes()
  {
    _selectedTab = FooderlichTab.recipes;
    notifyListeners();
  }

  void logout()
  {
    _loggedIn = false;
    _onboardingComplete = false;
    _initialized = false;
    _selectedTab = 0;

    initializeApp();
    notifyListeners();
  }

}
