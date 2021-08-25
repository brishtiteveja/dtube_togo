import 'dart:io';

import 'package:dtube_togo/utils/randomPermlink.dart';
import 'package:path/path.dart' as p;
import 'package:bloc/bloc.dart';
import 'package:dtube_togo/bloc/ThirdPartyUploader/ThirdPartyUploader_event.dart';
import 'package:dtube_togo/bloc/ThirdPartyUploader/ThirdPartyUploader_state.dart';

import 'package:dtube_togo/bloc/ThirdPartyUploader/ThirdPartyUploader_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

class ThirdPartyUploaderBloc
    extends Bloc<ThirdPartyUploaderEvent, ThirdPartyUploaderState> {
  ThirdPartyUploaderRepository repository;

  ThirdPartyUploaderBloc({required this.repository})
      : super(ThirdPartyUploaderInitialState());

  @override
  Stream<ThirdPartyUploaderState> mapEventToState(
      ThirdPartyUploaderEvent event) async* {
    String imageUploadProvider = await sec.getImageUploadService();
// TODO: error handling
    if (event is UploadFile) {
      yield ThirdPartyUploaderUploadingState();
      String _uploadServiceEndpoint =
          await repository.getUploadServiceEndpoint(imageUploadProvider);

      String resultString =
          await repository.uploadFile(event.filePath, _uploadServiceEndpoint);

      yield ThirdPartyUploaderUploadedState(uploadResponse: resultString);
    }
    if (event is SetThirdPartyUploaderInitState) {
      yield ThirdPartyUploaderInitialState();
    }
  }
}