import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meetz/core/core.dart';
import 'package:meetz/pages/home/home_page.dart';
import 'package:meetz/shared/widgets/form_input_widget.dart';
import 'package:meetz/pages/rooms_manegment/room_manegment_page.dart';
import 'package:meetz/shared/widgets/app_bar_back_widget.dart';
import 'package:meetz/shared/widgets/page_title_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../shared/widgets/form_button_widget.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final _formkey = GlobalKey<FormState>();
  final _imageController = TextEditingController();
  final _maxPeopleController = TextEditingController();
  final _roomNumberController = TextEditingController();
  final _floorNumberController = TextEditingController();
  final _roomNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _metersRoomController = TextEditingController();
  var numMask =
      new MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});

  bool _hasSplit = false;
  bool _hasBoard = false;
  bool _hasDatashow = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarBackWidget(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RoomsManegmentPage(),
              ),
            );
          },
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageTitleWidget(title: "Adicionar sala"),
                Expanded(
                  flex: 1,
                  child: Form(
                      key: _formkey,
                      child: Center(
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FormInputWidget(
                                label: "Insira o nome da sala",
                                icon: Icons.text_format,
                                controller: _roomNameController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return ("O campo nome da sala não está preenchido");
                                  }
                                  return null;
                                },
                              ),
                              FormInputWidget(
                                  label: "Insira uma URL de imagem",
                                  icon: Icons.image,
                                  controller: _imageController,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return ("O campo imagem não está preenchido");
                                    }
                                    return null;
                                  }),
                              FormInputWidget(
                                label: "Insira o número máximo de pessoas",
                                icon: Icons.people,
                                controller: _maxPeopleController,
                                keyboardType: TextInputType.number,
                                mask: [numMask],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return ("O campo número máximo de pessoas não está preenchido");
                                  }
                                  return null;
                                },
                              ),
                              FormInputWidget(
                                label: "Insira o número da sala",
                                icon: Icons.room_sharp,
                                controller: _roomNumberController,
                                keyboardType: TextInputType.number,
                                mask: [numMask],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return ("O campo número da sala não está preenchido");
                                  }
                                  return null;
                                },
                              ),
                              FormInputWidget(
                                label: "Insira o andar da sala",
                                icon: Icons.room_sharp,
                                controller: _floorNumberController,
                                keyboardType: TextInputType.number,
                                mask: [numMask],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return ("O campo andar da sala não está preenchido");
                                  }
                                  return null;
                                },
                              ),

                              FormInputWidget(
                                label: "Escreva aqui a descrição da sala",
                                icon: Icons.rtt,
                                controller: _descriptionController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return ("O campo descrição da sala não está preenchido");
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: FormInputWidget(
                                      label: "Insira o tamanho da sala",
                                      icon: Icons.rule,
                                      controller: _metersRoomController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return ("O campo tamanho da sala não está preenchido corretamente");
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Text("metros²")
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text("Especificações: "),
                              ),
                              SwitchListTile(
                                  title: Text('Ar-condicionado'),
                                  value: _hasSplit,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _hasSplit = value;
                                    });
                                  },
                                  secondary: Icon(
                                    Icons.air,
                                    color: AppColors.green800,
                                  )),
                              SwitchListTile(
                                  title: Text('Quadro'),
                                  value: _hasBoard,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _hasBoard = value;
                                    });
                                  },
                                  secondary: Icon(
                                    Icons.check_box_outline_blank,
                                    color: AppColors.green800,
                                  )),
                              SwitchListTile(
                                  title: Text('Datashow'),
                                  value: _hasDatashow,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _hasDatashow = value;
                                    });
                                  },
                                  secondary: Icon(
                                    Icons.camera_outdoor,
                                    color: AppColors.green800,
                                  )),

                              //RememberMeWidget(),
                              FormButtonWidget(
                                  text: 'ADICIONAR',
                                  onPressed: () async {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (_formkey.currentState!.validate()) {
                                      var response = await createRoom();
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      if (response == true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBarSuccess);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RoomsManegmentPage()));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBarError);
                                      }
                                    }
                                  })
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final snackBarSuccess = SnackBar(
      content: Text("Sala criada com sucesso", textAlign: TextAlign.center),
      backgroundColor: AppColors.green600);

  final snackBarError = SnackBar(
      content: Text("Alguns campos estáo incorretos/não preenchidos",
          textAlign: TextAlign.center),
      backgroundColor: Colors.redAccent);

  Future<bool?> createRoom() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getStringList('config') != null) {
      List<String> map = sharedPreferences.getStringList('config') ?? [];
      String token = map[0];
      var url = Uri.parse("${dotenv.env["URL"]}/meeting_room");

      Map data = {
        'room_specification': {
          'name': _roomNameController.text,
          'description': _descriptionController.text,
          'max_person': _maxPeopleController.text,
          'has_data_show': _hasDatashow.toString(),
          'has_board': _hasBoard.toString(),
          'has_split': _hasSplit.toString(),
          'size': "${_metersRoomController.text}m quadrados"
        },
        'room_localization': {
          'number': _roomNumberController.text,
          'floor': _floorNumberController.text
        },
        'image': {'url': _imageController.text}
      };
      String body = json.encode(data);

      http.Response? response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: body);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }
  }
}
