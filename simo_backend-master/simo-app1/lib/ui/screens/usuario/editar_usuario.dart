import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_notifier.dart';

class EditarUsuarioScreen extends ConsumerStatefulWidget {
  const EditarUsuarioScreen({super.key});

  @override
  ConsumerState<EditarUsuarioScreen> createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends ConsumerState<EditarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _correoController = TextEditingController();

  // Estado
  String _nombreAMostrar = "Nombre";
  bool _esFemenino = true;

  @override
  void initState() {
    super.initState();
    // Actualizar el nombre en tiempo real
    _nombreController.addListener(() {
      setState(() {
        if (_nombreController.text.trim().isNotEmpty) {
          final words = _nombreController.text.trim().split(RegExp(r'\s+'));
          final capitalizedWords = words.map((w) {
            if (w.isEmpty) return w;
            return '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';
          });
          _nombreAMostrar = capitalizedWords.join('\n');
        } else {
          _nombreAMostrar = "Nombre";
        }
      });
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  void _confirmar() {
    if (_formKey.currentState!.validate()) {
      // Simular guardado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Información guardada exitosamente!'),
          backgroundColor: Colors.green,
        ),
      );
      // Aquí iría la lógica de backend
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colores principales
    const colorMagenta = Color(0xFFD8006B);
    const colorAmarillo = Color(0xFFFECD20);
    const colorFondoInput = Color(0xFFFFFCE7);
    const colorTexto = Color(0xFF404040);
    const colorGris = Color(0xFFD8D8D8);

    return Scaffold(
      backgroundColor: colorMagenta,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF7F4EC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/imagenes/usuario/simo.png', height: 45),
                  Row(
                    children: [
                      Image.asset(
                        'assets/imagenes/usuario/icono_moneda.png',
                        height: 35,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${ref.watch(authProvider).usuario?.puntosVerdes ?? 0}',
                        style: TextStyle(
                          color: Color(0xFF2D4EA2),
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/notificaciones'),
                        child: Image.asset(
                          'assets/imagenes/usuario/campana.png',
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 6.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        '¡Mi información!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Sección Superior: Toggle + Avatar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Selector de género
                          Container(
                            width: 70,
                            decoration: BoxDecoration(
                              color: colorFondoInput,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _esFemenino = true),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _esFemenino
                                          ? colorAmarillo.withOpacity(0.3)
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.female,
                                          color: colorTexto,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Femenino',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: colorTexto,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: colorGris,
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _esFemenino = false),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !_esFemenino
                                          ? colorAmarillo.withOpacity(0.3)
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(12),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.male,
                                          color: colorTexto,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Masculino',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: colorTexto,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Avatar interactivo
                          Stack(
                            alignment: Alignment.bottomCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorFondoInput,
                                  border: Border.all(
                                    color: colorAmarillo,
                                    width: 4,
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      _esFemenino
                                          ? 'assets/imagenes/usuario/editar_usuario/image 26.png'
                                          : 'assets/imagenes/usuario/editar_usuario/image 25.png',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  constraints: const BoxConstraints(
                                    maxWidth: 100,
                                  ),
                                  child: Text(
                                    _nombreAMostrar,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: colorTexto,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      height: 1.1,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12), // Balance visual
                        ],
                      ),
                      const SizedBox(height: 22),

                      // Campos del formulario
                      _crearInput(
                        controller: _nombreController,
                        icon: Icons.person,
                        hint: 'Nombre',
                        textCapitalization: TextCapitalization.words,
                        validator: (v) =>
                            v!.isEmpty ? 'El nombre es requerido' : null,
                      ),
                      const SizedBox(height: 8),

                      _crearInput(
                        controller: _cedulaController,
                        icon: Icons.badge,
                        hint: 'Cédula',
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v!.isEmpty) return 'La cédula es requerida';
                          if (double.tryParse(v) == null) {
                            return 'Debe ser un número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      _crearInput(
                        controller: _telefonoController,
                        icon: Icons.phone,
                        hint: 'Teléfono',
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          if (v!.isEmpty) return 'El teléfono es requerido';
                          if (double.tryParse(v) == null) {
                            return 'Debe ser un número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      _crearInput(
                        controller: _direccionController,
                        icon: Icons.home,
                        hint: 'Dirección',
                        validator: (v) =>
                            v!.isEmpty ? 'La dirección es requerida' : null,
                      ),
                      const SizedBox(height: 8),

                      _crearInput(
                        controller: _correoController,
                        icon: Icons.email,
                        hint: 'Correo electrónico',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v!.isEmpty) return 'El correo es requerido';
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(v)) {
                            return 'Ingrese un correo válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      // Botón Confirmar
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _confirmar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorAmarillo,
                            foregroundColor: colorTexto,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            'Confirmar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        decoration: const BoxDecoration(
          color: Color(0xFFF7F4EC),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBottomNavItem(
              'Inicio',
              'assets/imagenes/usuario/icono_inicio.png',
              false,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
            ),
            _buildBottomNavItem(
              'Opciones',
              'assets/imagenes/usuario/icono_opciones.png',
              false,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/opciones', (route) => false),
            ),
            _buildBottomNavItem(
              'Canjear',
              'assets/imagenes/usuario/icono_canjear.png',
              false,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/canjear', (route) => false),
            ),
            _buildBottomNavItem(
              'Usuario',
              'assets/imagenes/usuario/icono_usuario.png',
              true,
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/usuario', (route) => false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearInput({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      style: TextStyle(
        color: const Color(0xFF404040),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFF404040),
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: const Color(0xFFFFFCE7),
        prefixIcon: Icon(icon, color: const Color(0xFF404040)),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildBottomNavItem(
    String label,
    String iconPath,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath, height: 32),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF333333),
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 40,
            color: isSelected ? const Color(0xFFD8006B) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
