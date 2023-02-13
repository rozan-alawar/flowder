import 'package:download_files/common/widgets/item.dart';
import 'package:download_files/controller/downloade_provider.dart';
import 'package:download_files/model/file_model.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(downloadProvider);
    final files = ref.watch(fileProvider);

    List<Widget> generateItems() {
      List<Widget> items = [];

      files.asMap().forEach((index, value) {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Files')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: generateItems(),
        ),
      ),
    );
  }
}
