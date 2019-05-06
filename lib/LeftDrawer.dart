import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double _kWidth = 200;
class LeftDrawer extends StatelessWidget {

  const LeftDrawer({
    Key key,
    this.elevation = 16.0,
    this.child,
    this.semanticLabel,
    this.color = Colors.white,
  }) : assert(elevation != null && elevation >= 0.0),
        super(key: key);


  final double elevation;

  final Widget child;

  final String semanticLabel;

  final Color color;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    String label = semanticLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        label = semanticLabel;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        label = semanticLabel ?? MaterialLocalizations.of(context)?.drawerLabel;
    }
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(width: _kWidth),
        child: Material(
          color: color,
          elevation: elevation,
          child: child,
        ),
      ),
    );
  }
}

