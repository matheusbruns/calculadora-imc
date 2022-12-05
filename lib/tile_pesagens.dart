import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calc_imc_n3/main.dart';

class PesagemTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  PesagemTile(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 4.0
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "NOME: ${snapshot.get('nome')} || PESO: ${snapshot.get("peso")} || ALTURA: ${snapshot.get("altura")}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "IMC: ${snapshot.get('imc').toStringAsPrecision(4)}",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  " - ${snapshot.get('result')}",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
