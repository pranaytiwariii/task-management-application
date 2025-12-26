class FilterModel {
  final String? category;
  final String? priority;
  final String? status;
  final String? searchQuery;
  final String? sortBy; // e.g., 'due_date:asc', 'priority:desc'
  final int limit;
  final int offset;

  FilterModel({
    this.category,
    this.priority,
    this.status,
    this.searchQuery,
    this.sortBy,
    this.limit = 10,
    this.offset = 0,
  });

  // Convert to query parameters for API
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{'limit': limit, 'offset': offset};

    if (category != null && category!.isNotEmpty) {
      params['category'] = category;
    }
    if (priority != null && priority!.isNotEmpty) {
      params['priority'] = priority;
    }
    if (status != null && status!.isNotEmpty) {
      params['status'] = status;
    }
    if (sortBy != null && sortBy!.isNotEmpty) {
      params['sort'] = sortBy;
    }

    return params;
  }

  FilterModel copyWith({
    String? category,
    String? priority,
    String? status,
    String? searchQuery,
    String? sortBy,
    int? limit,
    int? offset,
  }) {
    return FilterModel(
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}
