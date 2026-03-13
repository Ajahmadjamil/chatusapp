import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> results = [];
  bool searching = false;

  final TextEditingController _controller = TextEditingController();

  // ---------------------------
  // Search logic
  // ---------------------------
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() => results = []);
      return;
    }

    setState(() => searching = true);

    // Split by space to match first/last names separately
    final terms = query.trim().split(' ');

    var builder = supabase.from('profiles').select();

    for (var term in terms) {
      builder = builder.ilike('name', '%$term%');
    }

    final data = await builder.limit(20);

    final currentUser = supabase.auth.currentUser!.id;
    results = data.where((u) => u['id'] != currentUser).toList();

    debugPrint("Supabase returned ${results.length} users: $results");

    setState(() => searching = false);
  }

  // ---------------------------
  // Send "hi" to tapped user
  // ---------------------------
  Future<void> sendHiMessage(String otherUserId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // 1️⃣ Check if a 1-on-1 chat exists
      final existing1 = await supabase
          .from('chat_participants')
          .select('chat_id')
          .eq('user_id', userId);

      final existing2 = await supabase
          .from('chat_participants')
          .select('chat_id')
          .eq('user_id', otherUserId);

      final mutualChats = existing1.map((e) => e['chat_id'])
          .where((chatId) => existing2.any((x) => x['chat_id'] == chatId))
          .toList();

      String chatId;

      if (mutualChats.isNotEmpty) {
        chatId = mutualChats.first;
      } else {
        // 2️⃣ Create new 1-on-1 chat
        final chat = await supabase.from('chats').insert({
          'chat_name': null, // Dynamic via view
          'updated_at': DateTime.now().toIso8601String(),
        }).select().single();

        chatId = chat['id'];

        // Add participants
        await supabase.from('chat_participants').insert([
          {'chat_id': chatId, 'user_id': userId},
          {'chat_id': chatId, 'user_id': otherUserId},
        ]);
      }

      // 3️⃣ Send "hi" message
      await supabase.from('messages').insert({
        'chat_id': chatId,
        'sender_id': userId,
        'receiver_id': otherUserId,
        'msg': 'hi',
        'msg_status': 'sent',
        'created_at': DateTime.now().toIso8601String(),
      });

      // 4️⃣ Update last_message
      await supabase.from('chats').update({
        'last_message': 'hi',
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', chatId);
    } catch (e) {
      debugPrint("Error sending hi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Search Users'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[900],
                      hintText: "Search by name",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: (){searchUsers(_controller.text.toString());},
                  child: const Text("Search"),
                ),
              ],
            ),
          ),
          searching
              ? const Padding(
            padding: EdgeInsets.only(top: 20),
            child: CircularProgressIndicator(),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, i) {
                final user = results[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user['profile_image'] != null
                        ? NetworkImage(user['profile_image'])
                        : null,
                    child: user['profile_image'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(
                    user['name'] ?? 'Unknown',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    user['email'] ?? "",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onTap: () => sendHiMessage(user['id']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
