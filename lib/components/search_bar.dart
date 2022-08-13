import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key, required this.onChanged, required this.searchCtrl})
      : super(key: key);
  final Function(String) onChanged;
  final TextEditingController searchCtrl;
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        controller: widget.searchCtrl,
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search), labelText: "Search by username"),
        onChanged: widget.onChanged,
      ),
    );
  }
}
