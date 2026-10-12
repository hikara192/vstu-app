part of 'group.dart';

T _$identity<T>(T value) => value;

mixin _$Group {
  int get id;
  String get name;
  String? get facultyName;
  String? get facultyType;
  int? get course;
  String? get educationLevel;
  String? get specShort;
  String? get specName;
  String? get specCode;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupCopyWith<Group> get copyWith =>
      _$GroupCopyWithImpl<Group>(this as Group, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as Group;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Group &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.name, _this.name) || other.name == _this.name) &&
            (identical(other.facultyName, _this.facultyName) ||
                other.facultyName == _this.facultyName) &&
            (identical(other.facultyType, _this.facultyType) ||
                other.facultyType == _this.facultyType) &&
            (identical(other.course, _this.course) ||
                other.course == _this.course) &&
            (identical(other.educationLevel, _this.educationLevel) ||
                other.educationLevel == _this.educationLevel) &&
            (identical(other.specShort, _this.specShort) ||
                other.specShort == _this.specShort) &&
            (identical(other.specName, _this.specName) ||
                other.specName == _this.specName) &&
            (identical(other.specCode, _this.specCode) ||
                other.specCode == _this.specCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as Group;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.name,
      _this.facultyName,
      _this.facultyType,
      _this.course,
      _this.educationLevel,
      _this.specShort,
      _this.specName,
      _this.specCode,
    );
  }

  @override
  String toString() {
    final _this = this as Group;
    return 'Group(id: ${_this.id}, name: ${_this.name}, facultyName: ${_this.facultyName}, facultyType: ${_this.facultyType}, course: ${_this.course}, educationLevel: ${_this.educationLevel}, specShort: ${_this.specShort}, specName: ${_this.specName}, specCode: ${_this.specCode})';
  }
}

abstract mixin class $GroupCopyWith<$Res> {
  factory $GroupCopyWith(Group value, $Res Function(Group) _then) =
      _$GroupCopyWithImpl;
  @useResult
  $Res call({
    int id,
    String name,
    String? facultyName,
    String? facultyType,
    int? course,
    String? educationLevel,
    String? specShort,
    String? specName,
    String? specCode,
  });
}

class _$GroupCopyWithImpl<$Res> implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._self, this._then);

  final Group _self;
  final $Res Function(Group) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? facultyName = freezed,
    Object? facultyType = freezed,
    Object? course = freezed,
    Object? educationLevel = freezed,
    Object? specShort = freezed,
    Object? specName = freezed,
    Object? specCode = freezed,
  }) {
    return _then(
      Group(
        id: null == id ? _self.id : id as int,
        name: null == name ? _self.name : name as String,
        facultyName: freezed == facultyName
            ? _self.facultyName
            : facultyName as String?,
        facultyType: freezed == facultyType
            ? _self.facultyType
            : facultyType as String?,
        course: freezed == course ? _self.course : course as int?,
        educationLevel: freezed == educationLevel
            ? _self.educationLevel
            : educationLevel as String?,
        specShort: freezed == specShort
            ? _self.specShort
            : specShort as String?,
        specName: freezed == specName ? _self.specName : specName as String?,
        specCode: freezed == specCode ? _self.specCode : specCode as String?,
      ),
    );
  }
}

extension GroupPatterns on Group {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Group value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Group() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Group value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Group():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Group value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Group() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      int id,
      String name,
      String? facultyName,
      String? facultyType,
      int? course,
      String? educationLevel,
      String? specShort,
      String? specName,
      String? specCode,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Group() when $default != null:
        return $default(
          _that.id,
          _that.name,
          _that.facultyName,
          _that.facultyType,
          _that.course,
          _that.educationLevel,
          _that.specShort,
          _that.specName,
          _that.specCode,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      int id,
      String name,
      String? facultyName,
      String? facultyType,
      int? course,
      String? educationLevel,
      String? specShort,
      String? specName,
      String? specCode,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Group():
        return $default(
          _that.id,
          _that.name,
          _that.facultyName,
          _that.facultyType,
          _that.course,
          _that.educationLevel,
          _that.specShort,
          _that.specName,
          _that.specCode,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      int id,
      String name,
      String? facultyName,
      String? facultyType,
      int? course,
      String? educationLevel,
      String? specShort,
      String? specName,
      String? specCode,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Group() when $default != null:
        return $default(
          _that.id,
          _that.name,
          _that.facultyName,
          _that.facultyType,
          _that.course,
          _that.educationLevel,
          _that.specShort,
          _that.specName,
          _that.specCode,
        );
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _Group implements Group {
  const _Group({
    required this.id,
    required this.name,
    this.facultyName,
    this.facultyType,
    this.course,
    this.educationLevel,
    this.specShort,
    this.specName,
    this.specCode,
  });
  factory _Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? facultyName;
  @override
  final String? facultyType;
  @override
  final int? course;
  @override
  final String? educationLevel;
  @override
  final String? specShort;
  @override
  final String? specName;
  @override
  final String? specCode;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupCopyWith<_Group> get copyWith =>
      __$GroupCopyWithImpl<_Group>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Group &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.facultyName, facultyName) ||
                other.facultyName == facultyName) &&
            (identical(other.facultyType, facultyType) ||
                other.facultyType == facultyType) &&
            (identical(other.course, course) || other.course == course) &&
            (identical(other.educationLevel, educationLevel) ||
                other.educationLevel == educationLevel) &&
            (identical(other.specShort, specShort) ||
                other.specShort == specShort) &&
            (identical(other.specName, specName) ||
                other.specName == specName) &&
            (identical(other.specCode, specCode) ||
                other.specCode == specCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      name,
      facultyName,
      facultyType,
      course,
      educationLevel,
      specShort,
      specName,
      specCode,
    );
  }

  @override
  String toString() {
    return 'Group(id: $id, name: $name, facultyName: $facultyName, facultyType: $facultyType, course: $course, educationLevel: $educationLevel, specShort: $specShort, specName: $specName, specCode: $specCode)';
  }
}

abstract mixin class _$GroupCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$GroupCopyWith(_Group value, $Res Function(_Group) _then) =
      __$GroupCopyWithImpl;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? facultyName,
    String? facultyType,
    int? course,
    String? educationLevel,
    String? specShort,
    String? specName,
    String? specCode,
  });
}

class __$GroupCopyWithImpl<$Res> implements _$GroupCopyWith<$Res> {
  __$GroupCopyWithImpl(this._self, this._then);

  final _Group _self;
  final $Res Function(_Group) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? facultyName = freezed,
    Object? facultyType = freezed,
    Object? course = freezed,
    Object? educationLevel = freezed,
    Object? specShort = freezed,
    Object? specName = freezed,
    Object? specCode = freezed,
  }) {
    return _then(
      _Group(
        id: null == id ? _self.id : id as int,
        name: null == name ? _self.name : name as String,
        facultyName: freezed == facultyName
            ? _self.facultyName
            : facultyName as String?,
        facultyType: freezed == facultyType
            ? _self.facultyType
            : facultyType as String?,
        course: freezed == course ? _self.course : course as int?,
        educationLevel: freezed == educationLevel
            ? _self.educationLevel
            : educationLevel as String?,
        specShort: freezed == specShort
            ? _self.specShort
            : specShort as String?,
        specName: freezed == specName ? _self.specName : specName as String?,
        specCode: freezed == specCode ? _self.specCode : specCode as String?,
      ),
    );
  }
}
