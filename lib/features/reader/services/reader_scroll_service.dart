import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReaderScrollService {
  final ScrollController scrollController = ScrollController();
  
  bool _isVisible = true;
  bool get isVisible => _isVisible;

  // Listeners that need to be notified when visibility changes
  final List<VoidCallback> _visibilityListeners = [];

  ReaderScrollService() {
    scrollController.addListener(_scrollListener);
  }

  void addVisibilityListener(VoidCallback listener) {
    _visibilityListeners.add(listener);
  }

  void removeVisibilityListener(VoidCallback listener) {
    _visibilityListeners.remove(listener);
  }

  void _notifyVisibilityListeners() {
    for (final listener in _visibilityListeners) {
      listener();
    }
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;

    final direction = scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      if (_isVisible) {
        _isVisible = false;
        _notifyVisibilityListeners();
      }
    } else if (direction == ScrollDirection.forward) {
      if (!_isVisible) {
        _isVisible = true;
        _notifyVisibilityListeners();
      }
    }
  }

  void toggleVisibility() {
    _isVisible = !_isVisible;
    _notifyVisibilityListeners();
  }

  void setVisibility(bool visible) {
    if (_isVisible != visible) {
      _isVisible = visible;
      _notifyVisibilityListeners();
    }
  }

  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    _visibilityListeners.clear();
  }
}
