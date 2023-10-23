import 'dart:io';

import 'package:ceps_app/models/cep_model.dart';
import 'package:ceps_app/repositories/ceps_repository.dart';
import 'package:ceps_app/views/cep_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _repository = CepsRepository();
  var _ceps = <CepModel>[];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    if (_loading) {
      return;
    }
    _repository.getAll().then((value) {
      _ceps = value;
      setState(() {
        _loading = false;
      });
    });
    setState(() {
      _loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Expanded(child: Text("CEPs")),
            Expanded(
                child: Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => exit(0),
              ),
            ))
          ],
        ),
      ),
      body: Visibility(
        visible: _loading,
        replacement: _ceps.isEmpty
            ? const Center(
                child: Text("Nenhum CEP cadastrado"),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: _ceps.length,
                    itemBuilder: (BuildContext bc, int i) {
                      var model = _ceps[i];
                      return Dismissible(
                        background: Container(color: Colors.red),
                        onDismissed: (direction) async {
                          if (await _repository.delete(model.objectId!)) {
                            _load();
                          }
                        },
                        key: Key(model.objectId!),
                        child: InkWell(
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              title: Text("${model.cep} - ${model.logradouro}"),
                              subtitle: Text("${model.localidade}/${model.uf}"),
                            ),
                          ),
                          onTap: () async {
                            String? retorno = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (bc) => CepPage(model: model)));
                            if (retorno == "refresh") {
                              _load();
                            }
                          },
                        ),
                      );
                    }),
              ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? retorno = await Navigator.push(context,
              MaterialPageRoute(builder: (bc) => CepPage(model: CepModel())));
          if (retorno == "refresh") {
            _load();
          }
        },
        child: const Icon(Icons.add),
      ),
    ));
  }
}
