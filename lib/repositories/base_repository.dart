abstract class BaseRepository<T> {
  Future<String> update({
    required T entity,
    required int logUserId,
    required String token,
  });

  Future<Map<String, dynamic>> findById({
    required int entityId,
    required int logUserId,
    required String token,
  });

  Future<Map<String, dynamic>> findAll(int logUserId, String token,
      {int page = 0});

  Future<String> add({
    required T entity,
    required int logUserId,
    required String token,
  });
}
