import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Pagination {
  final int page;
  final int limit;
  final int total;

  Pagination({required this.page, required this.limit, required this.total});

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);

  int get totalPages => (total / limit).ceil();
  bool get hasNextPage => page < totalPages;
}
