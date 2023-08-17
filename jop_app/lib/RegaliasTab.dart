import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Una pantalla que muestra un formulario para calcular la regalía de navidad.
///
/// El usuario puede ingresar la fecha de entrada, la fecha de salida y el salario mensual,
/// y pulsar el botón Calcular Regalía. La aplicación muestra la regalía calculada según
/// la fórmula que se explica en el primer resultado de la búsqueda web.
class RegaliasTab extends StatefulWidget {
  @override
  _RegaliasTabState createState() => _RegaliasTabState();
}

class _RegaliasTabState extends State<RegaliasTab> {
  // Usa final para las variables que no cambian después de ser asignadas
  final _fechaEntradaController = TextEditingController();
  final _fechaSalidaController = TextEditingController();
  final _salarioController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Usa una clave global para el formulario

  double _regalia = 0.0;

  // Usa async y await para manejar las operaciones asíncronas
  Future<void> _calcularRegalia() async {
    // Valida el formulario antes de calcular la regalía
    if (_formKey.currentState!.validate()) {
      setState(() {
        String fechaEntrada = _fechaEntradaController.text;
        String fechaSalida = _fechaSalidaController.text;

        DateTime inicio = DateTime.parse(fechaEntrada);
        DateTime fin = DateTime.parse(fechaSalida);

        int mesesTrabajadosEnAnoSalida = fin.month;
        Duration diferencia = fin.difference(inicio);
        int diasTrabajadosEnMesSalida = fin.day;
        double salarioMensual = double.parse(_salarioController.text);
        int diasEnMesSalida =
            DateTime(fin.year, fin.month + 1, 0).day; // Número de días en el mes de salida usando el constructor DateTime
        double salarioPorDia =
            salarioMensual / diasEnMesSalida; // Salario por día en el mes de salida
        double salarioMes = salarioPorDia *
            diasTrabajadosEnMesSalida; // Salario proporcional al número de días trabajados en el mes

        double salarioNavidad =
            (salarioMensual * mesesTrabajadosEnAnoSalida + salarioMes) / 12;

        _regalia = salarioNavidad;
      });
    }
  }

  Future<void> _seleccionarFecha(TextEditingController controller) async {
    // Usa await para esperar a que se seleccione una fecha antes de asignarla al controlador de texto
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (fechaSeleccionada != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(fechaSeleccionada);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Usa const para los widgets que no cambian
        child: Form( // Usa Form para validar los campos de texto
          key: _formKey, // Usa la clave global para el formulario
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField( // Usa TextFormField con un validador para comprobar si el campo está vacío
                controller: _fechaEntradaController,
                decoration:
                    const InputDecoration(labelText: 'Fecha de Entrada'), // Usa const para los widgets que no cambian
                readOnly: true,
                onTap: () => _seleccionarFecha(_fechaEntradaController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una fecha de entrada';
                  }
                  return null;
                },
              ),
              TextFormField( // Usa TextFormField con un validador para comprobar si el campo está vacío
                controller: _fechaSalidaController,
                decoration:
                    const InputDecoration(labelText: 'Fecha de Salida'), // Usa const para los widgets que no cambian
                readOnly: true,
                onTap: () => _seleccionarFecha(_fechaSalidaController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una fecha de salida';
                  }
                  return null;
                },
              ),
              TextFormField( // Usa TextFormField con un validador para comprobar si el campo está vacío
                controller: _salarioController,
                decoration: const InputDecoration(labelText: 'Salario'), // Usa const para los widgets que no cambian
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un salario';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Usa const para los widgets que no cambian
              ElevatedButton(
                onPressed: _calcularRegalia,
                child: const Text('Calcular Regalía'), // Usa const para los widgets que no cambian
              ),
              const SizedBox(height: 16.0), // Usa const para los widgets que no cambian
              Text(
                'Regalía Calculada: \$${_regalia.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
