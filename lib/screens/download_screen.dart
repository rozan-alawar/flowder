import 'package:download_files/controller/downloade_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DownloadScreen extends ConsumerStatefulWidget {
  const DownloadScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends ConsumerState<DownloadScreen> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(downloadProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  label: Text('URL'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(120, 50),
              ),
              onPressed: () async {
                await ref.read(downloadProvider).downloadFile2(controller.text);
              },
              child: provider.progress == 0
                  ? const Text('Download')
                  : CircularPercentIndicator(
                      curve: Curves.easeIn,
                      widgetIndicator: const Text('hrlll'),
                      radius: 20,
                      percent: provider.progress,
                      backgroundColor: Colors.grey,
                      progressColor: Colors.white,
                      center: Text(
                        "%${provider.progress * 100}".split('.').first,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
