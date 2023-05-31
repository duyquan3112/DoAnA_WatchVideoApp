import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/info_video.dart';

/// The different ways that we can filter/sort video.
enum VideoQuery {
  newest,
  oldest,
  likesDesc,
}

extension on Query<InfoVideo> {
  /// Create a firebase query from a [VideoQuery]
  Query<InfoVideo> queryBy(VideoQuery query) {
    switch (query) {
      case VideoQuery.newest:
        return orderBy(
          'timeStamp',
          descending: true,
        );
      case VideoQuery.oldest:
        return orderBy(
          'timeStamp',
        );
      case VideoQuery.likesDesc:
        return orderBy(
          'likedCount',
          descending: query == VideoQuery.likesDesc,
        );
    }
  }
}
