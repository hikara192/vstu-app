// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sdo_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SdoProfile {

 int get userId; String get username; String get fullName; String get siteName; String get userPictureUrl;
/// Create a copy of SdoProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoProfileCopyWith<SdoProfile> get copyWith => _$SdoProfileCopyWithImpl<SdoProfile>(this as SdoProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoProfile&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.siteName, _this.siteName) || other.siteName == _this.siteName)&&(identical(other.userPictureUrl, _this.userPictureUrl) || other.userPictureUrl == _this.userPictureUrl));
}


@override
int get hashCode {
  final _this = this as SdoProfile;
  return Object.hash(runtimeType,_this.userId,_this.username,_this.fullName,_this.siteName,_this.userPictureUrl);
}

@override
String toString() {
  final _this = this as SdoProfile;
  return 'SdoProfile(userId: ${_this.userId}, username: ${_this.username}, fullName: ${_this.fullName}, siteName: ${_this.siteName}, userPictureUrl: ${_this.userPictureUrl})';
}


}

/// @nodoc
abstract mixin class $SdoProfileCopyWith<$Res>  {
  factory $SdoProfileCopyWith(SdoProfile value, $Res Function(SdoProfile) _then) = _$SdoProfileCopyWithImpl;
@useResult
$Res call({
 int userId, String username, String fullName, String siteName, String userPictureUrl
});




}
/// @nodoc
class _$SdoProfileCopyWithImpl<$Res>
    implements $SdoProfileCopyWith<$Res> {
  _$SdoProfileCopyWithImpl(this._self, this._then);

  final SdoProfile _self;
  final $Res Function(SdoProfile) _then;

/// Create a copy of SdoProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = null,Object? fullName = null,Object? siteName = null,Object? userPictureUrl = null,}) {
  return _then(SdoProfile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,siteName: null == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String,userPictureUrl: null == userPictureUrl ? _self.userPictureUrl : userPictureUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoProfile].
extension SdoProfilePatterns on SdoProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoProfile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoProfile value)  $default,){
final _that = this;
switch (_that) {
case _SdoProfile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoProfile value)?  $default,){
final _that = this;
switch (_that) {
case _SdoProfile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  String username,  String fullName,  String siteName,  String userPictureUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoProfile() when $default != null:
return $default(_that.userId,_that.username,_that.fullName,_that.siteName,_that.userPictureUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  String username,  String fullName,  String siteName,  String userPictureUrl)  $default,) {final _that = this;
switch (_that) {
case _SdoProfile():
return $default(_that.userId,_that.username,_that.fullName,_that.siteName,_that.userPictureUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  String username,  String fullName,  String siteName,  String userPictureUrl)?  $default,) {final _that = this;
switch (_that) {
case _SdoProfile() when $default != null:
return $default(_that.userId,_that.username,_that.fullName,_that.siteName,_that.userPictureUrl);case _:
  return null;

}
}

}

/// @nodoc


class _SdoProfile implements SdoProfile {
  const _SdoProfile({required this.userId, required this.username, required this.fullName, this.siteName = '', this.userPictureUrl = ''});
  

@override final  int userId;
@override final  String username;
@override final  String fullName;
@override@JsonKey() final  String siteName;
@override@JsonKey() final  String userPictureUrl;

/// Create a copy of SdoProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoProfileCopyWith<_SdoProfile> get copyWith => __$SdoProfileCopyWithImpl<_SdoProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoProfile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.siteName, siteName) || other.siteName == siteName)&&(identical(other.userPictureUrl, userPictureUrl) || other.userPictureUrl == userPictureUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId,username,fullName,siteName,userPictureUrl);
}

@override
String toString() {
    return 'SdoProfile(userId: $userId, username: $username, fullName: $fullName, siteName: $siteName, userPictureUrl: $userPictureUrl)';
}


}

/// @nodoc
abstract mixin class _$SdoProfileCopyWith<$Res> implements $SdoProfileCopyWith<$Res> {
  factory _$SdoProfileCopyWith(_SdoProfile value, $Res Function(_SdoProfile) _then) = __$SdoProfileCopyWithImpl;
@override @useResult
$Res call({
 int userId, String username, String fullName, String siteName, String userPictureUrl
});




}
/// @nodoc
class __$SdoProfileCopyWithImpl<$Res>
    implements _$SdoProfileCopyWith<$Res> {
  __$SdoProfileCopyWithImpl(this._self, this._then);

  final _SdoProfile _self;
  final $Res Function(_SdoProfile) _then;

/// Create a copy of SdoProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = null,Object? fullName = null,Object? siteName = null,Object? userPictureUrl = null,}) {
  return _then(_SdoProfile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,siteName: null == siteName ? _self.siteName : siteName // ignore: cast_nullable_to_non_nullable
as String,userPictureUrl: null == userPictureUrl ? _self.userPictureUrl : userPictureUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SdoCourse {

 int get id; String get shortName; String get fullName; String get displayName; int? get categoryId; bool get visible; DateTime? get startDate; DateTime? get endDate;
/// Create a copy of SdoCourse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoCourseCopyWith<SdoCourse> get copyWith => _$SdoCourseCopyWithImpl<SdoCourse>(this as SdoCourse, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoCourse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoCourse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.shortName, _this.shortName) || other.shortName == _this.shortName)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.visible, _this.visible) || other.visible == _this.visible)&&(identical(other.startDate, _this.startDate) || other.startDate == _this.startDate)&&(identical(other.endDate, _this.endDate) || other.endDate == _this.endDate));
}


@override
int get hashCode {
  final _this = this as SdoCourse;
  return Object.hash(runtimeType,_this.id,_this.shortName,_this.fullName,_this.displayName,_this.categoryId,_this.visible,_this.startDate,_this.endDate);
}

@override
String toString() {
  final _this = this as SdoCourse;
  return 'SdoCourse(id: ${_this.id}, shortName: ${_this.shortName}, fullName: ${_this.fullName}, displayName: ${_this.displayName}, categoryId: ${_this.categoryId}, visible: ${_this.visible}, startDate: ${_this.startDate}, endDate: ${_this.endDate})';
}


}

/// @nodoc
abstract mixin class $SdoCourseCopyWith<$Res>  {
  factory $SdoCourseCopyWith(SdoCourse value, $Res Function(SdoCourse) _then) = _$SdoCourseCopyWithImpl;
@useResult
$Res call({
 int id, String shortName, String fullName, String displayName, int? categoryId, bool visible, DateTime? startDate, DateTime? endDate
});




}
/// @nodoc
class _$SdoCourseCopyWithImpl<$Res>
    implements $SdoCourseCopyWith<$Res> {
  _$SdoCourseCopyWithImpl(this._self, this._then);

  final SdoCourse _self;
  final $Res Function(SdoCourse) _then;

/// Create a copy of SdoCourse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shortName = null,Object? fullName = null,Object? displayName = null,Object? categoryId = freezed,Object? visible = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(SdoCourse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,shortName: null == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoCourse].
extension SdoCoursePatterns on SdoCourse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoCourse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoCourse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoCourse value)  $default,){
final _that = this;
switch (_that) {
case _SdoCourse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoCourse value)?  $default,){
final _that = this;
switch (_that) {
case _SdoCourse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String shortName,  String fullName,  String displayName,  int? categoryId,  bool visible,  DateTime? startDate,  DateTime? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoCourse() when $default != null:
return $default(_that.id,_that.shortName,_that.fullName,_that.displayName,_that.categoryId,_that.visible,_that.startDate,_that.endDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String shortName,  String fullName,  String displayName,  int? categoryId,  bool visible,  DateTime? startDate,  DateTime? endDate)  $default,) {final _that = this;
switch (_that) {
case _SdoCourse():
return $default(_that.id,_that.shortName,_that.fullName,_that.displayName,_that.categoryId,_that.visible,_that.startDate,_that.endDate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String shortName,  String fullName,  String displayName,  int? categoryId,  bool visible,  DateTime? startDate,  DateTime? endDate)?  $default,) {final _that = this;
switch (_that) {
case _SdoCourse() when $default != null:
return $default(_that.id,_that.shortName,_that.fullName,_that.displayName,_that.categoryId,_that.visible,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc


class _SdoCourse implements SdoCourse {
  const _SdoCourse({required this.id, this.shortName = '', this.fullName = '', this.displayName = '', this.categoryId, this.visible = true, this.startDate, this.endDate});
  

@override final  int id;
@override@JsonKey() final  String shortName;
@override@JsonKey() final  String fullName;
@override@JsonKey() final  String displayName;
@override final  int? categoryId;
@override@JsonKey() final  bool visible;
@override final  DateTime? startDate;
@override final  DateTime? endDate;

/// Create a copy of SdoCourse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoCourseCopyWith<_SdoCourse> get copyWith => __$SdoCourseCopyWithImpl<_SdoCourse>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoCourse&&(identical(other.id, id) || other.id == id)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.visible, visible) || other.visible == visible)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,shortName,fullName,displayName,categoryId,visible,startDate,endDate);
}

@override
String toString() {
    return 'SdoCourse(id: $id, shortName: $shortName, fullName: $fullName, displayName: $displayName, categoryId: $categoryId, visible: $visible, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$SdoCourseCopyWith<$Res> implements $SdoCourseCopyWith<$Res> {
  factory _$SdoCourseCopyWith(_SdoCourse value, $Res Function(_SdoCourse) _then) = __$SdoCourseCopyWithImpl;
@override @useResult
$Res call({
 int id, String shortName, String fullName, String displayName, int? categoryId, bool visible, DateTime? startDate, DateTime? endDate
});




}
/// @nodoc
class __$SdoCourseCopyWithImpl<$Res>
    implements _$SdoCourseCopyWith<$Res> {
  __$SdoCourseCopyWithImpl(this._self, this._then);

  final _SdoCourse _self;
  final $Res Function(_SdoCourse) _then;

/// Create a copy of SdoCourse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shortName = null,Object? fullName = null,Object? displayName = null,Object? categoryId = freezed,Object? visible = null,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_SdoCourse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,shortName: null == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$SdoDeadline {

 int get id; String get name; DateTime get timeSort; int? get courseId; String get courseName; String get moduleName; String get eventType; String get description; String get url; bool get overdue;
/// Create a copy of SdoDeadline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoDeadlineCopyWith<SdoDeadline> get copyWith => _$SdoDeadlineCopyWithImpl<SdoDeadline>(this as SdoDeadline, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoDeadline;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoDeadline&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.timeSort, _this.timeSort) || other.timeSort == _this.timeSort)&&(identical(other.courseId, _this.courseId) || other.courseId == _this.courseId)&&(identical(other.courseName, _this.courseName) || other.courseName == _this.courseName)&&(identical(other.moduleName, _this.moduleName) || other.moduleName == _this.moduleName)&&(identical(other.eventType, _this.eventType) || other.eventType == _this.eventType)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.overdue, _this.overdue) || other.overdue == _this.overdue));
}


@override
int get hashCode {
  final _this = this as SdoDeadline;
  return Object.hash(runtimeType,_this.id,_this.name,_this.timeSort,_this.courseId,_this.courseName,_this.moduleName,_this.eventType,_this.description,_this.url,_this.overdue);
}

@override
String toString() {
  final _this = this as SdoDeadline;
  return 'SdoDeadline(id: ${_this.id}, name: ${_this.name}, timeSort: ${_this.timeSort}, courseId: ${_this.courseId}, courseName: ${_this.courseName}, moduleName: ${_this.moduleName}, eventType: ${_this.eventType}, description: ${_this.description}, url: ${_this.url}, overdue: ${_this.overdue})';
}


}

/// @nodoc
abstract mixin class $SdoDeadlineCopyWith<$Res>  {
  factory $SdoDeadlineCopyWith(SdoDeadline value, $Res Function(SdoDeadline) _then) = _$SdoDeadlineCopyWithImpl;
@useResult
$Res call({
 int id, String name, DateTime timeSort, int? courseId, String courseName, String moduleName, String eventType, String description, String url, bool overdue
});




}
/// @nodoc
class _$SdoDeadlineCopyWithImpl<$Res>
    implements $SdoDeadlineCopyWith<$Res> {
  _$SdoDeadlineCopyWithImpl(this._self, this._then);

  final SdoDeadline _self;
  final $Res Function(SdoDeadline) _then;

/// Create a copy of SdoDeadline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? timeSort = null,Object? courseId = freezed,Object? courseName = null,Object? moduleName = null,Object? eventType = null,Object? description = null,Object? url = null,Object? overdue = null,}) {
  return _then(SdoDeadline(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,timeSort: null == timeSort ? _self.timeSort : timeSort // ignore: cast_nullable_to_non_nullable
as DateTime,courseId: freezed == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int?,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,moduleName: null == moduleName ? _self.moduleName : moduleName // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoDeadline].
extension SdoDeadlinePatterns on SdoDeadline {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoDeadline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoDeadline() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoDeadline value)  $default,){
final _that = this;
switch (_that) {
case _SdoDeadline():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoDeadline value)?  $default,){
final _that = this;
switch (_that) {
case _SdoDeadline() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  DateTime timeSort,  int? courseId,  String courseName,  String moduleName,  String eventType,  String description,  String url,  bool overdue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoDeadline() when $default != null:
return $default(_that.id,_that.name,_that.timeSort,_that.courseId,_that.courseName,_that.moduleName,_that.eventType,_that.description,_that.url,_that.overdue);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  DateTime timeSort,  int? courseId,  String courseName,  String moduleName,  String eventType,  String description,  String url,  bool overdue)  $default,) {final _that = this;
switch (_that) {
case _SdoDeadline():
return $default(_that.id,_that.name,_that.timeSort,_that.courseId,_that.courseName,_that.moduleName,_that.eventType,_that.description,_that.url,_that.overdue);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  DateTime timeSort,  int? courseId,  String courseName,  String moduleName,  String eventType,  String description,  String url,  bool overdue)?  $default,) {final _that = this;
switch (_that) {
case _SdoDeadline() when $default != null:
return $default(_that.id,_that.name,_that.timeSort,_that.courseId,_that.courseName,_that.moduleName,_that.eventType,_that.description,_that.url,_that.overdue);case _:
  return null;

}
}

}

/// @nodoc


class _SdoDeadline implements SdoDeadline {
  const _SdoDeadline({required this.id, required this.name, required this.timeSort, this.courseId, this.courseName = '', this.moduleName = '', this.eventType = '', this.description = '', this.url = '', this.overdue = false});
  

@override final  int id;
@override final  String name;
@override final  DateTime timeSort;
@override final  int? courseId;
@override@JsonKey() final  String courseName;
@override@JsonKey() final  String moduleName;
@override@JsonKey() final  String eventType;
@override@JsonKey() final  String description;
@override@JsonKey() final  String url;
@override@JsonKey() final  bool overdue;

/// Create a copy of SdoDeadline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoDeadlineCopyWith<_SdoDeadline> get copyWith => __$SdoDeadlineCopyWithImpl<_SdoDeadline>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoDeadline&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.timeSort, timeSort) || other.timeSort == timeSort)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.moduleName, moduleName) || other.moduleName == moduleName)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.description, description) || other.description == description)&&(identical(other.url, url) || other.url == url)&&(identical(other.overdue, overdue) || other.overdue == overdue));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,timeSort,courseId,courseName,moduleName,eventType,description,url,overdue);
}

@override
String toString() {
    return 'SdoDeadline(id: $id, name: $name, timeSort: $timeSort, courseId: $courseId, courseName: $courseName, moduleName: $moduleName, eventType: $eventType, description: $description, url: $url, overdue: $overdue)';
}


}

/// @nodoc
abstract mixin class _$SdoDeadlineCopyWith<$Res> implements $SdoDeadlineCopyWith<$Res> {
  factory _$SdoDeadlineCopyWith(_SdoDeadline value, $Res Function(_SdoDeadline) _then) = __$SdoDeadlineCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, DateTime timeSort, int? courseId, String courseName, String moduleName, String eventType, String description, String url, bool overdue
});




}
/// @nodoc
class __$SdoDeadlineCopyWithImpl<$Res>
    implements _$SdoDeadlineCopyWith<$Res> {
  __$SdoDeadlineCopyWithImpl(this._self, this._then);

  final _SdoDeadline _self;
  final $Res Function(_SdoDeadline) _then;

/// Create a copy of SdoDeadline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? timeSort = null,Object? courseId = freezed,Object? courseName = null,Object? moduleName = null,Object? eventType = null,Object? description = null,Object? url = null,Object? overdue = null,}) {
  return _then(_SdoDeadline(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,timeSort: null == timeSort ? _self.timeSort : timeSort // ignore: cast_nullable_to_non_nullable
as DateTime,courseId: freezed == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int?,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,moduleName: null == moduleName ? _self.moduleName : moduleName // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,overdue: null == overdue ? _self.overdue : overdue // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SdoGradeItem {

 int get id; String get name; String get moduleName; String get itemType; String get gradeFormatted; double? get gradeRaw; double? get minGrade; double? get maxGrade; int? get courseModuleId;
/// Create a copy of SdoGradeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoGradeItemCopyWith<SdoGradeItem> get copyWith => _$SdoGradeItemCopyWithImpl<SdoGradeItem>(this as SdoGradeItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoGradeItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoGradeItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.moduleName, _this.moduleName) || other.moduleName == _this.moduleName)&&(identical(other.itemType, _this.itemType) || other.itemType == _this.itemType)&&(identical(other.gradeFormatted, _this.gradeFormatted) || other.gradeFormatted == _this.gradeFormatted)&&(identical(other.gradeRaw, _this.gradeRaw) || other.gradeRaw == _this.gradeRaw)&&(identical(other.minGrade, _this.minGrade) || other.minGrade == _this.minGrade)&&(identical(other.maxGrade, _this.maxGrade) || other.maxGrade == _this.maxGrade)&&(identical(other.courseModuleId, _this.courseModuleId) || other.courseModuleId == _this.courseModuleId));
}


@override
int get hashCode {
  final _this = this as SdoGradeItem;
  return Object.hash(runtimeType,_this.id,_this.name,_this.moduleName,_this.itemType,_this.gradeFormatted,_this.gradeRaw,_this.minGrade,_this.maxGrade,_this.courseModuleId);
}

@override
String toString() {
  final _this = this as SdoGradeItem;
  return 'SdoGradeItem(id: ${_this.id}, name: ${_this.name}, moduleName: ${_this.moduleName}, itemType: ${_this.itemType}, gradeFormatted: ${_this.gradeFormatted}, gradeRaw: ${_this.gradeRaw}, minGrade: ${_this.minGrade}, maxGrade: ${_this.maxGrade}, courseModuleId: ${_this.courseModuleId})';
}


}

/// @nodoc
abstract mixin class $SdoGradeItemCopyWith<$Res>  {
  factory $SdoGradeItemCopyWith(SdoGradeItem value, $Res Function(SdoGradeItem) _then) = _$SdoGradeItemCopyWithImpl;
@useResult
$Res call({
 int id, String name, String moduleName, String itemType, String gradeFormatted, double? gradeRaw, double? minGrade, double? maxGrade, int? courseModuleId
});




}
/// @nodoc
class _$SdoGradeItemCopyWithImpl<$Res>
    implements $SdoGradeItemCopyWith<$Res> {
  _$SdoGradeItemCopyWithImpl(this._self, this._then);

  final SdoGradeItem _self;
  final $Res Function(SdoGradeItem) _then;

/// Create a copy of SdoGradeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? moduleName = null,Object? itemType = null,Object? gradeFormatted = null,Object? gradeRaw = freezed,Object? minGrade = freezed,Object? maxGrade = freezed,Object? courseModuleId = freezed,}) {
  return _then(SdoGradeItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,moduleName: null == moduleName ? _self.moduleName : moduleName // ignore: cast_nullable_to_non_nullable
as String,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as String,gradeFormatted: null == gradeFormatted ? _self.gradeFormatted : gradeFormatted // ignore: cast_nullable_to_non_nullable
as String,gradeRaw: freezed == gradeRaw ? _self.gradeRaw : gradeRaw // ignore: cast_nullable_to_non_nullable
as double?,minGrade: freezed == minGrade ? _self.minGrade : minGrade // ignore: cast_nullable_to_non_nullable
as double?,maxGrade: freezed == maxGrade ? _self.maxGrade : maxGrade // ignore: cast_nullable_to_non_nullable
as double?,courseModuleId: freezed == courseModuleId ? _self.courseModuleId : courseModuleId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoGradeItem].
extension SdoGradeItemPatterns on SdoGradeItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoGradeItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoGradeItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoGradeItem value)  $default,){
final _that = this;
switch (_that) {
case _SdoGradeItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoGradeItem value)?  $default,){
final _that = this;
switch (_that) {
case _SdoGradeItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String moduleName,  String itemType,  String gradeFormatted,  double? gradeRaw,  double? minGrade,  double? maxGrade,  int? courseModuleId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoGradeItem() when $default != null:
return $default(_that.id,_that.name,_that.moduleName,_that.itemType,_that.gradeFormatted,_that.gradeRaw,_that.minGrade,_that.maxGrade,_that.courseModuleId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String moduleName,  String itemType,  String gradeFormatted,  double? gradeRaw,  double? minGrade,  double? maxGrade,  int? courseModuleId)  $default,) {final _that = this;
switch (_that) {
case _SdoGradeItem():
return $default(_that.id,_that.name,_that.moduleName,_that.itemType,_that.gradeFormatted,_that.gradeRaw,_that.minGrade,_that.maxGrade,_that.courseModuleId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String moduleName,  String itemType,  String gradeFormatted,  double? gradeRaw,  double? minGrade,  double? maxGrade,  int? courseModuleId)?  $default,) {final _that = this;
switch (_that) {
case _SdoGradeItem() when $default != null:
return $default(_that.id,_that.name,_that.moduleName,_that.itemType,_that.gradeFormatted,_that.gradeRaw,_that.minGrade,_that.maxGrade,_that.courseModuleId);case _:
  return null;

}
}

}

/// @nodoc


class _SdoGradeItem implements SdoGradeItem {
  const _SdoGradeItem({required this.id, this.name = '', this.moduleName = '', this.itemType = '', this.gradeFormatted = '', this.gradeRaw, this.minGrade, this.maxGrade, this.courseModuleId});
  

@override final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String moduleName;
@override@JsonKey() final  String itemType;
@override@JsonKey() final  String gradeFormatted;
@override final  double? gradeRaw;
@override final  double? minGrade;
@override final  double? maxGrade;
@override final  int? courseModuleId;

/// Create a copy of SdoGradeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoGradeItemCopyWith<_SdoGradeItem> get copyWith => __$SdoGradeItemCopyWithImpl<_SdoGradeItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoGradeItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.moduleName, moduleName) || other.moduleName == moduleName)&&(identical(other.itemType, itemType) || other.itemType == itemType)&&(identical(other.gradeFormatted, gradeFormatted) || other.gradeFormatted == gradeFormatted)&&(identical(other.gradeRaw, gradeRaw) || other.gradeRaw == gradeRaw)&&(identical(other.minGrade, minGrade) || other.minGrade == minGrade)&&(identical(other.maxGrade, maxGrade) || other.maxGrade == maxGrade)&&(identical(other.courseModuleId, courseModuleId) || other.courseModuleId == courseModuleId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,moduleName,itemType,gradeFormatted,gradeRaw,minGrade,maxGrade,courseModuleId);
}

@override
String toString() {
    return 'SdoGradeItem(id: $id, name: $name, moduleName: $moduleName, itemType: $itemType, gradeFormatted: $gradeFormatted, gradeRaw: $gradeRaw, minGrade: $minGrade, maxGrade: $maxGrade, courseModuleId: $courseModuleId)';
}


}

/// @nodoc
abstract mixin class _$SdoGradeItemCopyWith<$Res> implements $SdoGradeItemCopyWith<$Res> {
  factory _$SdoGradeItemCopyWith(_SdoGradeItem value, $Res Function(_SdoGradeItem) _then) = __$SdoGradeItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String moduleName, String itemType, String gradeFormatted, double? gradeRaw, double? minGrade, double? maxGrade, int? courseModuleId
});




}
/// @nodoc
class __$SdoGradeItemCopyWithImpl<$Res>
    implements _$SdoGradeItemCopyWith<$Res> {
  __$SdoGradeItemCopyWithImpl(this._self, this._then);

  final _SdoGradeItem _self;
  final $Res Function(_SdoGradeItem) _then;

/// Create a copy of SdoGradeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? moduleName = null,Object? itemType = null,Object? gradeFormatted = null,Object? gradeRaw = freezed,Object? minGrade = freezed,Object? maxGrade = freezed,Object? courseModuleId = freezed,}) {
  return _then(_SdoGradeItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,moduleName: null == moduleName ? _self.moduleName : moduleName // ignore: cast_nullable_to_non_nullable
as String,itemType: null == itemType ? _self.itemType : itemType // ignore: cast_nullable_to_non_nullable
as String,gradeFormatted: null == gradeFormatted ? _self.gradeFormatted : gradeFormatted // ignore: cast_nullable_to_non_nullable
as String,gradeRaw: freezed == gradeRaw ? _self.gradeRaw : gradeRaw // ignore: cast_nullable_to_non_nullable
as double?,minGrade: freezed == minGrade ? _self.minGrade : minGrade // ignore: cast_nullable_to_non_nullable
as double?,maxGrade: freezed == maxGrade ? _self.maxGrade : maxGrade // ignore: cast_nullable_to_non_nullable
as double?,courseModuleId: freezed == courseModuleId ? _self.courseModuleId : courseModuleId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$SdoCourseGrades {

 int get courseId; String get courseName; String get courseGradeFormatted; List<SdoGradeItem> get items;
/// Create a copy of SdoCourseGrades
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoCourseGradesCopyWith<SdoCourseGrades> get copyWith => _$SdoCourseGradesCopyWithImpl<SdoCourseGrades>(this as SdoCourseGrades, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoCourseGrades;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoCourseGrades&&(identical(other.courseId, _this.courseId) || other.courseId == _this.courseId)&&(identical(other.courseName, _this.courseName) || other.courseName == _this.courseName)&&(identical(other.courseGradeFormatted, _this.courseGradeFormatted) || other.courseGradeFormatted == _this.courseGradeFormatted)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as SdoCourseGrades;
  return Object.hash(runtimeType,_this.courseId,_this.courseName,_this.courseGradeFormatted,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as SdoCourseGrades;
  return 'SdoCourseGrades(courseId: ${_this.courseId}, courseName: ${_this.courseName}, courseGradeFormatted: ${_this.courseGradeFormatted}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $SdoCourseGradesCopyWith<$Res>  {
  factory $SdoCourseGradesCopyWith(SdoCourseGrades value, $Res Function(SdoCourseGrades) _then) = _$SdoCourseGradesCopyWithImpl;
@useResult
$Res call({
 int courseId, String courseName, String courseGradeFormatted, List<SdoGradeItem> items
});




}
/// @nodoc
class _$SdoCourseGradesCopyWithImpl<$Res>
    implements $SdoCourseGradesCopyWith<$Res> {
  _$SdoCourseGradesCopyWithImpl(this._self, this._then);

  final SdoCourseGrades _self;
  final $Res Function(SdoCourseGrades) _then;

/// Create a copy of SdoCourseGrades
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseId = null,Object? courseName = null,Object? courseGradeFormatted = null,Object? items = null,}) {
  return _then(SdoCourseGrades(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,courseGradeFormatted: null == courseGradeFormatted ? _self.courseGradeFormatted : courseGradeFormatted // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SdoGradeItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoCourseGrades].
extension SdoCourseGradesPatterns on SdoCourseGrades {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoCourseGrades value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoCourseGrades() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoCourseGrades value)  $default,){
final _that = this;
switch (_that) {
case _SdoCourseGrades():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoCourseGrades value)?  $default,){
final _that = this;
switch (_that) {
case _SdoCourseGrades() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int courseId,  String courseName,  String courseGradeFormatted,  List<SdoGradeItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoCourseGrades() when $default != null:
return $default(_that.courseId,_that.courseName,_that.courseGradeFormatted,_that.items);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int courseId,  String courseName,  String courseGradeFormatted,  List<SdoGradeItem> items)  $default,) {final _that = this;
switch (_that) {
case _SdoCourseGrades():
return $default(_that.courseId,_that.courseName,_that.courseGradeFormatted,_that.items);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int courseId,  String courseName,  String courseGradeFormatted,  List<SdoGradeItem> items)?  $default,) {final _that = this;
switch (_that) {
case _SdoCourseGrades() when $default != null:
return $default(_that.courseId,_that.courseName,_that.courseGradeFormatted,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _SdoCourseGrades implements SdoCourseGrades {
  const _SdoCourseGrades({required this.courseId, this.courseName = '', this.courseGradeFormatted = '',  List<SdoGradeItem> items = const <SdoGradeItem>[]}): _items = items;
  

@override final  int courseId;
@override@JsonKey() final  String courseName;
@override@JsonKey() final  String courseGradeFormatted;
 final  List<SdoGradeItem> _items;
@override@JsonKey() List<SdoGradeItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SdoCourseGrades
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoCourseGradesCopyWith<_SdoCourseGrades> get copyWith => __$SdoCourseGradesCopyWithImpl<_SdoCourseGrades>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoCourseGrades&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.courseGradeFormatted, courseGradeFormatted) || other.courseGradeFormatted == courseGradeFormatted)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,courseId,courseName,courseGradeFormatted,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'SdoCourseGrades(courseId: $courseId, courseName: $courseName, courseGradeFormatted: $courseGradeFormatted, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SdoCourseGradesCopyWith<$Res> implements $SdoCourseGradesCopyWith<$Res> {
  factory _$SdoCourseGradesCopyWith(_SdoCourseGrades value, $Res Function(_SdoCourseGrades) _then) = __$SdoCourseGradesCopyWithImpl;
@override @useResult
$Res call({
 int courseId, String courseName, String courseGradeFormatted, List<SdoGradeItem> items
});




}
/// @nodoc
class __$SdoCourseGradesCopyWithImpl<$Res>
    implements _$SdoCourseGradesCopyWith<$Res> {
  __$SdoCourseGradesCopyWithImpl(this._self, this._then);

  final _SdoCourseGrades _self;
  final $Res Function(_SdoCourseGrades) _then;

/// Create a copy of SdoCourseGrades
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseId = null,Object? courseName = null,Object? courseGradeFormatted = null,Object? items = null,}) {
  return _then(_SdoCourseGrades(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,courseGradeFormatted: null == courseGradeFormatted ? _self.courseGradeFormatted : courseGradeFormatted // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SdoGradeItem>,
  ));
}


}

/// @nodoc
mixin _$SdoModule {

 int get id; String get name; String get modName; String get url; String get description; bool get visible;
/// Create a copy of SdoModule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoModuleCopyWith<SdoModule> get copyWith => _$SdoModuleCopyWithImpl<SdoModule>(this as SdoModule, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoModule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoModule&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.modName, _this.modName) || other.modName == _this.modName)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.visible, _this.visible) || other.visible == _this.visible));
}


@override
int get hashCode {
  final _this = this as SdoModule;
  return Object.hash(runtimeType,_this.id,_this.name,_this.modName,_this.url,_this.description,_this.visible);
}

@override
String toString() {
  final _this = this as SdoModule;
  return 'SdoModule(id: ${_this.id}, name: ${_this.name}, modName: ${_this.modName}, url: ${_this.url}, description: ${_this.description}, visible: ${_this.visible})';
}


}

/// @nodoc
abstract mixin class $SdoModuleCopyWith<$Res>  {
  factory $SdoModuleCopyWith(SdoModule value, $Res Function(SdoModule) _then) = _$SdoModuleCopyWithImpl;
@useResult
$Res call({
 int id, String name, String modName, String url, String description, bool visible
});




}
/// @nodoc
class _$SdoModuleCopyWithImpl<$Res>
    implements $SdoModuleCopyWith<$Res> {
  _$SdoModuleCopyWithImpl(this._self, this._then);

  final SdoModule _self;
  final $Res Function(SdoModule) _then;

/// Create a copy of SdoModule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? modName = null,Object? url = null,Object? description = null,Object? visible = null,}) {
  return _then(SdoModule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,modName: null == modName ? _self.modName : modName // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoModule].
extension SdoModulePatterns on SdoModule {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoModule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoModule() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoModule value)  $default,){
final _that = this;
switch (_that) {
case _SdoModule():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoModule value)?  $default,){
final _that = this;
switch (_that) {
case _SdoModule() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String modName,  String url,  String description,  bool visible)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoModule() when $default != null:
return $default(_that.id,_that.name,_that.modName,_that.url,_that.description,_that.visible);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String modName,  String url,  String description,  bool visible)  $default,) {final _that = this;
switch (_that) {
case _SdoModule():
return $default(_that.id,_that.name,_that.modName,_that.url,_that.description,_that.visible);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String modName,  String url,  String description,  bool visible)?  $default,) {final _that = this;
switch (_that) {
case _SdoModule() when $default != null:
return $default(_that.id,_that.name,_that.modName,_that.url,_that.description,_that.visible);case _:
  return null;

}
}

}

/// @nodoc


class _SdoModule implements SdoModule {
  const _SdoModule({required this.id, required this.name, this.modName = '', this.url = '', this.description = '', this.visible = true});
  

@override final  int id;
@override final  String name;
@override@JsonKey() final  String modName;
@override@JsonKey() final  String url;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool visible;

/// Create a copy of SdoModule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoModuleCopyWith<_SdoModule> get copyWith => __$SdoModuleCopyWithImpl<_SdoModule>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoModule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.modName, modName) || other.modName == modName)&&(identical(other.url, url) || other.url == url)&&(identical(other.description, description) || other.description == description)&&(identical(other.visible, visible) || other.visible == visible));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,modName,url,description,visible);
}

@override
String toString() {
    return 'SdoModule(id: $id, name: $name, modName: $modName, url: $url, description: $description, visible: $visible)';
}


}

/// @nodoc
abstract mixin class _$SdoModuleCopyWith<$Res> implements $SdoModuleCopyWith<$Res> {
  factory _$SdoModuleCopyWith(_SdoModule value, $Res Function(_SdoModule) _then) = __$SdoModuleCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String modName, String url, String description, bool visible
});




}
/// @nodoc
class __$SdoModuleCopyWithImpl<$Res>
    implements _$SdoModuleCopyWith<$Res> {
  __$SdoModuleCopyWithImpl(this._self, this._then);

  final _SdoModule _self;
  final $Res Function(_SdoModule) _then;

/// Create a copy of SdoModule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? modName = null,Object? url = null,Object? description = null,Object? visible = null,}) {
  return _then(_SdoModule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,modName: null == modName ? _self.modName : modName // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SdoSection {

 int get id; String get name; String get summary; List<SdoModule> get modules;
/// Create a copy of SdoSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoSectionCopyWith<SdoSection> get copyWith => _$SdoSectionCopyWithImpl<SdoSection>(this as SdoSection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoSection&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.modules, _this.modules));
}


@override
int get hashCode {
  final _this = this as SdoSection;
  return Object.hash(runtimeType,_this.id,_this.name,_this.summary,const DeepCollectionEquality().hash(_this.modules));
}

@override
String toString() {
  final _this = this as SdoSection;
  return 'SdoSection(id: ${_this.id}, name: ${_this.name}, summary: ${_this.summary}, modules: ${_this.modules})';
}


}

/// @nodoc
abstract mixin class $SdoSectionCopyWith<$Res>  {
  factory $SdoSectionCopyWith(SdoSection value, $Res Function(SdoSection) _then) = _$SdoSectionCopyWithImpl;
@useResult
$Res call({
 int id, String name, String summary, List<SdoModule> modules
});




}
/// @nodoc
class _$SdoSectionCopyWithImpl<$Res>
    implements $SdoSectionCopyWith<$Res> {
  _$SdoSectionCopyWithImpl(this._self, this._then);

  final SdoSection _self;
  final $Res Function(SdoSection) _then;

/// Create a copy of SdoSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? summary = null,Object? modules = null,}) {
  return _then(SdoSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,modules: null == modules ? _self.modules : modules // ignore: cast_nullable_to_non_nullable
as List<SdoModule>,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoSection].
extension SdoSectionPatterns on SdoSection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoSection() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoSection value)  $default,){
final _that = this;
switch (_that) {
case _SdoSection():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoSection value)?  $default,){
final _that = this;
switch (_that) {
case _SdoSection() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String summary,  List<SdoModule> modules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoSection() when $default != null:
return $default(_that.id,_that.name,_that.summary,_that.modules);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String summary,  List<SdoModule> modules)  $default,) {final _that = this;
switch (_that) {
case _SdoSection():
return $default(_that.id,_that.name,_that.summary,_that.modules);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String summary,  List<SdoModule> modules)?  $default,) {final _that = this;
switch (_that) {
case _SdoSection() when $default != null:
return $default(_that.id,_that.name,_that.summary,_that.modules);case _:
  return null;

}
}

}

/// @nodoc


class _SdoSection implements SdoSection {
  const _SdoSection({required this.id, this.name = '', this.summary = '',  List<SdoModule> modules = const <SdoModule>[]}): _modules = modules;
  

@override final  int id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String summary;
 final  List<SdoModule> _modules;
@override@JsonKey() List<SdoModule> get modules {
  if (_modules is EqualUnmodifiableListView) return _modules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modules);
}


/// Create a copy of SdoSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoSectionCopyWith<_SdoSection> get copyWith => __$SdoSectionCopyWithImpl<_SdoSection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoSection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.modules, _modules));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,summary,const DeepCollectionEquality().hash(_modules));
}

@override
String toString() {
    return 'SdoSection(id: $id, name: $name, summary: $summary, modules: $modules)';
}


}

/// @nodoc
abstract mixin class _$SdoSectionCopyWith<$Res> implements $SdoSectionCopyWith<$Res> {
  factory _$SdoSectionCopyWith(_SdoSection value, $Res Function(_SdoSection) _then) = __$SdoSectionCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String summary, List<SdoModule> modules
});




}
/// @nodoc
class __$SdoSectionCopyWithImpl<$Res>
    implements _$SdoSectionCopyWith<$Res> {
  __$SdoSectionCopyWithImpl(this._self, this._then);

  final _SdoSection _self;
  final $Res Function(_SdoSection) _then;

/// Create a copy of SdoSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? summary = null,Object? modules = null,}) {
  return _then(_SdoSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,modules: null == modules ? _self._modules : modules // ignore: cast_nullable_to_non_nullable
as List<SdoModule>,
  ));
}


}

// dart format on
