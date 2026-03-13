import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  Future<void> signUp(String email, String password, String username) async {
    await _supabase.auth.signUp(
      email: email, 
      password: password,
      data: {'display_name': username}, 
    );
  }

  Future<void> signIn(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<List<ProductModel>> getProducts() async {
    final response = await _supabase
        .from('products')
        .select()
        .order('created_at', ascending: false);
    return (response as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<void> addProduct(ProductModel product) async {
    await _supabase.from('products').insert(product.toJson());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _supabase
        .from('products')
        .update(product.toJson())
        .eq('id', product.id as Object);
  }

  Future<void> deleteProduct(String id) async {
    await _supabase.from('products').delete().eq('id', id);
  }
}