// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Address _$AddressFromJson(Map<String, dynamic> json) {
  return _Address.fromJson(json);
}

/// @nodoc
mixin _$Address {
// Ligne d'adresse
  String? get streetNumber => throw _privateConstructorUsedError;
  String? get streetName => throw _privateConstructorUsedError;
  String? get streetLine1 => throw _privateConstructorUsedError;
  String? get streetLine2 => throw _privateConstructorUsedError;
  String? get building => throw _privateConstructorUsedError;
  String? get apartment => throw _privateConstructorUsedError;
  String? get floor => throw _privateConstructorUsedError; // Localisation
  String? get neighborhood => throw _privateConstructorUsedError; // Quartier
  String? get district =>
      throw _privateConstructorUsedError; // Arrondissement/Commune
  String get city => throw _privateConstructorUsedError;
  String? get region =>
      throw _privateConstructorUsedError; // Région/Département
  String? get postalCode => throw _privateConstructorUsedError;
  String? get poBox => throw _privateConstructorUsedError; // Boîte postale
  String get country =>
      throw _privateConstructorUsedError; // Repères (très important en Afrique)
  String? get landmark =>
      throw _privateConstructorUsedError; // Point de repère principal
  String? get nearbyLandmark => throw _privateConstructorUsedError;
  String? get directions =>
      throw _privateConstructorUsedError; // Coordonnées GPS
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError; // Métadonnées
  AddressType get type => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  DateTime? get verifiedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddressCopyWith<Address> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressCopyWith<$Res> {
  factory $AddressCopyWith(Address value, $Res Function(Address) then) =
      _$AddressCopyWithImpl<$Res, Address>;
  @useResult
  $Res call(
      {String? streetNumber,
      String? streetName,
      String? streetLine1,
      String? streetLine2,
      String? building,
      String? apartment,
      String? floor,
      String? neighborhood,
      String? district,
      String city,
      String? region,
      String? postalCode,
      String? poBox,
      String country,
      String? landmark,
      String? nearbyLandmark,
      String? directions,
      double? latitude,
      double? longitude,
      AddressType type,
      bool isVerified,
      DateTime? verifiedAt});
}

/// @nodoc
class _$AddressCopyWithImpl<$Res, $Val extends Address>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streetNumber = freezed,
    Object? streetName = freezed,
    Object? streetLine1 = freezed,
    Object? streetLine2 = freezed,
    Object? building = freezed,
    Object? apartment = freezed,
    Object? floor = freezed,
    Object? neighborhood = freezed,
    Object? district = freezed,
    Object? city = null,
    Object? region = freezed,
    Object? postalCode = freezed,
    Object? poBox = freezed,
    Object? country = null,
    Object? landmark = freezed,
    Object? nearbyLandmark = freezed,
    Object? directions = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? type = null,
    Object? isVerified = null,
    Object? verifiedAt = freezed,
  }) {
    return _then(_value.copyWith(
      streetNumber: freezed == streetNumber
          ? _value.streetNumber
          : streetNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      streetName: freezed == streetName
          ? _value.streetName
          : streetName // ignore: cast_nullable_to_non_nullable
              as String?,
      streetLine1: freezed == streetLine1
          ? _value.streetLine1
          : streetLine1 // ignore: cast_nullable_to_non_nullable
              as String?,
      streetLine2: freezed == streetLine2
          ? _value.streetLine2
          : streetLine2 // ignore: cast_nullable_to_non_nullable
              as String?,
      building: freezed == building
          ? _value.building
          : building // ignore: cast_nullable_to_non_nullable
              as String?,
      apartment: freezed == apartment
          ? _value.apartment
          : apartment // ignore: cast_nullable_to_non_nullable
              as String?,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as String?,
      neighborhood: freezed == neighborhood
          ? _value.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String?,
      district: freezed == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      poBox: freezed == poBox
          ? _value.poBox
          : poBox // ignore: cast_nullable_to_non_nullable
              as String?,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
      nearbyLandmark: freezed == nearbyLandmark
          ? _value.nearbyLandmark
          : nearbyLandmark // ignore: cast_nullable_to_non_nullable
              as String?,
      directions: freezed == directions
          ? _value.directions
          : directions // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AddressType,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressImplCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$$AddressImplCopyWith(
          _$AddressImpl value, $Res Function(_$AddressImpl) then) =
      __$$AddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? streetNumber,
      String? streetName,
      String? streetLine1,
      String? streetLine2,
      String? building,
      String? apartment,
      String? floor,
      String? neighborhood,
      String? district,
      String city,
      String? region,
      String? postalCode,
      String? poBox,
      String country,
      String? landmark,
      String? nearbyLandmark,
      String? directions,
      double? latitude,
      double? longitude,
      AddressType type,
      bool isVerified,
      DateTime? verifiedAt});
}

/// @nodoc
class __$$AddressImplCopyWithImpl<$Res>
    extends _$AddressCopyWithImpl<$Res, _$AddressImpl>
    implements _$$AddressImplCopyWith<$Res> {
  __$$AddressImplCopyWithImpl(
      _$AddressImpl _value, $Res Function(_$AddressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streetNumber = freezed,
    Object? streetName = freezed,
    Object? streetLine1 = freezed,
    Object? streetLine2 = freezed,
    Object? building = freezed,
    Object? apartment = freezed,
    Object? floor = freezed,
    Object? neighborhood = freezed,
    Object? district = freezed,
    Object? city = null,
    Object? region = freezed,
    Object? postalCode = freezed,
    Object? poBox = freezed,
    Object? country = null,
    Object? landmark = freezed,
    Object? nearbyLandmark = freezed,
    Object? directions = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? type = null,
    Object? isVerified = null,
    Object? verifiedAt = freezed,
  }) {
    return _then(_$AddressImpl(
      streetNumber: freezed == streetNumber
          ? _value.streetNumber
          : streetNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      streetName: freezed == streetName
          ? _value.streetName
          : streetName // ignore: cast_nullable_to_non_nullable
              as String?,
      streetLine1: freezed == streetLine1
          ? _value.streetLine1
          : streetLine1 // ignore: cast_nullable_to_non_nullable
              as String?,
      streetLine2: freezed == streetLine2
          ? _value.streetLine2
          : streetLine2 // ignore: cast_nullable_to_non_nullable
              as String?,
      building: freezed == building
          ? _value.building
          : building // ignore: cast_nullable_to_non_nullable
              as String?,
      apartment: freezed == apartment
          ? _value.apartment
          : apartment // ignore: cast_nullable_to_non_nullable
              as String?,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as String?,
      neighborhood: freezed == neighborhood
          ? _value.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String?,
      district: freezed == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      poBox: freezed == poBox
          ? _value.poBox
          : poBox // ignore: cast_nullable_to_non_nullable
              as String?,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
      nearbyLandmark: freezed == nearbyLandmark
          ? _value.nearbyLandmark
          : nearbyLandmark // ignore: cast_nullable_to_non_nullable
              as String?,
      directions: freezed == directions
          ? _value.directions
          : directions // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AddressType,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      verifiedAt: freezed == verifiedAt
          ? _value.verifiedAt
          : verifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressImpl extends _Address {
  const _$AddressImpl(
      {this.streetNumber,
      this.streetName,
      this.streetLine1,
      this.streetLine2,
      this.building,
      this.apartment,
      this.floor,
      this.neighborhood,
      this.district,
      required this.city,
      this.region,
      this.postalCode,
      this.poBox,
      this.country = 'Côte d\'Ivoire',
      this.landmark,
      this.nearbyLandmark,
      this.directions,
      this.latitude,
      this.longitude,
      this.type = AddressType.home,
      this.isVerified = false,
      this.verifiedAt})
      : super._();

  factory _$AddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressImplFromJson(json);

// Ligne d'adresse
  @override
  final String? streetNumber;
  @override
  final String? streetName;
  @override
  final String? streetLine1;
  @override
  final String? streetLine2;
  @override
  final String? building;
  @override
  final String? apartment;
  @override
  final String? floor;
// Localisation
  @override
  final String? neighborhood;
// Quartier
  @override
  final String? district;
// Arrondissement/Commune
  @override
  final String city;
  @override
  final String? region;
// Région/Département
  @override
  final String? postalCode;
  @override
  final String? poBox;
// Boîte postale
  @override
  @JsonKey()
  final String country;
// Repères (très important en Afrique)
  @override
  final String? landmark;
// Point de repère principal
  @override
  final String? nearbyLandmark;
  @override
  final String? directions;
// Coordonnées GPS
  @override
  final double? latitude;
  @override
  final double? longitude;
// Métadonnées
  @override
  @JsonKey()
  final AddressType type;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final DateTime? verifiedAt;

  @override
  String toString() {
    return 'Address(streetNumber: $streetNumber, streetName: $streetName, streetLine1: $streetLine1, streetLine2: $streetLine2, building: $building, apartment: $apartment, floor: $floor, neighborhood: $neighborhood, district: $district, city: $city, region: $region, postalCode: $postalCode, poBox: $poBox, country: $country, landmark: $landmark, nearbyLandmark: $nearbyLandmark, directions: $directions, latitude: $latitude, longitude: $longitude, type: $type, isVerified: $isVerified, verifiedAt: $verifiedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressImpl &&
            (identical(other.streetNumber, streetNumber) ||
                other.streetNumber == streetNumber) &&
            (identical(other.streetName, streetName) ||
                other.streetName == streetName) &&
            (identical(other.streetLine1, streetLine1) ||
                other.streetLine1 == streetLine1) &&
            (identical(other.streetLine2, streetLine2) ||
                other.streetLine2 == streetLine2) &&
            (identical(other.building, building) ||
                other.building == building) &&
            (identical(other.apartment, apartment) ||
                other.apartment == apartment) &&
            (identical(other.floor, floor) || other.floor == floor) &&
            (identical(other.neighborhood, neighborhood) ||
                other.neighborhood == neighborhood) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.poBox, poBox) || other.poBox == poBox) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.landmark, landmark) ||
                other.landmark == landmark) &&
            (identical(other.nearbyLandmark, nearbyLandmark) ||
                other.nearbyLandmark == nearbyLandmark) &&
            (identical(other.directions, directions) ||
                other.directions == directions) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        streetNumber,
        streetName,
        streetLine1,
        streetLine2,
        building,
        apartment,
        floor,
        neighborhood,
        district,
        city,
        region,
        postalCode,
        poBox,
        country,
        landmark,
        nearbyLandmark,
        directions,
        latitude,
        longitude,
        type,
        isVerified,
        verifiedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      __$$AddressImplCopyWithImpl<_$AddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressImplToJson(
      this,
    );
  }
}

abstract class _Address extends Address {
  const factory _Address(
      {final String? streetNumber,
      final String? streetName,
      final String? streetLine1,
      final String? streetLine2,
      final String? building,
      final String? apartment,
      final String? floor,
      final String? neighborhood,
      final String? district,
      required final String city,
      final String? region,
      final String? postalCode,
      final String? poBox,
      final String country,
      final String? landmark,
      final String? nearbyLandmark,
      final String? directions,
      final double? latitude,
      final double? longitude,
      final AddressType type,
      final bool isVerified,
      final DateTime? verifiedAt}) = _$AddressImpl;
  const _Address._() : super._();

  factory _Address.fromJson(Map<String, dynamic> json) = _$AddressImpl.fromJson;

  @override // Ligne d'adresse
  String? get streetNumber;
  @override
  String? get streetName;
  @override
  String? get streetLine1;
  @override
  String? get streetLine2;
  @override
  String? get building;
  @override
  String? get apartment;
  @override
  String? get floor;
  @override // Localisation
  String? get neighborhood;
  @override // Quartier
  String? get district;
  @override // Arrondissement/Commune
  String get city;
  @override
  String? get region;
  @override // Région/Département
  String? get postalCode;
  @override
  String? get poBox;
  @override // Boîte postale
  String get country;
  @override // Repères (très important en Afrique)
  String? get landmark;
  @override // Point de repère principal
  String? get nearbyLandmark;
  @override
  String? get directions;
  @override // Coordonnées GPS
  double? get latitude;
  @override
  double? get longitude;
  @override // Métadonnées
  AddressType get type;
  @override
  bool get isVerified;
  @override
  DateTime? get verifiedAt;
  @override
  @JsonKey(ignore: true)
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
