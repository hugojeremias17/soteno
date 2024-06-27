import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sotenooficial/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:sotenooficial/global/common/toast.dart';
import 'package:sotenooficial/features/user_auth/presentation/pages/tecnicopage.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class SignpageTecnico extends StatefulWidget {
  const SignpageTecnico({super.key});

  @override
  State<SignpageTecnico> createState() => _SignpageTecnicoState();
}

class _SignpageTecnicoState extends State<SignpageTecnico> {
  final _formKey = GlobalKey<FormState>();
  bool IsSigningUp = false;
  bool _obscureText = true;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  late TextEditingController _passwordController;
  late TextEditingController _idadeController;
  late TextEditingController _enderecoController;
  late TextEditingController _descricaoController;
  late TextEditingController _funcaoController;
  late TextEditingController _experienciaController;
  User? get currentUser => _auth.currentUser;
  String? selectedValue;
  String? selecioneValor;
  Uint8List? _imageWeb;
  String? _downloadUrl;
  File? _image;

  final List<String> options = [
    'Motorista',
    'Empregada',
    'Canalizador',
    'Pintor',
    'Carpinteiro',
    'Lavadeira',
    'Jardineiro',
    'Babá',
    'Eletrecista',
    'Cozinheira/o'
  ];
  final List<String> municipios = [
    'Município de Belas',
    'Município de Cacuaco',
    'Município de Cazenga',
    'Município de Ícolo e Bengo',
    'Município de Kilamba Kiaxi',
    'Município de Luanda Sul',
    'Município de Talatona',
    'Município de Viana'
  ];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _roleController = TextEditingController();
    _enderecoController = TextEditingController();
    _descricaoController = TextEditingController();
    _idadeController = TextEditingController();
    _experienciaController = TextEditingController();
    _funcaoController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    _enderecoController.dispose();
    _descricaoController.dispose();
    _idadeController.dispose();
    _experienciaController.dispose();
    _funcaoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Use file_picker for web
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        Uint8List? fileBytes = result.files.first.bytes;
        String fileName = result.files.first.name;

        // Upload to Firebase Storage
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('uploads/$fileName')
            .putData(fileBytes!);

        // Get the download URL
        _downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _imageWeb = fileBytes; // Save the selected image bytes for web
        });
      }
    } else {
      // Use image_picker for mobile
      final ImagePicker _picker = ImagePicker();
      XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Upload to Firebase Storage
        String fileName = pickedFile.name;
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('uploads/$fileName')
            .putFile(imageFile);

        // Get the download URL
        _downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _image = imageFile; // Save the selected image file for mobile
        });
      }
    }
  }

  Future<void> adicionarUsuario(
      String email,
      String role,
      String username,
      String idade,
      String descricao,
      String endereco,
      String funcao,
      String experiencia,
      String password,
      ) async {
    try {
      CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
      Map<String, dynamic> novoUsuario = {
        'email': email,
        'role': role,
        'username': username,
        'idade': idade,
        'endereco': endereco,
        'funcao': funcao,
        'experiencia': experiencia,
        'descricao': descricao,
        'password': password,
        'uid': FirebaseAuth.instance.currentUser?.uid,
        'imageUrl': _downloadUrl, // Save the image URL
      };

      await usersRef.add(novoUsuario);
      print('Usuario Adicionado com sucesso');
    } catch (error) {
      print('Erro ao adicionar usuario: $error');
    }
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      IsSigningUp = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;
    String username = _usernameController.text;
    String idade = _idadeController.text;
    String descricao = _descricaoController.text;
    String endereco = _enderecoController.text;
    String funcao = _funcaoController.text;
    String experiencia = _experienciaController.text;
    String role = 'tecnico';

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      IsSigningUp = false;
    });

    if (user != null) {
      await adicionarUsuario(
        email,
        role,
        username,
        idade,
        descricao,
        endereco,
        funcao,
        experiencia,
        password,
      );
      showToast(message: "Técnico Criado com Sucesso");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TecnicoPage()),
      );
    } else {
      showToast(message: 'Erro ao criar técnico');
    }
  }

  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Técnico'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Nome de Usuário',
                  prefixIcon: Icon(Icons.person_2_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome de usuário';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Funções',
                  prefixIcon: Icon(Icons.work_outline),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: selectedValue,
                items: options.map((String valor) {
                  return DropdownMenuItem<String>(
                    value: valor,
                    child: Text(valor),
                  );
                }).toList(),
                onChanged: (String? novoValor) {
                  setState(() {
                    selectedValue = novoValor;
                    _funcaoController.text = novoValor ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma função';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Município',
                  prefixIcon: Icon(Icons.location_history_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: selecioneValor,
                items: municipios.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selecioneValor = newValue;
                    _enderecoController.text = newValue ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione um município';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Idade',
                  prefixIcon: Icon(Icons.numbers),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // Permite apenas números
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua idade';
                  }

                  final intValue = int.tryParse(value);
                  if (intValue == null) {
                    return 'Por favor, insira um número válido';
                  } else if (intValue < 18) {
                    return 'A idade deve ser maior que 18';
                  } else if (intValue >= 65) {
                    return 'Sua Idade é de Aposentado';
                  }

                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _experienciaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Experiência',
                  prefixIcon: Icon(Icons.watch_later_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // Permite apenas números
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu tempo de experiência';
                  }

                  final intValue = int.tryParse(value);
                  if (intValue == null) {
                    return 'Por favor, insira um número válido';
                  } else if (intValue >= 40) {
                    return 'Tempo de experiência muito longo';
                  }

                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descricaoController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.description_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _togglePasswordView,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha';
                  } else if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              IsSigningUp
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _signUp,
                child: Text(
                  'Cadastrar Técnico',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
