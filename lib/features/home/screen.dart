import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatus/features/home/controller.dart';

import '../add_new_user/screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomeController>();
      provider.loadChats();        // safe now
      provider.listenRealTime();   // safe now
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeController>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Chat Us", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0), // 50 pixels from bottom
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(Icons.chat, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchUsersScreen()),
            );
          },
        ),
      ),


      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                hintText: "Search or start a new chat",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Chats List
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: provider.chats.length,
              itemBuilder: (context, i) {
                final chat = provider.chats[i];

                final chatName = chat['display_name'] ?? "Unknown Chat";
                final image = chat['display_image'];
                final lastMsg = chat['last_message'] ?? "";
                final time = chat['updated_at'];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: image != null
                        ? NetworkImage(image)
                        : null,
                    backgroundColor: Colors.grey[800],
                    child: image == null
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),

                  title: Text(
                    chatName,
                    style: const TextStyle(color: Colors.white),
                  ),

                  subtitle: Text(
                    lastMsg,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(time),
                        style:
                        const TextStyle(color: Colors.greenAccent),
                      ),
                      const SizedBox(height: 5),

                      // Unread bubble (static example)
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.green,
                        child: Text(
                          "3",
                          style: TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  onTap: () {
                    // Navigate to chat screen
                  },
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  String _formatTime(String time) {
    final dt = DateTime.parse(time);
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
