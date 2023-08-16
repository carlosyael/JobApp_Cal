import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p; // Usa p como alias para el paquete path
import 'MainScreen.dart';

/// Una pantalla que muestra un formulario de inicio de sesión o registro.
///
/// El usuario puede ingresar su nombre de usuario y contraseña, y pulsar el botón
/// Login para iniciar sesión. Si las credenciales son válidas, la aplicación navega
/// a la pantalla principal. Si no, muestra un mensaje de error.
///
/// El usuario también puede pulsar el botón Register para crear una nueva cuenta.
/// La aplicación inserta un nuevo registro en la base de datos local de usuarios y
/// muestra un diálogo de éxito.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Usa final para las variables que no cambian después de ser asignadas
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Usa una clave global para el formulario
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  // Usa async y await para manejar las operaciones asíncronas
  Future<void> _initDatabase() async {
    // Usa await para esperar a que se abra la base de datos antes de usarla
    _database = await openDatabase(
      p.join(await getDatabasesPath(), 'user_database.db'), // Usa p.join para usar el paquete path
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _login() async {
    // Valida el formulario antes de acceder a la base de datos
    if (_formKey.currentState!.validate()) {
      final users = await _database!.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [_usernameController.text, _passwordController.text],
      );

      if (users.isNotEmpty) {
        // Comprueba si el widget está montado antes de usar el contexto
        if (mounted) {
          Navigator.push(
            context, // Usa context como un BuildContext
            // Usa el constructor de la clase MainScreen para crear un widget
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      } else {
        // Muestra un mensaje de error si las credenciales no son válidas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nombre de usuario o contraseña incorrectos')),
        );
      }
    }
  }

  Future<void> _register() async {
    // Valida el formulario antes de acceder a la base de datos
    if (_formKey.currentState!.validate()) {
      // Usa await para esperar a que se inserte un nuevo usuario antes de mostrar el diálogo
      await _database!.insert(
        'users',
        {
          'username': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      showDialog(
        context: context, // Usa context como un BuildContext
        builder: (context) {
          return AlertDialog(
            title: Text('Registro Exitoso'),
            content: Text('Usuario registrado con éxito.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'), // Usa const para los widgets que no cambian
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Usa const para los widgets que no cambian
        child: Form( // Usa Form para validar los campos de texto
          key: _formKey, // Usa la clave global para el formulario
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField( // Usa TextFormField con un validador para comprobar si el campo está vacío
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'), // Usa const para los widgets que no cambian
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField( // Usa TextFormField con un validador para comprobar si el campo está vacío
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'), // Usa const para los widgets que no cambian
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Usa const para los widgets que no cambian
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'), // Usa const para los widgets que no cambian
                  ),
                  const SizedBox(width: 16.0), // Usa const para los widgets que no cambian
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Register'), // Usa const para los widgets que no cambian
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
