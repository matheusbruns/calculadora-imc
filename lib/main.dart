import 'package:calc_imc_n3/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCKaO2NHrAZnIozn4HMRWBgcd7C40b7nxM",
      appId: "1:944778622998:android:d88ce6bbb98fc421e01d37",
      messagingSenderId: "944778622998",
      projectId: "calc-imc-2ac59",
    ),
  );
  runApp(MaterialApp(
    home: HomeScreen(),
    theme: ThemeData.light(),
  ));
}

String _result = "";

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Calcule seu IMC';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

TextEditingController controllerPeso = TextEditingController();
TextEditingController controllerAltura = TextEditingController();
TextEditingController controllerNome = TextEditingController();

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  int? status;

  void sendData(double imc, double peso, double altura, String nome) {
    FirebaseFirestore.instance.collection("Pesagens").add(
      {
        "altura": altura,
        "peso": peso,
        "imc": imc,
        "nome": nome,
        "data": Timestamp.now()
      }
    );
  }

  void calculateImc() {
    double peso = double.parse(controllerPeso.text);
    double altura = double.parse(controllerAltura.text) / 100.0;
    double imc = peso / (altura * altura);
    String nome = controllerNome.text.toString();

    setState(() {
      _result = "IMC = ${imc.toStringAsPrecision(2)}\n";
      if(imc < 17)
        _result += "Muito abaixo do peso";
      else if (imc < 18.49)
        _result += "Abaixo do peso";
      else if (imc < 24.99)
        _result += "Peso normal";
      else if (imc < 29.99)
        _result += "Acima do peso";
      else if (imc < 35.0)
        _result += "Obesidade I";
      else if (imc < 40.0)
        _result += "Obesidade II (severa)";
      else
        _result += "Obesidade III (mórbida)";
    });

    sendData(imc, peso, altura, nome);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: controllerNome,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.green, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.green),
              ),
              border: OutlineInputBorder(),
              labelText: 'Insira seu nome aqui',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: controllerPeso,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.green, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.green),
              ),
              border: OutlineInputBorder(),
              labelText: 'Insira seu peso aqui',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: controllerAltura,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.green, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.green),
              ),
              border: OutlineInputBorder(),
              labelText: 'Insira sua altura aqui',
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            alignment: Alignment.center,
              backgroundColor: Colors.black,
              elevation: 0,
              shadowColor: Colors.green),
          child: Text(
            'Calcular',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            calculateImc();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        SizedBox(
          height: 8.0,
        ),
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              elevation: 0,
              shadowColor: Colors.green),
          child: Text(
            'Voltar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 36.0),
          child: Text(
            _result,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}


