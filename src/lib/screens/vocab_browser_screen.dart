import 'package:flutter/material.dart';
import 'package:language_trainer/data/adjectives.dart';
import 'package:language_trainer/data/nouns.dart';
import 'package:language_trainer/data/verbs.dart';
import 'package:language_trainer/models/adjective.dart';
import 'package:language_trainer/models/noun.dart';
import 'package:language_trainer/models/verb.dart';

class VocabBrowserScreen extends StatefulWidget {
  const VocabBrowserScreen({super.key});

  @override
  State<VocabBrowserScreen> createState() => _VocabBrowserScreenState();
}

class _VocabBrowserScreenState extends State<VocabBrowserScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [Tab(text: 'Nouns'), Tab(text: 'Verbs'), Tab(text: 'Adjectives')],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search…',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _NounList(query: _query),
                _VerbList(query: _query),
                _AdjList(query: _query),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NounList extends StatelessWidget {
  const _NounList({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final items = query.isEmpty
        ? kNouns
        : kNouns.where((n) =>
            n.word.toLowerCase().contains(query) ||
            n.english.toLowerCase().contains(query)).toList();

    if (items.isEmpty) {
      return const Center(child: Text('No results'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final n = items[i];
        return ListTile(
          leading: _ArticleChip(article: n.article),
          title: Text(n.word),
          subtitle: Text(n.english),
          trailing: n.hasPlural
              ? Text('pl: ${n.plural}',
                  style: Theme.of(context).textTheme.bodySmall)
              : null,
        );
      },
    );
  }
}

class _VerbList extends StatelessWidget {
  const _VerbList({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final items = query.isEmpty
        ? kVerbs
        : kVerbs.where((v) =>
            v.infinitive.toLowerCase().contains(query) ||
            v.english.toLowerCase().contains(query)).toList();

    if (items.isEmpty) {
      return const Center(child: Text('No results'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final v = items[i];
        return ExpansionTile(
          title: Text(v.infinitive),
          subtitle: Text(v.english),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AuxChip(auxiliary: v.auxiliary),
              const SizedBox(width: 8),
              const Icon(Icons.expand_more),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _VerbDetails(verb: v),
            ),
          ],
        );
      },
    );
  }
}

class _VerbDetails extends StatelessWidget {
  const _VerbDetails({required this.verb});
  final VerbEntry verb;

  @override
  Widget build(BuildContext context) {
    final persons = GrammaticalPerson.values;
    final labels = ['ich', 'du', 'er/sie/es', 'wir', 'ihr', 'sie/Sie'];
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1.5),
        3: FlexColumnWidth(2.5),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          children: ['', 'Präsens', 'Präteritum', 'Perfekt']
              .map((h) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 4),
                    child: Text(h,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ))
              .toList(),
        ),
        for (var i = 0; i < persons.length; i++)
          TableRow(children: [
            _cell(labels[i]),
            _cell(verb.praesens[persons[i]]!),
            _cell(verb.praeteritum[persons[i]]!),
            _cell(verb.perfektForm(persons[i])),
          ]),
        TableRow(children: [
          _cell('Partizip II'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(verb.partizip2,
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ),
          _cell(''),
          _cell(''),
        ]),
      ],
    );
  }

  static Widget _cell(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(text),
      );
}

class _AdjList extends StatelessWidget {
  const _AdjList({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final items = query.isEmpty
        ? kAdjectives
        : kAdjectives.where((a) =>
            a.word.toLowerCase().contains(query) ||
            a.english.toLowerCase().contains(query)).toList();

    if (items.isEmpty) {
      return const Center(child: Text('No results'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final a = items[i];
        return ListTile(
          title: Text(a.word),
          subtitle: Text(a.english),
          trailing: Text(
            '${a.comparative} · ${a.superlative}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }
}

class _ArticleChip extends StatelessWidget {
  const _ArticleChip({required this.article});
  final Article article;

  static const _colors = {
    Article.der: Color(0xFF1565C0),
    Article.die: Color(0xFFC62828),
    Article.das: Color(0xFF2E7D32),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _colors[article],
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Text(
        article.name,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}

class _AuxChip extends StatelessWidget {
  const _AuxChip({required this.auxiliary});
  final Auxiliary auxiliary;

  @override
  Widget build(BuildContext context) {
    final label = auxiliary == Auxiliary.haben ? 'hat' : 'ist';
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
