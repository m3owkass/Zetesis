import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/providers.dart';

class ItemTema extends ConsumerStatefulWidget {
  final TemaModel tema;

  ItemTema({super.key, required this.tema});

  @override
  ConsumerState<ItemTema> createState() => _ItemTemaState();
}

class _ItemTemaState extends ConsumerState<ItemTema> {
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
                ref.read(temaSelecionadoProvider.notifier).state = widget.tema.nome;
                Navigator.pop(context);
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
                    child: Image.network(widget.tema.assetUrl),
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
              child: Text(widget.tema.nome),
            ),
          ],
        ),
      ),
    );
  }
}
