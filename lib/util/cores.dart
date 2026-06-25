import 'package:flutter/material.dart';

class Cores {
  
  static const noite = Color(0xFF0E0E12); 
  static const tomate = Color(0xFFF5431E); 
  static const ambar = Color(0xFFFFB22C); 
  static const creme = Color(0xFFF7F0E1); 
  static const lima = Color(0xFFC6F24E); 

 
  static const superficie = Color(0xFF16161D);
  static const superficie2 = Color(0xFF1F1F29);
  static const borda = Color(0xFF2A2A36);
  static const cinza = Color(0xFF9B97A8);
  static const tranquilo = ambar; 
  static const bombando = lima; 

  static const gradBrinde = LinearGradient(
    colors: [tomate, ambar],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}