 import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Widget messages(Size size, DataSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Username",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 30),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Colors.blue,
            ),
            child: Text(
              snapshot.child('message').value.toString(),
              style:const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget messagesByUser(Size size, Map<String, dynamic> map) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "User",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              CircleAvatar(
                backgroundColor: Colors.black,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 30),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Colors.blue,
            ),
            child:const Text(
              "textifnkdsnisdfmb",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

