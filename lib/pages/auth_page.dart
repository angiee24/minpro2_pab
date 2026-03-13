import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  final Function toggleTheme;
  const AuthPage({super.key, required this.toggleTheme});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _service = SupabaseService();
  
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true; 
  
  String? _authError; 

  Future<void> _handleAuth() async {
    setState(() {
      _authError = null;
    });

    if (!_formKey.currentState!.validate()) {
      return; 
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    setState(() => _isLoading = true);
    
    try {
      if (_isLogin) {
        await _service.signIn(email, password);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(toggleTheme: widget.toggleTheme)),
        );
      } else {
        await _service.signUp(email, password, username);
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Daftar berhasil! Silakan login dengan akun barumu."), backgroundColor: Colors.green),
        );
        
        setState(() {
          _isLogin = true;
          _passwordController.clear();
          _formKey.currentState?.reset(); 
        });
      }
    } catch (e) {
      if (!mounted) return;
      
      String errorMsg = e.toString();
      if (errorMsg.contains("User already registered")) {
        errorMsg = "Email ini sudah terdaftar, silakan langsung Login.";
      } else if (errorMsg.contains("Invalid login credentials")) {
        errorMsg = "Email atau Password salah!"; 
      } else {
        errorMsg = "Terjadi kesalahan: $e";
      }

      setState(() {
        _authError = errorMsg;
      });

    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1D27) : const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => widget.toggleTheme(),
            icon: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: isDark ? Colors.orange : Colors.blueGrey,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Icon(Icons.inventory_2_rounded, size: 80, color: Colors.blue.shade700),
                  const SizedBox(height: 20),
                  Text(_isLogin ? "Login Stok UMKM" : "Daftar Akun", 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  
                  if (!_isLogin) ...[
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Username / Display Name",
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF242735) : Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      validator: (value) {
                        if (!_isLogin && (value == null || value.trim().isEmpty)) {
                          return "Username wajib diisi";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email (@gmail.com)",
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF242735) : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    onChanged: (value) {
                      if (_authError != null) setState(() => _authError = null);
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email wajib diisi";
                      }
                      
                      // --- VALIDASI EMAIL GOOGLE YANG KETAT ---
                      // Penjelasan: Harus mulai huruf/angka, boleh ada titik, akhiran @gmail.com
                      final emailRegex = RegExp(r'^[a-z0-9][a-z0-9.]*@gmail\.com$');
                      if (!emailRegex.hasMatch(value.toLowerCase())) {
                        return "Format email Gmail tidak valid";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword, 
                    decoration: InputDecoration(
                      labelText: "Password (Min. 6 karakter)",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword; 
                          });
                        },
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF242735) : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    onChanged: (value) {
                      if (_authError != null) setState(() => _authError = null);
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Password wajib diisi";
                      }
                      if (value.length < 6) {
                        return "Password minimal 6 karakter";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  if (_authError != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _authError!,
                              style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isLoading ? null : _handleAuth,
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : Text(_isLogin ? "MASUK" : "DAFTAR", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        _passwordController.clear();
                        _formKey.currentState?.reset(); 
                        _obscurePassword = true; 
                        _authError = null;
                      });
                    },
                    child: Text(_isLogin ? "Belum punya akun? Daftar" : "Sudah punya akun? Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}