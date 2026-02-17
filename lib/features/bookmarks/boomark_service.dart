import 'package:smart_bookmark_app/features/bookmarks/bookmark_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookmarkService {
  final supabase = Supabase.instance.client;

  Future<List<Bookmark>> fetchBookmarks() async {
    final user = supabase.auth.currentUser;
    if(user == null) return [];

    final data = await supabase
                        .from('bookmarks')
                        .select()
                        .eq('user_id', user.id)
                        .order('created_at', ascending: false);

    return (data as List)
              .map((e) => Bookmark.fromJson(e))
              .toList();
  }

  Future<void> addBookmark(String title, String url) async {
    final user = supabase.auth.currentUser;
    if(user == null) return;

    await supabase.from('bookmarks').insert({
      'title': title,
      'url':url,
      'user_id': user.id,
    });

    
  }
  Future<void> deleteBookmark(String id) async {
    await supabase.from('bookmarks').delete().eq('id', id);
  }
}