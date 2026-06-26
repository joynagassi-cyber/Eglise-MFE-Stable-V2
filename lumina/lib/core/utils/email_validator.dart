class EmailValidator {
  static final _regex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  static final _disposableDomains = {
    'tempmail.com',
    'guerrillamail.com',
    '10minutemail.com',
    'throwaway.email',
    'mailinator.com',
    'maildrop.cc',
    'temp-mail.org',
    'getnada.com',
    'trashmail.com',
    'yopmail.com',
    'fakeinbox.com',
    'sharklasers.com',
  };

  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email requis';
    }

    final email = value.trim().toLowerCase();

    if (!_regex.hasMatch(email)) {
      return 'Format email invalide';
    }

    if (email.length > 254) {
      return 'Email trop long';
    }

    final domain = email.split('@').last;
    if (_disposableDomains.contains(domain)) {
      return 'Les emails jetables ne sont pas acceptés';
    }

    if (domain.contains('test') || domain.contains('example')) {
      return 'Domaine email invalide';
    }

    return null;
  }
}
