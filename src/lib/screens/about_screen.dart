import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:language_trainer/services/database.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key, required this.db});
  final AppDatabase db;

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late Future<PackageInfo> _info;
  int _taps = 0;

  @override
  void initState() {
    super.initState();
    _info = PackageInfo.fromPlatform();
  }

  void _onVersionTap() {
    _taps++;
    if (_taps >= 5) {
      _taps = 0;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: const Text(
            'Created for Nkule Mabaso.\nSthandwa sami',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('❤️'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _exportLog() async {
    try {
      final entries = await widget.db.getAllReviewEntries();
      final rows = entries.map((e) => {
            'id': e.id,
            'cardType': e.cardType,
            'easeFactor': e.easeFactor,
            'intervalDays': e.intervalDays,
            'repetitions': e.repetitions,
            'nextReviewMs': e.nextReviewMs,
          });
      final json = const JsonEncoder.withIndent('  ').convert(rows.toList());

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/language_trainer_log.json');
      await file.writeAsString(json);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'LanguageTrainer review log',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: FutureBuilder<PackageInfo>(
        future: _info,
        builder: (context, snap) {
          final version = snap.hasData
              ? 'Version ${snap.data!.version} (build ${snap.data!.buildNumber})'
              : '';
          return ListView(
            children: [
              const SizedBox(height: 32),
              // ── App logo + name ──────────────────────────────────────────
              Center(
                child: Icon(Icons.school_outlined,
                    size: 64, color: scheme.primary),
              ),
              const SizedBox(height: 12),
              Text(
                'LanguageTrainer',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (version.isNotEmpty) ...[
                const SizedBox(height: 4),
                Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _onVersionTap,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        version,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              // ── Description ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'LanguageTrainer is a personal, ad-free app for '
                      'drilling German vocabulary. It uses spaced repetition '
                      '(SM-2) to help you memorise noun articles and verb '
                      'conjugations efficiently.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // ── Links ─────────────────────────────────────────────────────
              _SectionHeader('Legal'),
              ListTile(
                leading: const Icon(Icons.balance_outlined),
                title: const Text('Licence'),
                subtitle: const Text('GNU General Public License v3.0'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _launchUrl(
                    'https://www.gnu.org/licenses/gpl-3.0.html'),
              ),
              ListTile(
                leading: const Icon(Icons.code_outlined),
                title: const Text('Source code'),
                subtitle: const Text('GitHub — GPL-3.0'),
                trailing: const Icon(Icons.open_in_new, size: 18),
                onTap: () => _launchUrl(
                    'https://github.com/Cythraul89/LanguageTrainer'),
              ),
              const Divider(indent: 16, endIndent: 16),
              // ── Data ──────────────────────────────────────────────────────
              _SectionHeader('Data'),
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: const Text('Export review log'),
                subtitle: const Text('Share your SM-2 progress as JSON'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _exportLog,
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
