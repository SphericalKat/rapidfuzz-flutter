import 'package:flutter/material.dart';
import 'package:rapidfuzz/rapidfuzz.dart' as rapidfuzz;
import 'package:rapidfuzz/models/extracted_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _s1Controller = TextEditingController(
    text: 'this is a test',
  );
  final TextEditingController _s2Controller = TextEditingController(
    text: 'this is a test!',
  );
  final TextEditingController _queryController = TextEditingController(
    text: 'goolge',
  );

  late double ratioResult;
  late double partialRatioResult;
  late double tokenSortRatioResult;
  late double tokenSetRatioResult;
  late double weightedRatioResult;
  late List<ExtractedResult<String>> extractOneResult;
  late List<ExtractedResult<String>> extractTopResult;
  late List<ExtractedResult<String>> extractAllSortedResult;
  late List<ExtractedResult<String>> extractAllResult;

  final List<String> choices = [
    'google',
    'bing',
    'facebook',
    'linkedin',
    'twitter',
    'googleplus',
    'bingnews',
    'plexoogl',
  ];

  void _calculateRatios() {
    setState(() {
      ratioResult = rapidfuzz.ratio(_s1Controller.text, _s2Controller.text);
      partialRatioResult = rapidfuzz.partialRatio(
        _s1Controller.text,
        _s2Controller.text,
      );
      tokenSortRatioResult = rapidfuzz.tokenSortRatio(
        _s1Controller.text,
        _s2Controller.text,
      );
      tokenSetRatioResult = rapidfuzz.tokenSetRatio(
        _s1Controller.text,
        _s2Controller.text,
      );
      weightedRatioResult = rapidfuzz.weightedRatio(
        _s1Controller.text,
        _s2Controller.text,
      );

      final oneResult = rapidfuzz.extractOne(
        query: _queryController.text,
        choices: choices,
        cutoff: 10,
      );
      extractOneResult = [oneResult];

      extractTopResult = rapidfuzz.extractTop(
        query: _queryController.text,
        choices: choices,
        limit: 4,
        cutoff: 50,
      );

      extractAllSortedResult = rapidfuzz.extractAllSorted(
        query: _queryController.text,
        choices: choices,
        cutoff: 10,
      );

      extractAllResult = rapidfuzz.extractAll(
        query: _queryController.text,
        choices: choices,
        cutoff: 10,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _calculateRatios();
  }

  @override
  void dispose() {
    _s1Controller.dispose();
    _s2Controller.dispose();
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('RapidFuzz Demo')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _s1Controller,
                  decoration: const InputDecoration(labelText: 'String 1'),
                  onChanged: (_) => _calculateRatios(),
                ),
                TextField(
                  controller: _s2Controller,
                  decoration: const InputDecoration(labelText: 'String 2'),
                  onChanged: (_) => _calculateRatios(),
                ),
                const SizedBox(height: 20),
                Text('Ratio: $ratioResult'),
                Text('Partial Ratio: $partialRatioResult'),
                Text('Token Sort Ratio: $tokenSortRatioResult'),
                Text('Token Set Ratio: $tokenSetRatioResult'),
                Text('Weighted Ratio: $weightedRatioResult'),
                const SizedBox(height: 20),
                const Text(
                  'Extraction Examples:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _queryController,
                  decoration: const InputDecoration(
                    labelText: 'Query for extraction',
                  ),
                  onChanged: (_) => _calculateRatios(),
                ),
                const SizedBox(height: 10),
                Text('Extract One: $extractOneResult'),
                Text('Extract Top: $extractTopResult'),
                Text('Extract All Sorted: $extractAllSortedResult'),
                Text('Extract All: $extractAllResult'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
