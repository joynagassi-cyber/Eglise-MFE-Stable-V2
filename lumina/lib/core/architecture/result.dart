/// Modèle de résultat fonctionnel (Pattern Either / Result)
/// Utilisé pour forcer la gestion des erreurs dans l'UI
sealed class Result<S, F> {
  const Result();

  /// Exécute [onSuccess] si le résultat est un succès, sinon [onFailure]
  T fold<T>(T Function(S success) onSuccess, T Function(F failure) onFailure);

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is Failure<S, F>;

  S? get successOrNull => fold((s) => s, (_) => null);
  F? get failureOrNull => fold((_) => null, (f) => f);
}

final class Success<S, F> extends Result<S, F> {
  final S value;
  const Success(this.value);

  @override
  T fold<T>(T Function(S s) onSuccess, T Function(F f) onFailure) => onSuccess(value);
}

final class Failure<S, F> extends Result<S, F> {
  final F error;
  const Failure(this.error);

  @override
  T fold<T>(T Function(S s) onSuccess, T Function(F f) onFailure) => onFailure(error);
}
