

class UnexpectedError extends Error {

  final String message;
  UnexpectedError([this.message = ""]);

  @override
  String toString() => "Unexpected error${message.isNotEmpty ? ": $message" : ""}.";

}