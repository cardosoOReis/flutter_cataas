import 'package:anyhow/base.dart';

import '../../data/dtos/cached_cat_tags.dart';
import '../failures/app_failure.dart';
import '../repositories/local_repository.dart';
import '../repositories/remote_repository.dart';
import '../value_objects/cat_tag.dart';

class GetTagsUseCase {
  const GetTagsUseCase({
    required LocalRepository localRepository,
    required RemoteRepository remoteRepository,
  })  : _localRepository = localRepository,
        _remoteRepository = remoteRepository;

  final LocalRepository _localRepository;
  final RemoteRepository _remoteRepository;

  FutureResult<Iterable<CatTag>, AppFailure> call(DateTime now) async {
    return _getTagsFromCache(now).orElse((_) => _getRemoteTags());
  }

  FutureResult<Iterable<CatTag>, AppFailure> _getRemoteTags() async {
    final tags = await _remoteRepository.getTags();

    if (tags case Ok(ok: final tags)) {
      await _localRepository.updateCatTags(tags);
    }

    return tags;
  }

  FutureResult<Iterable<CatTag>, AppFailure> _getTagsFromCache(DateTime now) {
    return Result.async(
      ($) async {
        final cache = await _getLocalTags()[$];
        final isCacheExpired = now.difference(cache.cachedTime).inDays > 1;
        if (isCacheExpired) {
          return const Err(ExpiredCacheFailure());
        }

        return Ok(cache.tags.iter());
      },
    );
  }

  FutureResult<CachedCatTags, AppFailure> _getLocalTags() =>
      _localRepository.getCatTags();
}