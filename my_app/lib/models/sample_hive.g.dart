// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SampleAdapter extends TypeAdapter<Sample> {
  @override
  final int typeId = 0;

  @override
  Sample read(BinaryReader reader) {
    return Sample.empty();
  }

  @override
  void write(BinaryWriter writer, Sample obj) {
    writer.writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SampleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
