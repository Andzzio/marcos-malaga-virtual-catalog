import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';

class NewArrivalsScreen extends StatelessWidget {
  const NewArrivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
          const HeaderBar(colorLerp: false),
          SliverFillRemaining(
            child: Center(
              child: Text('NewArrivals Screen', style: const TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }
}

