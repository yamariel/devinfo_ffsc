// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleModelAdapter extends TypeAdapter<ArticleModel> {
  @override
  final int typeId = 0;

  @override
  ArticleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArticleModel(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      url: fields[3] as String,
      coverImage: fields[4] as String?,
      socialImage: fields[5] as String?,
      publishedAt: fields[6] as String,
      readablePublishDate: fields[7] as String,
      readingTimeMinutes: fields[8] as int,
      publicReactionsCount: fields[9] as int,
      commentsCount: fields[10] as int,
      tags: fields[11] as String,
      authorName: fields[12] as String,
      authorUsername: fields[13] as String,
      authorProfileImage: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ArticleModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.coverImage)
      ..writeByte(5)
      ..write(obj.socialImage)
      ..writeByte(6)
      ..write(obj.publishedAt)
      ..writeByte(7)
      ..write(obj.readablePublishDate)
      ..writeByte(8)
      ..write(obj.readingTimeMinutes)
      ..writeByte(9)
      ..write(obj.publicReactionsCount)
      ..writeByte(10)
      ..write(obj.commentsCount)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.authorName)
      ..writeByte(13)
      ..write(obj.authorUsername)
      ..writeByte(14)
      ..write(obj.authorProfileImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
