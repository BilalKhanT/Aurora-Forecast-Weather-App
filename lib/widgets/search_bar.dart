import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;

  const SearchBarWidget({
    Key? key,
    required this.searchController,
    this.onSearchChanged,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.searchController,
      onChanged: widget.onSearchChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        fillColor: Theme.of(context)
            .colorScheme.outline,
        filled: true,
        suffixIcon: Icon(
          Icons.tune,
          color: Theme.of(context)
              .colorScheme.primary,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context)
              .colorScheme.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        hintText: "Search a location",
        hintStyle: GoogleFonts.poppins(
          color: Theme.of(context)
              .colorScheme.secondary,
          fontSize: 14,
        ),
      ),
    );
  }
}