

import 'package:client/classes/utilizable.dart';
import 'package:client/dto/page_dto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


typedef PageableSetter<T> = void Function(List<T> content, {int? index});


class PageableLoader<T, F extends Comparable<F>> with Utilizable implements IUtilizable {

  final List<T> Function(F filter)? sync;
  final Future<PageDto<T>> Function(F filter, int page) async;

  final Rx<bool> isLoading;
  final Rx<bool> isUploading;
  final PageableSetter<T> setter;

  F _filter;
  int page = 0;
  int? size;
  int? pages = 0;
  List<T> content = <T>[];

  PageableLoader({
    required this.async,
    this.sync,
    required this.setter,
    required this.isLoading,
    required this.isUploading,
    required F query,
  }) :
        _filter = query;

  setContent(List<T> content, {int? index}) {
    this.content = content;
    setter(content, index: index);
  }

  F get filter => _filter;

  updateFilter(F Function(F) updater) {
    setFilter(updater.call(_filter));
  }

  setFilter(F nextFilter) {

    if (_filter.compareTo(nextFilter) != 0) {
      _filter = nextFilter;
      _load(nextFilter);
    }

  }

  load() => _load(_filter);

  _load(F nextFilter) async {

    List<T> newContent = [];
    if (sync != null) {
      newContent = sync!(nextFilter);
    }


    final used = Set<T>.of(newContent);
    if (newContent.isEmpty) {
      isLoading.value = true;
      isUploading.value = false;
    } else {
      isLoading.value = false;
      isUploading.value = true;
      setContent(newContent, index: 0);
    }

    PageDto<T>? result;

    try {
      result = await async.call(nextFilter, 0);
    } catch(e, st) {
      debugPrintStack(stackTrace: st, label: "PageableLoader error: $e");
      result = PageDto.empty();
    }

    if (utilized || _filter != nextFilter) {
      return;
    }

    page = result.page;
    size = result.size;
    pages = result.pages;

    if (result.content.isNotEmpty) {

      if (used.isNotEmpty) {
        for (var loaded in result.content) {
          if (!used.contains(loaded)) {
            newContent.add(loaded);
          }
        }
      } else {
        newContent.addAll(result.content);
      }

    }

    // NB! Content must be set anyway as empty list [] it's also valid content
    setContent(newContent, index: isLoading.value ? 0 : null);

    isLoading.value = false;
    isUploading.value = false;
  }

  uploadMore() async {

    final totalPages = pages;
    final cantLoadMore = totalPages != null ? page >= totalPages - 1 : size == 0;
    if (isLoading.value || isUploading.value || cantLoadMore) {
      return;
    }

    final currentQuery = _filter;
    final nextPage = page + 1;
    isUploading.value = true;

    PageDto<T>? result;

    try {
      result = await async.call(currentQuery, nextPage);
    } catch(e) {
      debugPrint("ERROR: $e");
    }

    if (utilized || _filter != currentQuery || (page + 1) != nextPage || isLoading.value || !isUploading.value) {
      return;
    }

    isUploading.value = false;

    if (result != null) {
      page = result.page;
      pages = result.pages;
      content.addAll(result.content);
      setContent(content);
    }

  }


}
