// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) => Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String?,
      filePath: json['filePath'] as String,
      fileType: $enumDecode(_$FileTypeEnumMap, json['fileType']),
      fileSize: (json['fileSize'] as num?)?.toInt() ?? 0,
      coverPath: json['coverPath'] as String?,
      fileHash: json['fileHash'] as String?,
      lastOpened: json['lastOpened'] == null
          ? null
          : DateTime.parse(json['lastOpened'] as String),
      addedAt: DateTime.parse(json['addedAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      readingProgress: (json['readingProgress'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'filePath': instance.filePath,
      'fileType': _$FileTypeEnumMap[instance.fileType]!,
      'fileSize': instance.fileSize,
      'coverPath': instance.coverPath,
      'fileHash': instance.fileHash,
      'lastOpened': instance.lastOpened?.toIso8601String(),
      'addedAt': instance.addedAt.toIso8601String(),
      'isFavorite': instance.isFavorite,
      'isPinned': instance.isPinned,
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'readingProgress': instance.readingProgress,
    };

const _$FileTypeEnumMap = {
  FileType.txt: 'txt',
  FileType.markdown: 'markdown',
  FileType.epub: 'epub',
  FileType.html: 'html',
};
