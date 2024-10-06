import 'package:flutter/material.dart';

class AppTheme {
  // Function to create an OutlineInputBorder from JSON
  static OutlineInputBorder _borderLayout(Map<String, dynamic>? borderJson) {
    if (borderJson == null) {
      return const OutlineInputBorder(borderSide: BorderSide.none);
    }

    Color color =
        Color(int.parse(borderJson['color'].replaceFirst('#', '0xff')));
    BorderStyle style =
        borderJson['style'] == 'solid' ? BorderStyle.solid : BorderStyle.none;

    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1, style: style),
      borderRadius: BorderRadius.circular(10),
    );
  }

  // Function to recreate ThemeData from JSON
  static ThemeData createThemeFromJson(Map<String, dynamic> json) {
    return ThemeData(
      brightness:
          json['brightness'] == 'light' ? Brightness.light : Brightness.dark,
      primaryColor:
          Color(int.parse(json['primaryColor'].replaceFirst('#', '0xff'))),
      indicatorColor:
          Color(int.parse(json['indicatorColor'].replaceFirst('#', '0xff'))),
      scaffoldBackgroundColor: Color(
          int.parse(json['scaffoldBackgroundColor'].replaceFirst('#', '0xff'))),
      fontFamily: json['fontFamily'],
      appBarTheme: AppBarTheme(
        backgroundColor: Color(int.parse(
            json['appBarTheme']['backgroundColor'].replaceFirst('#', '0xff'))),
        titleTextStyle: TextStyle(
          color: Color(int.parse(json['appBarTheme']['titleTextStyle']['color']
              .replaceFirst('#', '0xff'))),
          fontSize:
              json['appBarTheme']['titleTextStyle']['fontSize'].toDouble(),
          fontWeight:
              json['appBarTheme']['titleTextStyle']['fontWeight'] == 'bold'
                  ? FontWeight.bold
                  : FontWeight.normal,
        ),
        iconTheme: IconThemeData(
          color: Color(int.parse(json['appBarTheme']['iconTheme']['color']
              .replaceFirst('#', '0xff'))),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Color(int.parse(json['textTheme']['bodyLarge']['color']
              .replaceFirst('#', '0xff'))),
          fontSize: json['textTheme']['bodyLarge']['fontSize'].toDouble(),
        ),
        bodyMedium: TextStyle(
          color: Color(int.parse(json['textTheme']['bodyMedium']['color']
              .replaceFirst('#', '0xff'))),
          fontSize: json['textTheme']['bodyMedium']['fontSize'].toDouble(),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: json['inputDecorationTheme']['filled'],
        fillColor: Color(int.parse(json['inputDecorationTheme']['fillColor']
            .replaceFirst('#', '0xff'))),
        enabledBorder: _borderLayout({
          'color': json['inputDecorationTheme']['enabledBorderColor'],
          'style': 'solid'
        }),
        focusedBorder: _borderLayout({
          'color': json['inputDecorationTheme']['focusedBorderColor'],
          'style': 'solid'
        }),
        errorBorder: _borderLayout({
          'color': json['inputDecorationTheme']['errorBorderColor'],
          'style': 'solid'
        }),
      ),
    );
  }

  // Add other themes like darkTheme and materialYouTheme if needed, following the same approach
}
