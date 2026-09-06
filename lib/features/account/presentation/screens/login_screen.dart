

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/mobile_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/tablet_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
    return CustomScrollView(
      slivers: [
        const HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
        ResponsiveTheme.isMobile(context)
            ? MobileHeaderBar(colorLerp: false)
            : ResponsiveTheme.isTablet(context)
            ? const TabletHeaderBar(colorLerp: false)
            : const HeaderBar(colorLerp: false),
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Iniciar Sesión', style: titleStyle),
                    const Gap(5),
                    Text(
                      'Inicia sesión o crea una cuenta',
                      style: style?.copyWith(color: Color(0xff707070)),
                    ),
                    const Gap(15),
                    SizedBox(
                      height: 50,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 20,
                            children: [
                              FaIcon(FontAwesomeIcons.google),
                              Text(
                                'Iniciar Sesión con Google',
                                style: titleStyle?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Si continúas, aceptas nuestros',
                          style: style?.copyWith(color: Color(0xff707070)),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/legal/terms');
                          },
                          child: Text(
                            'Términos del servicio',
                            style: style?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverGap(50),
        FooterBar(),
      ],
    );
  }
}
