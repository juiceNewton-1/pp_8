import 'package:pp_8/generated/assets.gen.dart';

class ResourceQuery {
  final String symbol;
  final String name;
  final AssetGenImage icon;

  const ResourceQuery({
    required this.symbol,
    required this.icon,
    required this.name,
  });
}
