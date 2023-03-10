// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'webp_bridge_generated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Filter {
  FilterConfig get field0 => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FilterConfig field0) simple,
    required TResult Function(FilterConfig field0) strong,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FilterConfig field0)? simple,
    TResult? Function(FilterConfig field0)? strong,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FilterConfig field0)? simple,
    TResult Function(FilterConfig field0)? strong,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Filter_Simple value) simple,
    required TResult Function(Filter_Strong value) strong,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Filter_Simple value)? simple,
    TResult? Function(Filter_Strong value)? strong,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Filter_Simple value)? simple,
    TResult Function(Filter_Strong value)? strong,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FilterCopyWith<Filter> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterCopyWith<$Res> {
  factory $FilterCopyWith(Filter value, $Res Function(Filter) then) =
      _$FilterCopyWithImpl<$Res, Filter>;
  @useResult
  $Res call({FilterConfig field0});
}

/// @nodoc
class _$FilterCopyWithImpl<$Res, $Val extends Filter>
    implements $FilterCopyWith<$Res> {
  _$FilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_value.copyWith(
      field0: null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as FilterConfig,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Filter_SimpleCopyWith<$Res> implements $FilterCopyWith<$Res> {
  factory _$$Filter_SimpleCopyWith(
          _$Filter_Simple value, $Res Function(_$Filter_Simple) then) =
      __$$Filter_SimpleCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FilterConfig field0});
}

/// @nodoc
class __$$Filter_SimpleCopyWithImpl<$Res>
    extends _$FilterCopyWithImpl<$Res, _$Filter_Simple>
    implements _$$Filter_SimpleCopyWith<$Res> {
  __$$Filter_SimpleCopyWithImpl(
      _$Filter_Simple _value, $Res Function(_$Filter_Simple) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Filter_Simple(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as FilterConfig,
    ));
  }
}

/// @nodoc

class _$Filter_Simple implements Filter_Simple {
  const _$Filter_Simple(this.field0);

  @override
  final FilterConfig field0;

  @override
  String toString() {
    return 'Filter.simple(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Filter_Simple &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Filter_SimpleCopyWith<_$Filter_Simple> get copyWith =>
      __$$Filter_SimpleCopyWithImpl<_$Filter_Simple>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FilterConfig field0) simple,
    required TResult Function(FilterConfig field0) strong,
  }) {
    return simple(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FilterConfig field0)? simple,
    TResult? Function(FilterConfig field0)? strong,
  }) {
    return simple?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FilterConfig field0)? simple,
    TResult Function(FilterConfig field0)? strong,
    required TResult orElse(),
  }) {
    if (simple != null) {
      return simple(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Filter_Simple value) simple,
    required TResult Function(Filter_Strong value) strong,
  }) {
    return simple(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Filter_Simple value)? simple,
    TResult? Function(Filter_Strong value)? strong,
  }) {
    return simple?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Filter_Simple value)? simple,
    TResult Function(Filter_Strong value)? strong,
    required TResult orElse(),
  }) {
    if (simple != null) {
      return simple(this);
    }
    return orElse();
  }
}

abstract class Filter_Simple implements Filter {
  const factory Filter_Simple(final FilterConfig field0) = _$Filter_Simple;

  @override
  FilterConfig get field0;
  @override
  @JsonKey(ignore: true)
  _$$Filter_SimpleCopyWith<_$Filter_Simple> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$Filter_StrongCopyWith<$Res> implements $FilterCopyWith<$Res> {
  factory _$$Filter_StrongCopyWith(
          _$Filter_Strong value, $Res Function(_$Filter_Strong) then) =
      __$$Filter_StrongCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FilterConfig field0});
}

/// @nodoc
class __$$Filter_StrongCopyWithImpl<$Res>
    extends _$FilterCopyWithImpl<$Res, _$Filter_Strong>
    implements _$$Filter_StrongCopyWith<$Res> {
  __$$Filter_StrongCopyWithImpl(
      _$Filter_Strong _value, $Res Function(_$Filter_Strong) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field0 = null,
  }) {
    return _then(_$Filter_Strong(
      null == field0
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as FilterConfig,
    ));
  }
}

/// @nodoc

class _$Filter_Strong implements Filter_Strong {
  const _$Filter_Strong(this.field0);

  @override
  final FilterConfig field0;

  @override
  String toString() {
    return 'Filter.strong(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Filter_Strong &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Filter_StrongCopyWith<_$Filter_Strong> get copyWith =>
      __$$Filter_StrongCopyWithImpl<_$Filter_Strong>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(FilterConfig field0) simple,
    required TResult Function(FilterConfig field0) strong,
  }) {
    return strong(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(FilterConfig field0)? simple,
    TResult? Function(FilterConfig field0)? strong,
  }) {
    return strong?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(FilterConfig field0)? simple,
    TResult Function(FilterConfig field0)? strong,
    required TResult orElse(),
  }) {
    if (strong != null) {
      return strong(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Filter_Simple value) simple,
    required TResult Function(Filter_Strong value) strong,
  }) {
    return strong(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Filter_Simple value)? simple,
    TResult? Function(Filter_Strong value)? strong,
  }) {
    return strong?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Filter_Simple value)? simple,
    TResult Function(Filter_Strong value)? strong,
    required TResult orElse(),
  }) {
    if (strong != null) {
      return strong(this);
    }
    return orElse();
  }
}

abstract class Filter_Strong implements Filter {
  const factory Filter_Strong(final FilterConfig field0) = _$Filter_Strong;

  @override
  FilterConfig get field0;
  @override
  @JsonKey(ignore: true)
  _$$Filter_StrongCopyWith<_$Filter_Strong> get copyWith =>
      throw _privateConstructorUsedError;
}
