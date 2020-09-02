import 'dart:convert';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const tableCategory = SqfEntityTable(
  tableName: 'storage',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  useSoftDeleting: true,
  modelName: null,
  fields: [
    SqfEntityField('path', DbType.text)
  ]
);

@SqfEntityBuilder(notesDbModel)
const notesDbModel = SqfEntityModel(
    modelName: 'MyDbModel', // optional
    databaseName: 'sampleORM.db',
    databaseTables: [tableCategory],
    sequences: [],
    bundledDatabasePath: null 
);