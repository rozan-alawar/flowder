import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../controller/downloade_provider.dart';

class ItemWidget extends ConsumerStatefulWidget {
  ItemWidget(
      {required this.title,
      required this.icon,
      required this.url,
      required this.index,
      required this.progress,
      super.key});
  final String title;
  final IconData icon;
  final String url;
  double progress;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends ConsumerState<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(downloadProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(widget.icon),
          const SizedBox(width: 20),
          Text(widget.title),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(fixedSize: const Size(50, 50)),
            onPressed: () async {
              ref.read(downloadProvider).downloadFile(widget.url, widget.index);
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
          widget.progress != 0
              ? (!provider.isPaused
                  ? IconButton(
                      onPressed: () {
                        ref.read(downloadProvider).pauseDownload();
                      },
                      icon: const Icon(Icons.pause))
                  : IconButton(
                      onPressed: () {
                        ref.read(downloadProvider).resumeDownload();
                      },
                      icon: const Icon(Icons.play_arrow_rounded)))
              : const SizedBox(),
          widget.progress != 0
              ? IconButton(
                  onPressed: () {
                    ref.read(downloadProvider).cancelDownload(widget.index);
                  },
                  icon: const Icon(Icons.cancel))
              : const SizedBox(),
        ],
      ),
    );
  }
}
