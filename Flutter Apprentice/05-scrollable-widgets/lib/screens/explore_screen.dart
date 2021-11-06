import 'package:flutter/material.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../api/mock_fooderlich_service.dart';

class ExploreScreen extends StatefulWidget
{

  ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();

}

class _ExploreScreenState extends State<ExploreScreen>
{

  final mockService = MockFooderlichService();
  late ScrollController _controller;

  @override
  void initState()
  { 
    _controller = ScrollController(); 
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {

    return FutureBuilder(

      future: mockService.getExploreData(),

      builder: (context, AsyncSnapshot<ExploreData> snapshot)
      {

        if (snapshot.connectionState == ConnectionState.done)
        {

          return Scrollbar(
            child: ListView(
              controller: _controller,

              scrollDirection: Axis.vertical,

              children: [

                TodayRecipeListView(recipes:
                snapshot.data?.todayRecipes ?? []),

                const SizedBox(height: 16),

                FriendPostListView(
                    friendPosts: snapshot.data?.friendPosts ?? []),

              ],
            ),
          );
        }
        else
        {
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _scrollListener()
  {
    // Prints message when user scrolls to the top or the bottom of the list
    // in the Explore screen

    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print('i am at the bottom!');
    }

    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print('i am at the top!');
    }
  }

  @override
  void dispose()
  {
    // Disposes the scrollListener
    _controller.removeListener(_scrollListener);
    super.dispose();
  }



}
