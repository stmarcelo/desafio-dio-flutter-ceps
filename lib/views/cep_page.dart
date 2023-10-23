import 'package:brasil_fields/brasil_fields.dart';
import 'package:ceps_app/models/cep_model.dart';
import 'package:ceps_app/repositories/ceps_repository.dart';
import 'package:ceps_app/repositories/via_cep_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CepPage extends StatefulWidget {
  CepModel model;
  CepPage({super.key, required this.model});

  @override
  State<CepPage> createState() => _CepPageState();
}

class _CepPageState extends State<CepPage> {
  final GlobalKey<FormState> _form = GlobalKey();
  final _repository = CepsRepository();
  final _viaCep = ViaCEPRepository();
  late CepModel _model;
  var _loading = false;

  @override
  void initState() {
    super.initState();
    _model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("CEP ${widget.model.cep ?? "(novo)"}")),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                child: Column(
                  //   spacing: 10,
                  //   direction: Axis.vertical,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: TextEditingController(text: _model.cep),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(label: Text("CEP")),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CepInputFormatter(),
                      ],
                      validator: (value) {
                        var cep = value
                            ?.replaceAll(".", "")
                            .replaceAll("-", "")
                            .trim();
                        if (cep == null || cep.length != 8) {
                          return "CEP inválido";
                        }
                        return null;
                      },
                      onChanged: (value) async {
                        _model.cep = value;
                        if (value.length == 10) {
                          var viacep = await _viaCep.get(value);
                          if (viacep != null) {
                            _model.logradouro = viacep.logradouro;
                            _model.complemento = viacep.complemento;
                            _model.bairro = viacep.bairro;
                            _model.localidade = viacep.localidade;
                            _model.logradouro = viacep.logradouro;
                            _model.uf = viacep.uf;
                            _model.ddd = viacep.ddd;
                            _model.gia = viacep.gia;
                            _model.ibge = viacep.ibge;
                            _model.siafi = viacep.siafi;
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                          setState(() {});
                        }
                      },
                    ),
                    TextFormField(
                      controller:
                          TextEditingController(text: _model.logradouro),
                      decoration:
                          const InputDecoration(label: Text("Logradouro")),
                      onChanged: (value) => _model.logradouro = value,
                    ),
                    TextFormField(
                      controller:
                          TextEditingController(text: _model.complemento),
                      decoration:
                          const InputDecoration(label: Text("Complemento")),
                      onChanged: (value) => _model.complemento = value,
                    ),
                    TextFormField(
                      controller: TextEditingController(text: _model.bairro),
                      decoration: const InputDecoration(label: Text("Bairro")),
                      onChanged: (value) => _model.bairro = value,
                    ),
                    TextFormField(
                      controller:
                          TextEditingController(text: _model.localidade),
                      decoration:
                          const InputDecoration(label: Text("Municipio")),
                      onChanged: (value) => _model.localidade = value,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 20,
                      children: [
                        DropdownButtonFormField(
                          value: _model.uf,
                          decoration: const InputDecoration(label: Text("UF")),
                          items: Estados.listaEstadosSigla.map((String estado) {
                            return DropdownMenuItem(
                                value: estado, child: Text(estado));
                          }).toList(),
                          onChanged: (value) => _model.uf = value,
                        ),
                        TextFormField(
                          controller: TextEditingController(text: _model.ddd),
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          decoration: const InputDecoration(label: Text("DDD")),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (value) => _model.ddd = value,
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          if (_form.currentState?.validate() == true) {
                            if (_model.objectId == null) {
                              await _repository.create(_model);
                            } else {
                              await _repository.update(_model);
                            }
                            Navigator.pop(context, "refresh");
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text("Salvar"))
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
