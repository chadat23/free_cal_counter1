// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_database.dart';

// ignore_for_file: type=lint
class $FoodsTable extends Foods with TableInfo<$FoodsTable, Food> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesPer100gMeta = const VerificationMeta(
    'caloriesPer100g',
  );
  @override
  late final GeneratedColumn<double> caloriesPer100g = GeneratedColumn<double>(
    'calories_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinPer100gMeta = const VerificationMeta(
    'proteinPer100g',
  );
  @override
  late final GeneratedColumn<double> proteinPer100g = GeneratedColumn<double>(
    'protein_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatPer100gMeta = const VerificationMeta(
    'fatPer100g',
  );
  @override
  late final GeneratedColumn<double> fatPer100g = GeneratedColumn<double>(
    'fat_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsPer100gMeta = const VerificationMeta(
    'carbsPer100g',
  );
  @override
  late final GeneratedColumn<double> carbsPer100g = GeneratedColumn<double>(
    'carbs_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberPer100gMeta = const VerificationMeta(
    'fiberPer100g',
  );
  @override
  late final GeneratedColumn<double> fiberPer100g = GeneratedColumn<double>(
    'fiber_per100g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceFdcIdMeta = const VerificationMeta(
    'sourceFdcId',
  );
  @override
  late final GeneratedColumn<int> sourceFdcId = GeneratedColumn<int>(
    'source_fdc_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceBarcodeMeta = const VerificationMeta(
    'sourceBarcode',
  );
  @override
  late final GeneratedColumn<String> sourceBarcode = GeneratedColumn<String>(
    'source_barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("hidden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    source,
    imageUrl,
    caloriesPer100g,
    proteinPer100g,
    fatPer100g,
    carbsPer100g,
    fiberPer100g,
    sourceFdcId,
    sourceBarcode,
    hidden,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Food> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('calories_per100g')) {
      context.handle(
        _caloriesPer100gMeta,
        caloriesPer100g.isAcceptableOrUnknown(
          data['calories_per100g']!,
          _caloriesPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesPer100gMeta);
    }
    if (data.containsKey('protein_per100g')) {
      context.handle(
        _proteinPer100gMeta,
        proteinPer100g.isAcceptableOrUnknown(
          data['protein_per100g']!,
          _proteinPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinPer100gMeta);
    }
    if (data.containsKey('fat_per100g')) {
      context.handle(
        _fatPer100gMeta,
        fatPer100g.isAcceptableOrUnknown(data['fat_per100g']!, _fatPer100gMeta),
      );
    } else if (isInserting) {
      context.missing(_fatPer100gMeta);
    }
    if (data.containsKey('carbs_per100g')) {
      context.handle(
        _carbsPer100gMeta,
        carbsPer100g.isAcceptableOrUnknown(
          data['carbs_per100g']!,
          _carbsPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carbsPer100gMeta);
    }
    if (data.containsKey('fiber_per100g')) {
      context.handle(
        _fiberPer100gMeta,
        fiberPer100g.isAcceptableOrUnknown(
          data['fiber_per100g']!,
          _fiberPer100gMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fiberPer100gMeta);
    }
    if (data.containsKey('source_fdc_id')) {
      context.handle(
        _sourceFdcIdMeta,
        sourceFdcId.isAcceptableOrUnknown(
          data['source_fdc_id']!,
          _sourceFdcIdMeta,
        ),
      );
    }
    if (data.containsKey('source_barcode')) {
      context.handle(
        _sourceBarcodeMeta,
        sourceBarcode.isAcceptableOrUnknown(
          data['source_barcode']!,
          _sourceBarcodeMeta,
        ),
      );
    }
    if (data.containsKey('hidden')) {
      context.handle(
        _hiddenMeta,
        hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Food map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Food(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      caloriesPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_per100g'],
      )!,
      proteinPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_per100g'],
      )!,
      fatPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_per100g'],
      )!,
      carbsPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_per100g'],
      )!,
      fiberPer100g: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_per100g'],
      )!,
      sourceFdcId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_fdc_id'],
      ),
      sourceBarcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_barcode'],
      ),
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hidden'],
      )!,
    );
  }

  @override
  $FoodsTable createAlias(String alias) {
    return $FoodsTable(attachedDatabase, alias);
  }
}

class Food extends DataClass implements Insertable<Food> {
  final int id;
  final String name;
  final String source;
  final String? imageUrl;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double fatPer100g;
  final double carbsPer100g;
  final double fiberPer100g;
  final int? sourceFdcId;
  final String? sourceBarcode;
  final bool hidden;
  const Food({
    required this.id,
    required this.name,
    required this.source,
    this.imageUrl,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.fatPer100g,
    required this.carbsPer100g,
    required this.fiberPer100g,
    this.sourceFdcId,
    this.sourceBarcode,
    required this.hidden,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['calories_per100g'] = Variable<double>(caloriesPer100g);
    map['protein_per100g'] = Variable<double>(proteinPer100g);
    map['fat_per100g'] = Variable<double>(fatPer100g);
    map['carbs_per100g'] = Variable<double>(carbsPer100g);
    map['fiber_per100g'] = Variable<double>(fiberPer100g);
    if (!nullToAbsent || sourceFdcId != null) {
      map['source_fdc_id'] = Variable<int>(sourceFdcId);
    }
    if (!nullToAbsent || sourceBarcode != null) {
      map['source_barcode'] = Variable<String>(sourceBarcode);
    }
    map['hidden'] = Variable<bool>(hidden);
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      id: Value(id),
      name: Value(name),
      source: Value(source),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      caloriesPer100g: Value(caloriesPer100g),
      proteinPer100g: Value(proteinPer100g),
      fatPer100g: Value(fatPer100g),
      carbsPer100g: Value(carbsPer100g),
      fiberPer100g: Value(fiberPer100g),
      sourceFdcId: sourceFdcId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceFdcId),
      sourceBarcode: sourceBarcode == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceBarcode),
      hidden: Value(hidden),
    );
  }

  factory Food.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Food(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      source: serializer.fromJson<String>(json['source']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      caloriesPer100g: serializer.fromJson<double>(json['caloriesPer100g']),
      proteinPer100g: serializer.fromJson<double>(json['proteinPer100g']),
      fatPer100g: serializer.fromJson<double>(json['fatPer100g']),
      carbsPer100g: serializer.fromJson<double>(json['carbsPer100g']),
      fiberPer100g: serializer.fromJson<double>(json['fiberPer100g']),
      sourceFdcId: serializer.fromJson<int?>(json['sourceFdcId']),
      sourceBarcode: serializer.fromJson<String?>(json['sourceBarcode']),
      hidden: serializer.fromJson<bool>(json['hidden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'source': serializer.toJson<String>(source),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'caloriesPer100g': serializer.toJson<double>(caloriesPer100g),
      'proteinPer100g': serializer.toJson<double>(proteinPer100g),
      'fatPer100g': serializer.toJson<double>(fatPer100g),
      'carbsPer100g': serializer.toJson<double>(carbsPer100g),
      'fiberPer100g': serializer.toJson<double>(fiberPer100g),
      'sourceFdcId': serializer.toJson<int?>(sourceFdcId),
      'sourceBarcode': serializer.toJson<String?>(sourceBarcode),
      'hidden': serializer.toJson<bool>(hidden),
    };
  }

  Food copyWith({
    int? id,
    String? name,
    String? source,
    Value<String?> imageUrl = const Value.absent(),
    double? caloriesPer100g,
    double? proteinPer100g,
    double? fatPer100g,
    double? carbsPer100g,
    double? fiberPer100g,
    Value<int?> sourceFdcId = const Value.absent(),
    Value<String?> sourceBarcode = const Value.absent(),
    bool? hidden,
  }) => Food(
    id: id ?? this.id,
    name: name ?? this.name,
    source: source ?? this.source,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
    proteinPer100g: proteinPer100g ?? this.proteinPer100g,
    fatPer100g: fatPer100g ?? this.fatPer100g,
    carbsPer100g: carbsPer100g ?? this.carbsPer100g,
    fiberPer100g: fiberPer100g ?? this.fiberPer100g,
    sourceFdcId: sourceFdcId.present ? sourceFdcId.value : this.sourceFdcId,
    sourceBarcode: sourceBarcode.present
        ? sourceBarcode.value
        : this.sourceBarcode,
    hidden: hidden ?? this.hidden,
  );
  Food copyWithCompanion(FoodsCompanion data) {
    return Food(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      source: data.source.present ? data.source.value : this.source,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      caloriesPer100g: data.caloriesPer100g.present
          ? data.caloriesPer100g.value
          : this.caloriesPer100g,
      proteinPer100g: data.proteinPer100g.present
          ? data.proteinPer100g.value
          : this.proteinPer100g,
      fatPer100g: data.fatPer100g.present
          ? data.fatPer100g.value
          : this.fatPer100g,
      carbsPer100g: data.carbsPer100g.present
          ? data.carbsPer100g.value
          : this.carbsPer100g,
      fiberPer100g: data.fiberPer100g.present
          ? data.fiberPer100g.value
          : this.fiberPer100g,
      sourceFdcId: data.sourceFdcId.present
          ? data.sourceFdcId.value
          : this.sourceFdcId,
      sourceBarcode: data.sourceBarcode.present
          ? data.sourceBarcode.value
          : this.sourceBarcode,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Food(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('source: $source, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('fatPer100g: $fatPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fiberPer100g: $fiberPer100g, ')
          ..write('sourceFdcId: $sourceFdcId, ')
          ..write('sourceBarcode: $sourceBarcode, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    source,
    imageUrl,
    caloriesPer100g,
    proteinPer100g,
    fatPer100g,
    carbsPer100g,
    fiberPer100g,
    sourceFdcId,
    sourceBarcode,
    hidden,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Food &&
          other.id == this.id &&
          other.name == this.name &&
          other.source == this.source &&
          other.imageUrl == this.imageUrl &&
          other.caloriesPer100g == this.caloriesPer100g &&
          other.proteinPer100g == this.proteinPer100g &&
          other.fatPer100g == this.fatPer100g &&
          other.carbsPer100g == this.carbsPer100g &&
          other.fiberPer100g == this.fiberPer100g &&
          other.sourceFdcId == this.sourceFdcId &&
          other.sourceBarcode == this.sourceBarcode &&
          other.hidden == this.hidden);
}

class FoodsCompanion extends UpdateCompanion<Food> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> source;
  final Value<String?> imageUrl;
  final Value<double> caloriesPer100g;
  final Value<double> proteinPer100g;
  final Value<double> fatPer100g;
  final Value<double> carbsPer100g;
  final Value<double> fiberPer100g;
  final Value<int?> sourceFdcId;
  final Value<String?> sourceBarcode;
  final Value<bool> hidden;
  const FoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.source = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.caloriesPer100g = const Value.absent(),
    this.proteinPer100g = const Value.absent(),
    this.fatPer100g = const Value.absent(),
    this.carbsPer100g = const Value.absent(),
    this.fiberPer100g = const Value.absent(),
    this.sourceFdcId = const Value.absent(),
    this.sourceBarcode = const Value.absent(),
    this.hidden = const Value.absent(),
  });
  FoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String source,
    this.imageUrl = const Value.absent(),
    required double caloriesPer100g,
    required double proteinPer100g,
    required double fatPer100g,
    required double carbsPer100g,
    required double fiberPer100g,
    this.sourceFdcId = const Value.absent(),
    this.sourceBarcode = const Value.absent(),
    this.hidden = const Value.absent(),
  }) : name = Value(name),
       source = Value(source),
       caloriesPer100g = Value(caloriesPer100g),
       proteinPer100g = Value(proteinPer100g),
       fatPer100g = Value(fatPer100g),
       carbsPer100g = Value(carbsPer100g),
       fiberPer100g = Value(fiberPer100g);
  static Insertable<Food> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? source,
    Expression<String>? imageUrl,
    Expression<double>? caloriesPer100g,
    Expression<double>? proteinPer100g,
    Expression<double>? fatPer100g,
    Expression<double>? carbsPer100g,
    Expression<double>? fiberPer100g,
    Expression<int>? sourceFdcId,
    Expression<String>? sourceBarcode,
    Expression<bool>? hidden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (source != null) 'source': source,
      if (imageUrl != null) 'image_url': imageUrl,
      if (caloriesPer100g != null) 'calories_per100g': caloriesPer100g,
      if (proteinPer100g != null) 'protein_per100g': proteinPer100g,
      if (fatPer100g != null) 'fat_per100g': fatPer100g,
      if (carbsPer100g != null) 'carbs_per100g': carbsPer100g,
      if (fiberPer100g != null) 'fiber_per100g': fiberPer100g,
      if (sourceFdcId != null) 'source_fdc_id': sourceFdcId,
      if (sourceBarcode != null) 'source_barcode': sourceBarcode,
      if (hidden != null) 'hidden': hidden,
    });
  }

  FoodsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? source,
    Value<String?>? imageUrl,
    Value<double>? caloriesPer100g,
    Value<double>? proteinPer100g,
    Value<double>? fatPer100g,
    Value<double>? carbsPer100g,
    Value<double>? fiberPer100g,
    Value<int?>? sourceFdcId,
    Value<String?>? sourceBarcode,
    Value<bool>? hidden,
  }) {
    return FoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      imageUrl: imageUrl ?? this.imageUrl,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      proteinPer100g: proteinPer100g ?? this.proteinPer100g,
      fatPer100g: fatPer100g ?? this.fatPer100g,
      carbsPer100g: carbsPer100g ?? this.carbsPer100g,
      fiberPer100g: fiberPer100g ?? this.fiberPer100g,
      sourceFdcId: sourceFdcId ?? this.sourceFdcId,
      sourceBarcode: sourceBarcode ?? this.sourceBarcode,
      hidden: hidden ?? this.hidden,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (caloriesPer100g.present) {
      map['calories_per100g'] = Variable<double>(caloriesPer100g.value);
    }
    if (proteinPer100g.present) {
      map['protein_per100g'] = Variable<double>(proteinPer100g.value);
    }
    if (fatPer100g.present) {
      map['fat_per100g'] = Variable<double>(fatPer100g.value);
    }
    if (carbsPer100g.present) {
      map['carbs_per100g'] = Variable<double>(carbsPer100g.value);
    }
    if (fiberPer100g.present) {
      map['fiber_per100g'] = Variable<double>(fiberPer100g.value);
    }
    if (sourceFdcId.present) {
      map['source_fdc_id'] = Variable<int>(sourceFdcId.value);
    }
    if (sourceBarcode.present) {
      map['source_barcode'] = Variable<String>(sourceBarcode.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('source: $source, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('caloriesPer100g: $caloriesPer100g, ')
          ..write('proteinPer100g: $proteinPer100g, ')
          ..write('fatPer100g: $fatPer100g, ')
          ..write('carbsPer100g: $carbsPer100g, ')
          ..write('fiberPer100g: $fiberPer100g, ')
          ..write('sourceFdcId: $sourceFdcId, ')
          ..write('sourceBarcode: $sourceBarcode, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }
}

class $FoodUnitsTable extends FoodUnits
    with TableInfo<$FoodUnitsTable, FoodUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES foods (id)',
    ),
  );
  static const VerificationMeta _unitNameMeta = const VerificationMeta(
    'unitName',
  );
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
    'unit_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gramsPerUnitMeta = const VerificationMeta(
    'gramsPerUnit',
  );
  @override
  late final GeneratedColumn<double> gramsPerUnit = GeneratedColumn<double>(
    'grams_per_unit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, foodId, unitName, gramsPerUnit];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_units';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodUnit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('unit_name')) {
      context.handle(
        _unitNameMeta,
        unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta),
      );
    } else if (isInserting) {
      context.missing(_unitNameMeta);
    }
    if (data.containsKey('grams_per_unit')) {
      context.handle(
        _gramsPerUnitMeta,
        gramsPerUnit.isAcceptableOrUnknown(
          data['grams_per_unit']!,
          _gramsPerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gramsPerUnitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodUnit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      )!,
      unitName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_name'],
      )!,
      gramsPerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grams_per_unit'],
      )!,
    );
  }

  @override
  $FoodUnitsTable createAlias(String alias) {
    return $FoodUnitsTable(attachedDatabase, alias);
  }
}

class FoodUnit extends DataClass implements Insertable<FoodUnit> {
  final int id;
  final int foodId;
  final String unitName;
  final double gramsPerUnit;
  const FoodUnit({
    required this.id,
    required this.foodId,
    required this.unitName,
    required this.gramsPerUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['food_id'] = Variable<int>(foodId);
    map['unit_name'] = Variable<String>(unitName);
    map['grams_per_unit'] = Variable<double>(gramsPerUnit);
    return map;
  }

  FoodUnitsCompanion toCompanion(bool nullToAbsent) {
    return FoodUnitsCompanion(
      id: Value(id),
      foodId: Value(foodId),
      unitName: Value(unitName),
      gramsPerUnit: Value(gramsPerUnit),
    );
  }

  factory FoodUnit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodUnit(
      id: serializer.fromJson<int>(json['id']),
      foodId: serializer.fromJson<int>(json['foodId']),
      unitName: serializer.fromJson<String>(json['unitName']),
      gramsPerUnit: serializer.fromJson<double>(json['gramsPerUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'foodId': serializer.toJson<int>(foodId),
      'unitName': serializer.toJson<String>(unitName),
      'gramsPerUnit': serializer.toJson<double>(gramsPerUnit),
    };
  }

  FoodUnit copyWith({
    int? id,
    int? foodId,
    String? unitName,
    double? gramsPerUnit,
  }) => FoodUnit(
    id: id ?? this.id,
    foodId: foodId ?? this.foodId,
    unitName: unitName ?? this.unitName,
    gramsPerUnit: gramsPerUnit ?? this.gramsPerUnit,
  );
  FoodUnit copyWithCompanion(FoodUnitsCompanion data) {
    return FoodUnit(
      id: data.id.present ? data.id.value : this.id,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
      gramsPerUnit: data.gramsPerUnit.present
          ? data.gramsPerUnit.value
          : this.gramsPerUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodUnit(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('unitName: $unitName, ')
          ..write('gramsPerUnit: $gramsPerUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, foodId, unitName, gramsPerUnit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodUnit &&
          other.id == this.id &&
          other.foodId == this.foodId &&
          other.unitName == this.unitName &&
          other.gramsPerUnit == this.gramsPerUnit);
}

class FoodUnitsCompanion extends UpdateCompanion<FoodUnit> {
  final Value<int> id;
  final Value<int> foodId;
  final Value<String> unitName;
  final Value<double> gramsPerUnit;
  const FoodUnitsCompanion({
    this.id = const Value.absent(),
    this.foodId = const Value.absent(),
    this.unitName = const Value.absent(),
    this.gramsPerUnit = const Value.absent(),
  });
  FoodUnitsCompanion.insert({
    this.id = const Value.absent(),
    required int foodId,
    required String unitName,
    required double gramsPerUnit,
  }) : foodId = Value(foodId),
       unitName = Value(unitName),
       gramsPerUnit = Value(gramsPerUnit);
  static Insertable<FoodUnit> custom({
    Expression<int>? id,
    Expression<int>? foodId,
    Expression<String>? unitName,
    Expression<double>? gramsPerUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodId != null) 'food_id': foodId,
      if (unitName != null) 'unit_name': unitName,
      if (gramsPerUnit != null) 'grams_per_unit': gramsPerUnit,
    });
  }

  FoodUnitsCompanion copyWith({
    Value<int>? id,
    Value<int>? foodId,
    Value<String>? unitName,
    Value<double>? gramsPerUnit,
  }) {
    return FoodUnitsCompanion(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      unitName: unitName ?? this.unitName,
      gramsPerUnit: gramsPerUnit ?? this.gramsPerUnit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    if (gramsPerUnit.present) {
      map['grams_per_unit'] = Variable<double>(gramsPerUnit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodUnitsCompanion(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('unitName: $unitName, ')
          ..write('gramsPerUnit: $gramsPerUnit')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingsCreatedMeta = const VerificationMeta(
    'servingsCreated',
  );
  @override
  late final GeneratedColumn<double> servingsCreated = GeneratedColumn<double>(
    'servings_created',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finalWeightGramsMeta = const VerificationMeta(
    'finalWeightGrams',
  );
  @override
  late final GeneratedColumn<double> finalWeightGrams = GeneratedColumn<double>(
    'final_weight_grams',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
    'hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("hidden" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    servingsCreated,
    finalWeightGrams,
    notes,
    hidden,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('servings_created')) {
      context.handle(
        _servingsCreatedMeta,
        servingsCreated.isAcceptableOrUnknown(
          data['servings_created']!,
          _servingsCreatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_servingsCreatedMeta);
    }
    if (data.containsKey('final_weight_grams')) {
      context.handle(
        _finalWeightGramsMeta,
        finalWeightGrams.isAcceptableOrUnknown(
          data['final_weight_grams']!,
          _finalWeightGramsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('hidden')) {
      context.handle(
        _hiddenMeta,
        hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      servingsCreated: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}servings_created'],
      )!,
      finalWeightGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}final_weight_grams'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      hidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}hidden'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final int id;
  final String name;
  final double servingsCreated;
  final double? finalWeightGrams;
  final String? notes;
  final bool hidden;
  const Recipe({
    required this.id,
    required this.name,
    required this.servingsCreated,
    this.finalWeightGrams,
    this.notes,
    required this.hidden,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['servings_created'] = Variable<double>(servingsCreated);
    if (!nullToAbsent || finalWeightGrams != null) {
      map['final_weight_grams'] = Variable<double>(finalWeightGrams);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['hidden'] = Variable<bool>(hidden);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      servingsCreated: Value(servingsCreated),
      finalWeightGrams: finalWeightGrams == null && nullToAbsent
          ? const Value.absent()
          : Value(finalWeightGrams),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      hidden: Value(hidden),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      servingsCreated: serializer.fromJson<double>(json['servingsCreated']),
      finalWeightGrams: serializer.fromJson<double?>(json['finalWeightGrams']),
      notes: serializer.fromJson<String?>(json['notes']),
      hidden: serializer.fromJson<bool>(json['hidden']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'servingsCreated': serializer.toJson<double>(servingsCreated),
      'finalWeightGrams': serializer.toJson<double?>(finalWeightGrams),
      'notes': serializer.toJson<String?>(notes),
      'hidden': serializer.toJson<bool>(hidden),
    };
  }

  Recipe copyWith({
    int? id,
    String? name,
    double? servingsCreated,
    Value<double?> finalWeightGrams = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? hidden,
  }) => Recipe(
    id: id ?? this.id,
    name: name ?? this.name,
    servingsCreated: servingsCreated ?? this.servingsCreated,
    finalWeightGrams: finalWeightGrams.present
        ? finalWeightGrams.value
        : this.finalWeightGrams,
    notes: notes.present ? notes.value : this.notes,
    hidden: hidden ?? this.hidden,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      servingsCreated: data.servingsCreated.present
          ? data.servingsCreated.value
          : this.servingsCreated,
      finalWeightGrams: data.finalWeightGrams.present
          ? data.finalWeightGrams.value
          : this.finalWeightGrams,
      notes: data.notes.present ? data.notes.value : this.notes,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('servingsCreated: $servingsCreated, ')
          ..write('finalWeightGrams: $finalWeightGrams, ')
          ..write('notes: $notes, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, servingsCreated, finalWeightGrams, notes, hidden);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.name == this.name &&
          other.servingsCreated == this.servingsCreated &&
          other.finalWeightGrams == this.finalWeightGrams &&
          other.notes == this.notes &&
          other.hidden == this.hidden);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> servingsCreated;
  final Value<double?> finalWeightGrams;
  final Value<String?> notes;
  final Value<bool> hidden;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.servingsCreated = const Value.absent(),
    this.finalWeightGrams = const Value.absent(),
    this.notes = const Value.absent(),
    this.hidden = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double servingsCreated,
    this.finalWeightGrams = const Value.absent(),
    this.notes = const Value.absent(),
    this.hidden = const Value.absent(),
  }) : name = Value(name),
       servingsCreated = Value(servingsCreated);
  static Insertable<Recipe> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? servingsCreated,
    Expression<double>? finalWeightGrams,
    Expression<String>? notes,
    Expression<bool>? hidden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (servingsCreated != null) 'servings_created': servingsCreated,
      if (finalWeightGrams != null) 'final_weight_grams': finalWeightGrams,
      if (notes != null) 'notes': notes,
      if (hidden != null) 'hidden': hidden,
    });
  }

  RecipesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<double>? servingsCreated,
    Value<double?>? finalWeightGrams,
    Value<String?>? notes,
    Value<bool>? hidden,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      servingsCreated: servingsCreated ?? this.servingsCreated,
      finalWeightGrams: finalWeightGrams ?? this.finalWeightGrams,
      notes: notes ?? this.notes,
      hidden: hidden ?? this.hidden,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (servingsCreated.present) {
      map['servings_created'] = Variable<double>(servingsCreated.value);
    }
    if (finalWeightGrams.present) {
      map['final_weight_grams'] = Variable<double>(finalWeightGrams.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('servingsCreated: $servingsCreated, ')
          ..write('finalWeightGrams: $finalWeightGrams, ')
          ..write('notes: $notes, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }
}

class $RecipeItemsTable extends RecipeItems
    with TableInfo<$RecipeItemsTable, RecipeItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _ingredientFoodIdMeta = const VerificationMeta(
    'ingredientFoodId',
  );
  @override
  late final GeneratedColumn<int> ingredientFoodId = GeneratedColumn<int>(
    'ingredient_food_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES foods (id)',
    ),
  );
  static const VerificationMeta _ingredientRecipeIdMeta =
      const VerificationMeta('ingredientRecipeId');
  @override
  late final GeneratedColumn<int> ingredientRecipeId = GeneratedColumn<int>(
    'ingredient_recipe_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitNameMeta = const VerificationMeta(
    'unitName',
  );
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
    'unit_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    ingredientFoodId,
    ingredientRecipeId,
    quantity,
    unitName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('ingredient_food_id')) {
      context.handle(
        _ingredientFoodIdMeta,
        ingredientFoodId.isAcceptableOrUnknown(
          data['ingredient_food_id']!,
          _ingredientFoodIdMeta,
        ),
      );
    }
    if (data.containsKey('ingredient_recipe_id')) {
      context.handle(
        _ingredientRecipeIdMeta,
        ingredientRecipeId.isAcceptableOrUnknown(
          data['ingredient_recipe_id']!,
          _ingredientRecipeIdMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_name')) {
      context.handle(
        _unitNameMeta,
        unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta),
      );
    } else if (isInserting) {
      context.missing(_unitNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      ingredientFoodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingredient_food_id'],
      ),
      ingredientRecipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ingredient_recipe_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_name'],
      )!,
    );
  }

  @override
  $RecipeItemsTable createAlias(String alias) {
    return $RecipeItemsTable(attachedDatabase, alias);
  }
}

class RecipeItem extends DataClass implements Insertable<RecipeItem> {
  final int id;
  final int recipeId;
  final int? ingredientFoodId;
  final int? ingredientRecipeId;
  final double quantity;
  final String unitName;
  const RecipeItem({
    required this.id,
    required this.recipeId,
    this.ingredientFoodId,
    this.ingredientRecipeId,
    required this.quantity,
    required this.unitName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    if (!nullToAbsent || ingredientFoodId != null) {
      map['ingredient_food_id'] = Variable<int>(ingredientFoodId);
    }
    if (!nullToAbsent || ingredientRecipeId != null) {
      map['ingredient_recipe_id'] = Variable<int>(ingredientRecipeId);
    }
    map['quantity'] = Variable<double>(quantity);
    map['unit_name'] = Variable<String>(unitName);
    return map;
  }

  RecipeItemsCompanion toCompanion(bool nullToAbsent) {
    return RecipeItemsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      ingredientFoodId: ingredientFoodId == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientFoodId),
      ingredientRecipeId: ingredientRecipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientRecipeId),
      quantity: Value(quantity),
      unitName: Value(unitName),
    );
  }

  factory RecipeItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeItem(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      ingredientFoodId: serializer.fromJson<int?>(json['ingredientFoodId']),
      ingredientRecipeId: serializer.fromJson<int?>(json['ingredientRecipeId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitName: serializer.fromJson<String>(json['unitName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'ingredientFoodId': serializer.toJson<int?>(ingredientFoodId),
      'ingredientRecipeId': serializer.toJson<int?>(ingredientRecipeId),
      'quantity': serializer.toJson<double>(quantity),
      'unitName': serializer.toJson<String>(unitName),
    };
  }

  RecipeItem copyWith({
    int? id,
    int? recipeId,
    Value<int?> ingredientFoodId = const Value.absent(),
    Value<int?> ingredientRecipeId = const Value.absent(),
    double? quantity,
    String? unitName,
  }) => RecipeItem(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    ingredientFoodId: ingredientFoodId.present
        ? ingredientFoodId.value
        : this.ingredientFoodId,
    ingredientRecipeId: ingredientRecipeId.present
        ? ingredientRecipeId.value
        : this.ingredientRecipeId,
    quantity: quantity ?? this.quantity,
    unitName: unitName ?? this.unitName,
  );
  RecipeItem copyWithCompanion(RecipeItemsCompanion data) {
    return RecipeItem(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      ingredientFoodId: data.ingredientFoodId.present
          ? data.ingredientFoodId.value
          : this.ingredientFoodId,
      ingredientRecipeId: data.ingredientRecipeId.present
          ? data.ingredientRecipeId.value
          : this.ingredientRecipeId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItem(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientFoodId: $ingredientFoodId, ')
          ..write('ingredientRecipeId: $ingredientRecipeId, ')
          ..write('quantity: $quantity, ')
          ..write('unitName: $unitName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    ingredientFoodId,
    ingredientRecipeId,
    quantity,
    unitName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeItem &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.ingredientFoodId == this.ingredientFoodId &&
          other.ingredientRecipeId == this.ingredientRecipeId &&
          other.quantity == this.quantity &&
          other.unitName == this.unitName);
}

class RecipeItemsCompanion extends UpdateCompanion<RecipeItem> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int?> ingredientFoodId;
  final Value<int?> ingredientRecipeId;
  final Value<double> quantity;
  final Value<String> unitName;
  const RecipeItemsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.ingredientFoodId = const Value.absent(),
    this.ingredientRecipeId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitName = const Value.absent(),
  });
  RecipeItemsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    this.ingredientFoodId = const Value.absent(),
    this.ingredientRecipeId = const Value.absent(),
    required double quantity,
    required String unitName,
  }) : recipeId = Value(recipeId),
       quantity = Value(quantity),
       unitName = Value(unitName);
  static Insertable<RecipeItem> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? ingredientFoodId,
    Expression<int>? ingredientRecipeId,
    Expression<double>? quantity,
    Expression<String>? unitName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (ingredientFoodId != null) 'ingredient_food_id': ingredientFoodId,
      if (ingredientRecipeId != null)
        'ingredient_recipe_id': ingredientRecipeId,
      if (quantity != null) 'quantity': quantity,
      if (unitName != null) 'unit_name': unitName,
    });
  }

  RecipeItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<int?>? ingredientFoodId,
    Value<int?>? ingredientRecipeId,
    Value<double>? quantity,
    Value<String>? unitName,
  }) {
    return RecipeItemsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      ingredientFoodId: ingredientFoodId ?? this.ingredientFoodId,
      ingredientRecipeId: ingredientRecipeId ?? this.ingredientRecipeId,
      quantity: quantity ?? this.quantity,
      unitName: unitName ?? this.unitName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (ingredientFoodId.present) {
      map['ingredient_food_id'] = Variable<int>(ingredientFoodId.value);
    }
    if (ingredientRecipeId.present) {
      map['ingredient_recipe_id'] = Variable<int>(ingredientRecipeId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItemsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientFoodId: $ingredientFoodId, ')
          ..write('ingredientRecipeId: $ingredientRecipeId, ')
          ..write('quantity: $quantity, ')
          ..write('unitName: $unitName')
          ..write(')'))
        .toString();
  }
}

class $LoggedFoodsTable extends LoggedFoods
    with TableInfo<$LoggedFoodsTable, LoggedFood> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoggedFoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _logTimestampMeta = const VerificationMeta(
    'logTimestamp',
  );
  @override
  late final GeneratedColumn<int> logTimestamp = GeneratedColumn<int>(
    'log_timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mealNameMeta = const VerificationMeta(
    'mealName',
  );
  @override
  late final GeneratedColumn<String> mealName = GeneratedColumn<String>(
    'meal_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES foods (id)',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitNameMeta = const VerificationMeta(
    'unitName',
  );
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
    'unit_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    logTimestamp,
    mealName,
    foodId,
    recipeId,
    quantity,
    unitName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'logged_foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoggedFood> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('log_timestamp')) {
      context.handle(
        _logTimestampMeta,
        logTimestamp.isAcceptableOrUnknown(
          data['log_timestamp']!,
          _logTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_logTimestampMeta);
    }
    if (data.containsKey('meal_name')) {
      context.handle(
        _mealNameMeta,
        mealName.isAcceptableOrUnknown(data['meal_name']!, _mealNameMeta),
      );
    } else if (isInserting) {
      context.missing(_mealNameMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_name')) {
      context.handle(
        _unitNameMeta,
        unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta),
      );
    } else if (isInserting) {
      context.missing(_unitNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoggedFood map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoggedFood(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      logTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}log_timestamp'],
      )!,
      mealName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_name'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      ),
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_name'],
      )!,
    );
  }

  @override
  $LoggedFoodsTable createAlias(String alias) {
    return $LoggedFoodsTable(attachedDatabase, alias);
  }
}

class LoggedFood extends DataClass implements Insertable<LoggedFood> {
  final int id;
  final int logTimestamp;
  final String mealName;
  final int? foodId;
  final int? recipeId;
  final double quantity;
  final String unitName;
  const LoggedFood({
    required this.id,
    required this.logTimestamp,
    required this.mealName,
    this.foodId,
    this.recipeId,
    required this.quantity,
    required this.unitName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['log_timestamp'] = Variable<int>(logTimestamp);
    map['meal_name'] = Variable<String>(mealName);
    if (!nullToAbsent || foodId != null) {
      map['food_id'] = Variable<int>(foodId);
    }
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<int>(recipeId);
    }
    map['quantity'] = Variable<double>(quantity);
    map['unit_name'] = Variable<String>(unitName);
    return map;
  }

  LoggedFoodsCompanion toCompanion(bool nullToAbsent) {
    return LoggedFoodsCompanion(
      id: Value(id),
      logTimestamp: Value(logTimestamp),
      mealName: Value(mealName),
      foodId: foodId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodId),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
      quantity: Value(quantity),
      unitName: Value(unitName),
    );
  }

  factory LoggedFood.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoggedFood(
      id: serializer.fromJson<int>(json['id']),
      logTimestamp: serializer.fromJson<int>(json['logTimestamp']),
      mealName: serializer.fromJson<String>(json['mealName']),
      foodId: serializer.fromJson<int?>(json['foodId']),
      recipeId: serializer.fromJson<int?>(json['recipeId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitName: serializer.fromJson<String>(json['unitName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logTimestamp': serializer.toJson<int>(logTimestamp),
      'mealName': serializer.toJson<String>(mealName),
      'foodId': serializer.toJson<int?>(foodId),
      'recipeId': serializer.toJson<int?>(recipeId),
      'quantity': serializer.toJson<double>(quantity),
      'unitName': serializer.toJson<String>(unitName),
    };
  }

  LoggedFood copyWith({
    int? id,
    int? logTimestamp,
    String? mealName,
    Value<int?> foodId = const Value.absent(),
    Value<int?> recipeId = const Value.absent(),
    double? quantity,
    String? unitName,
  }) => LoggedFood(
    id: id ?? this.id,
    logTimestamp: logTimestamp ?? this.logTimestamp,
    mealName: mealName ?? this.mealName,
    foodId: foodId.present ? foodId.value : this.foodId,
    recipeId: recipeId.present ? recipeId.value : this.recipeId,
    quantity: quantity ?? this.quantity,
    unitName: unitName ?? this.unitName,
  );
  LoggedFood copyWithCompanion(LoggedFoodsCompanion data) {
    return LoggedFood(
      id: data.id.present ? data.id.value : this.id,
      logTimestamp: data.logTimestamp.present
          ? data.logTimestamp.value
          : this.logTimestamp,
      mealName: data.mealName.present ? data.mealName.value : this.mealName,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoggedFood(')
          ..write('id: $id, ')
          ..write('logTimestamp: $logTimestamp, ')
          ..write('mealName: $mealName, ')
          ..write('foodId: $foodId, ')
          ..write('recipeId: $recipeId, ')
          ..write('quantity: $quantity, ')
          ..write('unitName: $unitName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    logTimestamp,
    mealName,
    foodId,
    recipeId,
    quantity,
    unitName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoggedFood &&
          other.id == this.id &&
          other.logTimestamp == this.logTimestamp &&
          other.mealName == this.mealName &&
          other.foodId == this.foodId &&
          other.recipeId == this.recipeId &&
          other.quantity == this.quantity &&
          other.unitName == this.unitName);
}

class LoggedFoodsCompanion extends UpdateCompanion<LoggedFood> {
  final Value<int> id;
  final Value<int> logTimestamp;
  final Value<String> mealName;
  final Value<int?> foodId;
  final Value<int?> recipeId;
  final Value<double> quantity;
  final Value<String> unitName;
  const LoggedFoodsCompanion({
    this.id = const Value.absent(),
    this.logTimestamp = const Value.absent(),
    this.mealName = const Value.absent(),
    this.foodId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitName = const Value.absent(),
  });
  LoggedFoodsCompanion.insert({
    this.id = const Value.absent(),
    required int logTimestamp,
    required String mealName,
    this.foodId = const Value.absent(),
    this.recipeId = const Value.absent(),
    required double quantity,
    required String unitName,
  }) : logTimestamp = Value(logTimestamp),
       mealName = Value(mealName),
       quantity = Value(quantity),
       unitName = Value(unitName);
  static Insertable<LoggedFood> custom({
    Expression<int>? id,
    Expression<int>? logTimestamp,
    Expression<String>? mealName,
    Expression<int>? foodId,
    Expression<int>? recipeId,
    Expression<double>? quantity,
    Expression<String>? unitName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logTimestamp != null) 'log_timestamp': logTimestamp,
      if (mealName != null) 'meal_name': mealName,
      if (foodId != null) 'food_id': foodId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (quantity != null) 'quantity': quantity,
      if (unitName != null) 'unit_name': unitName,
    });
  }

  LoggedFoodsCompanion copyWith({
    Value<int>? id,
    Value<int>? logTimestamp,
    Value<String>? mealName,
    Value<int?>? foodId,
    Value<int?>? recipeId,
    Value<double>? quantity,
    Value<String>? unitName,
  }) {
    return LoggedFoodsCompanion(
      id: id ?? this.id,
      logTimestamp: logTimestamp ?? this.logTimestamp,
      mealName: mealName ?? this.mealName,
      foodId: foodId ?? this.foodId,
      recipeId: recipeId ?? this.recipeId,
      quantity: quantity ?? this.quantity,
      unitName: unitName ?? this.unitName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (logTimestamp.present) {
      map['log_timestamp'] = Variable<int>(logTimestamp.value);
    }
    if (mealName.present) {
      map['meal_name'] = Variable<String>(mealName.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoggedFoodsCompanion(')
          ..write('id: $id, ')
          ..write('logTimestamp: $logTimestamp, ')
          ..write('mealName: $mealName, ')
          ..write('foodId: $foodId, ')
          ..write('recipeId: $recipeId, ')
          ..write('quantity: $quantity, ')
          ..write('unitName: $unitName')
          ..write(')'))
        .toString();
  }
}

abstract class _$LiveDatabase extends GeneratedDatabase {
  _$LiveDatabase(QueryExecutor e) : super(e);
  $LiveDatabaseManager get managers => $LiveDatabaseManager(this);
  late final $FoodsTable foods = $FoodsTable(this);
  late final $FoodUnitsTable foodUnits = $FoodUnitsTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeItemsTable recipeItems = $RecipeItemsTable(this);
  late final $LoggedFoodsTable loggedFoods = $LoggedFoodsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    foods,
    foodUnits,
    recipes,
    recipeItems,
    loggedFoods,
  ];
}

typedef $$FoodsTableCreateCompanionBuilder =
    FoodsCompanion Function({
      Value<int> id,
      required String name,
      required String source,
      Value<String?> imageUrl,
      required double caloriesPer100g,
      required double proteinPer100g,
      required double fatPer100g,
      required double carbsPer100g,
      required double fiberPer100g,
      Value<int?> sourceFdcId,
      Value<String?> sourceBarcode,
      Value<bool> hidden,
    });
typedef $$FoodsTableUpdateCompanionBuilder =
    FoodsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> source,
      Value<String?> imageUrl,
      Value<double> caloriesPer100g,
      Value<double> proteinPer100g,
      Value<double> fatPer100g,
      Value<double> carbsPer100g,
      Value<double> fiberPer100g,
      Value<int?> sourceFdcId,
      Value<String?> sourceBarcode,
      Value<bool> hidden,
    });

final class $$FoodsTableReferences
    extends BaseReferences<_$LiveDatabase, $FoodsTable, Food> {
  $$FoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FoodUnitsTable, List<FoodUnit>>
  _foodUnitsRefsTable(_$LiveDatabase db) => MultiTypedResultKey.fromTable(
    db.foodUnits,
    aliasName: $_aliasNameGenerator(db.foods.id, db.foodUnits.foodId),
  );

  $$FoodUnitsTableProcessedTableManager get foodUnitsRefs {
    final manager = $$FoodUnitsTableTableManager(
      $_db,
      $_db.foodUnits,
    ).filter((f) => f.foodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodUnitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeItemsTable, List<RecipeItem>>
  _recipeItemsRefsTable(_$LiveDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeItems,
    aliasName: $_aliasNameGenerator(
      db.foods.id,
      db.recipeItems.ingredientFoodId,
    ),
  );

  $$RecipeItemsTableProcessedTableManager get recipeItemsRefs {
    final manager = $$RecipeItemsTableTableManager(
      $_db,
      $_db.recipeItems,
    ).filter((f) => f.ingredientFoodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LoggedFoodsTable, List<LoggedFood>>
  _loggedFoodsRefsTable(_$LiveDatabase db) => MultiTypedResultKey.fromTable(
    db.loggedFoods,
    aliasName: $_aliasNameGenerator(db.foods.id, db.loggedFoods.foodId),
  );

  $$LoggedFoodsTableProcessedTableManager get loggedFoodsRefs {
    final manager = $$LoggedFoodsTableTableManager(
      $_db,
      $_db.loggedFoods,
    ).filter((f) => f.foodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loggedFoodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FoodsTableFilterComposer extends Composer<_$LiveDatabase, $FoodsTable> {
  $$FoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceFdcId => $composableBuilder(
    column: $table.sourceFdcId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceBarcode => $composableBuilder(
    column: $table.sourceBarcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> foodUnitsRefs(
    Expression<bool> Function($$FoodUnitsTableFilterComposer f) f,
  ) {
    final $$FoodUnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodUnits,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodUnitsTableFilterComposer(
            $db: $db,
            $table: $db.foodUnits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipeItemsRefs(
    Expression<bool> Function($$RecipeItemsTableFilterComposer f) f,
  ) {
    final $$RecipeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.ingredientFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableFilterComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> loggedFoodsRefs(
    Expression<bool> Function($$LoggedFoodsTableFilterComposer f) f,
  ) {
    final $$LoggedFoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loggedFoods,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoggedFoodsTableFilterComposer(
            $db: $db,
            $table: $db.loggedFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodsTableOrderingComposer
    extends Composer<_$LiveDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceFdcId => $composableBuilder(
    column: $table.sourceFdcId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceBarcode => $composableBuilder(
    column: $table.sourceBarcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodsTableAnnotationComposer
    extends Composer<_$LiveDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<double> get caloriesPer100g => $composableBuilder(
    column: $table.caloriesPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinPer100g => $composableBuilder(
    column: $table.proteinPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatPer100g => $composableBuilder(
    column: $table.fatPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsPer100g => $composableBuilder(
    column: $table.carbsPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiberPer100g => $composableBuilder(
    column: $table.fiberPer100g,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sourceFdcId => $composableBuilder(
    column: $table.sourceFdcId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceBarcode => $composableBuilder(
    column: $table.sourceBarcode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => column);

  Expression<T> foodUnitsRefs<T extends Object>(
    Expression<T> Function($$FoodUnitsTableAnnotationComposer a) f,
  ) {
    final $$FoodUnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodUnits,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodUnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodUnits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recipeItemsRefs<T extends Object>(
    Expression<T> Function($$RecipeItemsTableAnnotationComposer a) f,
  ) {
    final $$RecipeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.ingredientFoodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> loggedFoodsRefs<T extends Object>(
    Expression<T> Function($$LoggedFoodsTableAnnotationComposer a) f,
  ) {
    final $$LoggedFoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loggedFoods,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoggedFoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.loggedFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodsTableTableManager
    extends
        RootTableManager<
          _$LiveDatabase,
          $FoodsTable,
          Food,
          $$FoodsTableFilterComposer,
          $$FoodsTableOrderingComposer,
          $$FoodsTableAnnotationComposer,
          $$FoodsTableCreateCompanionBuilder,
          $$FoodsTableUpdateCompanionBuilder,
          (Food, $$FoodsTableReferences),
          Food,
          PrefetchHooks Function({
            bool foodUnitsRefs,
            bool recipeItemsRefs,
            bool loggedFoodsRefs,
          })
        > {
  $$FoodsTableTableManager(_$LiveDatabase db, $FoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<double> caloriesPer100g = const Value.absent(),
                Value<double> proteinPer100g = const Value.absent(),
                Value<double> fatPer100g = const Value.absent(),
                Value<double> carbsPer100g = const Value.absent(),
                Value<double> fiberPer100g = const Value.absent(),
                Value<int?> sourceFdcId = const Value.absent(),
                Value<String?> sourceBarcode = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
              }) => FoodsCompanion(
                id: id,
                name: name,
                source: source,
                imageUrl: imageUrl,
                caloriesPer100g: caloriesPer100g,
                proteinPer100g: proteinPer100g,
                fatPer100g: fatPer100g,
                carbsPer100g: carbsPer100g,
                fiberPer100g: fiberPer100g,
                sourceFdcId: sourceFdcId,
                sourceBarcode: sourceBarcode,
                hidden: hidden,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String source,
                Value<String?> imageUrl = const Value.absent(),
                required double caloriesPer100g,
                required double proteinPer100g,
                required double fatPer100g,
                required double carbsPer100g,
                required double fiberPer100g,
                Value<int?> sourceFdcId = const Value.absent(),
                Value<String?> sourceBarcode = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
              }) => FoodsCompanion.insert(
                id: id,
                name: name,
                source: source,
                imageUrl: imageUrl,
                caloriesPer100g: caloriesPer100g,
                proteinPer100g: proteinPer100g,
                fatPer100g: fatPer100g,
                carbsPer100g: carbsPer100g,
                fiberPer100g: fiberPer100g,
                sourceFdcId: sourceFdcId,
                sourceBarcode: sourceBarcode,
                hidden: hidden,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$FoodsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                foodUnitsRefs = false,
                recipeItemsRefs = false,
                loggedFoodsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (foodUnitsRefs) db.foodUnits,
                    if (recipeItemsRefs) db.recipeItems,
                    if (loggedFoodsRefs) db.loggedFoods,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (foodUnitsRefs)
                        await $_getPrefetchedData<Food, $FoodsTable, FoodUnit>(
                          currentTable: table,
                          referencedTable: $$FoodsTableReferences
                              ._foodUnitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FoodsTableReferences(
                                db,
                                table,
                                p0,
                              ).foodUnitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.foodId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipeItemsRefs)
                        await $_getPrefetchedData<
                          Food,
                          $FoodsTable,
                          RecipeItem
                        >(
                          currentTable: table,
                          referencedTable: $$FoodsTableReferences
                              ._recipeItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FoodsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientFoodId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (loggedFoodsRefs)
                        await $_getPrefetchedData<
                          Food,
                          $FoodsTable,
                          LoggedFood
                        >(
                          currentTable: table,
                          referencedTable: $$FoodsTableReferences
                              ._loggedFoodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FoodsTableReferences(
                                db,
                                table,
                                p0,
                              ).loggedFoodsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.foodId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiveDatabase,
      $FoodsTable,
      Food,
      $$FoodsTableFilterComposer,
      $$FoodsTableOrderingComposer,
      $$FoodsTableAnnotationComposer,
      $$FoodsTableCreateCompanionBuilder,
      $$FoodsTableUpdateCompanionBuilder,
      (Food, $$FoodsTableReferences),
      Food,
      PrefetchHooks Function({
        bool foodUnitsRefs,
        bool recipeItemsRefs,
        bool loggedFoodsRefs,
      })
    >;
typedef $$FoodUnitsTableCreateCompanionBuilder =
    FoodUnitsCompanion Function({
      Value<int> id,
      required int foodId,
      required String unitName,
      required double gramsPerUnit,
    });
typedef $$FoodUnitsTableUpdateCompanionBuilder =
    FoodUnitsCompanion Function({
      Value<int> id,
      Value<int> foodId,
      Value<String> unitName,
      Value<double> gramsPerUnit,
    });

final class $$FoodUnitsTableReferences
    extends BaseReferences<_$LiveDatabase, $FoodUnitsTable, FoodUnit> {
  $$FoodUnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoodsTable _foodIdTable(_$LiveDatabase db) => db.foods.createAlias(
    $_aliasNameGenerator(db.foodUnits.foodId, db.foods.id),
  );

  $$FoodsTableProcessedTableManager get foodId {
    final $_column = $_itemColumn<int>('food_id')!;

    final manager = $$FoodsTableTableManager(
      $_db,
      $_db.foods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FoodUnitsTableFilterComposer
    extends Composer<_$LiveDatabase, $FoodUnitsTable> {
  $$FoodUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gramsPerUnit => $composableBuilder(
    column: $table.gramsPerUnit,
    builder: (column) => ColumnFilters(column),
  );

  $$FoodsTableFilterComposer get foodId {
    final $$FoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableFilterComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodUnitsTableOrderingComposer
    extends Composer<_$LiveDatabase, $FoodUnitsTable> {
  $$FoodUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gramsPerUnit => $composableBuilder(
    column: $table.gramsPerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  $$FoodsTableOrderingComposer get foodId {
    final $$FoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableOrderingComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodUnitsTableAnnotationComposer
    extends Composer<_$LiveDatabase, $FoodUnitsTable> {
  $$FoodUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get unitName =>
      $composableBuilder(column: $table.unitName, builder: (column) => column);

  GeneratedColumn<double> get gramsPerUnit => $composableBuilder(
    column: $table.gramsPerUnit,
    builder: (column) => column,
  );

  $$FoodsTableAnnotationComposer get foodId {
    final $$FoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodUnitsTableTableManager
    extends
        RootTableManager<
          _$LiveDatabase,
          $FoodUnitsTable,
          FoodUnit,
          $$FoodUnitsTableFilterComposer,
          $$FoodUnitsTableOrderingComposer,
          $$FoodUnitsTableAnnotationComposer,
          $$FoodUnitsTableCreateCompanionBuilder,
          $$FoodUnitsTableUpdateCompanionBuilder,
          (FoodUnit, $$FoodUnitsTableReferences),
          FoodUnit,
          PrefetchHooks Function({bool foodId})
        > {
  $$FoodUnitsTableTableManager(_$LiveDatabase db, $FoodUnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> foodId = const Value.absent(),
                Value<String> unitName = const Value.absent(),
                Value<double> gramsPerUnit = const Value.absent(),
              }) => FoodUnitsCompanion(
                id: id,
                foodId: foodId,
                unitName: unitName,
                gramsPerUnit: gramsPerUnit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int foodId,
                required String unitName,
                required double gramsPerUnit,
              }) => FoodUnitsCompanion.insert(
                id: id,
                foodId: foodId,
                unitName: unitName,
                gramsPerUnit: gramsPerUnit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FoodUnitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({foodId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (foodId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.foodId,
                                referencedTable: $$FoodUnitsTableReferences
                                    ._foodIdTable(db),
                                referencedColumn: $$FoodUnitsTableReferences
                                    ._foodIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FoodUnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiveDatabase,
      $FoodUnitsTable,
      FoodUnit,
      $$FoodUnitsTableFilterComposer,
      $$FoodUnitsTableOrderingComposer,
      $$FoodUnitsTableAnnotationComposer,
      $$FoodUnitsTableCreateCompanionBuilder,
      $$FoodUnitsTableUpdateCompanionBuilder,
      (FoodUnit, $$FoodUnitsTableReferences),
      FoodUnit,
      PrefetchHooks Function({bool foodId})
    >;
typedef $$RecipesTableCreateCompanionBuilder =
    RecipesCompanion Function({
      Value<int> id,
      required String name,
      required double servingsCreated,
      Value<double?> finalWeightGrams,
      Value<String?> notes,
      Value<bool> hidden,
    });
typedef $$RecipesTableUpdateCompanionBuilder =
    RecipesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<double> servingsCreated,
      Value<double?> finalWeightGrams,
      Value<String?> notes,
      Value<bool> hidden,
    });

final class $$RecipesTableReferences
    extends BaseReferences<_$LiveDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeItemsTable, List<RecipeItem>>
  _RecipeEntriesTable(_$LiveDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeItems,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.recipeItems.recipeId),
  );

  $$RecipeItemsTableProcessedTableManager get RecipeEntries {
    final manager = $$RecipeItemsTableTableManager(
      $_db,
      $_db.recipeItems,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_RecipeEntriesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeItemsTable, List<RecipeItem>>
  _IngredientRecipesTable(_$LiveDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeItems,
    aliasName: $_aliasNameGenerator(
      db.recipes.id,
      db.recipeItems.ingredientRecipeId,
    ),
  );

  $$RecipeItemsTableProcessedTableManager get IngredientRecipes {
    final manager = $$RecipeItemsTableTableManager($_db, $_db.recipeItems)
        .filter(
          (f) => f.ingredientRecipeId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_IngredientRecipesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LoggedFoodsTable, List<LoggedFood>>
  _loggedFoodsRefsTable(_$LiveDatabase db) => MultiTypedResultKey.fromTable(
    db.loggedFoods,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.loggedFoods.recipeId),
  );

  $$LoggedFoodsTableProcessedTableManager get loggedFoodsRefs {
    final manager = $$LoggedFoodsTableTableManager(
      $_db,
      $_db.loggedFoods,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loggedFoodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$LiveDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servingsCreated => $composableBuilder(
    column: $table.servingsCreated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get finalWeightGrams => $composableBuilder(
    column: $table.finalWeightGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> RecipeEntries(
    Expression<bool> Function($$RecipeItemsTableFilterComposer f) f,
  ) {
    final $$RecipeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableFilterComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> IngredientRecipes(
    Expression<bool> Function($$RecipeItemsTableFilterComposer f) f,
  ) {
    final $$RecipeItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.ingredientRecipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableFilterComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> loggedFoodsRefs(
    Expression<bool> Function($$LoggedFoodsTableFilterComposer f) f,
  ) {
    final $$LoggedFoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loggedFoods,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoggedFoodsTableFilterComposer(
            $db: $db,
            $table: $db.loggedFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$LiveDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servingsCreated => $composableBuilder(
    column: $table.servingsCreated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get finalWeightGrams => $composableBuilder(
    column: $table.finalWeightGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hidden => $composableBuilder(
    column: $table.hidden,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$LiveDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get servingsCreated => $composableBuilder(
    column: $table.servingsCreated,
    builder: (column) => column,
  );

  GeneratedColumn<double> get finalWeightGrams => $composableBuilder(
    column: $table.finalWeightGrams,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => column);

  Expression<T> RecipeEntries<T extends Object>(
    Expression<T> Function($$RecipeItemsTableAnnotationComposer a) f,
  ) {
    final $$RecipeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> IngredientRecipes<T extends Object>(
    Expression<T> Function($$RecipeItemsTableAnnotationComposer a) f,
  ) {
    final $$RecipeItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeItems,
      getReferencedColumn: (t) => t.ingredientRecipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> loggedFoodsRefs<T extends Object>(
    Expression<T> Function($$LoggedFoodsTableAnnotationComposer a) f,
  ) {
    final $$LoggedFoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loggedFoods,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoggedFoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.loggedFoods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$LiveDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, $$RecipesTableReferences),
          Recipe,
          PrefetchHooks Function({
            bool RecipeEntries,
            bool IngredientRecipes,
            bool loggedFoodsRefs,
          })
        > {
  $$RecipesTableTableManager(_$LiveDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> servingsCreated = const Value.absent(),
                Value<double?> finalWeightGrams = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                name: name,
                servingsCreated: servingsCreated,
                finalWeightGrams: finalWeightGrams,
                notes: notes,
                hidden: hidden,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required double servingsCreated,
                Value<double?> finalWeightGrams = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                name: name,
                servingsCreated: servingsCreated,
                finalWeightGrams: finalWeightGrams,
                notes: notes,
                hidden: hidden,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                RecipeEntries = false,
                IngredientRecipes = false,
                loggedFoodsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (RecipeEntries) db.recipeItems,
                    if (IngredientRecipes) db.recipeItems,
                    if (loggedFoodsRefs) db.loggedFoods,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (RecipeEntries)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeItem
                        >(
                          currentTable: table,
                          referencedTable:
                              $$RecipesTableReferences._RecipeEntriesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).RecipeEntries,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (IngredientRecipes)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeItem
                        >(
                          currentTable: table,
                          referencedTable:
                              $$RecipesTableReferences._IngredientRecipesTable(
                                db,
                              ),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).IngredientRecipes,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientRecipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (loggedFoodsRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          LoggedFood
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._loggedFoodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).loggedFoodsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$LiveDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, $$RecipesTableReferences),
      Recipe,
      PrefetchHooks Function({
        bool RecipeEntries,
        bool IngredientRecipes,
        bool loggedFoodsRefs,
      })
    >;
typedef $$RecipeItemsTableCreateCompanionBuilder =
    RecipeItemsCompanion Function({
      Value<int> id,
      required int recipeId,
      Value<int?> ingredientFoodId,
      Value<int?> ingredientRecipeId,
      required double quantity,
      required String unitName,
    });
typedef $$RecipeItemsTableUpdateCompanionBuilder =
    RecipeItemsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<int?> ingredientFoodId,
      Value<int?> ingredientRecipeId,
      Value<double> quantity,
      Value<String> unitName,
    });

final class $$RecipeItemsTableReferences
    extends BaseReferences<_$LiveDatabase, $RecipeItemsTable, RecipeItem> {
  $$RecipeItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$LiveDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.recipeItems.recipeId, db.recipes.id),
      );

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FoodsTable _ingredientFoodIdTable(_$LiveDatabase db) =>
      db.foods.createAlias(
        $_aliasNameGenerator(db.recipeItems.ingredientFoodId, db.foods.id),
      );

  $$FoodsTableProcessedTableManager? get ingredientFoodId {
    final $_column = $_itemColumn<int>('ingredient_food_id');
    if ($_column == null) return null;
    final manager = $$FoodsTableTableManager(
      $_db,
      $_db.foods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientFoodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecipesTable _ingredientRecipeIdTable(_$LiveDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.recipeItems.ingredientRecipeId, db.recipes.id),
      );

  $$RecipesTableProcessedTableManager? get ingredientRecipeId {
    final $_column = $_itemColumn<int>('ingredient_recipe_id');
    if ($_column == null) return null;
    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientRecipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeItemsTableFilterComposer
    extends Composer<_$LiveDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodsTableFilterComposer get ingredientFoodId {
    final $$FoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientFoodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableFilterComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableFilterComposer get ingredientRecipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientRecipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableOrderingComposer
    extends Composer<_$LiveDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodsTableOrderingComposer get ingredientFoodId {
    final $$FoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientFoodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableOrderingComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableOrderingComposer get ingredientRecipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientRecipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableAnnotationComposer
    extends Composer<_$LiveDatabase, $RecipeItemsTable> {
  $$RecipeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unitName =>
      $composableBuilder(column: $table.unitName, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodsTableAnnotationComposer get ingredientFoodId {
    final $$FoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientFoodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableAnnotationComposer get ingredientRecipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientRecipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeItemsTableTableManager
    extends
        RootTableManager<
          _$LiveDatabase,
          $RecipeItemsTable,
          RecipeItem,
          $$RecipeItemsTableFilterComposer,
          $$RecipeItemsTableOrderingComposer,
          $$RecipeItemsTableAnnotationComposer,
          $$RecipeItemsTableCreateCompanionBuilder,
          $$RecipeItemsTableUpdateCompanionBuilder,
          (RecipeItem, $$RecipeItemsTableReferences),
          RecipeItem,
          PrefetchHooks Function({
            bool recipeId,
            bool ingredientFoodId,
            bool ingredientRecipeId,
          })
        > {
  $$RecipeItemsTableTableManager(_$LiveDatabase db, $RecipeItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<int?> ingredientFoodId = const Value.absent(),
                Value<int?> ingredientRecipeId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unitName = const Value.absent(),
              }) => RecipeItemsCompanion(
                id: id,
                recipeId: recipeId,
                ingredientFoodId: ingredientFoodId,
                ingredientRecipeId: ingredientRecipeId,
                quantity: quantity,
                unitName: unitName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                Value<int?> ingredientFoodId = const Value.absent(),
                Value<int?> ingredientRecipeId = const Value.absent(),
                required double quantity,
                required String unitName,
              }) => RecipeItemsCompanion.insert(
                id: id,
                recipeId: recipeId,
                ingredientFoodId: ingredientFoodId,
                ingredientRecipeId: ingredientRecipeId,
                quantity: quantity,
                unitName: unitName,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recipeId = false,
                ingredientFoodId = false,
                ingredientRecipeId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (recipeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.recipeId,
                                    referencedTable:
                                        $$RecipeItemsTableReferences
                                            ._recipeIdTable(db),
                                    referencedColumn:
                                        $$RecipeItemsTableReferences
                                            ._recipeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (ingredientFoodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ingredientFoodId,
                                    referencedTable:
                                        $$RecipeItemsTableReferences
                                            ._ingredientFoodIdTable(db),
                                    referencedColumn:
                                        $$RecipeItemsTableReferences
                                            ._ingredientFoodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (ingredientRecipeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ingredientRecipeId,
                                    referencedTable:
                                        $$RecipeItemsTableReferences
                                            ._ingredientRecipeIdTable(db),
                                    referencedColumn:
                                        $$RecipeItemsTableReferences
                                            ._ingredientRecipeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RecipeItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiveDatabase,
      $RecipeItemsTable,
      RecipeItem,
      $$RecipeItemsTableFilterComposer,
      $$RecipeItemsTableOrderingComposer,
      $$RecipeItemsTableAnnotationComposer,
      $$RecipeItemsTableCreateCompanionBuilder,
      $$RecipeItemsTableUpdateCompanionBuilder,
      (RecipeItem, $$RecipeItemsTableReferences),
      RecipeItem,
      PrefetchHooks Function({
        bool recipeId,
        bool ingredientFoodId,
        bool ingredientRecipeId,
      })
    >;
typedef $$LoggedFoodsTableCreateCompanionBuilder =
    LoggedFoodsCompanion Function({
      Value<int> id,
      required int logTimestamp,
      required String mealName,
      Value<int?> foodId,
      Value<int?> recipeId,
      required double quantity,
      required String unitName,
    });
typedef $$LoggedFoodsTableUpdateCompanionBuilder =
    LoggedFoodsCompanion Function({
      Value<int> id,
      Value<int> logTimestamp,
      Value<String> mealName,
      Value<int?> foodId,
      Value<int?> recipeId,
      Value<double> quantity,
      Value<String> unitName,
    });

final class $$LoggedFoodsTableReferences
    extends BaseReferences<_$LiveDatabase, $LoggedFoodsTable, LoggedFood> {
  $$LoggedFoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoodsTable _foodIdTable(_$LiveDatabase db) => db.foods.createAlias(
    $_aliasNameGenerator(db.loggedFoods.foodId, db.foods.id),
  );

  $$FoodsTableProcessedTableManager? get foodId {
    final $_column = $_itemColumn<int>('food_id');
    if ($_column == null) return null;
    final manager = $$FoodsTableTableManager(
      $_db,
      $_db.foods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecipesTable _recipeIdTable(_$LiveDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.loggedFoods.recipeId, db.recipes.id),
      );

  $$RecipesTableProcessedTableManager? get recipeId {
    final $_column = $_itemColumn<int>('recipe_id');
    if ($_column == null) return null;
    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LoggedFoodsTableFilterComposer
    extends Composer<_$LiveDatabase, $LoggedFoodsTable> {
  $$LoggedFoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get logTimestamp => $composableBuilder(
    column: $table.logTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealName => $composableBuilder(
    column: $table.mealName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnFilters(column),
  );

  $$FoodsTableFilterComposer get foodId {
    final $$FoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableFilterComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoggedFoodsTableOrderingComposer
    extends Composer<_$LiveDatabase, $LoggedFoodsTable> {
  $$LoggedFoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get logTimestamp => $composableBuilder(
    column: $table.logTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealName => $composableBuilder(
    column: $table.mealName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnOrderings(column),
  );

  $$FoodsTableOrderingComposer get foodId {
    final $$FoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableOrderingComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoggedFoodsTableAnnotationComposer
    extends Composer<_$LiveDatabase, $LoggedFoodsTable> {
  $$LoggedFoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get logTimestamp => $composableBuilder(
    column: $table.logTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mealName =>
      $composableBuilder(column: $table.mealName, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unitName =>
      $composableBuilder(column: $table.unitName, builder: (column) => column);

  $$FoodsTableAnnotationComposer get foodId {
    final $$FoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoggedFoodsTableTableManager
    extends
        RootTableManager<
          _$LiveDatabase,
          $LoggedFoodsTable,
          LoggedFood,
          $$LoggedFoodsTableFilterComposer,
          $$LoggedFoodsTableOrderingComposer,
          $$LoggedFoodsTableAnnotationComposer,
          $$LoggedFoodsTableCreateCompanionBuilder,
          $$LoggedFoodsTableUpdateCompanionBuilder,
          (LoggedFood, $$LoggedFoodsTableReferences),
          LoggedFood,
          PrefetchHooks Function({bool foodId, bool recipeId})
        > {
  $$LoggedFoodsTableTableManager(_$LiveDatabase db, $LoggedFoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoggedFoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoggedFoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoggedFoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> logTimestamp = const Value.absent(),
                Value<String> mealName = const Value.absent(),
                Value<int?> foodId = const Value.absent(),
                Value<int?> recipeId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unitName = const Value.absent(),
              }) => LoggedFoodsCompanion(
                id: id,
                logTimestamp: logTimestamp,
                mealName: mealName,
                foodId: foodId,
                recipeId: recipeId,
                quantity: quantity,
                unitName: unitName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int logTimestamp,
                required String mealName,
                Value<int?> foodId = const Value.absent(),
                Value<int?> recipeId = const Value.absent(),
                required double quantity,
                required String unitName,
              }) => LoggedFoodsCompanion.insert(
                id: id,
                logTimestamp: logTimestamp,
                mealName: mealName,
                foodId: foodId,
                recipeId: recipeId,
                quantity: quantity,
                unitName: unitName,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LoggedFoodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({foodId = false, recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (foodId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.foodId,
                                referencedTable: $$LoggedFoodsTableReferences
                                    ._foodIdTable(db),
                                referencedColumn: $$LoggedFoodsTableReferences
                                    ._foodIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$LoggedFoodsTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn: $$LoggedFoodsTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LoggedFoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiveDatabase,
      $LoggedFoodsTable,
      LoggedFood,
      $$LoggedFoodsTableFilterComposer,
      $$LoggedFoodsTableOrderingComposer,
      $$LoggedFoodsTableAnnotationComposer,
      $$LoggedFoodsTableCreateCompanionBuilder,
      $$LoggedFoodsTableUpdateCompanionBuilder,
      (LoggedFood, $$LoggedFoodsTableReferences),
      LoggedFood,
      PrefetchHooks Function({bool foodId, bool recipeId})
    >;

class $LiveDatabaseManager {
  final _$LiveDatabase _db;
  $LiveDatabaseManager(this._db);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db, _db.foods);
  $$FoodUnitsTableTableManager get foodUnits =>
      $$FoodUnitsTableTableManager(_db, _db.foodUnits);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeItemsTableTableManager get recipeItems =>
      $$RecipeItemsTableTableManager(_db, _db.recipeItems);
  $$LoggedFoodsTableTableManager get loggedFoods =>
      $$LoggedFoodsTableTableManager(_db, _db.loggedFoods);
}
