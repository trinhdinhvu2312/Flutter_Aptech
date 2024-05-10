class GetProductRequest {
  final String keyword;
  final int categoryId;
  final int page;
  final int limit;

  GetProductRequest({
    this.keyword = '',
    this.categoryId = 0,
    this.page = 0,
    this.limit = 10,
  })  : assert(keyword.length <= 200, 'Keyword must be at most 200 characters'),
        assert(page >= 0, 'Page must be greater than or equal to 0'),
        assert(limit >= 1 && limit <= 100, 'Limit must be between 1 and 100');

  Map<String, String> toJson() {
    return {
      'keyword': keyword,
      'category_id': categoryId.toString(),
      'page': page.toString(),
      'limit': limit.toString(),
    };
  }
}
