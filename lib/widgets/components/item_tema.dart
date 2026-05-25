import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/services/database_service.dart';

class ItemTema extends StatelessWidget {
  final TemaModel tema;

  ItemTema({super.key, required this.tema});
  
  final DatabaseService databaseService = DatabaseService();

  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.widthOf(context) * 0.1,
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.heightOf(context) * 0.13),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GestureDetector(
                onTap: () {
                
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff0915a),
                    borderRadius: BorderRadius.circular(200),
                  ),
                  height: MediaQuery.heightOf(context) * 0.25,
                  width: MediaQuery.heightOf(context) * 0.25,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Image.network(tema.assetUrl),
                  ),
                ),
              ),
            ),

            Container(
              alignment: Alignment.center,
              width: MediaQuery.widthOf(context) * 0.25,
              height: MediaQuery.heightOf(context) * 0.02,
              decoration: BoxDecoration(
                color: Color(0xff6055a2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(tema.nome),
            ),
          ],
        ),
      ),
    );
  }
}
