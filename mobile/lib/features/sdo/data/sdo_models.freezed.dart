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
mixin _$SdoCategory {

 int get id; String get name; int? get parent; int get courseCount; String get idNumber;
/// Create a copy of SdoCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoCategoryCopyWith<SdoCategory> get copyWith => _$SdoCategoryCopyWithImpl<SdoCategory>(this as SdoCategory, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoCategory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoCategory&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.parent, _this.parent) || other.parent == _this.parent)&&(identical(other.courseCount, _this.courseCount) || other.courseCount == _this.courseCount)&&(identical(other.idNumber, _this.idNumber) || other.idNumber == _this.idNumber));
}


@override
int get hashCode {
  final _this = this as SdoCategory;
  return Object.hash(runtimeType,_this.id,_this.name,_this.parent,_this.courseCount,_this.idNumber);
}

@override
String toString() {
  final _this = this as SdoCategory;
  return 'SdoCategory(id: ${_this.id}, name: ${_this.name}, parent: ${_this.parent}, courseCount: ${_this.courseCount}, idNumber: ${_this.idNumber})';
}


}

/// @nodoc
abstract mixin class $SdoCategoryCopyWith<$Res>  {
  factory $SdoCategoryCopyWith(SdoCategory value, $Res Function(SdoCategory) _then) = _$SdoCategoryCopyWithImpl;
@useResult
$Res call({
 int id, String name, int? parent, int courseCount, String idNumber
});




}
/// @nodoc
class _$SdoCategoryCopyWithImpl<$Res>
    implements $SdoCategoryCopyWith<$Res> {
  _$SdoCategoryCopyWithImpl(this._self, this._then);

  final SdoCategory _self;
  final $Res Function(SdoCategory) _then;

/// Create a copy of SdoCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? parent = freezed,Object? courseCount = null,Object? idNumber = null,}) {
  return _then(SdoCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as int?,courseCount: null == courseCount ? _self.courseCount : courseCount // ignore: cast_nullable_to_non_nullable
as int,idNumber: null == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoCategory].
extension SdoCategoryPatterns on SdoCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoCategory value)  $default,){
final _that = this;
switch (_that) {
case _SdoCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoCategory value)?  $default,){
final _that = this;
switch (_that) {
case _SdoCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int? parent,  int courseCount,  String idNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoCategory() when $default != null:
return $default(_that.id,_that.name,_that.parent,_that.courseCount,_that.idNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int? parent,  int courseCount,  String idNumber)  $default,) {final _that = this;
switch (_that) {
case _SdoCategory():
return $default(_that.id,_that.name,_that.parent,_that.courseCount,_that.idNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int? parent,  int courseCount,  String idNumber)?  $default,) {final _that = this;
switch (_that) {
case _SdoCategory() when $default != null:
return $default(_that.id,_that.name,_that.parent,_that.courseCount,_that.idNumber);case _:
  return null;

}
}

}

/// @nodoc


class _SdoCategory implements SdoCategory {
  const _SdoCategory({required this.id, this.name = '', this.parent, this.courseCount = 0, this.idNumber = ''});
  

@override final  int id;
@override@JsonKey() final  String name;
@override final  int? parent;
@override@JsonKey() final  int courseCount;
@override@JsonKey() final  String idNumber;

/// Create a copy of SdoCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoCategoryCopyWith<_SdoCategory> get copyWith => __$SdoCategoryCopyWithImpl<_SdoCategory>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.courseCount, courseCount) || other.courseCount == courseCount)&&(identical(other.idNumber, idNumber) || other.idNumber == idNumber));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,parent,courseCount,idNumber);
}

@override
String toString() {
    return 'SdoCategory(id: $id, name: $name, parent: $parent, courseCount: $courseCount, idNumber: $idNumber)';
}


}

/// @nodoc
abstract mixin class _$SdoCategoryCopyWith<$Res> implements $SdoCategoryCopyWith<$Res> {
  factory _$SdoCategoryCopyWith(_SdoCategory value, $Res Function(_SdoCategory) _then) = __$SdoCategoryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int? parent, int courseCount, String idNumber
});




}
/// @nodoc
class __$SdoCategoryCopyWithImpl<$Res>
    implements _$SdoCategoryCopyWith<$Res> {
  __$SdoCategoryCopyWithImpl(this._self, this._then);

  final _SdoCategory _self;
  final $Res Function(_SdoCategory) _then;

/// Create a copy of SdoCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? parent = freezed,Object? courseCount = null,Object? idNumber = null,}) {
  return _then(_SdoCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as int?,courseCount: null == courseCount ? _self.courseCount : courseCount // ignore: cast_nullable_to_non_nullable
as int,idNumber: null == idNumber ? _self.idNumber : idNumber // ignore: cast_nullable_to_non_nullable
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
mixin _$SdoFile {

 String get type; String get fileName; String get fileUrl; String get mimeType; int get fileSize; DateTime? get timeModified; List<int> get fileBytes;
/// Create a copy of SdoFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoFileCopyWith<SdoFile> get copyWith => _$SdoFileCopyWithImpl<SdoFile>(this as SdoFile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoFile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoFile&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.fileUrl, _this.fileUrl) || other.fileUrl == _this.fileUrl)&&(identical(other.mimeType, _this.mimeType) || other.mimeType == _this.mimeType)&&(identical(other.fileSize, _this.fileSize) || other.fileSize == _this.fileSize)&&(identical(other.timeModified, _this.timeModified) || other.timeModified == _this.timeModified)&&const DeepCollectionEquality().equals(other.fileBytes, _this.fileBytes));
}


@override
int get hashCode {
  final _this = this as SdoFile;
  return Object.hash(runtimeType,_this.type,_this.fileName,_this.fileUrl,_this.mimeType,_this.fileSize,_this.timeModified,const DeepCollectionEquality().hash(_this.fileBytes));
}

@override
String toString() {
  final _this = this as SdoFile;
  return 'SdoFile(type: ${_this.type}, fileName: ${_this.fileName}, fileUrl: ${_this.fileUrl}, mimeType: ${_this.mimeType}, fileSize: ${_this.fileSize}, timeModified: ${_this.timeModified}, fileBytes: ${_this.fileBytes})';
}


}

/// @nodoc
abstract mixin class $SdoFileCopyWith<$Res>  {
  factory $SdoFileCopyWith(SdoFile value, $Res Function(SdoFile) _then) = _$SdoFileCopyWithImpl;
@useResult
$Res call({
 String type, String fileName, String fileUrl, String mimeType, int fileSize, DateTime? timeModified, List<int> fileBytes
});




}
/// @nodoc
class _$SdoFileCopyWithImpl<$Res>
    implements $SdoFileCopyWith<$Res> {
  _$SdoFileCopyWithImpl(this._self, this._then);

  final SdoFile _self;
  final $Res Function(SdoFile) _then;

/// Create a copy of SdoFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? fileName = null,Object? fileUrl = null,Object? mimeType = null,Object? fileSize = null,Object? timeModified = freezed,Object? fileBytes = null,}) {
  return _then(SdoFile(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,timeModified: freezed == timeModified ? _self.timeModified : timeModified // ignore: cast_nullable_to_non_nullable
as DateTime?,fileBytes: null == fileBytes ? _self.fileBytes : fileBytes // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoFile].
extension SdoFilePatterns on SdoFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoFile value)  $default,){
final _that = this;
switch (_that) {
case _SdoFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoFile value)?  $default,){
final _that = this;
switch (_that) {
case _SdoFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String fileName,  String fileUrl,  String mimeType,  int fileSize,  DateTime? timeModified,  List<int> fileBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoFile() when $default != null:
return $default(_that.type,_that.fileName,_that.fileUrl,_that.mimeType,_that.fileSize,_that.timeModified,_that.fileBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String fileName,  String fileUrl,  String mimeType,  int fileSize,  DateTime? timeModified,  List<int> fileBytes)  $default,) {final _that = this;
switch (_that) {
case _SdoFile():
return $default(_that.type,_that.fileName,_that.fileUrl,_that.mimeType,_that.fileSize,_that.timeModified,_that.fileBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String fileName,  String fileUrl,  String mimeType,  int fileSize,  DateTime? timeModified,  List<int> fileBytes)?  $default,) {final _that = this;
switch (_that) {
case _SdoFile() when $default != null:
return $default(_that.type,_that.fileName,_that.fileUrl,_that.mimeType,_that.fileSize,_that.timeModified,_that.fileBytes);case _:
  return null;

}
}

}

/// @nodoc


class _SdoFile implements SdoFile {
  const _SdoFile({this.type = 'file', this.fileName = '', this.fileUrl = '', this.mimeType = '', this.fileSize = 0, this.timeModified,  List<int> fileBytes = const <int>[]}): _fileBytes = fileBytes;
  

@override@JsonKey() final  String type;
@override@JsonKey() final  String fileName;
@override@JsonKey() final  String fileUrl;
@override@JsonKey() final  String mimeType;
@override@JsonKey() final  int fileSize;
@override final  DateTime? timeModified;
 final  List<int> _fileBytes;
@override@JsonKey() List<int> get fileBytes {
  if (_fileBytes is EqualUnmodifiableListView) return _fileBytes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fileBytes);
}


/// Create a copy of SdoFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoFileCopyWith<_SdoFile> get copyWith => __$SdoFileCopyWithImpl<_SdoFile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoFile&&(identical(other.type, type) || other.type == type)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.timeModified, timeModified) || other.timeModified == timeModified)&&const DeepCollectionEquality().equals(other.fileBytes, _fileBytes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,fileName,fileUrl,mimeType,fileSize,timeModified,const DeepCollectionEquality().hash(_fileBytes));
}

@override
String toString() {
    return 'SdoFile(type: $type, fileName: $fileName, fileUrl: $fileUrl, mimeType: $mimeType, fileSize: $fileSize, timeModified: $timeModified, fileBytes: $fileBytes)';
}


}

/// @nodoc
abstract mixin class _$SdoFileCopyWith<$Res> implements $SdoFileCopyWith<$Res> {
  factory _$SdoFileCopyWith(_SdoFile value, $Res Function(_SdoFile) _then) = __$SdoFileCopyWithImpl;
@override @useResult
$Res call({
 String type, String fileName, String fileUrl, String mimeType, int fileSize, DateTime? timeModified, List<int> fileBytes
});




}
/// @nodoc
class __$SdoFileCopyWithImpl<$Res>
    implements _$SdoFileCopyWith<$Res> {
  __$SdoFileCopyWithImpl(this._self, this._then);

  final _SdoFile _self;
  final $Res Function(_SdoFile) _then;

/// Create a copy of SdoFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? fileName = null,Object? fileUrl = null,Object? mimeType = null,Object? fileSize = null,Object? timeModified = freezed,Object? fileBytes = null,}) {
  return _then(_SdoFile(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileUrl: null == fileUrl ? _self.fileUrl : fileUrl // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,timeModified: freezed == timeModified ? _self.timeModified : timeModified // ignore: cast_nullable_to_non_nullable
as DateTime?,fileBytes: null == fileBytes ? _self._fileBytes : fileBytes // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc
mixin _$SdoModule {

 int get id; String get name; String get modName; int get instance; String get url; String get description; bool get visible; List<SdoFile> get contents;
/// Create a copy of SdoModule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoModuleCopyWith<SdoModule> get copyWith => _$SdoModuleCopyWithImpl<SdoModule>(this as SdoModule, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoModule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoModule&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.modName, _this.modName) || other.modName == _this.modName)&&(identical(other.instance, _this.instance) || other.instance == _this.instance)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.visible, _this.visible) || other.visible == _this.visible)&&const DeepCollectionEquality().equals(other.contents, _this.contents));
}


@override
int get hashCode {
  final _this = this as SdoModule;
  return Object.hash(runtimeType,_this.id,_this.name,_this.modName,_this.instance,_this.url,_this.description,_this.visible,const DeepCollectionEquality().hash(_this.contents));
}

@override
String toString() {
  final _this = this as SdoModule;
  return 'SdoModule(id: ${_this.id}, name: ${_this.name}, modName: ${_this.modName}, instance: ${_this.instance}, url: ${_this.url}, description: ${_this.description}, visible: ${_this.visible}, contents: ${_this.contents})';
}


}

/// @nodoc
abstract mixin class $SdoModuleCopyWith<$Res>  {
  factory $SdoModuleCopyWith(SdoModule value, $Res Function(SdoModule) _then) = _$SdoModuleCopyWithImpl;
@useResult
$Res call({
 int id, String name, String modName, int instance, String url, String description, bool visible, List<SdoFile> contents
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? modName = null,Object? instance = null,Object? url = null,Object? description = null,Object? visible = null,Object? contents = null,}) {
  return _then(SdoModule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,modName: null == modName ? _self.modName : modName // ignore: cast_nullable_to_non_nullable
as String,instance: null == instance ? _self.instance : instance // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as List<SdoFile>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String modName,  int instance,  String url,  String description,  bool visible,  List<SdoFile> contents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoModule() when $default != null:
return $default(_that.id,_that.name,_that.modName,_that.instance,_that.url,_that.description,_that.visible,_that.contents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String modName,  int instance,  String url,  String description,  bool visible,  List<SdoFile> contents)  $default,) {final _that = this;
switch (_that) {
case _SdoModule():
return $default(_that.id,_that.name,_that.modName,_that.instance,_that.url,_that.description,_that.visible,_that.contents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String modName,  int instance,  String url,  String description,  bool visible,  List<SdoFile> contents)?  $default,) {final _that = this;
switch (_that) {
case _SdoModule() when $default != null:
return $default(_that.id,_that.name,_that.modName,_that.instance,_that.url,_that.description,_that.visible,_that.contents);case _:
  return null;

}
}

}

/// @nodoc


class _SdoModule implements SdoModule {
  const _SdoModule({required this.id, required this.name, this.modName = '', this.instance = 0, this.url = '', this.description = '', this.visible = true,  List<SdoFile> contents = const <SdoFile>[]}): _contents = contents;
  

@override final  int id;
@override final  String name;
@override@JsonKey() final  String modName;
@override@JsonKey() final  int instance;
@override@JsonKey() final  String url;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool visible;
 final  List<SdoFile> _contents;
@override@JsonKey() List<SdoFile> get contents {
  if (_contents is EqualUnmodifiableListView) return _contents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contents);
}


/// Create a copy of SdoModule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoModuleCopyWith<_SdoModule> get copyWith => __$SdoModuleCopyWithImpl<_SdoModule>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoModule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.modName, modName) || other.modName == modName)&&(identical(other.instance, instance) || other.instance == instance)&&(identical(other.url, url) || other.url == url)&&(identical(other.description, description) || other.description == description)&&(identical(other.visible, visible) || other.visible == visible)&&const DeepCollectionEquality().equals(other.contents, _contents));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,modName,instance,url,description,visible,const DeepCollectionEquality().hash(_contents));
}

@override
String toString() {
    return 'SdoModule(id: $id, name: $name, modName: $modName, instance: $instance, url: $url, description: $description, visible: $visible, contents: $contents)';
}


}

/// @nodoc
abstract mixin class _$SdoModuleCopyWith<$Res> implements $SdoModuleCopyWith<$Res> {
  factory _$SdoModuleCopyWith(_SdoModule value, $Res Function(_SdoModule) _then) = __$SdoModuleCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String modName, int instance, String url, String description, bool visible, List<SdoFile> contents
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? modName = null,Object? instance = null,Object? url = null,Object? description = null,Object? visible = null,Object? contents = null,}) {
  return _then(_SdoModule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,modName: null == modName ? _self.modName : modName // ignore: cast_nullable_to_non_nullable
as String,instance: null == instance ? _self.instance : instance // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as bool,contents: null == contents ? _self._contents : contents // ignore: cast_nullable_to_non_nullable
as List<SdoFile>,
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

/// @nodoc
mixin _$SdoAssignment {

 int get id; int get courseId; String get name; int get courseModuleId; String get description; DateTime? get dueDate; DateTime? get allowFromDate; DateTime? get cutoffDate; int get maxAttempts; bool get requiresText; bool get requiresFile; SdoSubmissionStatus get status; DateTime? get submittedAt; String get onlineText; List<SdoFile> get files;
/// Create a copy of SdoAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoAssignmentCopyWith<SdoAssignment> get copyWith => _$SdoAssignmentCopyWithImpl<SdoAssignment>(this as SdoAssignment, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoAssignment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoAssignment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.courseId, _this.courseId) || other.courseId == _this.courseId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.courseModuleId, _this.courseModuleId) || other.courseModuleId == _this.courseModuleId)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.allowFromDate, _this.allowFromDate) || other.allowFromDate == _this.allowFromDate)&&(identical(other.cutoffDate, _this.cutoffDate) || other.cutoffDate == _this.cutoffDate)&&(identical(other.maxAttempts, _this.maxAttempts) || other.maxAttempts == _this.maxAttempts)&&(identical(other.requiresText, _this.requiresText) || other.requiresText == _this.requiresText)&&(identical(other.requiresFile, _this.requiresFile) || other.requiresFile == _this.requiresFile)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.submittedAt, _this.submittedAt) || other.submittedAt == _this.submittedAt)&&(identical(other.onlineText, _this.onlineText) || other.onlineText == _this.onlineText)&&const DeepCollectionEquality().equals(other.files, _this.files));
}


@override
int get hashCode {
  final _this = this as SdoAssignment;
  return Object.hash(runtimeType,_this.id,_this.courseId,_this.name,_this.courseModuleId,_this.description,_this.dueDate,_this.allowFromDate,_this.cutoffDate,_this.maxAttempts,_this.requiresText,_this.requiresFile,_this.status,_this.submittedAt,_this.onlineText,const DeepCollectionEquality().hash(_this.files));
}

@override
String toString() {
  final _this = this as SdoAssignment;
  return 'SdoAssignment(id: ${_this.id}, courseId: ${_this.courseId}, name: ${_this.name}, courseModuleId: ${_this.courseModuleId}, description: ${_this.description}, dueDate: ${_this.dueDate}, allowFromDate: ${_this.allowFromDate}, cutoffDate: ${_this.cutoffDate}, maxAttempts: ${_this.maxAttempts}, requiresText: ${_this.requiresText}, requiresFile: ${_this.requiresFile}, status: ${_this.status}, submittedAt: ${_this.submittedAt}, onlineText: ${_this.onlineText}, files: ${_this.files})';
}


}

/// @nodoc
abstract mixin class $SdoAssignmentCopyWith<$Res>  {
  factory $SdoAssignmentCopyWith(SdoAssignment value, $Res Function(SdoAssignment) _then) = _$SdoAssignmentCopyWithImpl;
@useResult
$Res call({
 int id, int courseId, String name, int courseModuleId, String description, DateTime? dueDate, DateTime? allowFromDate, DateTime? cutoffDate, int maxAttempts, bool requiresText, bool requiresFile, SdoSubmissionStatus status, DateTime? submittedAt, String onlineText, List<SdoFile> files
});




}
/// @nodoc
class _$SdoAssignmentCopyWithImpl<$Res>
    implements $SdoAssignmentCopyWith<$Res> {
  _$SdoAssignmentCopyWithImpl(this._self, this._then);

  final SdoAssignment _self;
  final $Res Function(SdoAssignment) _then;

/// Create a copy of SdoAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? name = null,Object? courseModuleId = null,Object? description = null,Object? dueDate = freezed,Object? allowFromDate = freezed,Object? cutoffDate = freezed,Object? maxAttempts = null,Object? requiresText = null,Object? requiresFile = null,Object? status = null,Object? submittedAt = freezed,Object? onlineText = null,Object? files = null,}) {
  return _then(SdoAssignment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,courseModuleId: null == courseModuleId ? _self.courseModuleId : courseModuleId // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,allowFromDate: freezed == allowFromDate ? _self.allowFromDate : allowFromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cutoffDate: freezed == cutoffDate ? _self.cutoffDate : cutoffDate // ignore: cast_nullable_to_non_nullable
as DateTime?,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,requiresText: null == requiresText ? _self.requiresText : requiresText // ignore: cast_nullable_to_non_nullable
as bool,requiresFile: null == requiresFile ? _self.requiresFile : requiresFile // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SdoSubmissionStatus,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,onlineText: null == onlineText ? _self.onlineText : onlineText // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<SdoFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoAssignment].
extension SdoAssignmentPatterns on SdoAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoAssignment value)  $default,){
final _that = this;
switch (_that) {
case _SdoAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _SdoAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int courseId,  String name,  int courseModuleId,  String description,  DateTime? dueDate,  DateTime? allowFromDate,  DateTime? cutoffDate,  int maxAttempts,  bool requiresText,  bool requiresFile,  SdoSubmissionStatus status,  DateTime? submittedAt,  String onlineText,  List<SdoFile> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoAssignment() when $default != null:
return $default(_that.id,_that.courseId,_that.name,_that.courseModuleId,_that.description,_that.dueDate,_that.allowFromDate,_that.cutoffDate,_that.maxAttempts,_that.requiresText,_that.requiresFile,_that.status,_that.submittedAt,_that.onlineText,_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int courseId,  String name,  int courseModuleId,  String description,  DateTime? dueDate,  DateTime? allowFromDate,  DateTime? cutoffDate,  int maxAttempts,  bool requiresText,  bool requiresFile,  SdoSubmissionStatus status,  DateTime? submittedAt,  String onlineText,  List<SdoFile> files)  $default,) {final _that = this;
switch (_that) {
case _SdoAssignment():
return $default(_that.id,_that.courseId,_that.name,_that.courseModuleId,_that.description,_that.dueDate,_that.allowFromDate,_that.cutoffDate,_that.maxAttempts,_that.requiresText,_that.requiresFile,_that.status,_that.submittedAt,_that.onlineText,_that.files);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int courseId,  String name,  int courseModuleId,  String description,  DateTime? dueDate,  DateTime? allowFromDate,  DateTime? cutoffDate,  int maxAttempts,  bool requiresText,  bool requiresFile,  SdoSubmissionStatus status,  DateTime? submittedAt,  String onlineText,  List<SdoFile> files)?  $default,) {final _that = this;
switch (_that) {
case _SdoAssignment() when $default != null:
return $default(_that.id,_that.courseId,_that.name,_that.courseModuleId,_that.description,_that.dueDate,_that.allowFromDate,_that.cutoffDate,_that.maxAttempts,_that.requiresText,_that.requiresFile,_that.status,_that.submittedAt,_that.onlineText,_that.files);case _:
  return null;

}
}

}

/// @nodoc


class _SdoAssignment implements SdoAssignment {
  const _SdoAssignment({required this.id, required this.courseId, required this.name, this.courseModuleId = 0, this.description = '', this.dueDate, this.allowFromDate, this.cutoffDate, this.maxAttempts = 0, this.requiresText = false, this.requiresFile = false, this.status = SdoSubmissionStatus.newSubmission, this.submittedAt, this.onlineText = '',  List<SdoFile> files = const <SdoFile>[]}): _files = files;
  

@override final  int id;
@override final  int courseId;
@override final  String name;
@override@JsonKey() final  int courseModuleId;
@override@JsonKey() final  String description;
@override final  DateTime? dueDate;
@override final  DateTime? allowFromDate;
@override final  DateTime? cutoffDate;
@override@JsonKey() final  int maxAttempts;
@override@JsonKey() final  bool requiresText;
@override@JsonKey() final  bool requiresFile;
@override@JsonKey() final  SdoSubmissionStatus status;
@override final  DateTime? submittedAt;
@override@JsonKey() final  String onlineText;
 final  List<SdoFile> _files;
@override@JsonKey() List<SdoFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of SdoAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoAssignmentCopyWith<_SdoAssignment> get copyWith => __$SdoAssignmentCopyWithImpl<_SdoAssignment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoAssignment&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.name, name) || other.name == name)&&(identical(other.courseModuleId, courseModuleId) || other.courseModuleId == courseModuleId)&&(identical(other.description, description) || other.description == description)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.allowFromDate, allowFromDate) || other.allowFromDate == allowFromDate)&&(identical(other.cutoffDate, cutoffDate) || other.cutoffDate == cutoffDate)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.requiresText, requiresText) || other.requiresText == requiresText)&&(identical(other.requiresFile, requiresFile) || other.requiresFile == requiresFile)&&(identical(other.status, status) || other.status == status)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.onlineText, onlineText) || other.onlineText == onlineText)&&const DeepCollectionEquality().equals(other.files, _files));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,courseId,name,courseModuleId,description,dueDate,allowFromDate,cutoffDate,maxAttempts,requiresText,requiresFile,status,submittedAt,onlineText,const DeepCollectionEquality().hash(_files));
}

@override
String toString() {
    return 'SdoAssignment(id: $id, courseId: $courseId, name: $name, courseModuleId: $courseModuleId, description: $description, dueDate: $dueDate, allowFromDate: $allowFromDate, cutoffDate: $cutoffDate, maxAttempts: $maxAttempts, requiresText: $requiresText, requiresFile: $requiresFile, status: $status, submittedAt: $submittedAt, onlineText: $onlineText, files: $files)';
}


}

/// @nodoc
abstract mixin class _$SdoAssignmentCopyWith<$Res> implements $SdoAssignmentCopyWith<$Res> {
  factory _$SdoAssignmentCopyWith(_SdoAssignment value, $Res Function(_SdoAssignment) _then) = __$SdoAssignmentCopyWithImpl;
@override @useResult
$Res call({
 int id, int courseId, String name, int courseModuleId, String description, DateTime? dueDate, DateTime? allowFromDate, DateTime? cutoffDate, int maxAttempts, bool requiresText, bool requiresFile, SdoSubmissionStatus status, DateTime? submittedAt, String onlineText, List<SdoFile> files
});




}
/// @nodoc
class __$SdoAssignmentCopyWithImpl<$Res>
    implements _$SdoAssignmentCopyWith<$Res> {
  __$SdoAssignmentCopyWithImpl(this._self, this._then);

  final _SdoAssignment _self;
  final $Res Function(_SdoAssignment) _then;

/// Create a copy of SdoAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? name = null,Object? courseModuleId = null,Object? description = null,Object? dueDate = freezed,Object? allowFromDate = freezed,Object? cutoffDate = freezed,Object? maxAttempts = null,Object? requiresText = null,Object? requiresFile = null,Object? status = null,Object? submittedAt = freezed,Object? onlineText = null,Object? files = null,}) {
  return _then(_SdoAssignment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,courseModuleId: null == courseModuleId ? _self.courseModuleId : courseModuleId // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,allowFromDate: freezed == allowFromDate ? _self.allowFromDate : allowFromDate // ignore: cast_nullable_to_non_nullable
as DateTime?,cutoffDate: freezed == cutoffDate ? _self.cutoffDate : cutoffDate // ignore: cast_nullable_to_non_nullable
as DateTime?,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,requiresText: null == requiresText ? _self.requiresText : requiresText // ignore: cast_nullable_to_non_nullable
as bool,requiresFile: null == requiresFile ? _self.requiresFile : requiresFile // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SdoSubmissionStatus,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,onlineText: null == onlineText ? _self.onlineText : onlineText // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<SdoFile>,
  ));
}


}

/// @nodoc
mixin _$SdoQuiz {

 int get id; int get courseId; String get name; int get courseModuleId; String get intro; DateTime? get timeOpen; DateTime? get timeClose; int get timeLimit; int get maxAttempts; int get gradeMethod; bool get hasQuestions;
/// Create a copy of SdoQuiz
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoQuizCopyWith<SdoQuiz> get copyWith => _$SdoQuizCopyWithImpl<SdoQuiz>(this as SdoQuiz, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoQuiz;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoQuiz&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.courseId, _this.courseId) || other.courseId == _this.courseId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.courseModuleId, _this.courseModuleId) || other.courseModuleId == _this.courseModuleId)&&(identical(other.intro, _this.intro) || other.intro == _this.intro)&&(identical(other.timeOpen, _this.timeOpen) || other.timeOpen == _this.timeOpen)&&(identical(other.timeClose, _this.timeClose) || other.timeClose == _this.timeClose)&&(identical(other.timeLimit, _this.timeLimit) || other.timeLimit == _this.timeLimit)&&(identical(other.maxAttempts, _this.maxAttempts) || other.maxAttempts == _this.maxAttempts)&&(identical(other.gradeMethod, _this.gradeMethod) || other.gradeMethod == _this.gradeMethod)&&(identical(other.hasQuestions, _this.hasQuestions) || other.hasQuestions == _this.hasQuestions));
}


@override
int get hashCode {
  final _this = this as SdoQuiz;
  return Object.hash(runtimeType,_this.id,_this.courseId,_this.name,_this.courseModuleId,_this.intro,_this.timeOpen,_this.timeClose,_this.timeLimit,_this.maxAttempts,_this.gradeMethod,_this.hasQuestions);
}

@override
String toString() {
  final _this = this as SdoQuiz;
  return 'SdoQuiz(id: ${_this.id}, courseId: ${_this.courseId}, name: ${_this.name}, courseModuleId: ${_this.courseModuleId}, intro: ${_this.intro}, timeOpen: ${_this.timeOpen}, timeClose: ${_this.timeClose}, timeLimit: ${_this.timeLimit}, maxAttempts: ${_this.maxAttempts}, gradeMethod: ${_this.gradeMethod}, hasQuestions: ${_this.hasQuestions})';
}


}

/// @nodoc
abstract mixin class $SdoQuizCopyWith<$Res>  {
  factory $SdoQuizCopyWith(SdoQuiz value, $Res Function(SdoQuiz) _then) = _$SdoQuizCopyWithImpl;
@useResult
$Res call({
 int id, int courseId, String name, int courseModuleId, String intro, DateTime? timeOpen, DateTime? timeClose, int timeLimit, int maxAttempts, int gradeMethod, bool hasQuestions
});




}
/// @nodoc
class _$SdoQuizCopyWithImpl<$Res>
    implements $SdoQuizCopyWith<$Res> {
  _$SdoQuizCopyWithImpl(this._self, this._then);

  final SdoQuiz _self;
  final $Res Function(SdoQuiz) _then;

/// Create a copy of SdoQuiz
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? name = null,Object? courseModuleId = null,Object? intro = null,Object? timeOpen = freezed,Object? timeClose = freezed,Object? timeLimit = null,Object? maxAttempts = null,Object? gradeMethod = null,Object? hasQuestions = null,}) {
  return _then(SdoQuiz(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,courseModuleId: null == courseModuleId ? _self.courseModuleId : courseModuleId // ignore: cast_nullable_to_non_nullable
as int,intro: null == intro ? _self.intro : intro // ignore: cast_nullable_to_non_nullable
as String,timeOpen: freezed == timeOpen ? _self.timeOpen : timeOpen // ignore: cast_nullable_to_non_nullable
as DateTime?,timeClose: freezed == timeClose ? _self.timeClose : timeClose // ignore: cast_nullable_to_non_nullable
as DateTime?,timeLimit: null == timeLimit ? _self.timeLimit : timeLimit // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,gradeMethod: null == gradeMethod ? _self.gradeMethod : gradeMethod // ignore: cast_nullable_to_non_nullable
as int,hasQuestions: null == hasQuestions ? _self.hasQuestions : hasQuestions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoQuiz].
extension SdoQuizPatterns on SdoQuiz {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoQuiz value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoQuiz() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoQuiz value)  $default,){
final _that = this;
switch (_that) {
case _SdoQuiz():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoQuiz value)?  $default,){
final _that = this;
switch (_that) {
case _SdoQuiz() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int courseId,  String name,  int courseModuleId,  String intro,  DateTime? timeOpen,  DateTime? timeClose,  int timeLimit,  int maxAttempts,  int gradeMethod,  bool hasQuestions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoQuiz() when $default != null:
return $default(_that.id,_that.courseId,_that.name,_that.courseModuleId,_that.intro,_that.timeOpen,_that.timeClose,_that.timeLimit,_that.maxAttempts,_that.gradeMethod,_that.hasQuestions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int courseId,  String name,  int courseModuleId,  String intro,  DateTime? timeOpen,  DateTime? timeClose,  int timeLimit,  int maxAttempts,  int gradeMethod,  bool hasQuestions)  $default,) {final _that = this;
switch (_that) {
case _SdoQuiz():
return $default(_that.id,_that.courseId,_that.name,_that.courseModuleId,_that.intro,_that.timeOpen,_that.timeClose,_that.timeLimit,_that.maxAttempts,_that.gradeMethod,_that.hasQuestions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int courseId,  String name,  int courseModuleId,  String intro,  DateTime? timeOpen,  DateTime? timeClose,  int timeLimit,  int maxAttempts,  int gradeMethod,  bool hasQuestions)?  $default,) {final _that = this;
switch (_that) {
case _SdoQuiz() when $default != null:
return $default(_that.id,_that.courseId,_that.name,_that.courseModuleId,_that.intro,_that.timeOpen,_that.timeClose,_that.timeLimit,_that.maxAttempts,_that.gradeMethod,_that.hasQuestions);case _:
  return null;

}
}

}

/// @nodoc


class _SdoQuiz implements SdoQuiz {
  const _SdoQuiz({required this.id, required this.courseId, required this.name, this.courseModuleId = 0, this.intro = '', this.timeOpen, this.timeClose, this.timeLimit = 0, this.maxAttempts = 0, this.gradeMethod = 0, this.hasQuestions = false});
  

@override final  int id;
@override final  int courseId;
@override final  String name;
@override@JsonKey() final  int courseModuleId;
@override@JsonKey() final  String intro;
@override final  DateTime? timeOpen;
@override final  DateTime? timeClose;
@override@JsonKey() final  int timeLimit;
@override@JsonKey() final  int maxAttempts;
@override@JsonKey() final  int gradeMethod;
@override@JsonKey() final  bool hasQuestions;

/// Create a copy of SdoQuiz
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoQuizCopyWith<_SdoQuiz> get copyWith => __$SdoQuizCopyWithImpl<_SdoQuiz>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoQuiz&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.name, name) || other.name == name)&&(identical(other.courseModuleId, courseModuleId) || other.courseModuleId == courseModuleId)&&(identical(other.intro, intro) || other.intro == intro)&&(identical(other.timeOpen, timeOpen) || other.timeOpen == timeOpen)&&(identical(other.timeClose, timeClose) || other.timeClose == timeClose)&&(identical(other.timeLimit, timeLimit) || other.timeLimit == timeLimit)&&(identical(other.maxAttempts, maxAttempts) || other.maxAttempts == maxAttempts)&&(identical(other.gradeMethod, gradeMethod) || other.gradeMethod == gradeMethod)&&(identical(other.hasQuestions, hasQuestions) || other.hasQuestions == hasQuestions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,courseId,name,courseModuleId,intro,timeOpen,timeClose,timeLimit,maxAttempts,gradeMethod,hasQuestions);
}

@override
String toString() {
    return 'SdoQuiz(id: $id, courseId: $courseId, name: $name, courseModuleId: $courseModuleId, intro: $intro, timeOpen: $timeOpen, timeClose: $timeClose, timeLimit: $timeLimit, maxAttempts: $maxAttempts, gradeMethod: $gradeMethod, hasQuestions: $hasQuestions)';
}


}

/// @nodoc
abstract mixin class _$SdoQuizCopyWith<$Res> implements $SdoQuizCopyWith<$Res> {
  factory _$SdoQuizCopyWith(_SdoQuiz value, $Res Function(_SdoQuiz) _then) = __$SdoQuizCopyWithImpl;
@override @useResult
$Res call({
 int id, int courseId, String name, int courseModuleId, String intro, DateTime? timeOpen, DateTime? timeClose, int timeLimit, int maxAttempts, int gradeMethod, bool hasQuestions
});




}
/// @nodoc
class __$SdoQuizCopyWithImpl<$Res>
    implements _$SdoQuizCopyWith<$Res> {
  __$SdoQuizCopyWithImpl(this._self, this._then);

  final _SdoQuiz _self;
  final $Res Function(_SdoQuiz) _then;

/// Create a copy of SdoQuiz
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? name = null,Object? courseModuleId = null,Object? intro = null,Object? timeOpen = freezed,Object? timeClose = freezed,Object? timeLimit = null,Object? maxAttempts = null,Object? gradeMethod = null,Object? hasQuestions = null,}) {
  return _then(_SdoQuiz(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,courseModuleId: null == courseModuleId ? _self.courseModuleId : courseModuleId // ignore: cast_nullable_to_non_nullable
as int,intro: null == intro ? _self.intro : intro // ignore: cast_nullable_to_non_nullable
as String,timeOpen: freezed == timeOpen ? _self.timeOpen : timeOpen // ignore: cast_nullable_to_non_nullable
as DateTime?,timeClose: freezed == timeClose ? _self.timeClose : timeClose // ignore: cast_nullable_to_non_nullable
as DateTime?,timeLimit: null == timeLimit ? _self.timeLimit : timeLimit // ignore: cast_nullable_to_non_nullable
as int,maxAttempts: null == maxAttempts ? _self.maxAttempts : maxAttempts // ignore: cast_nullable_to_non_nullable
as int,gradeMethod: null == gradeMethod ? _self.gradeMethod : gradeMethod // ignore: cast_nullable_to_non_nullable
as int,hasQuestions: null == hasQuestions ? _self.hasQuestions : hasQuestions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SdoQuizAttempt {

 int get id; int get quizId; int get attempt; String get state; DateTime? get timeStart; DateTime? get timeFinish; double? get grade;
/// Create a copy of SdoQuizAttempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SdoQuizAttemptCopyWith<SdoQuizAttempt> get copyWith => _$SdoQuizAttemptCopyWithImpl<SdoQuizAttempt>(this as SdoQuizAttempt, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SdoQuizAttempt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SdoQuizAttempt&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.quizId, _this.quizId) || other.quizId == _this.quizId)&&(identical(other.attempt, _this.attempt) || other.attempt == _this.attempt)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.timeStart, _this.timeStart) || other.timeStart == _this.timeStart)&&(identical(other.timeFinish, _this.timeFinish) || other.timeFinish == _this.timeFinish)&&(identical(other.grade, _this.grade) || other.grade == _this.grade));
}


@override
int get hashCode {
  final _this = this as SdoQuizAttempt;
  return Object.hash(runtimeType,_this.id,_this.quizId,_this.attempt,_this.state,_this.timeStart,_this.timeFinish,_this.grade);
}

@override
String toString() {
  final _this = this as SdoQuizAttempt;
  return 'SdoQuizAttempt(id: ${_this.id}, quizId: ${_this.quizId}, attempt: ${_this.attempt}, state: ${_this.state}, timeStart: ${_this.timeStart}, timeFinish: ${_this.timeFinish}, grade: ${_this.grade})';
}


}

/// @nodoc
abstract mixin class $SdoQuizAttemptCopyWith<$Res>  {
  factory $SdoQuizAttemptCopyWith(SdoQuizAttempt value, $Res Function(SdoQuizAttempt) _then) = _$SdoQuizAttemptCopyWithImpl;
@useResult
$Res call({
 int id, int quizId, int attempt, String state, DateTime? timeStart, DateTime? timeFinish, double? grade
});




}
/// @nodoc
class _$SdoQuizAttemptCopyWithImpl<$Res>
    implements $SdoQuizAttemptCopyWith<$Res> {
  _$SdoQuizAttemptCopyWithImpl(this._self, this._then);

  final SdoQuizAttempt _self;
  final $Res Function(SdoQuizAttempt) _then;

/// Create a copy of SdoQuizAttempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? quizId = null,Object? attempt = null,Object? state = null,Object? timeStart = freezed,Object? timeFinish = freezed,Object? grade = freezed,}) {
  return _then(SdoQuizAttempt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as DateTime?,timeFinish: freezed == timeFinish ? _self.timeFinish : timeFinish // ignore: cast_nullable_to_non_nullable
as DateTime?,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [SdoQuizAttempt].
extension SdoQuizAttemptPatterns on SdoQuizAttempt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SdoQuizAttempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SdoQuizAttempt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SdoQuizAttempt value)  $default,){
final _that = this;
switch (_that) {
case _SdoQuizAttempt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SdoQuizAttempt value)?  $default,){
final _that = this;
switch (_that) {
case _SdoQuizAttempt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int quizId,  int attempt,  String state,  DateTime? timeStart,  DateTime? timeFinish,  double? grade)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SdoQuizAttempt() when $default != null:
return $default(_that.id,_that.quizId,_that.attempt,_that.state,_that.timeStart,_that.timeFinish,_that.grade);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int quizId,  int attempt,  String state,  DateTime? timeStart,  DateTime? timeFinish,  double? grade)  $default,) {final _that = this;
switch (_that) {
case _SdoQuizAttempt():
return $default(_that.id,_that.quizId,_that.attempt,_that.state,_that.timeStart,_that.timeFinish,_that.grade);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int quizId,  int attempt,  String state,  DateTime? timeStart,  DateTime? timeFinish,  double? grade)?  $default,) {final _that = this;
switch (_that) {
case _SdoQuizAttempt() when $default != null:
return $default(_that.id,_that.quizId,_that.attempt,_that.state,_that.timeStart,_that.timeFinish,_that.grade);case _:
  return null;

}
}

}

/// @nodoc


class _SdoQuizAttempt implements SdoQuizAttempt {
  const _SdoQuizAttempt({required this.id, required this.quizId, this.attempt = 1, this.state = '', this.timeStart, this.timeFinish, this.grade});
  

@override final  int id;
@override final  int quizId;
@override@JsonKey() final  int attempt;
@override@JsonKey() final  String state;
@override final  DateTime? timeStart;
@override final  DateTime? timeFinish;
@override final  double? grade;

/// Create a copy of SdoQuizAttempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SdoQuizAttemptCopyWith<_SdoQuizAttempt> get copyWith => __$SdoQuizAttemptCopyWithImpl<_SdoQuizAttempt>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SdoQuizAttempt&&(identical(other.id, id) || other.id == id)&&(identical(other.quizId, quizId) || other.quizId == quizId)&&(identical(other.attempt, attempt) || other.attempt == attempt)&&(identical(other.state, state) || other.state == state)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeFinish, timeFinish) || other.timeFinish == timeFinish)&&(identical(other.grade, grade) || other.grade == grade));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,quizId,attempt,state,timeStart,timeFinish,grade);
}

@override
String toString() {
    return 'SdoQuizAttempt(id: $id, quizId: $quizId, attempt: $attempt, state: $state, timeStart: $timeStart, timeFinish: $timeFinish, grade: $grade)';
}


}

/// @nodoc
abstract mixin class _$SdoQuizAttemptCopyWith<$Res> implements $SdoQuizAttemptCopyWith<$Res> {
  factory _$SdoQuizAttemptCopyWith(_SdoQuizAttempt value, $Res Function(_SdoQuizAttempt) _then) = __$SdoQuizAttemptCopyWithImpl;
@override @useResult
$Res call({
 int id, int quizId, int attempt, String state, DateTime? timeStart, DateTime? timeFinish, double? grade
});




}
/// @nodoc
class __$SdoQuizAttemptCopyWithImpl<$Res>
    implements _$SdoQuizAttemptCopyWith<$Res> {
  __$SdoQuizAttemptCopyWithImpl(this._self, this._then);

  final _SdoQuizAttempt _self;
  final $Res Function(_SdoQuizAttempt) _then;

/// Create a copy of SdoQuizAttempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? quizId = null,Object? attempt = null,Object? state = null,Object? timeStart = freezed,Object? timeFinish = freezed,Object? grade = freezed,}) {
  return _then(_SdoQuizAttempt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,quizId: null == quizId ? _self.quizId : quizId // ignore: cast_nullable_to_non_nullable
as int,attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as DateTime?,timeFinish: freezed == timeFinish ? _self.timeFinish : timeFinish // ignore: cast_nullable_to_non_nullable
as DateTime?,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
