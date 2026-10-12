import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statuspage/bloc/versions/app_cubit.dart';
import 'package:statuspage/bloc/versions/app_state.dart';
import 'package:statuspage/utils.dart';
import 'package:statuspage/widgets/row_item.dart';

enum _ProjectFilter { all, unavailable, drift }

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key, required this.projects}) : super(key: key);

  final Map<String, List<Map<String, String>>> projects;

  @override
  StatusPageState createState() => StatusPageState();

  factory StatusPage.sorted({
    Key? key,
    required Map<String, List<Map<String, String>>> projects,
  }) {
    final sorted = sortProjects(projects);
    return StatusPage(key: key, projects: sorted);
  }

  static Map<String, List<Map<String, String>>> sortProjects(
      Map<String, List<Map<String, String>>> projects) {
    return Map.fromEntries(projects.entries
        .map((entry) => MapEntry(
              entry.key,
              List<Map<String, String>>.from(entry.value)
                ..sort((a, b) => a["name"]!.compareTo(b["name"]!)),
            ))
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key)));
  }
}

class StatusPageState extends State<StatusPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  _ProjectFilter _filter = _ProjectFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => _buildDashboard(context, state),
    );
  }

  Widget _buildDashboard(BuildContext context, AppState state) {
    final projects = _matchingProjects(state);

    return Column(
      children: [
        _buildSearchAndFilters(context),
        Expanded(
          child: projects.isEmpty
              ? _buildEmptyState(context)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    if (MediaQuery.sizeOf(context).width >= 900)
                      _buildEnvironmentLegend(context),
                    ...projects.entries.map(
                      (entry) =>
                          _buildGroup(context, entry.key, entry.value, state),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value.trim()),
            decoration: InputDecoration(
              labelText: 'Cerca un prodotto o servizio',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Cancella ricerca',
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      icon: const Icon(Icons.clear),
                    ),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('Tutti', _ProjectFilter.all),
                _filterChip('Dati non disponibili', _ProjectFilter.unavailable),
                _filterChip('Versioni non allineate', _ProjectFilter.drift),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, _ProjectFilter filter) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: _filter == filter,
        onSelected: (_) => setState(() => _filter = filter),
      ),
    );
  }

  Widget _buildEnvironmentLegend(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 24, 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('PRODOTTO')),
          Expanded(child: Center(child: Text('DEV'))),
          Expanded(child: Center(child: Text('UAT'))),
          Expanded(child: Center(child: Text('PROD'))),
          SizedBox(width: 144, child: Center(child: Text('LINK'))),
        ],
      ),
    );
  }

  Widget _buildGroup(
    BuildContext context,
    String name,
    List<Map<String, String>> projects,
    AppState state,
  ) {
    final unavailableCount =
        projects.where((project) => _hasUnavailableData(project, state)).length;
    final driftCount =
        projects.where((project) => _hasVersionDrift(project, state)).length;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: PageStorageKey<String>(name),
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(name, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Wrap(
          spacing: 12,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _buildSummaryItem(
              icon: Icons.widgets_outlined,
              label: '${projects.length} servizi',
              color: colorScheme.primary,
            ),
            if (unavailableCount > 0)
              _buildSummaryItem(
                icon: Icons.warning_amber_rounded,
                label: '$unavailableCount con dati mancanti',
                color: colorScheme.error,
              ),
            if (driftCount > 0)
              _buildSummaryItem(
                icon: Icons.sync_problem_outlined,
                label: '$driftCount con versioni diverse',
                color: colorScheme.tertiary,
              ),
          ],
        ),
        children: projects
            .map((project) => RowItem(project: project))
            .toList(growable: false),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final hasFilters = _searchQuery.isNotEmpty || _filter != _ProjectFilter.all;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off,
                size: 40, color: Theme.of(context).hintColor),
            const SizedBox(height: 12),
            Text(
              hasFilters
                  ? 'Nessun servizio corrisponde ai filtri.'
                  : 'Nessun servizio disponibile.',
              textAlign: TextAlign.center,
            ),
            if (hasFilters)
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _filter = _ProjectFilter.all;
                  });
                },
                child: const Text('Rimuovi i filtri'),
              ),
          ],
        ),
      ),
    );
  }

  Map<String, List<Map<String, String>>> _matchingProjects(AppState state) {
    final result = <String, List<Map<String, String>>>{};
    for (final entry in widget.projects.entries) {
      final matches = entry.value.where((project) {
        final query = _searchQuery.toLowerCase();
        final name = project['name']!.toLowerCase();
        final product = project['product']!.toLowerCase();
        final matchesSearch =
            query.isEmpty || name.contains(query) || product.contains(query);
        final matchesFilter = switch (_filter) {
          _ProjectFilter.all => true,
          _ProjectFilter.unavailable => _hasUnavailableData(project, state),
          _ProjectFilter.drift => _hasVersionDrift(project, state),
        };
        return matchesSearch && matchesFilter;
      }).toList(growable: false);
      if (matches.isNotEmpty) {
        result[entry.key] = matches;
      }
    }
    return result;
  }

  bool _hasUnavailableData(Map<String, String> project, AppState state) {
    final product = project['product'];
    return [
      state.devVersion[product],
      state.uatVersion[product],
      state.prodVersion[product],
    ].any(_isUnavailable);
  }

  bool _isUnavailable(String? version) {
    return version == 'ERROR' ||
        version == 'Empty Body' ||
        version == 'No Info Version';
  }

  bool _hasVersionDrift(Map<String, String> project, AppState state) {
    final product = project['product'];
    final deployed = state.prodVersion[product];
    final repository = state.repoVersion[product]?.replaceFirst('Release ', '');
    if (deployed == null ||
        repository == null ||
        _isUnavailable(deployed) ||
        _isUnavailable(repository) ||
        !deployed.contains('.') ||
        !repository.contains('.')) {
      return false;
    }
    return compareTo(repository, deployed) != 0 &&
        compareTo(repository, deployed) != -2;
  }
}
