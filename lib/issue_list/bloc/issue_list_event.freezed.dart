// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue_list_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IssueListEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueListEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'IssueListEvent()';
}


}

/// @nodoc
class $IssueListEventCopyWith<$Res>  {
$IssueListEventCopyWith(IssueListEvent _, $Res Function(IssueListEvent) __);
}


/// Adds pattern-matching-related methods to [IssueListEvent].
extension IssueListEventPatterns on IssueListEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( IssueListFetched value)?  fetched,TResult Function( IssueListNextPageRequested value)?  nextPageRequested,TResult Function( IssueListStateFilterChanged value)?  stateFilterChanged,TResult Function( IssueListLabelFilterChanged value)?  labelFilterChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case IssueListFetched() when fetched != null:
return fetched(_that);case IssueListNextPageRequested() when nextPageRequested != null:
return nextPageRequested(_that);case IssueListStateFilterChanged() when stateFilterChanged != null:
return stateFilterChanged(_that);case IssueListLabelFilterChanged() when labelFilterChanged != null:
return labelFilterChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( IssueListFetched value)  fetched,required TResult Function( IssueListNextPageRequested value)  nextPageRequested,required TResult Function( IssueListStateFilterChanged value)  stateFilterChanged,required TResult Function( IssueListLabelFilterChanged value)  labelFilterChanged,}){
final _that = this;
switch (_that) {
case IssueListFetched():
return fetched(_that);case IssueListNextPageRequested():
return nextPageRequested(_that);case IssueListStateFilterChanged():
return stateFilterChanged(_that);case IssueListLabelFilterChanged():
return labelFilterChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( IssueListFetched value)?  fetched,TResult? Function( IssueListNextPageRequested value)?  nextPageRequested,TResult? Function( IssueListStateFilterChanged value)?  stateFilterChanged,TResult? Function( IssueListLabelFilterChanged value)?  labelFilterChanged,}){
final _that = this;
switch (_that) {
case IssueListFetched() when fetched != null:
return fetched(_that);case IssueListNextPageRequested() when nextPageRequested != null:
return nextPageRequested(_that);case IssueListStateFilterChanged() when stateFilterChanged != null:
return stateFilterChanged(_that);case IssueListLabelFilterChanged() when labelFilterChanged != null:
return labelFilterChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  fetched,TResult Function()?  nextPageRequested,TResult Function( IssueStateFilter filter)?  stateFilterChanged,TResult Function( String? label)?  labelFilterChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case IssueListFetched() when fetched != null:
return fetched();case IssueListNextPageRequested() when nextPageRequested != null:
return nextPageRequested();case IssueListStateFilterChanged() when stateFilterChanged != null:
return stateFilterChanged(_that.filter);case IssueListLabelFilterChanged() when labelFilterChanged != null:
return labelFilterChanged(_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  fetched,required TResult Function()  nextPageRequested,required TResult Function( IssueStateFilter filter)  stateFilterChanged,required TResult Function( String? label)  labelFilterChanged,}) {final _that = this;
switch (_that) {
case IssueListFetched():
return fetched();case IssueListNextPageRequested():
return nextPageRequested();case IssueListStateFilterChanged():
return stateFilterChanged(_that.filter);case IssueListLabelFilterChanged():
return labelFilterChanged(_that.label);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  fetched,TResult? Function()?  nextPageRequested,TResult? Function( IssueStateFilter filter)?  stateFilterChanged,TResult? Function( String? label)?  labelFilterChanged,}) {final _that = this;
switch (_that) {
case IssueListFetched() when fetched != null:
return fetched();case IssueListNextPageRequested() when nextPageRequested != null:
return nextPageRequested();case IssueListStateFilterChanged() when stateFilterChanged != null:
return stateFilterChanged(_that.filter);case IssueListLabelFilterChanged() when labelFilterChanged != null:
return labelFilterChanged(_that.label);case _:
  return null;

}
}

}

/// @nodoc


class IssueListFetched implements IssueListEvent {
  const IssueListFetched();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueListFetched);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'IssueListEvent.fetched()';
}


}




/// @nodoc


class IssueListNextPageRequested implements IssueListEvent {
  const IssueListNextPageRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueListNextPageRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'IssueListEvent.nextPageRequested()';
}


}




/// @nodoc


class IssueListStateFilterChanged implements IssueListEvent {
  const IssueListStateFilterChanged({required this.filter});
  

 final  IssueStateFilter filter;

/// Create a copy of IssueListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueListStateFilterChangedCopyWith<IssueListStateFilterChanged> get copyWith => _$IssueListStateFilterChangedCopyWithImpl<IssueListStateFilterChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueListStateFilterChanged&&(identical(other.filter, filter) || other.filter == filter));
}


@override
int get hashCode => Object.hash(runtimeType,filter);

@override
String toString() {
  return 'IssueListEvent.stateFilterChanged(filter: $filter)';
}


}

/// @nodoc
abstract mixin class $IssueListStateFilterChangedCopyWith<$Res> implements $IssueListEventCopyWith<$Res> {
  factory $IssueListStateFilterChangedCopyWith(IssueListStateFilterChanged value, $Res Function(IssueListStateFilterChanged) _then) = _$IssueListStateFilterChangedCopyWithImpl;
@useResult
$Res call({
 IssueStateFilter filter
});




}
/// @nodoc
class _$IssueListStateFilterChangedCopyWithImpl<$Res>
    implements $IssueListStateFilterChangedCopyWith<$Res> {
  _$IssueListStateFilterChangedCopyWithImpl(this._self, this._then);

  final IssueListStateFilterChanged _self;
  final $Res Function(IssueListStateFilterChanged) _then;

/// Create a copy of IssueListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filter = null,}) {
  return _then(IssueListStateFilterChanged(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as IssueStateFilter,
  ));
}


}

/// @nodoc


class IssueListLabelFilterChanged implements IssueListEvent {
  const IssueListLabelFilterChanged({this.label});
  

 final  String? label;

/// Create a copy of IssueListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueListLabelFilterChangedCopyWith<IssueListLabelFilterChanged> get copyWith => _$IssueListLabelFilterChangedCopyWithImpl<IssueListLabelFilterChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IssueListLabelFilterChanged&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode => Object.hash(runtimeType,label);

@override
String toString() {
  return 'IssueListEvent.labelFilterChanged(label: $label)';
}


}

/// @nodoc
abstract mixin class $IssueListLabelFilterChangedCopyWith<$Res> implements $IssueListEventCopyWith<$Res> {
  factory $IssueListLabelFilterChangedCopyWith(IssueListLabelFilterChanged value, $Res Function(IssueListLabelFilterChanged) _then) = _$IssueListLabelFilterChangedCopyWithImpl;
@useResult
$Res call({
 String? label
});




}
/// @nodoc
class _$IssueListLabelFilterChangedCopyWithImpl<$Res>
    implements $IssueListLabelFilterChangedCopyWith<$Res> {
  _$IssueListLabelFilterChangedCopyWithImpl(this._self, this._then);

  final IssueListLabelFilterChanged _self;
  final $Res Function(IssueListLabelFilterChanged) _then;

/// Create a copy of IssueListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? label = freezed,}) {
  return _then(IssueListLabelFilterChanged(
label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
