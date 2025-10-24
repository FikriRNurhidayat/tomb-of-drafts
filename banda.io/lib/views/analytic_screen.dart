import 'package:banda/providers/metric_provider.dart';
import 'package:banda/widgets/empty.dart';
import 'package:banda/widgets/metric_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticScreen extends StatelessWidget {
  const AnalyticScreen({super.key});

  static String title = "Analytics";
  static IconData icon = Icons.analytics;

  @override
  Widget build(BuildContext context) {
    final metricProvider = context.watch<MetricProvider>();

    return FutureBuilder(
      future: metricProvider.compute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Empty("No metrics available", icon: Icons.analytics);
          }
        }

        final metrics = snapshot.data as List<Map>;

        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, i) {
            final metric = metrics[i];
            return MetricCard(label: metric["name"], value: metric["value"]);
          },
        );
      },
    );
  }
}
