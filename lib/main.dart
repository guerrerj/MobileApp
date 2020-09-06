import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(Heet());

class Heet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Bienvenue a Heet!",
        home: Scaffold(
            appBar: AppBar(title: Text("Bienvenue")),
            body: Center(child: RandomWords())));
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return Text(wordPair.asPascalCase);
  }
}
