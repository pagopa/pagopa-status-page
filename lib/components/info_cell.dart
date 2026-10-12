import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:statuspage/bloc/versions/app_cubit.dart';
import 'package:statuspage/bloc/versions/app_state.dart';
import 'package:statuspage/utils.dart';

class InfoCell extends StatelessWidget {
  const InfoCell({
    super.key,
    required this.env,
    required this.project,
    this.compact = false,
  });

  final String env;
  final Map<String, String> project;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final product = project['product'];
        final version = switch (env) {
          'DEV' => state.devVersion[product],
          'UAT' => state.uatVersion[product],
          'PROD' => state.prodVersion[product],
          _ => null,
        };
        final status = _status(context, state, version);
        return Semantics(
          label: '$env: ${status.label}',
          child: Tooltip(
            message: status.tooltip,
            child: Padding(
              padding: EdgeInsets.all(compact ? 4 : 16),
              child: compact
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        status.icon,
                        const SizedBox(height: 4),
                        Text(
                          status.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        status.icon,
                        const SizedBox(height: 8),
                        Text(
                          status.value,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  _CellStatus _status(
    BuildContext context,
    AppState state,
    String? version,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    if (version == null) {
      return _CellStatus(
        icon: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
        label: 'Caricamento in corso',
        value: 'In caricamento',
        tooltip: '$env: caricamento in corso',
      );
    }
    if (version == 'ERROR' ||
        version == 'Empty Body' ||
        version == 'No Info Version') {
      return _CellStatus(
        icon: Icon(
          version == 'ERROR' ? Icons.cloud_off_outlined : Icons.warning_amber,
          color: version == 'ERROR' ? colorScheme.error : colorScheme.tertiary,
        ),
        label: 'Dati non disponibili',
        value: 'Non disponibile',
        tooltip: '$env: $version',
      );
    }
    if (!version.contains('.')) {
      return _CellStatus(
        icon: Icon(Icons.info_outline, color: colorScheme.tertiary),
        label: 'Versione non standard: $version',
        value: version,
        tooltip: '$env: versione non standard ($version)',
      );
    }

    final comparison = _compareWithRepository(state, version);
    final driftIcon = _driftIcon(context, comparison);
    final detail = switch (comparison) {
      -1 => 'Versione installata più recente del repository',
      1 => 'Versione installata meno recente del repository',
      0 => 'Versione allineata al repository',
      _ => 'Versione installata; confronto col repository non disponibile',
    };
    return _CellStatus(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, color: colorScheme.primary),
          if (driftIcon != null) ...[
            const SizedBox(width: 4),
            driftIcon,
          ],
        ],
      ),
      label: '$detail: $version',
      value: version,
      tooltip: '$env: $version. $detail.',
    );
  }

  int _compareWithRepository(AppState state, String version) {
    var repoVersion = state.repoVersion[project['product']] ?? '';
    if (repoVersion == 'ERROR' || repoVersion.isEmpty) {
      return -2;
    }
    repoVersion = repoVersion.replaceFirst('Release ', '');
    return compareTo(repoVersion, version);
  }

  Widget? _driftIcon(BuildContext context, int comparison) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (comparison) {
      -1 => Icon(Icons.arrow_upward, color: colorScheme.error, size: 18),
      1 => Icon(Icons.arrow_downward, color: colorScheme.tertiary, size: 18),
      0 => const Padding(
          padding: EdgeInsets.only(right: 2),
          child: FaIcon(FontAwesomeIcons.equals, size: 16),
        ),
      _ => null,
    };
  }
}

class _CellStatus {
  const _CellStatus({
    required this.icon,
    required this.label,
    required this.value,
    required this.tooltip,
  });

  final Widget icon;
  final String label;
  final String value;
  final String tooltip;
}
