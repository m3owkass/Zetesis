import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/controller/auth_controller.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/custom_formfield.dart';

class AddTaskForm extends ConsumerStatefulWidget {
  const AddTaskForm({super.key});

  @override
  ConsumerState<AddTaskForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends ConsumerState<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController= TextEditingController();
  final _descricaoController = TextEditingController();
  final _perguntaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var stringListReturnedFromApiCall = ["first", "second", "third", "fourth", "..."];
    // This list of controllers can be used to set and get the text from/to the TextFields
    Map<String,TextEditingController> textEditingControllers = {};
    var textFields = <TextField>[];
    stringListReturnedFromApiCall.forEach((str) {
      var textEditingController = new TextEditingController(text: str);
      textEditingControllers.putIfAbsent(str, ()=>textEditingController);
      return textFields.add( TextField(controller: textEditingController));
    });

    return Scaffold(
        appBar: AppBar(
          title: Text("oi"),
        ),
        body: SingleChildScrollView(
            child: new Column(
              children:[
              Column(children:  textFields),
                TextButton(
                  child: Text("Print Values"),
                    onPressed: (){
                    stringListReturnedFromApiCall.forEach((str){
                      print(textEditingControllers[str]?.text);
                    });
                  })
              ]
            )));
  }
}
