import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TableScreen extends StatefulWidget {
  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  Widget buildTable() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(" " + 1.toString() + "   "),
                Row(
                  children: [
                    Image.network(
                      "https://upload.wikimedia.org/wikipedia/en/thumb/5/52/Bengaluru_FC_logo.svg/1200px-Bengaluru_FC_logo.svg.png",
                      height: 30,
                      width: 30,
                    ),
                    Text("Bengaluru FC"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("10"),
                Text("10"),
                Text("10"),
                Text("10"),
                Text("10"),
                Text("10"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            const Color(0xffe84860),
            const Color(0xffe70066),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        )),
        child: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Pos',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Club',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PL',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'W',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'D',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'L',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'GD',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Pts',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            buildTable(),
          ],
        ),
      ),
    );
  }
}
