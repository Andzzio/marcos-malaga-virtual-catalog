import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/features/crm_orders/presentation/widgets/crm_order_details_panel.dart';
import 'package:marcos_malaga_app/features/crm_orders/presentation/widgets/crm_order_lines_table.dart';
import 'package:marcos_malaga_app/features/crm_orders/presentation/widgets/crm_orders_table.dart';
import 'package:marcos_malaga_app/features/crm_orders/presentation/widgets/crm_orders_top_bar.dart';

class CrmOrdersScreen extends StatelessWidget {
  const CrmOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  CrmOrdersTopBar(),
                  Gap(24),
                  Expanded(flex: 2, child: CrmOrdersTable()),
                  Gap(24),
                  Expanded(flex: 1, child: CrmOrderLinesTable()),
                ],
              ),
            ),
          ),
          const CrmOrderDetailsPanel(),
        ],
      ),
    );
  }
}
