// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IssueDetailState {

 IssueDetailStatus get status; Issue? get issue; List<Comment> get comments; String? get errorMessage; bool get isTogglingState; String? get toggleErrorMessage; CommentPostingStatus get commentPostingStatus; String? get commentErrorMessage;
/// Create a copy of IssueDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueDetailStateCopyWith<IssueDetailState> get copyWith => _$IssueDetailStateCopyWithImpl<IssueDetailState>(this as IssueDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.issue, issue) || other.issue == issue)&&const DeepCollectionEquality().equals(other.comments, comments)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isTogglingState, isTogglingState) || other.isTogglingState == isTogglingState)&&(identical(other.toggleErrorMessage, toggleErrorMessage) || other.toggleErrorMessage == toggleErrorMessage)&&(identical(other.commentPostingStatus, commentPostingStatus) || other.commentPostingStatus == commentPostingStatus)&&(identical(other.commentErrorMessage, commentErrorMessage) || other.commentErrorMessage == commentErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,issue,const DeepCollectionEquality().hash(comments),errorMessage,isTogglingState,toggleErrorMessage,commentPostingStatus,commentErrorMessage);

@override
String toString() {
  return 'IssueDetailState(status: $status, issue: $issue, comments: $comments, errorMessage: $errorMessage, isTogglingState: $isTogglingState, toggleErrorMessage: $toggleErrorMessage, commentPostingStatus: $commentPostingStatus, commentErrorMessage: $commentErrorMessage)';
}


}

/// @nodoc
abstract mixin class $IssueDetailStateCopyWith<$Res>  {
  factory $IssueDetailStateCopyWith(IssueDetailState value, $Res Function(IssueDetailState) _then) = _$IssueDetailStateCopyWithImpl;
@useResult
$Res call({
 IssueDetailStatus status, Issue? issue, List<Comment> comments, String? errorMessage, bool isTogglingState, String? toggleErrorMessage, CommentPostingStatus commentPostingStatus, String? commentErrorMessage
});


$IssueCopyWith<$Res>? get issue;

}
/// @nodoc
class _$IssueDetailStateCopyWithImpl<$Res>
    implements $IssueDetailStateCopyWith<$Res> {
  _$IssueDetailStateCopyWithImpl(this._self, this._then);

  final IssueDetailState _self;
  final $Res Function(IssueDetailState) _then;

/// Create a copy of IssueDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? issue = freezed,Object? comments = null,Object? errorMessage = freezed,Object? isTogglingState = null,Object? toggleErrorMessage = freezed,Object? commentPostingStatus = null,Object? commentErrorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IssueDetailStatus,issue: freezed == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as Issue?,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isTogglingState: null == isTogglingState ? _self.isTogglingState : isTogglingState // ignore: cast_nullable_to_non_nullable
as bool,toggleErrorMessage: freezed == toggleErrorMessage ? _self.toggleErrorMessage : toggleErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,commentPostingStatus: null == commentPostingStatus ? _self.commentPostingStatus : commentPostingStatus // ignore: cast_nullable_to_non_nullable
as CommentPostingStatus,commentErrorMessage: freezed == commentErrorMessage ? _self.commentErrorMessage : commentErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of IssueDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueCopyWith<$Res>? get issue {
    if (_self.issue == null) {
    return null;
  }

  return $IssueCopyWith<$Res>(_self.issue!, (value) {
    return _then(_self.copyWith(issue: value));
  });
}
}


/// Adds pattern-matching-related methods to [IssueDetailState].
extension IssueDetailStatePatterns on IssueDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IssueDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IssueDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IssueDetailState value)  $default,){
final _that = this;
switch (_that) {
case _IssueDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IssueDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _IssueDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IssueDetailStatus status,  Issue? issue,  List<Comment> comments,  String? errorMessage,  bool isTogglingState,  String? toggleErrorMessage,  CommentPostingStatus commentPostingStatus,  String? commentErrorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IssueDetailState() when $default != null:
return $default(_that.status,_that.issue,_that.comments,_that.errorMessage,_that.isTogglingState,_that.toggleErrorMessage,_that.commentPostingStatus,_that.commentErrorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IssueDetailStatus status,  Issue? issue,  List<Comment> comments,  String? errorMessage,  bool isTogglingState,  String? toggleErrorMessage,  CommentPostingStatus commentPostingStatus,  String? commentErrorMessage)  $default,) {final _that = this;
switch (_that) {
case _IssueDetailState():
return $default(_that.status,_that.issue,_that.comments,_that.errorMessage,_that.isTogglingState,_that.toggleErrorMessage,_that.commentPostingStatus,_that.commentErrorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IssueDetailStatus status,  Issue? issue,  List<Comment> comments,  String? errorMessage,  bool isTogglingState,  String? toggleErrorMessage,  CommentPostingStatus commentPostingStatus,  String? commentErrorMessage)?  $default,) {final _that = this;
switch (_that) {
case _IssueDetailState() when $default != null:
return $default(_that.status,_that.issue,_that.comments,_that.errorMessage,_that.isTogglingState,_that.toggleErrorMessage,_that.commentPostingStatus,_that.commentErrorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _IssueDetailState implements IssueDetailState {
  const _IssueDetailState({this.status = IssueDetailStatus.initial, this.issue, final  List<Comment> comments = const [], this.errorMessage, this.isTogglingState = false, this.toggleErrorMessage, this.commentPostingStatus = CommentPostingStatus.initial, this.commentErrorMessage}): _comments = comments;
  

@override@JsonKey() final  IssueDetailStatus status;
@override final  Issue? issue;
 final  List<Comment> _comments;
@override@JsonKey() List<Comment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

@override final  String? errorMessage;
@override@JsonKey() final  bool isTogglingState;
@override final  String? toggleErrorMessage;
@override@JsonKey() final  CommentPostingStatus commentPostingStatus;
@override final  String? commentErrorMessage;

/// Create a copy of IssueDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IssueDetailStateCopyWith<_IssueDetailState> get copyWith => __$IssueDetailStateCopyWithImpl<_IssueDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IssueDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.issue, issue) || other.issue == issue)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isTogglingState, isTogglingState) || other.isTogglingState == isTogglingState)&&(identical(other.toggleErrorMessage, toggleErrorMessage) || other.toggleErrorMessage == toggleErrorMessage)&&(identical(other.commentPostingStatus, commentPostingStatus) || other.commentPostingStatus == commentPostingStatus)&&(identical(other.commentErrorMessage, commentErrorMessage) || other.commentErrorMessage == commentErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,issue,const DeepCollectionEquality().hash(_comments),errorMessage,isTogglingState,toggleErrorMessage,commentPostingStatus,commentErrorMessage);

@override
String toString() {
  return 'IssueDetailState(status: $status, issue: $issue, comments: $comments, errorMessage: $errorMessage, isTogglingState: $isTogglingState, toggleErrorMessage: $toggleErrorMessage, commentPostingStatus: $commentPostingStatus, commentErrorMessage: $commentErrorMessage)';
}


}

/// @nodoc
abstract mixin class _$IssueDetailStateCopyWith<$Res> implements $IssueDetailStateCopyWith<$Res> {
  factory _$IssueDetailStateCopyWith(_IssueDetailState value, $Res Function(_IssueDetailState) _then) = __$IssueDetailStateCopyWithImpl;
@override @useResult
$Res call({
 IssueDetailStatus status, Issue? issue, List<Comment> comments, String? errorMessage, bool isTogglingState, String? toggleErrorMessage, CommentPostingStatus commentPostingStatus, String? commentErrorMessage
});


@override $IssueCopyWith<$Res>? get issue;

}
/// @nodoc
class __$IssueDetailStateCopyWithImpl<$Res>
    implements _$IssueDetailStateCopyWith<$Res> {
  __$IssueDetailStateCopyWithImpl(this._self, this._then);

  final _IssueDetailState _self;
  final $Res Function(_IssueDetailState) _then;

/// Create a copy of IssueDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? issue = freezed,Object? comments = null,Object? errorMessage = freezed,Object? isTogglingState = null,Object? toggleErrorMessage = freezed,Object? commentPostingStatus = null,Object? commentErrorMessage = freezed,}) {
  return _then(_IssueDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IssueDetailStatus,issue: freezed == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as Issue?,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<Comment>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isTogglingState: null == isTogglingState ? _self.isTogglingState : isTogglingState // ignore: cast_nullable_to_non_nullable
as bool,toggleErrorMessage: freezed == toggleErrorMessage ? _self.toggleErrorMessage : toggleErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,commentPostingStatus: null == commentPostingStatus ? _self.commentPostingStatus : commentPostingStatus // ignore: cast_nullable_to_non_nullable
as CommentPostingStatus,commentErrorMessage: freezed == commentErrorMessage ? _self.commentErrorMessage : commentErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of IssueDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IssueCopyWith<$Res>? get issue {
    if (_self.issue == null) {
    return null;
  }

  return $IssueCopyWith<$Res>(_self.issue!, (value) {
    return _then(_self.copyWith(issue: value));
  });
}
}

// dart format on
