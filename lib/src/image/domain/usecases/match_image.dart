import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/image/domain/entities/image.dart';
import 'package:pix2life/src/image/domain/repositories/image_repository.dart';

class MatchImageParams extends Equatable {
  final FormData formData;

  MatchImageParams({
    required this.formData,
  });

  MatchImageParams.empty() : this(formData: FormData.fromMap({}));

  @override
  List<Object> get props => [formData];
}

class MatchImage implements UseCase<Image, MatchImageParams> {
  final ImageRepository _imageRepository;
  const MatchImage(this._imageRepository);
  @override
  ResultFuture<Image> call(params) async {
    return await _imageRepository.matchImage(formData: params.formData);
  }
}
