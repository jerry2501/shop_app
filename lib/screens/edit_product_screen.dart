import 'package:flutter/material.dart';

class EditProductSCreen extends  StatefulWidget {
  @override
  _EditProductSCreenState createState() => _EditProductSCreenState();
}

class _EditProductSCreenState extends State<EditProductSCreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
      ),
    );
  }
}
