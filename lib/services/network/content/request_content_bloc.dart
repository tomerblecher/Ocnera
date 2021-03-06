import 'dart:async';

import 'package:ocnera/contracts/media_content.dart';
import 'package:ocnera/contracts/media_content_request.dart';
import 'package:ocnera/model/response/media_content/requests/media_content_request_response.dart';
import 'package:ocnera/services/network/repository.dart';
import 'package:rxdart/rxdart.dart';

class RequestContentBloc {
  final _requestSubject = PublishSubject<MediaContentRequestResponse>();

  Stream<MediaContentRequestResponse> get requestStream =>
      _requestSubject.stream;

  Future<void> requestContent(
      MediaContent content, MediaContentRequest request) async {
    MediaContentRequestResponse res =
        await repo.requestContent(request, content.contentType);
    if (res.statusCode != 200 || res.isError) {
      _requestSubject.sink.addError(res);
      return;
    }

    _requestSubject.sink.add(res);
  }

  void dispose() {
    //TODO - decide whether to call this method or keep stream alive for good.
    _requestSubject.close();
  }
}
