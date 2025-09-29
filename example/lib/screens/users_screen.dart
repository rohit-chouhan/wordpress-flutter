import 'package:flutter/material.dart';
import 'package:wordpress/wordpress.dart';

class UsersScreen extends StatefulWidget {
  final WordPress wp;

  const UsersScreen({super.key, required this.wp});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final users = await widget.wp.users.list();
      setState(() {
        _users = users;
      });
    } catch (e) {
      String errorMsg = e.toString();
      if (e is WordPressException) {
        errorMsg += '\nStatus: ${e.statusCode}\nData: ${e.data}';
        if (e.statusCode == 401) {
          errorMsg +=
              '\n\nNote: Users endpoint requires authentication. Please login first.';
        }
      }
      setState(() {
        _error = errorMsg;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToUserDetail(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDetailScreen(user: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Note: Users endpoint requires authentication.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _isLoading ? null : _fetchUsers,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Fetch Users'),
              ),
            ],
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error:',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
                if (_error!.contains('401') ||
                    _error!.contains('authentication'))
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to auth screen - you would need to implement this navigation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please login first using the Auth tab',
                            ),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                      child: const Text('Go to Login'),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: _users.isEmpty && !_isLoading
              ? const Center(child: Text('No users loaded'))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            user.name?.substring(0, 1).toUpperCase() ?? '?',
                          ),
                        ),
                        title: Text(user.name ?? 'No name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username: ${user.username ?? 'N/A'}'),
                            Text('Email: ${user.email ?? 'N/A'}'),
                            Text('ID: ${user.id}'),
                          ],
                        ),
                        trailing: const Icon(Icons.person),
                        onTap: () => _navigateToUserDetail(user),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name ?? 'User Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(
                user.name?.substring(0, 1).toUpperCase() ?? '?',
                style: const TextStyle(fontSize: 36),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name ?? 'No name',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildDetailRow('ID', user.id.toString()),
            _buildDetailRow('Username', user.username ?? 'N/A'),
            _buildDetailRow('Email', user.email ?? 'N/A'),
            _buildDetailRow('First Name', user.firstName ?? 'N/A'),
            _buildDetailRow('Last Name', user.lastName ?? 'N/A'),
            _buildDetailRow('Nickname', user.nickname ?? 'N/A'),
            _buildDetailRow('URL', user.url ?? 'N/A'),
            _buildDetailRow('Description', user.description ?? 'N/A'),
            _buildDetailRow('Locale', user.locale ?? 'N/A'),
            _buildDetailRow('Registered Date', user.registeredDate ?? 'N/A'),
            const SizedBox(height: 16),
            if (user.avatarUrls != null) ...[
              const Text(
                'Avatar URLs:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...user.avatarUrls!.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text('${entry.key}: ${entry.value}'),
                );
              }),
            ],
            const SizedBox(height: 16),
            const Text(
              'Full Response:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  user.getFullResponse().toString(),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
