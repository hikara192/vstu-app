part of 'schedule_models.dart';

T _$identity<T>(T value) => value;

mixin _$Teacher {
  int? get id;
  String get fullName;
  String? get degree;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeacherCopyWith<Teacher> get copyWith =>
      _$TeacherCopyWithImpl<Teacher>(this as Teacher, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as Teacher;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Teacher &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.fullName, _this.fullName) ||
                other.fullName == _this.fullName) &&
            (identical(other.degree, _this.degree) ||
                other.degree == _this.degree));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as Teacher;
    return Object.hash(runtimeType, _this.id, _this.fullName, _this.degree);
  }

  @override
  String toString() {
    final _this = this as Teacher;
    return 'Teacher(id: ${_this.id}, fullName: ${_this.fullName}, degree: ${_this.degree})';
  }
}

abstract mixin class $TeacherCopyWith<$Res> {
  factory $TeacherCopyWith(Teacher value, $Res Function(Teacher) _then) =
      _$TeacherCopyWithImpl;
  @useResult
  $Res call({int? id, String fullName, String? degree});
}

class _$TeacherCopyWithImpl<$Res> implements $TeacherCopyWith<$Res> {
  _$TeacherCopyWithImpl(this._self, this._then);

  final Teacher _self;
  final $Res Function(Teacher) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? fullName = null,
    Object? degree = freezed,
  }) {
    return _then(
      Teacher(
        id: freezed == id ? _self.id : id as int?,
        fullName: null == fullName ? _self.fullName : fullName as String,
        degree: freezed == degree ? _self.degree : degree as String?,
      ),
    );
  }
}

extension TeacherPatterns on Teacher {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Teacher value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Teacher() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Teacher value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Teacher():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Teacher value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Teacher() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int? id, String fullName, String? degree)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Teacher() when $default != null:
        return $default(_that.id, _that.fullName, _that.degree);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int? id, String fullName, String? degree) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Teacher():
        return $default(_that.id, _that.fullName, _that.degree);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int? id, String fullName, String? degree)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Teacher() when $default != null:
        return $default(_that.id, _that.fullName, _that.degree);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _Teacher implements Teacher {
  const _Teacher({this.id, required this.fullName, this.degree});
  factory _Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);

  @override
  final int? id;
  @override
  final String fullName;
  @override
  final String? degree;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeacherCopyWith<_Teacher> get copyWith =>
      __$TeacherCopyWithImpl<_Teacher>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeacherToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Teacher &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.degree, degree) || other.degree == degree));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, id, fullName, degree);
  }

  @override
  String toString() {
    return 'Teacher(id: $id, fullName: $fullName, degree: $degree)';
  }
}

abstract mixin class _$TeacherCopyWith<$Res> implements $TeacherCopyWith<$Res> {
  factory _$TeacherCopyWith(_Teacher value, $Res Function(_Teacher) _then) =
      __$TeacherCopyWithImpl;
  @override
  @useResult
  $Res call({int? id, String fullName, String? degree});
}

class __$TeacherCopyWithImpl<$Res> implements _$TeacherCopyWith<$Res> {
  __$TeacherCopyWithImpl(this._self, this._then);

  final _Teacher _self;
  final $Res Function(_Teacher) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? fullName = null,
    Object? degree = freezed,
  }) {
    return _then(
      _Teacher(
        id: freezed == id ? _self.id : id as int?,
        fullName: null == fullName ? _self.fullName : fullName as String,
        degree: freezed == degree ? _self.degree : degree as String?,
      ),
    );
  }
}

mixin _$Lesson {
  int get id;
  int get number;
  String get timeStart;
  String get timeEnd;
  String get type;
  String get typeShort;
  String get subject;
  Teacher? get teacher;

  String get room;

  int? get frame;
  String get weekType;
  String get subGroup;
  int get dayOfWeek;
  DateTime get dateStart;
  DateTime get dateEnd;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LessonCopyWith<Lesson> get copyWith =>
      _$LessonCopyWithImpl<Lesson>(this as Lesson, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as Lesson;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Lesson &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.number, _this.number) ||
                other.number == _this.number) &&
            (identical(other.timeStart, _this.timeStart) ||
                other.timeStart == _this.timeStart) &&
            (identical(other.timeEnd, _this.timeEnd) ||
                other.timeEnd == _this.timeEnd) &&
            (identical(other.type, _this.type) || other.type == _this.type) &&
            (identical(other.typeShort, _this.typeShort) ||
                other.typeShort == _this.typeShort) &&
            (identical(other.subject, _this.subject) ||
                other.subject == _this.subject) &&
            (identical(other.teacher, _this.teacher) ||
                other.teacher == _this.teacher) &&
            (identical(other.room, _this.room) || other.room == _this.room) &&
            (identical(other.frame, _this.frame) ||
                other.frame == _this.frame) &&
            (identical(other.weekType, _this.weekType) ||
                other.weekType == _this.weekType) &&
            (identical(other.subGroup, _this.subGroup) ||
                other.subGroup == _this.subGroup) &&
            (identical(other.dayOfWeek, _this.dayOfWeek) ||
                other.dayOfWeek == _this.dayOfWeek) &&
            (identical(other.dateStart, _this.dateStart) ||
                other.dateStart == _this.dateStart) &&
            (identical(other.dateEnd, _this.dateEnd) ||
                other.dateEnd == _this.dateEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as Lesson;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.number,
      _this.timeStart,
      _this.timeEnd,
      _this.type,
      _this.typeShort,
      _this.subject,
      _this.teacher,
      _this.room,
      _this.frame,
      _this.weekType,
      _this.subGroup,
      _this.dayOfWeek,
      _this.dateStart,
      _this.dateEnd,
    );
  }

  @override
  String toString() {
    final _this = this as Lesson;
    return 'Lesson(id: ${_this.id}, number: ${_this.number}, timeStart: ${_this.timeStart}, timeEnd: ${_this.timeEnd}, type: ${_this.type}, typeShort: ${_this.typeShort}, subject: ${_this.subject}, teacher: ${_this.teacher}, room: ${_this.room}, frame: ${_this.frame}, weekType: ${_this.weekType}, subGroup: ${_this.subGroup}, dayOfWeek: ${_this.dayOfWeek}, dateStart: ${_this.dateStart}, dateEnd: ${_this.dateEnd})';
  }
}

abstract mixin class $LessonCopyWith<$Res> {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) _then) =
      _$LessonCopyWithImpl;
  @useResult
  $Res call({
    int id,
    int number,
    String timeStart,
    String timeEnd,
    String type,
    String typeShort,
    String subject,
    Teacher? teacher,
    String room,
    int? frame,
    String weekType,
    String subGroup,
    int dayOfWeek,
    DateTime dateStart,
    DateTime dateEnd,
  });

  $TeacherCopyWith<$Res>? get teacher;
}

class _$LessonCopyWithImpl<$Res> implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._self, this._then);

  final Lesson _self;
  final $Res Function(Lesson) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? timeStart = null,
    Object? timeEnd = null,
    Object? type = null,
    Object? typeShort = null,
    Object? subject = null,
    Object? teacher = freezed,
    Object? room = null,
    Object? frame = freezed,
    Object? weekType = null,
    Object? subGroup = null,
    Object? dayOfWeek = null,
    Object? dateStart = null,
    Object? dateEnd = null,
  }) {
    return _then(
      Lesson(
        id: null == id ? _self.id : id as int,
        number: null == number ? _self.number : number as int,
        timeStart: null == timeStart ? _self.timeStart : timeStart as String,
        timeEnd: null == timeEnd ? _self.timeEnd : timeEnd as String,
        type: null == type ? _self.type : type as String,
        typeShort: null == typeShort ? _self.typeShort : typeShort as String,
        subject: null == subject ? _self.subject : subject as String,
        teacher: freezed == teacher ? _self.teacher : teacher as Teacher?,
        room: null == room ? _self.room : room as String,
        frame: freezed == frame ? _self.frame : frame as int?,
        weekType: null == weekType ? _self.weekType : weekType as String,
        subGroup: null == subGroup ? _self.subGroup : subGroup as String,
        dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek as int,
        dateStart: null == dateStart ? _self.dateStart : dateStart as DateTime,
        dateEnd: null == dateEnd ? _self.dateEnd : dateEnd as DateTime,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $TeacherCopyWith<$Res>? get teacher {
    if (_self.teacher == null) {
      return null;
    }

    return $TeacherCopyWith<$Res>(_self.teacher!, (value) {
      return _then(_self.copyWith(teacher: value));
    });
  }
}

extension LessonPatterns on Lesson {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Lesson value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Lesson() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Lesson value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lesson():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Lesson value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lesson() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      int id,
      int number,
      String timeStart,
      String timeEnd,
      String type,
      String typeShort,
      String subject,
      Teacher? teacher,
      String room,
      int? frame,
      String weekType,
      String subGroup,
      int dayOfWeek,
      DateTime dateStart,
      DateTime dateEnd,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Lesson() when $default != null:
        return $default(
          _that.id,
          _that.number,
          _that.timeStart,
          _that.timeEnd,
          _that.type,
          _that.typeShort,
          _that.subject,
          _that.teacher,
          _that.room,
          _that.frame,
          _that.weekType,
          _that.subGroup,
          _that.dayOfWeek,
          _that.dateStart,
          _that.dateEnd,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      int id,
      int number,
      String timeStart,
      String timeEnd,
      String type,
      String typeShort,
      String subject,
      Teacher? teacher,
      String room,
      int? frame,
      String weekType,
      String subGroup,
      int dayOfWeek,
      DateTime dateStart,
      DateTime dateEnd,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lesson():
        return $default(
          _that.id,
          _that.number,
          _that.timeStart,
          _that.timeEnd,
          _that.type,
          _that.typeShort,
          _that.subject,
          _that.teacher,
          _that.room,
          _that.frame,
          _that.weekType,
          _that.subGroup,
          _that.dayOfWeek,
          _that.dateStart,
          _that.dateEnd,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      int id,
      int number,
      String timeStart,
      String timeEnd,
      String type,
      String typeShort,
      String subject,
      Teacher? teacher,
      String room,
      int? frame,
      String weekType,
      String subGroup,
      int dayOfWeek,
      DateTime dateStart,
      DateTime dateEnd,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Lesson() when $default != null:
        return $default(
          _that.id,
          _that.number,
          _that.timeStart,
          _that.timeEnd,
          _that.type,
          _that.typeShort,
          _that.subject,
          _that.teacher,
          _that.room,
          _that.frame,
          _that.weekType,
          _that.subGroup,
          _that.dayOfWeek,
          _that.dateStart,
          _that.dateEnd,
        );
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _Lesson implements Lesson {
  const _Lesson({
    required this.id,
    required this.number,
    required this.timeStart,
    required this.timeEnd,
    required this.type,
    required this.typeShort,
    required this.subject,
    this.teacher,
    this.room = '',
    this.frame,
    this.weekType = 'Всегда',
    this.subGroup = 'Все',
    required this.dayOfWeek,
    required this.dateStart,
    required this.dateEnd,
  });
  factory _Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  @override
  final int id;
  @override
  final int number;
  @override
  final String timeStart;
  @override
  final String timeEnd;
  @override
  final String type;
  @override
  final String typeShort;
  @override
  final String subject;
  @override
  final Teacher? teacher;

  @override
  @JsonKey()
  final String room;

  @override
  final int? frame;
  @override
  @JsonKey()
  final String weekType;
  @override
  @JsonKey()
  final String subGroup;
  @override
  final int dayOfWeek;
  @override
  final DateTime dateStart;
  @override
  final DateTime dateEnd;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LessonCopyWith<_Lesson> get copyWith =>
      __$LessonCopyWithImpl<_Lesson>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LessonToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Lesson &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.timeStart, timeStart) ||
                other.timeStart == timeStart) &&
            (identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.typeShort, typeShort) ||
                other.typeShort == typeShort) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.teacher, teacher) || other.teacher == teacher) &&
            (identical(other.room, room) || other.room == room) &&
            (identical(other.frame, frame) || other.frame == frame) &&
            (identical(other.weekType, weekType) ||
                other.weekType == weekType) &&
            (identical(other.subGroup, subGroup) ||
                other.subGroup == subGroup) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.dateStart, dateStart) ||
                other.dateStart == dateStart) &&
            (identical(other.dateEnd, dateEnd) || other.dateEnd == dateEnd));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      number,
      timeStart,
      timeEnd,
      type,
      typeShort,
      subject,
      teacher,
      room,
      frame,
      weekType,
      subGroup,
      dayOfWeek,
      dateStart,
      dateEnd,
    );
  }

  @override
  String toString() {
    return 'Lesson(id: $id, number: $number, timeStart: $timeStart, timeEnd: $timeEnd, type: $type, typeShort: $typeShort, subject: $subject, teacher: $teacher, room: $room, frame: $frame, weekType: $weekType, subGroup: $subGroup, dayOfWeek: $dayOfWeek, dateStart: $dateStart, dateEnd: $dateEnd)';
  }
}

abstract mixin class _$LessonCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$LessonCopyWith(_Lesson value, $Res Function(_Lesson) _then) =
      __$LessonCopyWithImpl;
  @override
  @useResult
  $Res call({
    int id,
    int number,
    String timeStart,
    String timeEnd,
    String type,
    String typeShort,
    String subject,
    Teacher? teacher,
    String room,
    int? frame,
    String weekType,
    String subGroup,
    int dayOfWeek,
    DateTime dateStart,
    DateTime dateEnd,
  });

  @override
  $TeacherCopyWith<$Res>? get teacher;
}

class __$LessonCopyWithImpl<$Res> implements _$LessonCopyWith<$Res> {
  __$LessonCopyWithImpl(this._self, this._then);

  final _Lesson _self;
  final $Res Function(_Lesson) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? number = null,
    Object? timeStart = null,
    Object? timeEnd = null,
    Object? type = null,
    Object? typeShort = null,
    Object? subject = null,
    Object? teacher = freezed,
    Object? room = null,
    Object? frame = freezed,
    Object? weekType = null,
    Object? subGroup = null,
    Object? dayOfWeek = null,
    Object? dateStart = null,
    Object? dateEnd = null,
  }) {
    return _then(
      _Lesson(
        id: null == id ? _self.id : id as int,
        number: null == number ? _self.number : number as int,
        timeStart: null == timeStart ? _self.timeStart : timeStart as String,
        timeEnd: null == timeEnd ? _self.timeEnd : timeEnd as String,
        type: null == type ? _self.type : type as String,
        typeShort: null == typeShort ? _self.typeShort : typeShort as String,
        subject: null == subject ? _self.subject : subject as String,
        teacher: freezed == teacher ? _self.teacher : teacher as Teacher?,
        room: null == room ? _self.room : room as String,
        frame: freezed == frame ? _self.frame : frame as int?,
        weekType: null == weekType ? _self.weekType : weekType as String,
        subGroup: null == subGroup ? _self.subGroup : subGroup as String,
        dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek as int,
        dateStart: null == dateStart ? _self.dateStart : dateStart as DateTime,
        dateEnd: null == dateEnd ? _self.dateEnd : dateEnd as DateTime,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $TeacherCopyWith<$Res>? get teacher {
    if (_self.teacher == null) {
      return null;
    }

    return $TeacherCopyWith<$Res>(_self.teacher!, (value) {
      return _then(_self.copyWith(teacher: value));
    });
  }
}

mixin _$GroupInfo {
  int get id;
  String get name;
  String? get facultyName;
  int? get course;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupInfoCopyWith<GroupInfo> get copyWith =>
      _$GroupInfoCopyWithImpl<GroupInfo>(this as GroupInfo, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as GroupInfo;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupInfo &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.name, _this.name) || other.name == _this.name) &&
            (identical(other.facultyName, _this.facultyName) ||
                other.facultyName == _this.facultyName) &&
            (identical(other.course, _this.course) ||
                other.course == _this.course));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as GroupInfo;
    return Object.hash(
      runtimeType,
      _this.id,
      _this.name,
      _this.facultyName,
      _this.course,
    );
  }

  @override
  String toString() {
    final _this = this as GroupInfo;
    return 'GroupInfo(id: ${_this.id}, name: ${_this.name}, facultyName: ${_this.facultyName}, course: ${_this.course})';
  }
}

abstract mixin class $GroupInfoCopyWith<$Res> {
  factory $GroupInfoCopyWith(GroupInfo value, $Res Function(GroupInfo) _then) =
      _$GroupInfoCopyWithImpl;
  @useResult
  $Res call({int id, String name, String? facultyName, int? course});
}

class _$GroupInfoCopyWithImpl<$Res> implements $GroupInfoCopyWith<$Res> {
  _$GroupInfoCopyWithImpl(this._self, this._then);

  final GroupInfo _self;
  final $Res Function(GroupInfo) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? facultyName = freezed,
    Object? course = freezed,
  }) {
    return _then(
      GroupInfo(
        id: null == id ? _self.id : id as int,
        name: null == name ? _self.name : name as String,
        facultyName: freezed == facultyName
            ? _self.facultyName
            : facultyName as String?,
        course: freezed == course ? _self.course : course as int?,
      ),
    );
  }
}

extension GroupInfoPatterns on GroupInfo {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GroupInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GroupInfo() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GroupInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupInfo():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GroupInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupInfo() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int id, String name, String? facultyName, int? course)?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GroupInfo() when $default != null:
        return $default(_that.id, _that.name, _that.facultyName, _that.course);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int id, String name, String? facultyName, int? course)
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupInfo():
        return $default(_that.id, _that.name, _that.facultyName, _that.course);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(int id, String name, String? facultyName, int? course)?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupInfo() when $default != null:
        return $default(_that.id, _that.name, _that.facultyName, _that.course);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _GroupInfo implements GroupInfo {
  const _GroupInfo({
    required this.id,
    required this.name,
    this.facultyName,
    this.course,
  });
  factory _GroupInfo.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? facultyName;
  @override
  final int? course;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupInfoCopyWith<_GroupInfo> get copyWith =>
      __$GroupInfoCopyWithImpl<_GroupInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupInfoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupInfo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.facultyName, facultyName) ||
                other.facultyName == facultyName) &&
            (identical(other.course, course) || other.course == course));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, id, name, facultyName, course);
  }

  @override
  String toString() {
    return 'GroupInfo(id: $id, name: $name, facultyName: $facultyName, course: $course)';
  }
}

abstract mixin class _$GroupInfoCopyWith<$Res>
    implements $GroupInfoCopyWith<$Res> {
  factory _$GroupInfoCopyWith(
    _GroupInfo value,
    $Res Function(_GroupInfo) _then,
  ) = __$GroupInfoCopyWithImpl;
  @override
  @useResult
  $Res call({int id, String name, String? facultyName, int? course});
}

class __$GroupInfoCopyWithImpl<$Res> implements _$GroupInfoCopyWith<$Res> {
  __$GroupInfoCopyWithImpl(this._self, this._then);

  final _GroupInfo _self;
  final $Res Function(_GroupInfo) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? facultyName = freezed,
    Object? course = freezed,
  }) {
    return _then(
      _GroupInfo(
        id: null == id ? _self.id : id as int,
        name: null == name ? _self.name : name as String,
        facultyName: freezed == facultyName
            ? _self.facultyName
            : facultyName as String?,
        course: freezed == course ? _self.course : course as int?,
      ),
    );
  }
}

mixin _$WeekCycleAnchor {
  DateTime get date;
  int get number;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WeekCycleAnchorCopyWith<WeekCycleAnchor> get copyWith =>
      _$WeekCycleAnchorCopyWithImpl<WeekCycleAnchor>(
        this as WeekCycleAnchor,
        _$identity,
      );

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as WeekCycleAnchor;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WeekCycleAnchor &&
            (identical(other.date, _this.date) || other.date == _this.date) &&
            (identical(other.number, _this.number) ||
                other.number == _this.number));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as WeekCycleAnchor;
    return Object.hash(runtimeType, _this.date, _this.number);
  }

  @override
  String toString() {
    final _this = this as WeekCycleAnchor;
    return 'WeekCycleAnchor(date: ${_this.date}, number: ${_this.number})';
  }
}

abstract mixin class $WeekCycleAnchorCopyWith<$Res> {
  factory $WeekCycleAnchorCopyWith(
    WeekCycleAnchor value,
    $Res Function(WeekCycleAnchor) _then,
  ) = _$WeekCycleAnchorCopyWithImpl;
  @useResult
  $Res call({DateTime date, int number});
}

class _$WeekCycleAnchorCopyWithImpl<$Res>
    implements $WeekCycleAnchorCopyWith<$Res> {
  _$WeekCycleAnchorCopyWithImpl(this._self, this._then);

  final WeekCycleAnchor _self;
  final $Res Function(WeekCycleAnchor) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? number = null}) {
    return _then(
      WeekCycleAnchor(
        date: null == date ? _self.date : date as DateTime,
        number: null == number ? _self.number : number as int,
      ),
    );
  }
}

extension WeekCycleAnchorPatterns on WeekCycleAnchor {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_WeekCycleAnchor value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeekCycleAnchor() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_WeekCycleAnchor value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeekCycleAnchor():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_WeekCycleAnchor value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeekCycleAnchor() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DateTime date, int number)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WeekCycleAnchor() when $default != null:
        return $default(_that.date, _that.number);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DateTime date, int number) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeekCycleAnchor():
        return $default(_that.date, _that.number);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DateTime date, int number)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WeekCycleAnchor() when $default != null:
        return $default(_that.date, _that.number);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _WeekCycleAnchor implements WeekCycleAnchor {
  const _WeekCycleAnchor({required this.date, required this.number});
  factory _WeekCycleAnchor.fromJson(Map<String, dynamic> json) =>
      _$WeekCycleAnchorFromJson(json);

  @override
  final DateTime date;

  @override
  final int number;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WeekCycleAnchorCopyWith<_WeekCycleAnchor> get copyWith =>
      __$WeekCycleAnchorCopyWithImpl<_WeekCycleAnchor>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$WeekCycleAnchorToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WeekCycleAnchor &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.number, number) || other.number == number));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, date, number);
  }

  @override
  String toString() {
    return 'WeekCycleAnchor(date: $date, number: $number)';
  }
}

abstract mixin class _$WeekCycleAnchorCopyWith<$Res>
    implements $WeekCycleAnchorCopyWith<$Res> {
  factory _$WeekCycleAnchorCopyWith(
    _WeekCycleAnchor value,
    $Res Function(_WeekCycleAnchor) _then,
  ) = __$WeekCycleAnchorCopyWithImpl;
  @override
  @useResult
  $Res call({DateTime date, int number});
}

class __$WeekCycleAnchorCopyWithImpl<$Res>
    implements _$WeekCycleAnchorCopyWith<$Res> {
  __$WeekCycleAnchorCopyWithImpl(this._self, this._then);

  final _WeekCycleAnchor _self;
  final $Res Function(_WeekCycleAnchor) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({Object? date = null, Object? number = null}) {
    return _then(
      _WeekCycleAnchor(
        date: null == date ? _self.date : date as DateTime,
        number: null == number ? _self.number : number as int,
      ),
    );
  }
}

mixin _$GroupSchedule {
  GroupInfo get group;
  DateTime get semesterStart;
  List<Lesson> get lessons;

  WeekCycleAnchor? get weekAnchor;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupScheduleCopyWith<GroupSchedule> get copyWith =>
      _$GroupScheduleCopyWithImpl<GroupSchedule>(
        this as GroupSchedule,
        _$identity,
      );

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as GroupSchedule;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupSchedule &&
            (identical(other.group, _this.group) ||
                other.group == _this.group) &&
            (identical(other.semesterStart, _this.semesterStart) ||
                other.semesterStart == _this.semesterStart) &&
            const DeepCollectionEquality().equals(
              other.lessons,
              _this.lessons,
            ) &&
            (identical(other.weekAnchor, _this.weekAnchor) ||
                other.weekAnchor == _this.weekAnchor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as GroupSchedule;
    return Object.hash(
      runtimeType,
      _this.group,
      _this.semesterStart,
      const DeepCollectionEquality().hash(_this.lessons),
      _this.weekAnchor,
    );
  }

  @override
  String toString() {
    final _this = this as GroupSchedule;
    return 'GroupSchedule(group: ${_this.group}, semesterStart: ${_this.semesterStart}, lessons: ${_this.lessons}, weekAnchor: ${_this.weekAnchor})';
  }
}

abstract mixin class $GroupScheduleCopyWith<$Res> {
  factory $GroupScheduleCopyWith(
    GroupSchedule value,
    $Res Function(GroupSchedule) _then,
  ) = _$GroupScheduleCopyWithImpl;
  @useResult
  $Res call({
    GroupInfo group,
    DateTime semesterStart,
    List<Lesson> lessons,
    WeekCycleAnchor? weekAnchor,
  });

  $GroupInfoCopyWith<$Res> get group;
  $WeekCycleAnchorCopyWith<$Res>? get weekAnchor;
}

class _$GroupScheduleCopyWithImpl<$Res>
    implements $GroupScheduleCopyWith<$Res> {
  _$GroupScheduleCopyWithImpl(this._self, this._then);

  final GroupSchedule _self;
  final $Res Function(GroupSchedule) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = null,
    Object? semesterStart = null,
    Object? lessons = null,
    Object? weekAnchor = freezed,
  }) {
    return _then(
      GroupSchedule(
        group: null == group ? _self.group : group as GroupInfo,
        semesterStart: null == semesterStart
            ? _self.semesterStart
            : semesterStart as DateTime,
        lessons: null == lessons ? _self.lessons : lessons as List<Lesson>,
        weekAnchor: freezed == weekAnchor
            ? _self.weekAnchor
            : weekAnchor as WeekCycleAnchor?,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $GroupInfoCopyWith<$Res> get group {
    return $GroupInfoCopyWith<$Res>(_self.group, (value) {
      return _then(_self.copyWith(group: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WeekCycleAnchorCopyWith<$Res>? get weekAnchor {
    if (_self.weekAnchor == null) {
      return null;
    }

    return $WeekCycleAnchorCopyWith<$Res>(_self.weekAnchor!, (value) {
      return _then(_self.copyWith(weekAnchor: value));
    });
  }
}

extension GroupSchedulePatterns on GroupSchedule {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GroupSchedule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GroupSchedule() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GroupSchedule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupSchedule():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GroupSchedule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupSchedule() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      GroupInfo group,
      DateTime semesterStart,
      List<Lesson> lessons,
      WeekCycleAnchor? weekAnchor,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GroupSchedule() when $default != null:
        return $default(
          _that.group,
          _that.semesterStart,
          _that.lessons,
          _that.weekAnchor,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      GroupInfo group,
      DateTime semesterStart,
      List<Lesson> lessons,
      WeekCycleAnchor? weekAnchor,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupSchedule():
        return $default(
          _that.group,
          _that.semesterStart,
          _that.lessons,
          _that.weekAnchor,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      GroupInfo group,
      DateTime semesterStart,
      List<Lesson> lessons,
      WeekCycleAnchor? weekAnchor,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GroupSchedule() when $default != null:
        return $default(
          _that.group,
          _that.semesterStart,
          _that.lessons,
          _that.weekAnchor,
        );
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _GroupSchedule implements GroupSchedule {
  const _GroupSchedule({
    required this.group,
    required this.semesterStart,
    List<Lesson> lessons = const <Lesson>[],
    this.weekAnchor,
  }) : _lessons = lessons;
  factory _GroupSchedule.fromJson(Map<String, dynamic> json) =>
      _$GroupScheduleFromJson(json);

  @override
  final GroupInfo group;
  @override
  final DateTime semesterStart;
  final List<Lesson> _lessons;
  @override
  @JsonKey()
  List<Lesson> get lessons {
    if (_lessons is EqualUnmodifiableListView) return _lessons;

    return EqualUnmodifiableListView(_lessons);
  }

  @override
  final WeekCycleAnchor? weekAnchor;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupScheduleCopyWith<_GroupSchedule> get copyWith =>
      __$GroupScheduleCopyWithImpl<_GroupSchedule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupScheduleToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupSchedule &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.semesterStart, semesterStart) ||
                other.semesterStart == semesterStart) &&
            const DeepCollectionEquality().equals(other.lessons, _lessons) &&
            (identical(other.weekAnchor, weekAnchor) ||
                other.weekAnchor == weekAnchor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      group,
      semesterStart,
      const DeepCollectionEquality().hash(_lessons),
      weekAnchor,
    );
  }

  @override
  String toString() {
    return 'GroupSchedule(group: $group, semesterStart: $semesterStart, lessons: $lessons, weekAnchor: $weekAnchor)';
  }
}

abstract mixin class _$GroupScheduleCopyWith<$Res>
    implements $GroupScheduleCopyWith<$Res> {
  factory _$GroupScheduleCopyWith(
    _GroupSchedule value,
    $Res Function(_GroupSchedule) _then,
  ) = __$GroupScheduleCopyWithImpl;
  @override
  @useResult
  $Res call({
    GroupInfo group,
    DateTime semesterStart,
    List<Lesson> lessons,
    WeekCycleAnchor? weekAnchor,
  });

  @override
  $GroupInfoCopyWith<$Res> get group;
  @override
  $WeekCycleAnchorCopyWith<$Res>? get weekAnchor;
}

class __$GroupScheduleCopyWithImpl<$Res>
    implements _$GroupScheduleCopyWith<$Res> {
  __$GroupScheduleCopyWithImpl(this._self, this._then);

  final _GroupSchedule _self;
  final $Res Function(_GroupSchedule) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? group = null,
    Object? semesterStart = null,
    Object? lessons = null,
    Object? weekAnchor = freezed,
  }) {
    return _then(
      _GroupSchedule(
        group: null == group ? _self.group : group as GroupInfo,
        semesterStart: null == semesterStart
            ? _self.semesterStart
            : semesterStart as DateTime,
        lessons: null == lessons ? _self._lessons : lessons as List<Lesson>,
        weekAnchor: freezed == weekAnchor
            ? _self.weekAnchor
            : weekAnchor as WeekCycleAnchor?,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $GroupInfoCopyWith<$Res> get group {
    return $GroupInfoCopyWith<$Res>(_self.group, (value) {
      return _then(_self.copyWith(group: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WeekCycleAnchorCopyWith<$Res>? get weekAnchor {
    if (_self.weekAnchor == null) {
      return null;
    }

    return $WeekCycleAnchorCopyWith<$Res>(_self.weekAnchor!, (value) {
      return _then(_self.copyWith(weekAnchor: value));
    });
  }
}
