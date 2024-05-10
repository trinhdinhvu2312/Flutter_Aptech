class GetCategoryRequest {
  final int page;
  final int limit;

  GetCategoryRequest({
    this.page = 0,
    this.limit = 10,
  })  :
        assert(page >= 0, 'Page must be greater than or equal to 0'),
        assert(limit >= 1 && limit <= 100, 'Limit must be between 1 and 100');

  Map<String, String> toJson() {
    return {
      'page': page.toString(),
      'limit': limit.toString(),
    };
  }
}
