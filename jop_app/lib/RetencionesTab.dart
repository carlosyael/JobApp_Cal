import 'package:flutter/material.dart';

class RetencionesTab extends StatefulWidget {
  @override
  _RetencionesTabState createState() => _RetencionesTabState();
}

class _RetencionesTabState extends State<RetencionesTab> {
  TextEditingController _salarioController = TextEditingController();
  TextEditingController _comisionController = TextEditingController();

  double _isr = 0.0;
  double _sfs = 0.0;
  double _afp = 0.0;
  double _descuento = 0.0;
  double _retencionNeta = 0.0;

  void _calcularRetenciones() {
    // Implementa los cálculos de retenciones aquí
    setState(() {
      // Obtén los valores de salario y comisión ingresados por el usuario
      double salario = double.tryParse(_salarioController.text) ?? 0.0;
      double comision = double.tryParse(_comisionController.text) ?? 0.0;

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _salarioController,
              decoration: InputDecoration(labelText: 'Salario'),
            ),
            TextField(
              controller: _comisionController,
              decoration: InputDecoration(labelText: 'Comisión'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calcularRetenciones,
              child: Text('Calcular Retenciones'),
            ),
            SizedBox(height: 16.0),
            Text(
              'ISR: $_isr',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'SFS: $_sfs',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'AFP: $_afp',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'Descuento: $_descuento',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'Retención Neta: $_retencionNeta',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Calculadora de Retenciones',
    home: Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Retenciones'),
      ),
      body: RetencionesTab(),
    ),
  ));
}
