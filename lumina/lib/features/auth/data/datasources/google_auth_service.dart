// lib/features/auth/data/datasources/google_auth_service.dart

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/logging/app_logger.dart';
import '../../domain/exceptions/google_auth_exceptions.dart';
import '../../domain/models/auth_result.dart';
import '../../domain/repositories/i_google_auth_service.dart';

class GoogleAuthServiceImpl implements IGoogleAuthService {
  GoogleAuthServiceImpl({
    String? webClientId,
    bool enableLogging = kDebugMode,
  })  : _googleSignIn = GoogleSignIn.instance,
        _webClientId = webClientId ??
            const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID'),
        _enableLogging = enableLogging;

  GoogleAuthServiceImpl.direct({
    required String webClientId,
    bool enableLogging = kDebugMode,
  })  : _googleSignIn = GoogleSignIn.instance,
        _webClientId = webClientId,
        _enableLogging = enableLogging;

  final GoogleSignIn _googleSignIn;
  final String? _webClientId;
  final bool _enableLogging;

  bool _initialized = false;

  void _debug(String message, {String tag = 'GOOGLE_AUTH'}) {
    if (_enableLogging) {
      AppLogger.d(message, tag);
    }
  }

  void _error(
    String message, {
    String tag = 'GOOGLE_AUTH',
    Object? error,
    StackTrace? stackTrace,
  }) {
    AppLogger.e(message, tag, error, stackTrace);
  }

  String _requireWebClientId() {
    final webClientId = _webClientId?.trim();
    if (webClientId == null || webClientId.isEmpty) {
      _error(
        'Missing GOOGLE_WEB_CLIENT_ID',
        tag: 'GOOGLE_AUTH_CONFIG',
      );
      throw const GoogleAuthException('Missing GOOGLE_WEB_CLIENT_ID');
    }
    return webClientId;
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    final webClientId = _requireWebClientId();

    try {
      _debug(
        'Initialisation GoogleSignIn avec serverClientId',
        tag: 'GOOGLE_AUTH_INIT',
      );
      await _googleSignIn.initialize(serverClientId: webClientId);
      _initialized = true;
      _debug('GoogleSignIn initialisé', tag: 'GOOGLE_AUTH_INIT');
    } on GoogleSignInException catch (e) {
      _error(
        'Echec de l\'initialisation GoogleSignIn',
        tag: 'GOOGLE_AUTH_INIT',
        error: e,
      );
      if (e.code == GoogleSignInExceptionCode.clientConfigurationError ||
          e.code == GoogleSignInExceptionCode.providerConfigurationError) {
        throw GoogleAuthException(
          'Google Sign-In configuration error: ${e.description ?? e.code.name}',
        );
      }
      throw GoogleAuthException(
        'Google Sign-In initialization failed: ${e.description ?? e.code.name}',
      );
    } catch (e, st) {
      _error(
        'Echec inattendu de l\'initialisation GoogleSignIn',
        tag: 'GOOGLE_AUTH_INIT',
        error: e,
        stackTrace: st,
      );
      throw GoogleAuthException(
        'Google Sign-In initialization failed: ${e.toString()}',
      );
    }
  }

  GoogleAuthException _mapGoogleException(
    GoogleSignInException e, {
    required String context,
  }) {
    if (e.code == GoogleSignInExceptionCode.canceled) {
      return const GoogleAuthCancelledException();
    }

    if (e.code == GoogleSignInExceptionCode.clientConfigurationError ||
        e.code == GoogleSignInExceptionCode.providerConfigurationError) {
      return GoogleAuthException(
        '$context: ${e.description ?? e.code.name}',
      );
    }

    return GoogleAuthException(
      '$context: ${e.description ?? e.code.name}',
    );
  }

  @override
  void validateConfiguration() {
    _requireWebClientId();
    _debug(
      'Configuration Google valide',
      tag: 'GOOGLE_AUTH_CONFIG',
    );
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    _debug('Demande de connexion Google', tag: 'GOOGLE_AUTH_FLOW');

    await _ensureInitialized();

    const scopes = <String>['email', 'profile'];

    try {
      _debug(
        'Ouverture du dialogue Google Sign-In',
        tag: 'GOOGLE_AUTH_FLOW',
      );
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate(scopeHint: scopes);

      _debug(
        'Compte Google sélectionné: ${googleUser.email}',
        tag: 'GOOGLE_AUTH_FLOW',
      );

      final GoogleSignInAuthentication auth = googleUser.authentication;
      final String? idToken = auth.idToken;
      if (idToken == null || idToken.trim().isEmpty) {
        _error(
          'idToken Google manquant ou vide',
          tag: 'GOOGLE_AUTH_FLOW',
        );
        throw const GoogleAuthTokenException('idToken manquant ou vide');
      }
      _debug('idToken Google reçu', tag: 'GOOGLE_AUTH_FLOW');

      // FIX google_sign_in v7 : authorizationClient.authorizeScopes peut échouer
      // ou retourner un accessToken vide sur certaines configs Android.
      // Supabase accepte signInWithIdToken avec idToken seul, donc on ne
      // bloque plus ici : on envoie accessToken vide dans ce cas.
      String accessToken = '';
      try {
        final GoogleSignInClientAuthorization clientAuth =
            await googleUser.authorizationClient.authorizeScopes(scopes);
        accessToken = clientAuth.accessToken;
        _debug('accessToken Google reçu (${accessToken.length} chars)',
            tag: 'GOOGLE_AUTH_FLOW');
      } on GoogleSignInException catch (_) {
        _debug('authorizeScopes indisponible, tentative sans accessToken',
            tag: 'GOOGLE_AUTH_FLOW');
      } catch (_) {
        _debug('Erreur authorizeScopes ignorée', tag: 'GOOGLE_AUTH_FLOW');
      }

      return AuthResult(
        idToken: idToken,
        accessToken: accessToken,
        email: googleUser.email,
        name: googleUser.displayName,
      );
    } on GoogleSignInException catch (e, st) {
      _error(
        'Erreur GoogleSignIn pendant la connexion',
        tag: 'GOOGLE_AUTH_FLOW',
        error: e,
        stackTrace: st,
      );
      throw _mapGoogleException(e, context: 'Google Sign-In failed');
    } on GoogleAuthException {
      rethrow;
    } catch (e, st) {
      _error(
        'Erreur inattendue dans le flux Google',
        tag: 'GOOGLE_AUTH_FLOW',
        error: e,
        stackTrace: st,
      );
      throw GoogleAuthException(
        'Erreur inattendue dans le flux Google: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> signOut() async {
    if (!_initialized && (_webClientId?.trim().isEmpty ?? true)) {
      _debug(
        'Déconnexion Google ignorée: GOOGLE_WEB_CLIENT_ID manquant',
        tag: 'GOOGLE_AUTH_FLOW',
      );
      return;
    }

    if (!_initialized) {
      await _ensureInitialized();
    }

    _debug('Déconnexion Google', tag: 'GOOGLE_AUTH_FLOW');
    try {
      await _googleSignIn.signOut();
      _debug('Déconnexion Google réussie', tag: 'GOOGLE_AUTH_FLOW');
    } on GoogleSignInException catch (e, st) {
      _error(
        'Erreur GoogleSignIn pendant la déconnexion',
        tag: 'GOOGLE_AUTH_FLOW',
        error: e,
        stackTrace: st,
      );
      throw GoogleAuthException(
        'Erreur lors de la déconnexion Google: ${e.description ?? e.code.name}',
      );
    } catch (e, st) {
      _error(
        'Erreur inattendue pendant la déconnexion Google',
        tag: 'GOOGLE_AUTH_FLOW',
        error: e,
        stackTrace: st,
      );
      throw GoogleAuthException(
        'Erreur lors de la déconnexion Google: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isSignedIn() async {
    if ((_webClientId?.trim().isEmpty ?? true) && !_initialized) {
      _debug(
        'Vérification Google ignorée: GOOGLE_WEB_CLIENT_ID manquant',
        tag: 'GOOGLE_AUTH_STATUS',
      );
      return false;
    }

    try {
      await _ensureInitialized();
      final result = await _googleSignIn.attemptLightweightAuthentication();
      final isSignedIn = result != null;
      _debug('Statut de session Google: $isSignedIn',
          tag: 'GOOGLE_AUTH_STATUS');
      return isSignedIn;
    } on GoogleAuthException {
      return false;
    } catch (e, st) {
      _error(
        'Erreur lors de la vérification de la session Google',
        tag: 'GOOGLE_AUTH_STATUS',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }
}
