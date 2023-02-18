import 'package:download_files/common/widgets/item.dart';
import 'package:download_files/controller/downloade_provider.dart';
import 'package:download_files/screens/download_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> initPlatformState() async {
    ref.read(downloadProvider).setPath();
    if (!mounted) return;
  }

  @override
  void initState() {
    super.initState();

    initPlatformState();
    ref.read(downloadProvider.notifier).generateFiles();
  }

  List<Widget> generateItems() {
    List<Widget> items = [];

    ref.watch(downloadProvider).fileList.asMap().forEach((index, value) {
      items.add(ItemWidget(
        index: index,
        icon: value.icon!,
        url: value.url!,
        progress: value.progress!,
        title: value.fileName!,
      ));
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadScreen(),
                  ));
            },
            icon: const Icon(
              Icons.navigate_next_rounded,
            ),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: generateItems(),
        ),
      ),
    );
  }
}

// final fileProvider = Provider((ref) => fileList);
