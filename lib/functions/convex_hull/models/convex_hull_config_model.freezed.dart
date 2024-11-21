// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'convex_hull_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConvexHullConfigModel _$ConvexHullConfigModelFromJson(
    Map<String, dynamic> json) {
  return _ConvexHullConfigModel.fromJson(json);
}

/// @nodoc
mixin _$ConvexHullConfigModel {
  String? get activeImageSetBaseName => throw _privateConstructorUsedError;
  AbstractImage? get activeImage => throw _privateConstructorUsedError;
  ConvexHullResults? get activeResults => throw _privateConstructorUsedError;
  LeftMenuEnum get leftMenuEnum => throw _privateConstructorUsedError;
  String get overlaySearchPattern => throw _privateConstructorUsedError;
  Map<String, String> get searchPatternProteinConfig =>
      throw _privateConstructorUsedError;
  Map<String, bool> get searchPatternOverlayConfig =>
      throw _privateConstructorUsedError;
  double get imageWidth => throw _privateConstructorUsedError;
  double get imageHeight => throw _privateConstructorUsedError;
  String get units => throw _privateConstructorUsedError;
  int get channelNumber => throw _privateConstructorUsedError;

  /// Serializes this ConvexHullConfigModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConvexHullConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConvexHullConfigModelCopyWith<ConvexHullConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConvexHullConfigModelCopyWith<$Res> {
  factory $ConvexHullConfigModelCopyWith(ConvexHullConfigModel value,
          $Res Function(ConvexHullConfigModel) then) =
      _$ConvexHullConfigModelCopyWithImpl<$Res, ConvexHullConfigModel>;
  @useResult
  $Res call(
      {String? activeImageSetBaseName,
      AbstractImage? activeImage,
      ConvexHullResults? activeResults,
      LeftMenuEnum leftMenuEnum,
      String overlaySearchPattern,
      Map<String, String> searchPatternProteinConfig,
      Map<String, bool> searchPatternOverlayConfig,
      double imageWidth,
      double imageHeight,
      String units,
      int channelNumber});

  $AbstractImageCopyWith<$Res>? get activeImage;
  $ConvexHullResultsCopyWith<$Res>? get activeResults;
}

/// @nodoc
class _$ConvexHullConfigModelCopyWithImpl<$Res,
        $Val extends ConvexHullConfigModel>
    implements $ConvexHullConfigModelCopyWith<$Res> {
  _$ConvexHullConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConvexHullConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeImageSetBaseName = freezed,
    Object? activeImage = freezed,
    Object? activeResults = freezed,
    Object? leftMenuEnum = null,
    Object? overlaySearchPattern = null,
    Object? searchPatternProteinConfig = null,
    Object? searchPatternOverlayConfig = null,
    Object? imageWidth = null,
    Object? imageHeight = null,
    Object? units = null,
    Object? channelNumber = null,
  }) {
    return _then(_value.copyWith(
      activeImageSetBaseName: freezed == activeImageSetBaseName
          ? _value.activeImageSetBaseName
          : activeImageSetBaseName // ignore: cast_nullable_to_non_nullable
              as String?,
      activeImage: freezed == activeImage
          ? _value.activeImage
          : activeImage // ignore: cast_nullable_to_non_nullable
              as AbstractImage?,
      activeResults: freezed == activeResults
          ? _value.activeResults
          : activeResults // ignore: cast_nullable_to_non_nullable
              as ConvexHullResults?,
      leftMenuEnum: null == leftMenuEnum
          ? _value.leftMenuEnum
          : leftMenuEnum // ignore: cast_nullable_to_non_nullable
              as LeftMenuEnum,
      overlaySearchPattern: null == overlaySearchPattern
          ? _value.overlaySearchPattern
          : overlaySearchPattern // ignore: cast_nullable_to_non_nullable
              as String,
      searchPatternProteinConfig: null == searchPatternProteinConfig
          ? _value.searchPatternProteinConfig
          : searchPatternProteinConfig // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      searchPatternOverlayConfig: null == searchPatternOverlayConfig
          ? _value.searchPatternOverlayConfig
          : searchPatternOverlayConfig // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      imageWidth: null == imageWidth
          ? _value.imageWidth
          : imageWidth // ignore: cast_nullable_to_non_nullable
              as double,
      imageHeight: null == imageHeight
          ? _value.imageHeight
          : imageHeight // ignore: cast_nullable_to_non_nullable
              as double,
      units: null == units
          ? _value.units
          : units // ignore: cast_nullable_to_non_nullable
              as String,
      channelNumber: null == channelNumber
          ? _value.channelNumber
          : channelNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of ConvexHullConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AbstractImageCopyWith<$Res>? get activeImage {
    if (_value.activeImage == null) {
      return null;
    }

    return $AbstractImageCopyWith<$Res>(_value.activeImage!, (value) {
      return _then(_value.copyWith(activeImage: value) as $Val);
    });
  }

  /// Create a copy of ConvexHullConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConvexHullResultsCopyWith<$Res>? get activeResults {
    if (_value.activeResults == null) {
      return null;
    }

    return $ConvexHullResultsCopyWith<$Res>(_value.activeResults!, (value) {
      return _then(_value.copyWith(activeResults: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConvexHullConfigModelImplCopyWith<$Res>
    implements $ConvexHullConfigModelCopyWith<$Res> {
  factory _$$ConvexHullConfigModelImplCopyWith(
          _$ConvexHullConfigModelImpl value,
          $Res Function(_$ConvexHullConfigModelImpl) then) =
      __$$ConvexHullConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? activeImageSetBaseName,
      AbstractImage? activeImage,
      ConvexHullResults? activeResults,
      LeftMenuEnum leftMenuEnum,
      String overlaySearchPattern,
      Map<String, String> searchPatternProteinConfig,
      Map<String, bool> searchPatternOverlayConfig,
      double imageWidth,
      double imageHeight,
      String units,
      int channelNumber});

  @override
  $AbstractImageCopyWith<$Res>? get activeImage;
  @override
  $ConvexHullResultsCopyWith<$Res>? get activeResults;
}

/// @nodoc
class __$$ConvexHullConfigModelImplCopyWithImpl<$Res>
    extends _$ConvexHullConfigModelCopyWithImpl<$Res,
        _$ConvexHullConfigModelImpl>
    implements _$$ConvexHullConfigModelImplCopyWith<$Res> {
  __$$ConvexHullConfigModelImplCopyWithImpl(_$ConvexHullConfigModelImpl _value,
      $Res Function(_$ConvexHullConfigModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConvexHullConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeImageSetBaseName = freezed,
    Object? activeImage = freezed,
    Object? activeResults = freezed,
    Object? leftMenuEnum = null,
    Object? overlaySearchPattern = null,
    Object? searchPatternProteinConfig = null,
    Object? searchPatternOverlayConfig = null,
    Object? imageWidth = null,
    Object? imageHeight = null,
    Object? units = null,
    Object? channelNumber = null,
  }) {
    return _then(_$ConvexHullConfigModelImpl(
      activeImageSetBaseName: freezed == activeImageSetBaseName
          ? _value.activeImageSetBaseName
          : activeImageSetBaseName // ignore: cast_nullable_to_non_nullable
              as String?,
      activeImage: freezed == activeImage
          ? _value.activeImage
          : activeImage // ignore: cast_nullable_to_non_nullable
              as AbstractImage?,
      activeResults: freezed == activeResults
          ? _value.activeResults
          : activeResults // ignore: cast_nullable_to_non_nullable
              as ConvexHullResults?,
      leftMenuEnum: null == leftMenuEnum
          ? _value.leftMenuEnum
          : leftMenuEnum // ignore: cast_nullable_to_non_nullable
              as LeftMenuEnum,
      overlaySearchPattern: null == overlaySearchPattern
          ? _value.overlaySearchPattern
          : overlaySearchPattern // ignore: cast_nullable_to_non_nullable
              as String,
      searchPatternProteinConfig: null == searchPatternProteinConfig
          ? _value._searchPatternProteinConfig
          : searchPatternProteinConfig // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      searchPatternOverlayConfig: null == searchPatternOverlayConfig
          ? _value._searchPatternOverlayConfig
          : searchPatternOverlayConfig // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      imageWidth: null == imageWidth
          ? _value.imageWidth
          : imageWidth // ignore: cast_nullable_to_non_nullable
              as double,
      imageHeight: null == imageHeight
          ? _value.imageHeight
          : imageHeight // ignore: cast_nullable_to_non_nullable
              as double,
      units: null == units
          ? _value.units
          : units // ignore: cast_nullable_to_non_nullable
              as String,
      channelNumber: null == channelNumber
          ? _value.channelNumber
          : channelNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class _$ConvexHullConfigModelImpl implements _ConvexHullConfigModel {
  const _$ConvexHullConfigModelImpl(
      {this.activeImageSetBaseName,
      this.activeImage,
      this.activeResults,
      this.leftMenuEnum = LeftMenuEnum.functionSettings,
      this.overlaySearchPattern = overlay,
      final Map<String, String> searchPatternProteinConfig = const {},
      final Map<String, bool> searchPatternOverlayConfig = const {},
      this.imageWidth = width,
      this.imageHeight = length,
      this.units = lengthScale,
      this.channelNumber = totalChannelNumber})
      : _searchPatternProteinConfig = searchPatternProteinConfig,
        _searchPatternOverlayConfig = searchPatternOverlayConfig;

  factory _$ConvexHullConfigModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConvexHullConfigModelImplFromJson(json);

  @override
  final String? activeImageSetBaseName;
  @override
  final AbstractImage? activeImage;
  @override
  final ConvexHullResults? activeResults;
  @override
  @JsonKey()
  final LeftMenuEnum leftMenuEnum;
  @override
  @JsonKey()
  final String overlaySearchPattern;
  final Map<String, String> _searchPatternProteinConfig;
  @override
  @JsonKey()
  Map<String, String> get searchPatternProteinConfig {
    if (_searchPatternProteinConfig is EqualUnmodifiableMapView)
      return _searchPatternProteinConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_searchPatternProteinConfig);
  }

  final Map<String, bool> _searchPatternOverlayConfig;
  @override
  @JsonKey()
  Map<String, bool> get searchPatternOverlayConfig {
    if (_searchPatternOverlayConfig is EqualUnmodifiableMapView)
      return _searchPatternOverlayConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_searchPatternOverlayConfig);
  }

  @override
  @JsonKey()
  final double imageWidth;
  @override
  @JsonKey()
  final double imageHeight;
  @override
  @JsonKey()
  final String units;
  @override
  @JsonKey()
  final int channelNumber;

  @override
  String toString() {
    return 'ConvexHullConfigModel(activeImageSetBaseName: $activeImageSetBaseName, activeImage: $activeImage, activeResults: $activeResults, leftMenuEnum: $leftMenuEnum, overlaySearchPattern: $overlaySearchPattern, searchPatternProteinConfig: $searchPatternProteinConfig, searchPatternOverlayConfig: $searchPatternOverlayConfig, imageWidth: $imageWidth, imageHeight: $imageHeight, units: $units, channelNumber: $channelNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConvexHullConfigModelImpl &&
            (identical(other.activeImageSetBaseName, activeImageSetBaseName) ||
                other.activeImageSetBaseName == activeImageSetBaseName) &&
            (identical(other.activeImage, activeImage) ||
                other.activeImage == activeImage) &&
            (identical(other.activeResults, activeResults) ||
                other.activeResults == activeResults) &&
            (identical(other.leftMenuEnum, leftMenuEnum) ||
                other.leftMenuEnum == leftMenuEnum) &&
            (identical(other.overlaySearchPattern, overlaySearchPattern) ||
                other.overlaySearchPattern == overlaySearchPattern) &&
            const DeepCollectionEquality().equals(
                other._searchPatternProteinConfig,
                _searchPatternProteinConfig) &&
            const DeepCollectionEquality().equals(
                other._searchPatternOverlayConfig,
                _searchPatternOverlayConfig) &&
            (identical(other.imageWidth, imageWidth) ||
                other.imageWidth == imageWidth) &&
            (identical(other.imageHeight, imageHeight) ||
                other.imageHeight == imageHeight) &&
            (identical(other.units, units) || other.units == units) &&
            (identical(other.channelNumber, channelNumber) ||
                other.channelNumber == channelNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      activeImageSetBaseName,
      activeImage,
      activeResults,
      leftMenuEnum,
      overlaySearchPattern,
      const DeepCollectionEquality().hash(_searchPatternProteinConfig),
      const DeepCollectionEquality().hash(_searchPatternOverlayConfig),
      imageWidth,
      imageHeight,
      units,
      channelNumber);

  /// Create a copy of ConvexHullConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConvexHullConfigModelImplCopyWith<_$ConvexHullConfigModelImpl>
      get copyWith => __$$ConvexHullConfigModelImplCopyWithImpl<
          _$ConvexHullConfigModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConvexHullConfigModelImplToJson(
      this,
    );
  }
}

abstract class _ConvexHullConfigModel implements ConvexHullConfigModel {
  const factory _ConvexHullConfigModel(
      {final String? activeImageSetBaseName,
      final AbstractImage? activeImage,
      final ConvexHullResults? activeResults,
      final LeftMenuEnum leftMenuEnum,
      final String overlaySearchPattern,
      final Map<String, String> searchPatternProteinConfig,
      final Map<String, bool> searchPatternOverlayConfig,
      final double imageWidth,
      final double imageHeight,
      final String units,
      final int channelNumber}) = _$ConvexHullConfigModelImpl;

  factory _ConvexHullConfigModel.fromJson(Map<String, dynamic> json) =
      _$ConvexHullConfigModelImpl.fromJson;

  @override
  String? get activeImageSetBaseName;
  @override
  AbstractImage? get activeImage;
  @override
  ConvexHullResults? get activeResults;
  @override
  LeftMenuEnum get leftMenuEnum;
  @override
  String get overlaySearchPattern;
  @override
  Map<String, String> get searchPatternProteinConfig;
  @override
  Map<String, bool> get searchPatternOverlayConfig;
  @override
  double get imageWidth;
  @override
  double get imageHeight;
  @override
  String get units;
  @override
  int get channelNumber;

  /// Create a copy of ConvexHullConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConvexHullConfigModelImplCopyWith<_$ConvexHullConfigModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
