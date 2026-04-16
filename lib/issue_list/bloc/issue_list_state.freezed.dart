// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IssueListState {

 IssueListStatus get status; List<Issue> get issues; bool get hasReachedMax; IssueStateFilter get stateFilter; String? get labelFilter; String? get errorMessage; List<Label> get availableLabels;
/// Create a copy of IssueListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueListStateCopyWith<IssueListState> get copyWith => _$IssueListStateCopyWithImpl<IssueListState>(this as IssueListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.issues, issues)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.stateFilter, stateFilter) || other.stateFilter == stateFilter)&&(identical(other.labelFilter, labelFilter) || other.labelFilter == labelFilter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.availableLabels, availableLabels));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(issues),hasReachedMax,stateFilter,labelFilter,errorMessage,const DeepCollectionEquality().hash(availableLabels));

@override
String toString() {
  return 'IssueListState(status: $status, issues: $issues, hasReachedMax: $hasReachedMax, stateFilter: $stateFilter, labelFilter: $labelFilter, errorMessage: $errorMessage, availableLabels: $availableLabels)';
}


}

/// @nodoc
abstract mixin class $IssueListStateCopyWith<$Res>  {
  factory $IssueListStateCopyWith(IssueListState value, $Res Function(IssueListState) _then) = _$IssueListStateCopyWithImpl;
@useResult
$Res call({
 IssueListStatus status, List<Issue> issues, bool hasReachedMax, IssueStateFilter stateFilter, String? labelFilter, String? errorMessage, List<Label> availableLabels
});




}
/// @nodoc
class _$IssueListStateCopyWithImpl<$Res>
    implements $IssueListStateCopyWith<$Res> {
  _$IssueListStateCopyWithImpl(this._self, this._then);

  final IssueListState _self;
  final $Res Function(IssueListState) _then;

/// Create a copy of IssueListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? issues = null,Object? hasReachedMax = null,Object? stateFilter = null,Object? labelFilter = freezed,Object? errorMessage = freezed,Object? availableLabels = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IssueListStatus,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as List<Issue>,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,stateFilter: null == stateFilter ? _self.stateFilter : stateFilter // ignore: cast_nullable_to_non_nullable
as IssueStateFilter,labelFilter: freezed == labelFilter ? _self.labelFilter : labelFilter // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,availableLabels: null == availableLabels ? _self.availableLabels : availableLabels // ignore: cast_nullable_to_non_nullable
as List<Label>,
  ));
}

}


/// Adds pattern-matching-related methods to [IssueListState].
extension IssueListStatePatterns on IssueListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IssueListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IssueListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IssueListState value)  $default,){
final _that = this;
switch (_that) {
case _IssueListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IssueListState value)?  $default,){
final _that = this;
switch (_that) {
case _IssueListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IssueListStatus status,  List<Issue> issues,  bool hasReachedMax,  IssueStateFilter stateFilter,  String? labelFilter,  String? errorMessage,  List<Label> availableLabels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IssueListState() when $default != null:
return $default(_that.status,_that.issues,_that.hasReachedMax,_that.stateFilter,_that.labelFilter,_that.errorMessage,_that.availableLabels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IssueListStatus status,  List<Issue> issues,  bool hasReachedMax,  IssueStateFilter stateFilter,  String? labelFilter,  String? errorMessage,  List<Label> availableLabels)  $default,) {final _that = this;
switch (_that) {
case _IssueListState():
return $default(_that.status,_that.issues,_that.hasReachedMax,_that.stateFilter,_that.labelFilter,_that.errorMessage,_that.availableLabels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IssueListStatus status,  List<Issue> issues,  bool hasReachedMax,  IssueStateFilter stateFilter,  String? labelFilter,  String? errorMessage,  List<Label> availableLabels)?  $default,) {final _that = this;
switch (_that) {
case _IssueListState() when $default != null:
return $default(_that.status,_that.issues,_that.hasReachedMax,_that.stateFilter,_that.labelFilter,_that.errorMessage,_that.availableLabels);case _:
  return null;

}
}

}

/// @nodoc


class _IssueListState implements IssueListState {
  const _IssueListState({this.status = IssueListStatus.initial, final  List<Issue> issues = const [], this.hasReachedMax = false, this.stateFilter = IssueStateFilter.open, this.labelFilter, this.errorMessage, final  List<Label> availableLabels = const []}): _issues = issues,_availableLabels = availableLabels;
  

@override@JsonKey() final  IssueListStatus status;
 final  List<Issue> _issues;
@override@JsonKey() List<Issue> get issues {
  if (_issues is EqualUnmodifiableListView) return _issues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_issues);
}

@override@JsonKey() final  bool hasReachedMax;
@override@JsonKey() final  IssueStateFilter stateFilter;
@override final  String? labelFilter;
@override final  String? errorMessage;
 final  List<Label> _availableLabels;
@override@JsonKey() List<Label> get availableLabels {
  if (_availableLabels is EqualUnmodifiableListView) return _availableLabels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableLabels);
}


/// Create a copy of IssueListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IssueListStateCopyWith<_IssueListState> get copyWith => __$IssueListStateCopyWithImpl<_IssueListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IssueListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._issues, _issues)&&(identical(other.hasReachedMax, hasReachedMax) || other.hasReachedMax == hasReachedMax)&&(identical(other.stateFilter, stateFilter) || other.stateFilter == stateFilter)&&(identical(other.labelFilter, labelFilter) || other.labelFilter == labelFilter)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._availableLabels, _availableLabels));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_issues),hasReachedMax,stateFilter,labelFilter,errorMessage,const DeepCollectionEquality().hash(_availableLabels));

@override
String toString() {
  return 'IssueListState(status: $status, issues: $issues, hasReachedMax: $hasReachedMax, stateFilter: $stateFilter, labelFilter: $labelFilter, errorMessage: $errorMessage, availableLabels: $availableLabels)';
}


}

/// @nodoc
abstract mixin class _$IssueListStateCopyWith<$Res> implements $IssueListStateCopyWith<$Res> {
  factory _$IssueListStateCopyWith(_IssueListState value, $Res Function(_IssueListState) _then) = __$IssueListStateCopyWithImpl;
@override @useResult
$Res call({
 IssueListStatus status, List<Issue> issues, bool hasReachedMax, IssueStateFilter stateFilter, String? labelFilter, String? errorMessage, List<Label> availableLabels
});




}
/// @nodoc
class __$IssueListStateCopyWithImpl<$Res>
    implements _$IssueListStateCopyWith<$Res> {
  __$IssueListStateCopyWithImpl(this._self, this._then);

  final _IssueListState _self;
  final $Res Function(_IssueListState) _then;

/// Create a copy of IssueListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? issues = null,Object? hasReachedMax = null,Object? stateFilter = null,Object? labelFilter = freezed,Object? errorMessage = freezed,Object? availableLabels = null,}) {
  return _then(_IssueListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IssueListStatus,issues: null == issues ? _self._issues : issues // ignore: cast_nullable_to_non_nullable
as List<Issue>,hasReachedMax: null == hasReachedMax ? _self.hasReachedMax : hasReachedMax // ignore: cast_nullable_to_non_nullable
as bool,stateFilter: null == stateFilter ? _self.stateFilter : stateFilter // ignore: cast_nullable_to_non_nullable
as IssueStateFilter,labelFilter: freezed == labelFilter ? _self.labelFilter : labelFilter // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,availableLabels: null == availableLabels ? _self._availableLabels : availableLabels // ignore: cast_nullable_to_non_nullable
as List<Label>,
  ));
}


}

// dart format on
