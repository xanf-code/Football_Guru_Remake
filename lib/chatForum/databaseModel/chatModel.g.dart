part of 'chatModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouritesAdapter extends TypeAdapter<Favourites> {
  @override
  final int typeId = 0;

  @override
  Favourites read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favourites(
      isSaved: fields[5] as bool,
      title: fields[0] as String,
      bg: fields[1] as String,
      logo: fields[2] as String,
      appTitle: fields[3] as String,
      ref: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Favourites obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.bg)
      ..writeByte(2)
      ..write(obj.logo)
      ..writeByte(3)
      ..write(obj.appTitle)
      ..writeByte(4)
      ..write(obj.ref)
      ..writeByte(5)
      ..write(obj.isSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouritesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
