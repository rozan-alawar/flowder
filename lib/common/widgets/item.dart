import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../controller/downloade_provider.dart';

class ItemWidget extends ConsumerStatefulWidget {
  const ItemWidget(
      {required this.title,
      required this.icon,
      required this.url,
      required this.index,
      required this.progress,
      super.key});
  final String title;
  final IconData icon;
  final String url;
  final double progress;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends ConsumerState<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(downloadProvider);
    return ListTile(
      leading: Icon(widget.icon),
      title: Text(widget.title),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(fixedSize: const Size(50, 50)),
        onPressed: () async {
          await ref
              .read(downloadProvider.notifier)
              .downloadFile(widget.url, widget.progress, widget.index);
        },
        child: widget.progress == 0
            ? const Icon(Icons.download)
            : CircularPercentIndicator(
                curve: Curves.easeIn,
                widgetIndicator: const Text('hrlll'),
                radius: 20,
                percent: widget.progress,
                backgroundColor: Colors.grey,
                progressColor: Colors.white,
                center: Text(
                  "%${widget.progress * 100}".split('.').first,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
