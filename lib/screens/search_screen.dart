import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final List<String> _suggestions = [
    'Ho Chi Minh City', 'Ha Noi', 'Da Nang',
    'Can Tho', 'Hue', 'Nha Trang',
    'Tokyo', 'London', 'New York', 'Paris',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: Color(0xFF1A202C),
      appBar: AppBar(
        backgroundColor: Color(0xFF2D3748),
        title: Text(
          'Tìm kiếm thành phố',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nhập tên thành phố...',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Color(0xFF2D3748),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.white54),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _search,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),

            SizedBox(height: 24),

            // Favorite cities
            if (provider.favoriteCities.isNotEmpty) ...[
              Text(
                '❤️ Thành phố yêu thích',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: provider.favoriteCities
                    .map((city) => GestureDetector(
                          onTap: () => _searchCity(city),
                          child: Chip(
                            label: Text(city,
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: Colors.red[800],
                            avatar: Icon(Icons.favorite,
                                color: Colors.red[200], size: 16),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 20),
            ],

            // Suggestions
            Text(
              '🌍 Gợi ý thành phố',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _suggestions
                  .map((city) => GestureDetector(
                        onTap: () => _searchCity(city),
                        child: Chip(
                          label: Text(city,
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Color(0xFF4A5568),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _search() {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    _searchCity(city);
  }

  void _searchCity(String city) {
    context.read<WeatherProvider>().fetchWeatherByCity(city);
    Navigator.pop(context);
  }
}