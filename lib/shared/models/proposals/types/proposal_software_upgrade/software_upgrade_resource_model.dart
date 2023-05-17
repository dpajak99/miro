import 'package:equatable/equatable.dart';

class SoftwareUpgradeResourceModel extends Equatable {
  final String checksum;
  final String id;
  final String url;
  final String version;

  const SoftwareUpgradeResourceModel({
    required this.checksum,
    required this.id,
    required this.url,
    required this.version,
  });

  @override
  List<Object> get props => <Object>[checksum, id, url, version];
}
