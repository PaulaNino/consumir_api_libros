import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Campos para ingresar, login
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //Para formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); 

  //Para ppoder observar la contraseña presionando el icono
  bool _isVisible = true; 

  //url api
  //final String url = 'http://localhost:3000/api/users/login';
  final String url = 'https://resulting-describe-phases-event.trycloudflare.com';
  void apiLogin() async {
    final email=emailController.text;
    final password=passwordController.text;

    final body = jsonEncode({
      //Toma los campos del json y pasa la informacion
      'correo':email,
      'contrasena':password
    });


    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type':'application/json; charset=utf-8' //para caracteres especiales
      },
      body:body
    );

    //Códigos que indican si en la aplicación hay error, servidor caido,exito en la conexión etc.
    //Si la respuesta es igual a 200(solicitud con éxito) va a mostrar en pantalla el mensaje
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final rol = responseData['rol'];
      final message = responseData['message'];
      final nombre = responseData['nombre'];

      if (rol == "Administrador"){
        //Navegar a la pantalla dasboard
      }else if (rol == "Administrador"){
           //Navegar a la pantalla del cliente/
      }

    } else if (response.statusCode ==401){
      final responseData = jsonDecode(response.body);
      final error= responseData['error'];

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'Ingrese su correo',
                prefixIcon: Icon(Icons.email_outlined),
              )
            ),
             TextField(
              controller: passwordController,
              //Para no mostrar el texto ingresado:
              obscureText: _isVisible,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Ingrese su contraseña',
                prefixIcon: const Icon(Icons.lock_clock_outlined),

                //Condición para mostrar u ocultar contraseña al presionar el icono
                suffixIcon: IconButton(
                  onPressed: (){
                    //Actualizar el estado al presionar el icono
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: _isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                )
              )
            ),

            //Boton inicoo sesión
            const SizedBox(height: 20,),
            //Inicio de sesión, llamando el metodo apiLogin creado al inicio
            ElevatedButton(onPressed: (){
              apiLogin();
            },
            child: const Text('Iniciar sesión'),
            ),

          ],
        ),
      ),
      ),

    );
  }
}    