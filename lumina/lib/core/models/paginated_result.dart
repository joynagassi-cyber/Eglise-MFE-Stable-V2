/// Résultat paginé générique pour toutes les listes
class PaginatedResult<T> {
  final List<T> items;
  final int total;
  final int page;
  final int perPage;
  final bool hasMore;

  PaginatedResult({
    required this.items,
    required this.total,
    required this.page,
    required this.perPage,
  }) : hasMore = (page * perPage) < total;

  int get totalPages => (total / perPage).ceil();
  bool get isFirstPage => page == 1;
  bool get isLastPage => !hasMore;
}
