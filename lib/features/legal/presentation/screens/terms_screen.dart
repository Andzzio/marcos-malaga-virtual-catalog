import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
          const HeaderBar(colorLerp: false),
          SliverFillRemaining(
            child: Center(
              child: Text('Terms Screen', style: const TextStyle(fontSize: 24)),
            ),
          ),
          SliverGap(50),
          FooterBar(),
        ],
      ),
    );
  }
}

