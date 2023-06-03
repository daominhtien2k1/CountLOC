import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 335,
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: TextField(
        // controller: _controller,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm....',
          border: InputBorder.none,
        ),
        onSubmitted: (query) {
          // Code to handle the search query submitted by the user
          print('Search query: $query');
        },
      ),
    );
  }
}
