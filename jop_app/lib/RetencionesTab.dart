import 'package:flutter/material.dart';

/// Una pantalla que muestra un formulario para calcular las retenciones de impuestos.
///
/// El usuario puede ingresar el salario mensual y la comisión,
/// y pulsar el botón Calcular Retenciones. La aplicación muestra las retenciones de ISR, SFS, AFP, descuento y sueldo neto según
/// la tabla de ISR que se explica en el segundo resultado de la búsqueda web.
class RetencionesTab extends StatefulWidget {
  @override
  _RetencionesTabState createState() => _RetencionesTabState();
}

class _RetencionesTabState extends State<RetencionesTab> {
  // Usa final para las variables que no cambian después de ser asignadas
  final _salarioController = TextEditingController();
  final _comisionController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Usa una clave global para el formulario

  double _isr = 0.0;
  double _sfs = 0.0;
  double _afp = 0.0;
  double _descuento = 0.0;
  double _retencionNeta = 0.0;

  // Usa async y await para manejar las operaciones asíncronas
  Future<void> _calcularRetenciones() async {
    // Valida el formulario antes de calcular las retenciones
    if (_formKey.currentState!.validate()) {
      // Usa await para esperar a que se complete el cálculo antes de actualizar el estado
      setState(() {
        // Obtén los valores de salario y comisión ingresados por el usuario
        double salario = double.parse(_salarioController.text);
        double comision = double.parse(_comisionController.text);

        // Calcula los montos de ISR, SFS, AFP, descuento y retención neta
        double ingresoBrutoMensual = salario + comision;

        double sfs = ingresoBrutoMensual * 0.0304;
        double afp = ingresoBrutoMensual * 0.0287;

        double ingresoBrutoAnual = ingresoBrutoMensual * 12;

        double isr = 0;
        if (ingresoBrutoAnual > 867123.01) {
          isr = ((ingresoBrutoAnual-867123.01)*0.25)+79776.25;
        } else if (ingresoBrutoAnual > 624329.01) {
          isr = ((ingresoBrutoAnual-624329.01)*0.20)+31216.35;
        } else if (ingresoBrutoAnual >416220.01) {
          isr = (ingresoBrutoAnual-416220.01)*0.15;
        } else {
          isr=0;
        }
        isr=isr/12;
        double descuento = sfs + afp + isr;
        double retencionNeta = ingresoBrutoMensual - descuento;

        // Asigna los valores calculados a las variables correspondientes
        _isr = isr;
        _sfs = sfs ;
        _afp = afp ;
        _descuento = descuento ;
        _retencionNeta = retencionNeta ;
      });
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
              TextFormField( // Usa TextFormField con un validador para comprobar si el campo está vacío o es negativo
                controller: _salarioController,
                decoration:
                    const InputDecoration(labelText: 'Salario'), // Usa const para los widgets que no cambian
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un salario';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Por favor ingrese un valor numérico positivo';
                  }
                  return null;
                },
              ),
              TextFormField( // Usa TextFormField con un validador para comprobar si el campo está vacío o es negativo
                controller: _comisionController,
                decoration:
                    const InputDecoration(labelText: 'Comisión'), // Usa const para los widgets que no cambian
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una comisión';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Por favor ingrese un valor numérico positivo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Usa const para los widgets que no cambian
              ElevatedButton(
                onPressed: _calcularRetenciones,
                child: const Text('Calcular Retenciones'), // Usa const para los widgets que no cambian
              ),
              const SizedBox(height: 16.0), // Usa const para los widgets que no cambian
              Text(
                'ISR: \$${_isr.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'SFS: \$${_sfs.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'AFP: \$${_afp.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Descuento: \$${_descuento.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                'Sueldo Neto: \$${_retencionNeta.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
