import 'package:flutter/material.dart';
import 'package:wordpress/wordpress.dart';

class AuthScreen extends StatefulWidget {
  final WordPress wp;

  const AuthScreen({super.key, required this.wp});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  String? _error;
  String? _success;
  bool _isAuthenticated = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    final token = widget.wp.getToken();
    setState(() {
      _isAuthenticated = token != null;
    });
  }

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _error = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _success = null;
    });

    try {
      final user = await widget.wp.auth.login(
        _usernameController.text,
        _passwordController.text,
      );
      setState(() {
        _currentUser = user;
        _isAuthenticated = true;
        _success = 'Login successful!';
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _success = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _error = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _success = null;
    });

    try {
      final user = await widget.wp.auth.register(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        _currentUser = user;
        _success = 'Registration successful!';
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _success = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _logout() {
    widget.wp.clearToken();
    setState(() {
      _isAuthenticated = false;
      _currentUser = null;
      _success = 'Logged out successfully';
      _error = null;
    });
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _error = null;
      _success = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Authentication Status',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Logged In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Username: ${_currentUser!.username ?? 'N/A'}'),
                    Text('Email: ${_currentUser!.email ?? 'N/A'}'),
                    Text('ID: ${_currentUser!.id}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout'),
            ),
            if (_success != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _success!,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _isLogin ? 'Login' : 'Register',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (!_isLogin)
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          if (!_isLogin) const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isLoading ? null : (_isLogin ? _login : _register),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isLogin ? 'Login' : 'Register'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _toggleMode,
            child: Text(
              _isLogin
                  ? 'Don\'t have an account? Register'
                  : 'Already have an account? Login',
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          if (_success != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _success!,
                style: const TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
