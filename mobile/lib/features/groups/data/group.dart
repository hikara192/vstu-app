import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/plural.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
abstract class Group with _$Group {
  const factory Group({
    required int id,
    required String name,
    String? facultyName,
    String? facultyType,
    int? course,
    String? educationLevel,
    String? specShort,
    String? specName,
    String? specCode,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

extension GroupPresentation on Group {
  static const Map<String, String> _facultyTypeNames = {
    'DAYTIME': 'дневная',
    'CORRESPONDENCE': 'заочная',
    'MAG': 'магистратура',
    'FPK': 'ФПК',
  };

  String get facultyTypeName => _facultyTypeNames[facultyType] ?? '';

  String get subtitle {
    final parts = <String>[
      if (course != null) courseLabel(course!),
      if (facultyTypeName.isNotEmpty) facultyTypeName,
      if (specName != null && specName!.isNotEmpty) specName!,
    ];
    return parts.join(' • ');
  }
}
