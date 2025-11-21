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
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailMeta = const VerificationMeta(
    'thumbnail',
  );
  @override
  late final GeneratedColumn<String> thumbnail = GeneratedColumn<String>(
    'thumbnail',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesPerGramMeta = const VerificationMeta(
    'caloriesPerGram',
  );
  @override
  late final GeneratedColumn<double> caloriesPerGram = GeneratedColumn<double>(
    'caloriesPerGram',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinPerGramMeta = const VerificationMeta(
    'proteinPerGram',
  );
  @override
  late final GeneratedColumn<double> proteinPerGram = GeneratedColumn<double>(
    'proteinPerGram',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatPerGramMeta = const VerificationMeta(
    'fatPerGram',
  );
  @override
  late final GeneratedColumn<double> fatPerGram = GeneratedColumn<double>(
    'fatPerGram',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsPerGramMeta = const VerificationMeta(
    'carbsPerGram',
  );
  @override
  late final GeneratedColumn<double> carbsPerGram = GeneratedColumn<double>(
    'carbsPerGram',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberPerGramMeta = const VerificationMeta(
    'fiberPerGram',
  );
  @override
  late final GeneratedColumn<double> fiberPerGram = GeneratedColumn<double>(
    'fiberPerGram',
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
    'sourceFdcId',
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
    'sourceBarcode',
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
    emoji,
    thumbnail,
    caloriesPerGram,
    proteinPerGram,
    fatPerGram,
    carbsPerGram,
    fiberPerGram,
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
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('thumbnail')) {
      context.handle(
        _thumbnailMeta,
        thumbnail.isAcceptableOrUnknown(data['thumbnail']!, _thumbnailMeta),
      );
    }
    if (data.containsKey('caloriesPerGram')) {
      context.handle(
        _caloriesPerGramMeta,
        caloriesPerGram.isAcceptableOrUnknown(
          data['caloriesPerGram']!,
          _caloriesPerGramMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesPerGramMeta);
    }
    if (data.containsKey('proteinPerGram')) {
      context.handle(
        _proteinPerGramMeta,
        proteinPerGram.isAcceptableOrUnknown(
          data['proteinPerGram']!,
          _proteinPerGramMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinPerGramMeta);
    }
    if (data.containsKey('fatPerGram')) {
      context.handle(
        _fatPerGramMeta,
        fatPerGram.isAcceptableOrUnknown(data['fatPerGram']!, _fatPerGramMeta),
      );
    } else if (isInserting) {
      context.missing(_fatPerGramMeta);
    }
    if (data.containsKey('carbsPerGram')) {
      context.handle(
        _carbsPerGramMeta,
        carbsPerGram.isAcceptableOrUnknown(
          data['carbsPerGram']!,
          _carbsPerGramMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carbsPerGramMeta);
    }
    if (data.containsKey('fiberPerGram')) {
      context.handle(
        _fiberPerGramMeta,
        fiberPerGram.isAcceptableOrUnknown(
          data['fiberPerGram']!,
          _fiberPerGramMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fiberPerGramMeta);
    }
    if (data.containsKey('sourceFdcId')) {
      context.handle(
        _sourceFdcIdMeta,
        sourceFdcId.isAcceptableOrUnknown(
          data['sourceFdcId']!,
          _sourceFdcIdMeta,
        ),
      );
    }
    if (data.containsKey('sourceBarcode')) {
      context.handle(
        _sourceBarcodeMeta,
        sourceBarcode.isAcceptableOrUnknown(
          data['sourceBarcode']!,
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
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      ),
      thumbnail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail'],
      ),
      caloriesPerGram: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}caloriesPerGram'],
      )!,
      proteinPerGram: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}proteinPerGram'],
      )!,
      fatPerGram: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fatPerGram'],
      )!,
      carbsPerGram: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbsPerGram'],
      )!,
      fiberPerGram: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiberPerGram'],
      )!,
      sourceFdcId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sourceFdcId'],
      ),
      sourceBarcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sourceBarcode'],
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
  final String? emoji;
  final String? thumbnail;
  final double caloriesPerGram;
  final double proteinPerGram;
  final double fatPerGram;
  final double carbsPerGram;
  final double fiberPerGram;
  final int? sourceFdcId;
  final String? sourceBarcode;
  final bool hidden;
  const Food({
    required this.id,
    required this.name,
    required this.source,
    this.emoji,
    this.thumbnail,
    required this.caloriesPerGram,
    required this.proteinPerGram,
    required this.fatPerGram,
    required this.carbsPerGram,
    required this.fiberPerGram,
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
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    if (!nullToAbsent || thumbnail != null) {
      map['thumbnail'] = Variable<String>(thumbnail);
    }
    map['caloriesPerGram'] = Variable<double>(caloriesPerGram);
    map['proteinPerGram'] = Variable<double>(proteinPerGram);
    map['fatPerGram'] = Variable<double>(fatPerGram);
    map['carbsPerGram'] = Variable<double>(carbsPerGram);
    map['fiberPerGram'] = Variable<double>(fiberPerGram);
    if (!nullToAbsent || sourceFdcId != null) {
      map['sourceFdcId'] = Variable<int>(sourceFdcId);
    }
    if (!nullToAbsent || sourceBarcode != null) {
      map['sourceBarcode'] = Variable<String>(sourceBarcode);
    }
    map['hidden'] = Variable<bool>(hidden);
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      id: Value(id),
      name: Value(name),
      source: Value(source),
      emoji: emoji == null && nullToAbsent
          ? const Value.absent()
          : Value(emoji),
      thumbnail: thumbnail == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnail),
      caloriesPerGram: Value(caloriesPerGram),
      proteinPerGram: Value(proteinPerGram),
      fatPerGram: Value(fatPerGram),
      carbsPerGram: Value(carbsPerGram),
      fiberPerGram: Value(fiberPerGram),
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
      emoji: serializer.fromJson<String?>(json['emoji']),
      thumbnail: serializer.fromJson<String?>(json['thumbnail']),
      caloriesPerGram: serializer.fromJson<double>(json['caloriesPerGram']),
      proteinPerGram: serializer.fromJson<double>(json['proteinPerGram']),
      fatPerGram: serializer.fromJson<double>(json['fatPerGram']),
      carbsPerGram: serializer.fromJson<double>(json['carbsPerGram']),
      fiberPerGram: serializer.fromJson<double>(json['fiberPerGram']),
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
      'emoji': serializer.toJson<String?>(emoji),
      'thumbnail': serializer.toJson<String?>(thumbnail),
      'caloriesPerGram': serializer.toJson<double>(caloriesPerGram),
      'proteinPerGram': serializer.toJson<double>(proteinPerGram),
      'fatPerGram': serializer.toJson<double>(fatPerGram),
      'carbsPerGram': serializer.toJson<double>(carbsPerGram),
      'fiberPerGram': serializer.toJson<double>(fiberPerGram),
      'sourceFdcId': serializer.toJson<int?>(sourceFdcId),
      'sourceBarcode': serializer.toJson<String?>(sourceBarcode),
      'hidden': serializer.toJson<bool>(hidden),
    };
  }

  Food copyWith({
    int? id,
    String? name,
    String? source,
    Value<String?> emoji = const Value.absent(),
    Value<String?> thumbnail = const Value.absent(),
    double? caloriesPerGram,
    double? proteinPerGram,
    double? fatPerGram,
    double? carbsPerGram,
    double? fiberPerGram,
    Value<int?> sourceFdcId = const Value.absent(),
    Value<String?> sourceBarcode = const Value.absent(),
    bool? hidden,
  }) => Food(
    id: id ?? this.id,
    name: name ?? this.name,
    source: source ?? this.source,
    emoji: emoji.present ? emoji.value : this.emoji,
    thumbnail: thumbnail.present ? thumbnail.value : this.thumbnail,
    caloriesPerGram: caloriesPerGram ?? this.caloriesPerGram,
    proteinPerGram: proteinPerGram ?? this.proteinPerGram,
    fatPerGram: fatPerGram ?? this.fatPerGram,
    carbsPerGram: carbsPerGram ?? this.carbsPerGram,
    fiberPerGram: fiberPerGram ?? this.fiberPerGram,
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
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      thumbnail: data.thumbnail.present ? data.thumbnail.value : this.thumbnail,
      caloriesPerGram: data.caloriesPerGram.present
          ? data.caloriesPerGram.value
          : this.caloriesPerGram,
      proteinPerGram: data.proteinPerGram.present
          ? data.proteinPerGram.value
          : this.proteinPerGram,
      fatPerGram: data.fatPerGram.present
          ? data.fatPerGram.value
          : this.fatPerGram,
      carbsPerGram: data.carbsPerGram.present
          ? data.carbsPerGram.value
          : this.carbsPerGram,
      fiberPerGram: data.fiberPerGram.present
          ? data.fiberPerGram.value
          : this.fiberPerGram,
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
          ..write('emoji: $emoji, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('caloriesPerGram: $caloriesPerGram, ')
          ..write('proteinPerGram: $proteinPerGram, ')
          ..write('fatPerGram: $fatPerGram, ')
          ..write('carbsPerGram: $carbsPerGram, ')
          ..write('fiberPerGram: $fiberPerGram, ')
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
    emoji,
    thumbnail,
    caloriesPerGram,
    proteinPerGram,
    fatPerGram,
    carbsPerGram,
    fiberPerGram,
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
          other.emoji == this.emoji &&
          other.thumbnail == this.thumbnail &&
          other.caloriesPerGram == this.caloriesPerGram &&
          other.proteinPerGram == this.proteinPerGram &&
          other.fatPerGram == this.fatPerGram &&
          other.carbsPerGram == this.carbsPerGram &&
          other.fiberPerGram == this.fiberPerGram &&
          other.sourceFdcId == this.sourceFdcId &&
          other.sourceBarcode == this.sourceBarcode &&
          other.hidden == this.hidden);
}

class FoodsCompanion extends UpdateCompanion<Food> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> source;
  final Value<String?> emoji;
  final Value<String?> thumbnail;
  final Value<double> caloriesPerGram;
  final Value<double> proteinPerGram;
  final Value<double> fatPerGram;
  final Value<double> carbsPerGram;
  final Value<double> fiberPerGram;
  final Value<int?> sourceFdcId;
  final Value<String?> sourceBarcode;
  final Value<bool> hidden;
  const FoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.source = const Value.absent(),
    this.emoji = const Value.absent(),
    this.thumbnail = const Value.absent(),
    this.caloriesPerGram = const Value.absent(),
    this.proteinPerGram = const Value.absent(),
    this.fatPerGram = const Value.absent(),
    this.carbsPerGram = const Value.absent(),
    this.fiberPerGram = const Value.absent(),
    this.sourceFdcId = const Value.absent(),
    this.sourceBarcode = const Value.absent(),
    this.hidden = const Value.absent(),
  });
  FoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String source,
    this.emoji = const Value.absent(),
    this.thumbnail = const Value.absent(),
    required double caloriesPerGram,
    required double proteinPerGram,
    required double fatPerGram,
    required double carbsPerGram,
    required double fiberPerGram,
    this.sourceFdcId = const Value.absent(),
    this.sourceBarcode = const Value.absent(),
    this.hidden = const Value.absent(),
  }) : name = Value(name),
       source = Value(source),
       caloriesPerGram = Value(caloriesPerGram),
       proteinPerGram = Value(proteinPerGram),
       fatPerGram = Value(fatPerGram),
       carbsPerGram = Value(carbsPerGram),
       fiberPerGram = Value(fiberPerGram);
  static Insertable<Food> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? source,
    Expression<String>? emoji,
    Expression<String>? thumbnail,
    Expression<double>? caloriesPerGram,
    Expression<double>? proteinPerGram,
    Expression<double>? fatPerGram,
    Expression<double>? carbsPerGram,
    Expression<double>? fiberPerGram,
    Expression<int>? sourceFdcId,
    Expression<String>? sourceBarcode,
    Expression<bool>? hidden,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (source != null) 'source': source,
      if (emoji != null) 'emoji': emoji,
      if (thumbnail != null) 'thumbnail': thumbnail,
      if (caloriesPerGram != null) 'caloriesPerGram': caloriesPerGram,
      if (proteinPerGram != null) 'proteinPerGram': proteinPerGram,
      if (fatPerGram != null) 'fatPerGram': fatPerGram,
      if (carbsPerGram != null) 'carbsPerGram': carbsPerGram,
      if (fiberPerGram != null) 'fiberPerGram': fiberPerGram,
      if (sourceFdcId != null) 'sourceFdcId': sourceFdcId,
      if (sourceBarcode != null) 'sourceBarcode': sourceBarcode,
      if (hidden != null) 'hidden': hidden,
    });
  }

  FoodsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? source,
    Value<String?>? emoji,
    Value<String?>? thumbnail,
    Value<double>? caloriesPerGram,
    Value<double>? proteinPerGram,
    Value<double>? fatPerGram,
    Value<double>? carbsPerGram,
    Value<double>? fiberPerGram,
    Value<int?>? sourceFdcId,
    Value<String?>? sourceBarcode,
    Value<bool>? hidden,
  }) {
    return FoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      emoji: emoji ?? this.emoji,
      thumbnail: thumbnail ?? this.thumbnail,
      caloriesPerGram: caloriesPerGram ?? this.caloriesPerGram,
      proteinPerGram: proteinPerGram ?? this.proteinPerGram,
      fatPerGram: fatPerGram ?? this.fatPerGram,
      carbsPerGram: carbsPerGram ?? this.carbsPerGram,
      fiberPerGram: fiberPerGram ?? this.fiberPerGram,
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
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (thumbnail.present) {
      map['thumbnail'] = Variable<String>(thumbnail.value);
    }
    if (caloriesPerGram.present) {
      map['caloriesPerGram'] = Variable<double>(caloriesPerGram.value);
    }
    if (proteinPerGram.present) {
      map['proteinPerGram'] = Variable<double>(proteinPerGram.value);
    }
    if (fatPerGram.present) {
      map['fatPerGram'] = Variable<double>(fatPerGram.value);
    }
    if (carbsPerGram.present) {
      map['carbsPerGram'] = Variable<double>(carbsPerGram.value);
    }
    if (fiberPerGram.present) {
      map['fiberPerGram'] = Variable<double>(fiberPerGram.value);
    }
    if (sourceFdcId.present) {
      map['sourceFdcId'] = Variable<int>(sourceFdcId.value);
    }
    if (sourceBarcode.present) {
      map['sourceBarcode'] = Variable<String>(sourceBarcode.value);
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
          ..write('emoji: $emoji, ')
          ..write('thumbnail: $thumbnail, ')
          ..write('caloriesPerGram: $caloriesPerGram, ')
          ..write('proteinPerGram: $proteinPerGram, ')
          ..write('fatPerGram: $fatPerGram, ')
          ..write('carbsPerGram: $carbsPerGram, ')
          ..write('fiberPerGram: $fiberPerGram, ')
          ..write('sourceFdcId: $sourceFdcId, ')
          ..write('sourceBarcode: $sourceBarcode, ')
          ..write('hidden: $hidden')
          ..write(')'))
        .toString();
  }
}

class $FoodPortionsTable extends FoodPortions
    with TableInfo<$FoodPortionsTable, FoodPortion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodPortionsTable(this.attachedDatabase, [this._alias]);
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
    'foodId',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES foods (id)',
    ),
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unitName',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  @override
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
    'gramsPerPortion',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'amountPerPortion',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, foodId, unit, grams, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_portions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodPortion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('foodId')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['foodId']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('unitName')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unitName']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('gramsPerPortion')) {
      context.handle(
        _gramsMeta,
        grams.isAcceptableOrUnknown(data['gramsPerPortion']!, _gramsMeta),
      );
    } else if (isInserting) {
      context.missing(_gramsMeta);
    }
    if (data.containsKey('amountPerPortion')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(
          data['amountPerPortion']!,
          _quantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodPortion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodPortion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}foodId'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unitName'],
      )!,
      grams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gramsPerPortion'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amountPerPortion'],
      )!,
    );
  }

  @override
  $FoodPortionsTable createAlias(String alias) {
    return $FoodPortionsTable(attachedDatabase, alias);
  }
}

class FoodPortion extends DataClass implements Insertable<FoodPortion> {
  final int id;
  final int foodId;
  final String unit;
  final double grams;
  final double quantity;
  const FoodPortion({
    required this.id,
    required this.foodId,
    required this.unit,
    required this.grams,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['foodId'] = Variable<int>(foodId);
    map['unitName'] = Variable<String>(unit);
    map['gramsPerPortion'] = Variable<double>(grams);
    map['amountPerPortion'] = Variable<double>(quantity);
    return map;
  }

  FoodPortionsCompanion toCompanion(bool nullToAbsent) {
    return FoodPortionsCompanion(
      id: Value(id),
      foodId: Value(foodId),
      unit: Value(unit),
      grams: Value(grams),
      quantity: Value(quantity),
    );
  }

  factory FoodPortion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodPortion(
      id: serializer.fromJson<int>(json['id']),
      foodId: serializer.fromJson<int>(json['foodId']),
      unit: serializer.fromJson<String>(json['unit']),
      grams: serializer.fromJson<double>(json['grams']),
      quantity: serializer.fromJson<double>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'foodId': serializer.toJson<int>(foodId),
      'unit': serializer.toJson<String>(unit),
      'grams': serializer.toJson<double>(grams),
      'quantity': serializer.toJson<double>(quantity),
    };
  }

  FoodPortion copyWith({
    int? id,
    int? foodId,
    String? unit,
    double? grams,
    double? quantity,
  }) => FoodPortion(
    id: id ?? this.id,
    foodId: foodId ?? this.foodId,
    unit: unit ?? this.unit,
    grams: grams ?? this.grams,
    quantity: quantity ?? this.quantity,
  );
  FoodPortion copyWithCompanion(FoodPortionsCompanion data) {
    return FoodPortion(
      id: data.id.present ? data.id.value : this.id,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      unit: data.unit.present ? data.unit.value : this.unit,
      grams: data.grams.present ? data.grams.value : this.grams,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodPortion(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('unit: $unit, ')
          ..write('grams: $grams, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, foodId, unit, grams, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodPortion &&
          other.id == this.id &&
          other.foodId == this.foodId &&
          other.unit == this.unit &&
          other.grams == this.grams &&
          other.quantity == this.quantity);
}

class FoodPortionsCompanion extends UpdateCompanion<FoodPortion> {
  final Value<int> id;
  final Value<int> foodId;
  final Value<String> unit;
  final Value<double> grams;
  final Value<double> quantity;
  const FoodPortionsCompanion({
    this.id = const Value.absent(),
    this.foodId = const Value.absent(),
    this.unit = const Value.absent(),
    this.grams = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  FoodPortionsCompanion.insert({
    this.id = const Value.absent(),
    required int foodId,
    required String unit,
    required double grams,
    required double quantity,
  }) : foodId = Value(foodId),
       unit = Value(unit),
       grams = Value(grams),
       quantity = Value(quantity);
  static Insertable<FoodPortion> custom({
    Expression<int>? id,
    Expression<int>? foodId,
    Expression<String>? unit,
    Expression<double>? grams,
    Expression<double>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodId != null) 'foodId': foodId,
      if (unit != null) 'unitName': unit,
      if (grams != null) 'gramsPerPortion': grams,
      if (quantity != null) 'amountPerPortion': quantity,
    });
  }

  FoodPortionsCompanion copyWith({
    Value<int>? id,
    Value<int>? foodId,
    Value<String>? unit,
    Value<double>? grams,
    Value<double>? quantity,
  }) {
    return FoodPortionsCompanion(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      unit: unit ?? this.unit,
      grams: grams ?? this.grams,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (foodId.present) {
      map['foodId'] = Variable<int>(foodId.value);
    }
    if (unit.present) {
      map['unitName'] = Variable<String>(unit.value);
    }
    if (grams.present) {
      map['gramsPerPortion'] = Variable<double>(grams.value);
    }
    if (quantity.present) {
      map['amountPerPortion'] = Variable<double>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodPortionsCompanion(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('unit: $unit, ')
          ..write('grams: $grams, ')
          ..write('quantity: $quantity')
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
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  @override
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
    'grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
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
    grams,
    unit,
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
    if (data.containsKey('grams')) {
      context.handle(
        _gramsMeta,
        grams.isAcceptableOrUnknown(data['grams']!, _gramsMeta),
      );
    } else if (isInserting) {
      context.missing(_gramsMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
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
      grams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grams'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
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
  final double grams;
  final String unit;
  const RecipeItem({
    required this.id,
    required this.recipeId,
    this.ingredientFoodId,
    this.ingredientRecipeId,
    required this.grams,
    required this.unit,
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
    map['grams'] = Variable<double>(grams);
    map['unit'] = Variable<String>(unit);
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
      grams: Value(grams),
      unit: Value(unit),
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
      grams: serializer.fromJson<double>(json['grams']),
      unit: serializer.fromJson<String>(json['unit']),
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
      'grams': serializer.toJson<double>(grams),
      'unit': serializer.toJson<String>(unit),
    };
  }

  RecipeItem copyWith({
    int? id,
    int? recipeId,
    Value<int?> ingredientFoodId = const Value.absent(),
    Value<int?> ingredientRecipeId = const Value.absent(),
    double? grams,
    String? unit,
  }) => RecipeItem(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    ingredientFoodId: ingredientFoodId.present
        ? ingredientFoodId.value
        : this.ingredientFoodId,
    ingredientRecipeId: ingredientRecipeId.present
        ? ingredientRecipeId.value
        : this.ingredientRecipeId,
    grams: grams ?? this.grams,
    unit: unit ?? this.unit,
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
      grams: data.grams.present ? data.grams.value : this.grams,
      unit: data.unit.present ? data.unit.value : this.unit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItem(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientFoodId: $ingredientFoodId, ')
          ..write('ingredientRecipeId: $ingredientRecipeId, ')
          ..write('grams: $grams, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    ingredientFoodId,
    ingredientRecipeId,
    grams,
    unit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeItem &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.ingredientFoodId == this.ingredientFoodId &&
          other.ingredientRecipeId == this.ingredientRecipeId &&
          other.grams == this.grams &&
          other.unit == this.unit);
}

class RecipeItemsCompanion extends UpdateCompanion<RecipeItem> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int?> ingredientFoodId;
  final Value<int?> ingredientRecipeId;
  final Value<double> grams;
  final Value<String> unit;
  const RecipeItemsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.ingredientFoodId = const Value.absent(),
    this.ingredientRecipeId = const Value.absent(),
    this.grams = const Value.absent(),
    this.unit = const Value.absent(),
  });
  RecipeItemsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    this.ingredientFoodId = const Value.absent(),
    this.ingredientRecipeId = const Value.absent(),
    required double grams,
    required String unit,
  }) : recipeId = Value(recipeId),
       grams = Value(grams),
       unit = Value(unit);
  static Insertable<RecipeItem> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? ingredientFoodId,
    Expression<int>? ingredientRecipeId,
    Expression<double>? grams,
    Expression<String>? unit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (ingredientFoodId != null) 'ingredient_food_id': ingredientFoodId,
      if (ingredientRecipeId != null)
        'ingredient_recipe_id': ingredientRecipeId,
      if (grams != null) 'grams': grams,
      if (unit != null) 'unit': unit,
    });
  }

  RecipeItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<int?>? ingredientFoodId,
    Value<int?>? ingredientRecipeId,
    Value<double>? grams,
    Value<String>? unit,
  }) {
    return RecipeItemsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      ingredientFoodId: ingredientFoodId ?? this.ingredientFoodId,
      ingredientRecipeId: ingredientRecipeId ?? this.ingredientRecipeId,
      grams: grams ?? this.grams,
      unit: unit ?? this.unit,
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
    if (grams.present) {
      map['grams'] = Variable<double>(grams.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
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
          ..write('grams: $grams, ')
          ..write('unit: $unit')
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
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  @override
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
    'grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    logTimestamp,
    foodId,
    recipeId,
    grams,
    unit,
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
    if (data.containsKey('grams')) {
      context.handle(
        _gramsMeta,
        grams.isAcceptableOrUnknown(data['grams']!, _gramsMeta),
      );
    } else if (isInserting) {
      context.missing(_gramsMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
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
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      ),
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      ),
      grams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grams'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
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
  final int? foodId;
  final int? recipeId;
  final double grams;
  final String unit;
  const LoggedFood({
    required this.id,
    required this.logTimestamp,
    this.foodId,
    this.recipeId,
    required this.grams,
    required this.unit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['log_timestamp'] = Variable<int>(logTimestamp);
    if (!nullToAbsent || foodId != null) {
      map['food_id'] = Variable<int>(foodId);
    }
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<int>(recipeId);
    }
    map['grams'] = Variable<double>(grams);
    map['unit'] = Variable<String>(unit);
    return map;
  }

  LoggedFoodsCompanion toCompanion(bool nullToAbsent) {
    return LoggedFoodsCompanion(
      id: Value(id),
      logTimestamp: Value(logTimestamp),
      foodId: foodId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodId),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
      grams: Value(grams),
      unit: Value(unit),
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
      foodId: serializer.fromJson<int?>(json['foodId']),
      recipeId: serializer.fromJson<int?>(json['recipeId']),
      grams: serializer.fromJson<double>(json['grams']),
      unit: serializer.fromJson<String>(json['unit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logTimestamp': serializer.toJson<int>(logTimestamp),
      'foodId': serializer.toJson<int?>(foodId),
      'recipeId': serializer.toJson<int?>(recipeId),
      'grams': serializer.toJson<double>(grams),
      'unit': serializer.toJson<String>(unit),
    };
  }

  LoggedFood copyWith({
    int? id,
    int? logTimestamp,
    Value<int?> foodId = const Value.absent(),
    Value<int?> recipeId = const Value.absent(),
    double? grams,
    String? unit,
  }) => LoggedFood(
    id: id ?? this.id,
    logTimestamp: logTimestamp ?? this.logTimestamp,
    foodId: foodId.present ? foodId.value : this.foodId,
    recipeId: recipeId.present ? recipeId.value : this.recipeId,
    grams: grams ?? this.grams,
    unit: unit ?? this.unit,
  );
  LoggedFood copyWithCompanion(LoggedFoodsCompanion data) {
    return LoggedFood(
      id: data.id.present ? data.id.value : this.id,
      logTimestamp: data.logTimestamp.present
          ? data.logTimestamp.value
          : this.logTimestamp,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      grams: data.grams.present ? data.grams.value : this.grams,
      unit: data.unit.present ? data.unit.value : this.unit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoggedFood(')
          ..write('id: $id, ')
          ..write('logTimestamp: $logTimestamp, ')
          ..write('foodId: $foodId, ')
          ..write('recipeId: $recipeId, ')
          ..write('grams: $grams, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, logTimestamp, foodId, recipeId, grams, unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoggedFood &&
          other.id == this.id &&
          other.logTimestamp == this.logTimestamp &&
          other.foodId == this.foodId &&
          other.recipeId == this.recipeId &&
          other.grams == this.grams &&
          other.unit == this.unit);
}

class LoggedFoodsCompanion extends UpdateCompanion<LoggedFood> {
  final Value<int> id;
  final Value<int> logTimestamp;
  final Value<int?> foodId;
  final Value<int?> recipeId;
  final Value<double> grams;
  final Value<String> unit;
  const LoggedFoodsCompanion({
    this.id = const Value.absent(),
    this.logTimestamp = const Value.absent(),
    this.foodId = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.grams = const Value.absent(),
    this.unit = const Value.absent(),
  });
  LoggedFoodsCompanion.insert({
    this.id = const Value.absent(),
    required int logTimestamp,
    this.foodId = const Value.absent(),
    this.recipeId = const Value.absent(),
    required double grams,
    required String unit,
  }) : logTimestamp = Value(logTimestamp),
       grams = Value(grams),
       unit = Value(unit);
  static Insertable<LoggedFood> custom({
    Expression<int>? id,
    Expression<int>? logTimestamp,
    Expression<int>? foodId,
    Expression<int>? recipeId,
    Expression<double>? grams,
    Expression<String>? unit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logTimestamp != null) 'log_timestamp': logTimestamp,
      if (foodId != null) 'food_id': foodId,
      if (recipeId != null) 'recipe_id': recipeId,
      if (grams != null) 'grams': grams,
      if (unit != null) 'unit': unit,
    });
  }

  LoggedFoodsCompanion copyWith({
    Value<int>? id,
    Value<int>? logTimestamp,
    Value<int?>? foodId,
    Value<int?>? recipeId,
    Value<double>? grams,
    Value<String>? unit,
  }) {
    return LoggedFoodsCompanion(
      id: id ?? this.id,
      logTimestamp: logTimestamp ?? this.logTimestamp,
      foodId: foodId ?? this.foodId,
      recipeId: recipeId ?? this.recipeId,
      grams: grams ?? this.grams,
      unit: unit ?? this.unit,
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
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (grams.present) {
      map['grams'] = Variable<double>(grams.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoggedFoodsCompanion(')
          ..write('id: $id, ')
          ..write('logTimestamp: $logTimestamp, ')
          ..write('foodId: $foodId, ')
          ..write('recipeId: $recipeId, ')
          ..write('grams: $grams, ')
          ..write('unit: $unit')
          ..write(')'))
        .toString();
  }
}

abstract class _$LiveDatabase extends GeneratedDatabase {
  _$LiveDatabase(QueryExecutor e) : super(e);
  $LiveDatabaseManager get managers => $LiveDatabaseManager(this);
  late final $FoodsTable foods = $FoodsTable(this);
  late final $FoodPortionsTable foodPortions = $FoodPortionsTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeItemsTable recipeItems = $RecipeItemsTable(this);
  late final $LoggedFoodsTable loggedFoods = $LoggedFoodsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    foods,
    foodPortions,
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
      Value<String?> emoji,
      Value<String?> thumbnail,
      required double caloriesPerGram,
      required double proteinPerGram,
      required double fatPerGram,
      required double carbsPerGram,
      required double fiberPerGram,
      Value<int?> sourceFdcId,
      Value<String?> sourceBarcode,
      Value<bool> hidden,
    });
typedef $$FoodsTableUpdateCompanionBuilder =
    FoodsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> source,
      Value<String?> emoji,
      Value<String?> thumbnail,
      Value<double> caloriesPerGram,
      Value<double> proteinPerGram,
      Value<double> fatPerGram,
      Value<double> carbsPerGram,
      Value<double> fiberPerGram,
      Value<int?> sourceFdcId,
      Value<String?> sourceBarcode,
      Value<bool> hidden,
    });

final class $$FoodsTableReferences
    extends BaseReferences<_$LiveDatabase, $FoodsTable, Food> {
  $$FoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FoodPortionsTable, List<FoodPortion>>
  _foodPortionsRefsTable(_$LiveDatabase db) => MultiTypedResultKey.fromTable(
    db.foodPortions,
    aliasName: $_aliasNameGenerator(db.foods.id, db.foodPortions.foodId),
  );

  $$FoodPortionsTableProcessedTableManager get foodPortionsRefs {
    final manager = $$FoodPortionsTableTableManager(
      $_db,
      $_db.foodPortions,
    ).filter((f) => f.foodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodPortionsRefsTable($_db));
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

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnail => $composableBuilder(
    column: $table.thumbnail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesPerGram => $composableBuilder(
    column: $table.caloriesPerGram,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinPerGram => $composableBuilder(
    column: $table.proteinPerGram,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatPerGram => $composableBuilder(
    column: $table.fatPerGram,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsPerGram => $composableBuilder(
    column: $table.carbsPerGram,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberPerGram => $composableBuilder(
    column: $table.fiberPerGram,
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

  Expression<bool> foodPortionsRefs(
    Expression<bool> Function($$FoodPortionsTableFilterComposer f) f,
  ) {
    final $$FoodPortionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodPortions,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodPortionsTableFilterComposer(
            $db: $db,
            $table: $db.foodPortions,
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

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnail => $composableBuilder(
    column: $table.thumbnail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesPerGram => $composableBuilder(
    column: $table.caloriesPerGram,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinPerGram => $composableBuilder(
    column: $table.proteinPerGram,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPerGram => $composableBuilder(
    column: $table.fatPerGram,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsPerGram => $composableBuilder(
    column: $table.carbsPerGram,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberPerGram => $composableBuilder(
    column: $table.fiberPerGram,
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

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get thumbnail =>
      $composableBuilder(column: $table.thumbnail, builder: (column) => column);

  GeneratedColumn<double> get caloriesPerGram => $composableBuilder(
    column: $table.caloriesPerGram,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinPerGram => $composableBuilder(
    column: $table.proteinPerGram,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatPerGram => $composableBuilder(
    column: $table.fatPerGram,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsPerGram => $composableBuilder(
    column: $table.carbsPerGram,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiberPerGram => $composableBuilder(
    column: $table.fiberPerGram,
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

  Expression<T> foodPortionsRefs<T extends Object>(
    Expression<T> Function($$FoodPortionsTableAnnotationComposer a) f,
  ) {
    final $$FoodPortionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodPortions,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodPortionsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodPortions,
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
            bool foodPortionsRefs,
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
                Value<String?> emoji = const Value.absent(),
                Value<String?> thumbnail = const Value.absent(),
                Value<double> caloriesPerGram = const Value.absent(),
                Value<double> proteinPerGram = const Value.absent(),
                Value<double> fatPerGram = const Value.absent(),
                Value<double> carbsPerGram = const Value.absent(),
                Value<double> fiberPerGram = const Value.absent(),
                Value<int?> sourceFdcId = const Value.absent(),
                Value<String?> sourceBarcode = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
              }) => FoodsCompanion(
                id: id,
                name: name,
                source: source,
                emoji: emoji,
                thumbnail: thumbnail,
                caloriesPerGram: caloriesPerGram,
                proteinPerGram: proteinPerGram,
                fatPerGram: fatPerGram,
                carbsPerGram: carbsPerGram,
                fiberPerGram: fiberPerGram,
                sourceFdcId: sourceFdcId,
                sourceBarcode: sourceBarcode,
                hidden: hidden,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String source,
                Value<String?> emoji = const Value.absent(),
                Value<String?> thumbnail = const Value.absent(),
                required double caloriesPerGram,
                required double proteinPerGram,
                required double fatPerGram,
                required double carbsPerGram,
                required double fiberPerGram,
                Value<int?> sourceFdcId = const Value.absent(),
                Value<String?> sourceBarcode = const Value.absent(),
                Value<bool> hidden = const Value.absent(),
              }) => FoodsCompanion.insert(
                id: id,
                name: name,
                source: source,
                emoji: emoji,
                thumbnail: thumbnail,
                caloriesPerGram: caloriesPerGram,
                proteinPerGram: proteinPerGram,
                fatPerGram: fatPerGram,
                carbsPerGram: carbsPerGram,
                fiberPerGram: fiberPerGram,
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
                foodPortionsRefs = false,
                recipeItemsRefs = false,
                loggedFoodsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (foodPortionsRefs) db.foodPortions,
                    if (recipeItemsRefs) db.recipeItems,
                    if (loggedFoodsRefs) db.loggedFoods,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (foodPortionsRefs)
                        await $_getPrefetchedData<
                          Food,
                          $FoodsTable,
                          FoodPortion
                        >(
                          currentTable: table,
                          referencedTable: $$FoodsTableReferences
                              ._foodPortionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FoodsTableReferences(
                                db,
                                table,
                                p0,
                              ).foodPortionsRefs,
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
        bool foodPortionsRefs,
        bool recipeItemsRefs,
        bool loggedFoodsRefs,
      })
    >;
typedef $$FoodPortionsTableCreateCompanionBuilder =
    FoodPortionsCompanion Function({
      Value<int> id,
      required int foodId,
      required String unit,
      required double grams,
      required double quantity,
    });
typedef $$FoodPortionsTableUpdateCompanionBuilder =
    FoodPortionsCompanion Function({
      Value<int> id,
      Value<int> foodId,
      Value<String> unit,
      Value<double> grams,
      Value<double> quantity,
    });

final class $$FoodPortionsTableReferences
    extends BaseReferences<_$LiveDatabase, $FoodPortionsTable, FoodPortion> {
  $$FoodPortionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoodsTable _foodIdTable(_$LiveDatabase db) => db.foods.createAlias(
    $_aliasNameGenerator(db.foodPortions.foodId, db.foods.id),
  );

  $$FoodsTableProcessedTableManager get foodId {
    final $_column = $_itemColumn<int>('foodId')!;

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

class $$FoodPortionsTableFilterComposer
    extends Composer<_$LiveDatabase, $FoodPortionsTable> {
  $$FoodPortionsTableFilterComposer({
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

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
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

class $$FoodPortionsTableOrderingComposer
    extends Composer<_$LiveDatabase, $FoodPortionsTable> {
  $$FoodPortionsTableOrderingComposer({
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

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
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

class $$FoodPortionsTableAnnotationComposer
    extends Composer<_$LiveDatabase, $FoodPortionsTable> {
  $$FoodPortionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

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

class $$FoodPortionsTableTableManager
    extends
        RootTableManager<
          _$LiveDatabase,
          $FoodPortionsTable,
          FoodPortion,
          $$FoodPortionsTableFilterComposer,
          $$FoodPortionsTableOrderingComposer,
          $$FoodPortionsTableAnnotationComposer,
          $$FoodPortionsTableCreateCompanionBuilder,
          $$FoodPortionsTableUpdateCompanionBuilder,
          (FoodPortion, $$FoodPortionsTableReferences),
          FoodPortion,
          PrefetchHooks Function({bool foodId})
        > {
  $$FoodPortionsTableTableManager(_$LiveDatabase db, $FoodPortionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodPortionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodPortionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodPortionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> foodId = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> grams = const Value.absent(),
                Value<double> quantity = const Value.absent(),
              }) => FoodPortionsCompanion(
                id: id,
                foodId: foodId,
                unit: unit,
                grams: grams,
                quantity: quantity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int foodId,
                required String unit,
                required double grams,
                required double quantity,
              }) => FoodPortionsCompanion.insert(
                id: id,
                foodId: foodId,
                unit: unit,
                grams: grams,
                quantity: quantity,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FoodPortionsTableReferences(db, table, e),
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
                                referencedTable: $$FoodPortionsTableReferences
                                    ._foodIdTable(db),
                                referencedColumn: $$FoodPortionsTableReferences
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

typedef $$FoodPortionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiveDatabase,
      $FoodPortionsTable,
      FoodPortion,
      $$FoodPortionsTableFilterComposer,
      $$FoodPortionsTableOrderingComposer,
      $$FoodPortionsTableAnnotationComposer,
      $$FoodPortionsTableCreateCompanionBuilder,
      $$FoodPortionsTableUpdateCompanionBuilder,
      (FoodPortion, $$FoodPortionsTableReferences),
      FoodPortion,
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
      required double grams,
      required String unit,
    });
typedef $$RecipeItemsTableUpdateCompanionBuilder =
    RecipeItemsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<int?> ingredientFoodId,
      Value<int?> ingredientRecipeId,
      Value<double> grams,
      Value<String> unit,
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

  ColumnFilters<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
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

  ColumnOrderings<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
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

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

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
                Value<double> grams = const Value.absent(),
                Value<String> unit = const Value.absent(),
              }) => RecipeItemsCompanion(
                id: id,
                recipeId: recipeId,
                ingredientFoodId: ingredientFoodId,
                ingredientRecipeId: ingredientRecipeId,
                grams: grams,
                unit: unit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                Value<int?> ingredientFoodId = const Value.absent(),
                Value<int?> ingredientRecipeId = const Value.absent(),
                required double grams,
                required String unit,
              }) => RecipeItemsCompanion.insert(
                id: id,
                recipeId: recipeId,
                ingredientFoodId: ingredientFoodId,
                ingredientRecipeId: ingredientRecipeId,
                grams: grams,
                unit: unit,
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
      Value<int?> foodId,
      Value<int?> recipeId,
      required double grams,
      required String unit,
    });
typedef $$LoggedFoodsTableUpdateCompanionBuilder =
    LoggedFoodsCompanion Function({
      Value<int> id,
      Value<int> logTimestamp,
      Value<int?> foodId,
      Value<int?> recipeId,
      Value<double> grams,
      Value<String> unit,
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

  ColumnFilters<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
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

  ColumnOrderings<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
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

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

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
                Value<int?> foodId = const Value.absent(),
                Value<int?> recipeId = const Value.absent(),
                Value<double> grams = const Value.absent(),
                Value<String> unit = const Value.absent(),
              }) => LoggedFoodsCompanion(
                id: id,
                logTimestamp: logTimestamp,
                foodId: foodId,
                recipeId: recipeId,
                grams: grams,
                unit: unit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int logTimestamp,
                Value<int?> foodId = const Value.absent(),
                Value<int?> recipeId = const Value.absent(),
                required double grams,
                required String unit,
              }) => LoggedFoodsCompanion.insert(
                id: id,
                logTimestamp: logTimestamp,
                foodId: foodId,
                recipeId: recipeId,
                grams: grams,
                unit: unit,
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
  $$FoodPortionsTableTableManager get foodPortions =>
      $$FoodPortionsTableTableManager(_db, _db.foodPortions);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeItemsTableTableManager get recipeItems =>
      $$RecipeItemsTableTableManager(_db, _db.recipeItems);
  $$LoggedFoodsTableTableManager get loggedFoods =>
      $$LoggedFoodsTableTableManager(_db, _db.loggedFoods);
}
