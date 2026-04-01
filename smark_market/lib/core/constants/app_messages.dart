class AppMessages {
  // Errores de Conexión
  static const String connectionError = 'Error de conexión. Verifica tu internet.';
  static const String timeoutError = 'El servidor tardó mucho en responder.';
  static const String serverError = 'Error interno del servidor (500).';
  static const String notFoundError = 'Recurso no encontrado (404).';
  static const String unknownError = 'Ocurrió un error inesperado.';

  // Errores de Autenticación
  static const String emailAlreadyExists = 'Este correo ya está registrado.';
  static const String invalidCredentials = 'Correo o contraseña incorrectos.';
  static const String weakPassword = 'La contraseña es muy débil.';
  static const String loginSuccess = '¡Bienvenido de nuevo!';
  static const String registerSuccess = 'Cuenta creada exitosamente.';
  static const String resetEmailSent = 'Se envió un correo de recuperación.';

  // Estados de Búsqueda
  static const String searching = 'Buscando las mejores ofertas...';
  static const String noResults = 'No encontramos productos para tu búsqueda.';
  static const String emptyQuery = 'Por favor escribe algo para buscar.';

  // Mensajes de UI
  static const String welcomeBack = 'Hola de nuevo';
  static const String updateBudget = 'Presupuesto actualizado correctamente.';
}
