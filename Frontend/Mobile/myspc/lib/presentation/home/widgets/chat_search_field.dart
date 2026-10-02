import 'package:flutter/material.dart';

class ChatSearchField extends StatelessWidget {
  const ChatSearchField({required this.scale, super.key});
  final double scale;
  @override
  Widget build(BuildContext context) => SizedBox(height: 48 * scale, child: TextField(decoration: InputDecoration(hintText: 'Search chats', hintStyle: TextStyle(fontSize: 16 * scale), prefixIcon: Icon(Icons.search_rounded, size: 27 * scale), filled: true, fillColor: Colors.white, contentPadding: EdgeInsets.zero, border: OutlineInputBorder(borderRadius: BorderRadius.circular(28 * scale), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28 * scale), borderSide: BorderSide.none))));
}
