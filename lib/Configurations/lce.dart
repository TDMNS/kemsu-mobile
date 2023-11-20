class Lce<C> {
  final bool isLoading;
  final C? content;
  final Object? error;
  final StackTrace? stack;

  bool get hasContent => content != null;

  C get requiredContent => content!;

  bool get hasError => error != null;

  Object get requiredError => error!;

  const Lce.loading()
      : isLoading = true,
        content = null,
        stack = null,
        error = null;

  const Lce.content(this.content)
      : isLoading = false,
        stack = null,
        error = null;

  const Lce.idle([this.content])
      : isLoading = false,
        stack = null,
        error = null;

  const Lce.error([this.error, this.stack])
      : isLoading = false,
        content = null;

  Lce<C> clearError() => Lce(content: content, isLoading: isLoading, error: null, stack: null);

//<editor-fold desc="Data Methods">

  const Lce({
    this.isLoading = false,
    this.content,
    this.error,
    this.stack,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lce && runtimeType == other.runtimeType && isLoading == other.isLoading && content == other.content && error == other.error && stack == other.stack);

  @override
  int get hashCode => isLoading.hashCode ^ content.hashCode ^ error.hashCode ^ stack.hashCode;

  @override
  String toString() {
    return 'Lce{ isLoading: $isLoading, content: $content, error: $error, stack: $stack,}';
  }

  Lce<C> copyWith({
    bool? isLoading,
    C? content,
    Object? error,
    StackTrace? stack,
  }) {
    return Lce(
      isLoading: isLoading ?? this.isLoading,
      content: content ?? this.content,
      error: error ?? this.error,
      stack: stack ?? this.stack,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isLoading': isLoading,
      'content': content,
      'error': error,
      'stack': stack,
    };
  }

  factory Lce.fromMap(Map<String, dynamic> map) {
    return Lce(
      isLoading: map['isLoading'] as bool,
      content: map['content'] as C,
      error: map['error'] as Object,
      stack: map['stack'] as StackTrace,
    );
  }

//</editor-fold>
}

extension LceExt<T> on T {
  Lce<T> get asContent => Lce.content(this);
}
