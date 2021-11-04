import 'package:flutter/material.dart';

import '../components/components.dart';
import '../models/models.dart';
import '../api/mock_fooderlich_service.dart';

class ExploreScreen extends StatelessWidget {
  // 1
  final mockService = MockFooderlichService();

  ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(

      future: mockService.getExploreData(),

      builder: (context, AsyncSnapshot<ExploreData> snapshot) {

        if (snapshot.connectionState == ConnectionState.done) {

          return Scrollbar(
            child: ListView(

              scrollDirection: Axis.vertical,
              // ignore: lines_longer_than_80_chars, lines_longer_than_80_chars
              children: [

                TodayRecipeListView(recipes: snapshot.data?.todayRecipes ?? []),

                const SizedBox(height: 16),

                FriendPostListView(friendPosts: snapshot.data?.friendPosts ?? []),

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


}
