import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qgicnlqlppvkvqwlyduw.supabase.co',
    publishableKey: 'sb_publishable_6Zeu4BMohlMw4SeXTHa1NA_MkyggqZk',
  );
  runApp(const GlowFitApp());
}
