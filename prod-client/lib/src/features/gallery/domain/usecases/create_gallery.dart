import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/gallery/domain/repositories/gallery_repository.dart';

class CreateGalleryParams extends Equatable {
  final FormData formData;

  const CreateGalleryParams({
    required this.formData,
  });

  CreateGalleryParams.empty() : this(formData: FormData.fromMap({}));

  @override
  List<Object?> get props => [formData];
}

class CreateGallery implements UseCase<String, CreateGalleryParams> {
  final GalleryRepository _galleryRepository;
  const CreateGallery(this._galleryRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _galleryRepository.createGallery(formData: params.formData);
  }
}
