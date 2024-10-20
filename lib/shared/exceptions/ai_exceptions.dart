class AiException implements Exception {
  /// The error message
  final String message;

  AiException({
    required this.message,
  });
}

/// Thrown when the parsing of the AI generated content failed
class AiParsingException extends AiException {
  AiParsingException({
    required super.message,
  });
}

/// Thrown, when the generation of AI content failed
class AiGeneratingException extends AiException {
  AiGeneratingException({
    required super.message,
  });
}
