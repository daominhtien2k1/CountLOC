import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/unknown_people/unknown_people_bloc.dart';
import '../../blocs/unknown_people/unknown_people_event.dart';
import '../../blocs/unknown_people/unknown_people_state.dart';
import 'widgets/friend_widgets.dart';

class UnknownPeopleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UnknownPeopleBloc>(context).add(ListUnknownPeopleFetched());
    return UnknowPeopleScreenContent();
  }
}

class UnknowPeopleScreenContent extends StatefulWidget {
  const UnknowPeopleScreenContent({
    Key? key,
  }) : super(key: key);

  @override
  State<UnknowPeopleScreenContent> createState() =>
      _UnknowPeopleScreenContent();
}

class _UnknowPeopleScreenContent extends State<UnknowPeopleScreenContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: const Text("Gợi ý bạn bè"),
            centerTitle: false,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Container(
                color: Colors.white,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text("Danh sách người bạn có thể biết:",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ))),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: UnknownPeopleList()
          ),
        ],
      ),
    );
  }
}

class UnknownPeopleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnknownPeopleBloc, UnknownPeopleState>(
      builder: (context, state) {
        switch (state.status) {
          case UnknownPeopleStatus.initial:
            return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
          case UnknownPeopleStatus.loading:
            return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
          case UnknownPeopleStatus.failure:
            return SliverToBoxAdapter(child: Text("Failed"));
          case UnknownPeopleStatus.success: {
              final unknownPeopleList = state.unknownPeopleList;
              return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return UnknownPersonContainer(unknownPerson: unknownPeopleList.unknownPeople[index]);
                    },
                    childCount: unknownPeopleList.unknownPeople.length
                  )
              );
            }
        }
      }
    );
  }
}

