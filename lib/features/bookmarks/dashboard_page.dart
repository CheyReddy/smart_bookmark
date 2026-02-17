import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'boomark_service.dart';
import 'bookmark_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final service = BookmarkService();
  final titleController = TextEditingController();
  final urlController = TextEditingController();

  List<Bookmark> bookmarks = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    final data = await service.fetchBookmarks();
    setState(() => bookmarks = data);
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }

  @override
  void dispose() {
    titleController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Smart Bookmark",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            iconSize: 25,
            onPressed: logout,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "TITLE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "URL",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                TextField(
                  controller: urlController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter URL",
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      if (titleController.text.isEmpty ||
                          urlController.text.isEmpty) {
                        return;
                      }

                      await service.addBookmark(
                        titleController.text.trim(),
                        urlController.text.trim(),
                      );

                      titleController.clear();
                      urlController.clear();
                      FocusScope.of(context).unfocus();
                      loadBookmarks();
                    },
                    child: const Text(
                      "Add Bookmark",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "BOOKMARK LIST",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),


          Expanded(
            child: bookmarks.isEmpty
                ? const Center(
                    child: Text(
                      "No bookmarks yet",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: bookmarks.length,
                    itemBuilder: (context, index) {
                      final bookmark = bookmarks[index];

                      return Card(
                        color: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          title: Text(
                            bookmark.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            bookmark.url,
                            style:
                                const TextStyle(color: Colors.white70),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.redAccent,
                            onPressed: () async {
                              await service.deleteBookmark(bookmark.id);
                              loadBookmarks();
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
