import 'package:flutter/material.dart';

class LiquidacionTab extends StatefulWidget {
  @override
  _LiquidacionTabState createState() => _LiquidacionTabState();
}

class _LiquidacionTabState extends State<LiquidacionTab> {
  // Crear una clave global para el formulario
  final _formKey = GlobalKey<FormState>();

  // Crear controladores para los campos
  TextEditingController _fechaEntradaController = TextEditingController();
  TextEditingController _fechaSalidaController = TextEditingController();
  TextEditingController _salarioController = TextEditingController();

  // Crear variables para los checkbox
  bool _incluyePreaviso = false;
  bool _incluyeCesantia = false;
  bool _incluyeVacaciones = false;
  bool _incluyeSalarioNavidad = false;

  // Crear una variable para guardar la liquidación total
  double _liquidacionTotal = 0.0;

  // Crear una función para calcular la liquidación
  void _calcularLiquidacion() {
    // Validar el formulario
    if (_formKey.currentState!.validate()) {
      // Si el formulario es válido, obtener los valores de los campos
      DateTime fechaEntrada = DateTime.parse(_fechaEntradaController.text);
      DateTime fechaSalida = DateTime.parse(_fechaSalidaController.text);

      double salario = double.parse(_salarioController.text);

      int diasEnMes(int mes, int ano) {
        return DateTime(ano, mes + 1, 0).day;
      }

      int meses =
          fechaSalida.month - fechaEntrada.month + (fechaSalida.year - fechaEntrada.year) * 12;
      int dias = fechaSalida.day - fechaEntrada.day;
      int mesesTrabajadosEnAnoSalida = fechaSalida.month;
      int diasTrabajadosEnMesSalida = fechaSalida.day;
      int anosTrabajados = fechaSalida.year - fechaEntrada.year;
      if (fechaSalida.month < fechaEntrada.month ||
          (fechaSalida.month == fechaEntrada.month && fechaSalida.day < fechaEntrada.day)) {
        anosTrabajados--;
      }

      double preaviso = 0;
      double cesantia = 0;
      double vacaciones = 0;
      double salarioNavidad = 0;

      if (_incluyePreaviso) {
        if (meses < 3) {
          preaviso = 0.0;
        } else if (meses < 6) {
          preaviso =
              (salario * dias + salario * meses * 30) / (meses * 30) / 23.83 * 7;
        } else if (meses < 12) {
          preaviso =
              (salario * dias + salario * meses * 30) / (meses * 30) / 23.83 * 14;
        } else {
          preaviso =
              (salario * dias + salario * meses * 30) / (meses * 30) / 23.83 * 28;
        }
      }

      if (_incluyeCesantia) {
        if (meses < 3) {
          cesantia = 0.0;
        } else if (meses < 6) {
          cesantia =
              (salario * dias + salario * meses * 30) / (meses * 30) / 23.83 * 6;
        } else if (meses < 12) {
          cesantia =
              (salario * dias + salario * meses * 30) / (meses * 30) / 23.83 * 13;
        } else if (meses < 60) {
          cesantia =
              (salario * dias + salario * meses * 30) / (meses * 30) / 23.83 *
                  (21 + (meses - 12) * (21 / 12));
        } else {
          cesantia =
              (salario * dias + salario * meses * 30) / (meses * 30) / 23.83 *
                  (23 * meses / 12);
        }
      }

      if (_incluyeVacaciones) {
        if (anosTrabajados > 5) {
          vacaciones = (salario / 23.83) * 18;
        } else {
          vacaciones = (salario / 23.83) * 14;
        }
      }
      if (_incluyeSalarioNavidad) {
        int diasEnMesSalida =
            diasEnMes(fechaSalida.month, fechaSalida.year); // Número de días en el mes de salida
        double salarioPorDia =
            salario / diasEnMesSalida; // Salario por día en el mes de salida
        double salarioMes = salarioPorDia *
            diasTrabajadosEnMesSalida; // Salario proporcional al número de días trabajados en el mes
        salarioNavidad =
            (salario * mesesTrabajadosEnAnoSalida + salarioMes) / 12;
      }

      _liquidacionTotal = preaviso + cesantia + vacaciones + salarioNavidad;

      // Actualizar el estado con la liquidación calculada
      setState(() {
        _liquidacionTotal = _liquidacionTotal;
      });
    }
  }

  // Crear una función para seleccionar una fecha usando un date picker
  Future<void> _seleccionarFecha(TextEditingController controller) async {
    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        controller.text = fechaSeleccionada.toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          // Asignar la clave al formulario
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => _seleccionarFecha(_fechaEntradaController),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _fechaEntradaController,
                    decoration: InputDecoration(labelText: 'Fecha de Entrada'),
                    // Validar que el campo no esté vacío
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduzca una fecha';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _seleccionarFecha(_fechaSalidaController),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _fechaSalidaController,
                    decoration: InputDecoration(labelText: 'Fecha de Salida'),
                    // Validar que el campo no esté vacío
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduzca una fecha';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: _salarioController,
                decoration: InputDecoration(labelText: 'Salario'),
                // Validar que el campo no esté vacío y sea un número válido
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduzca un salario';
                  }
                  // Usar regex para validar que el valor sea un número
                  final regex = RegExp(r'^\d+(\.\d+)?$');
                  if (!regex.hasMatch(value)) {
                    return 'Por favor, introduzca un número válido';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: Text('¿Ha sido usted Pre-avisado?'),
                value: _incluyePreaviso,
                onChanged: (value) {
                  setState(() {
                    _incluyePreaviso = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('¿Desea incluir Cesantía?'),
                value: _incluyeCesantia,
                onChanged: (value) {
                  setState(() {
                    _incluyeCesantia = value!;
                  });
                },
              ),
      
            CheckboxListTile(
              title: Text('¿Ha tomado las Vacaciones correspondientes al último año?'),
              value: _incluyeVacaciones,
              onChanged: (value) {
                setState(() {
                  _incluyeVacaciones = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('¿Incluir salario de Navidad?'),
              value: _incluyeSalarioNavidad,
              onChanged: (value) {
                setState(() {
                  _incluyeSalarioNavidad = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calcularLiquidacion,
              child: Text('Calcular Liquidación'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Liquidación Calculada: $_liquidacionTotal',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    ));
  }
}
