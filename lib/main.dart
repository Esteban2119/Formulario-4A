import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: FormularioRegistro(),
            ),
          ),
        ),
      ),
    );
  }
}

class FormularioRegistro extends StatefulWidget {
  @override
  _FormularioRegistroState createState() => _FormularioRegistroState();
}

class _FormularioRegistroState extends State<FormularioRegistro> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController fechaNacimientoController = TextEditingController();
  final TextEditingController edadController = TextEditingController();

  String? genero;
  String? estadoCivil;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        fechaNacimientoController.text = DateFormat('yyyy-MM-dd').format(picked);
        calcularEdad(picked);
      });
    }
  }

  void calcularEdad(DateTime fechaNacimiento) {
    final today = DateTime.now();
    int edad = today.year - fechaNacimiento.year;
    if (today.month < fechaNacimiento.month ||
        (today.month == fechaNacimiento.month && today.day < fechaNacimiento.day)) {
      edad--;
    }
    edadController.text = edad.toString();
  }

  String? _validateCedula(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su cédula';
    }
    if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'La cédula debe tener 10 dígitos numéricos';
    }
    return null;
  }

  String? _validateNombreApellido(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su $fieldName';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return '$fieldName solo puede contener letras';
    }
    return null;
  }

  String? _validateFechaNacimiento(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor seleccione su fecha de nacimiento';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E), // Fondo oscuro
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Create An Account",
              style: TextStyle(
                color: const Color.fromARGB(255, 241, 3, 3),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: cedulaController,
                  decoration: InputDecoration(
                    labelText: 'Cédula',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 95, 94, 94)),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateCedula,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: nombresController,
                  decoration: InputDecoration(
                    labelText: 'Nombres',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 95, 94, 94)),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) => _validateNombreApellido(value, 'nombres'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: apellidosController,
                  decoration: InputDecoration(
                    labelText: 'Apellidos',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 95, 94, 94)),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) => _validateNombreApellido(value, 'apellidos'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: fechaNacimientoController,
                  decoration: InputDecoration(
                    labelText: 'Fecha de Nacimiento',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 95, 94, 94)),
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.white),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  readOnly: true,
                  validator: _validateFechaNacimiento,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: edadController,
                  decoration: InputDecoration(
                    labelText: 'Edad',
                    labelStyle: TextStyle(color: const Color.fromARGB(255, 95, 94, 94)),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 20),
                Text("Género", style: TextStyle(color: Colors.white)),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text('Masculino', style: TextStyle(color: Colors.white)),
                        leading: Radio<String>(
                          value: 'Masculino',
                          groupValue: genero,
                          onChanged: (String? value) {
                            setState(() {
                              genero = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text('Femenino', style: TextStyle(color: Colors.white)),
                        leading: Radio<String>(
                          value: 'Femenino',
                          groupValue: genero,
                          onChanged: (String? value) {
                            setState(() {
                              genero = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (genero == null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Por favor seleccione su género',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 20),
                Text("Estado Civil", style: TextStyle(color: Colors.white)),
                CheckboxListTile(
                  title: const Text("Soltero/a", style: TextStyle(color: Colors.white)),
                  value: estadoCivil == "Soltero/a",
                  onChanged: (bool? value) {
                    setState(() {
                      estadoCivil = value! ? "Soltero/a" : null;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("Casado/a", style: TextStyle(color: Colors.white)),
                  value: estadoCivil == "Casado/a",
                  onChanged: (bool? value) {
                    setState(() {
                      estadoCivil = value! ? "Casado/a" : null;
                    });
                  },
                ),
                if (estadoCivil == null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Por favor seleccione su estado civil',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && genero != null && estadoCivil != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Formulario completado exitosamente')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Por favor complete todos los campos')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), backgroundColor: Colors.orange,
                      ),
                      child: Text("Create Account"),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), backgroundColor: Colors.grey,
                      ),
                      child: Text("Salir"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
