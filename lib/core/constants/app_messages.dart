class AppMessages {
  static String currentLanguage = 'en';

  static String _t(String en, String es) => currentLanguage == 'es' ? es : en;

  // Connection Errors
  static String get connectionError => _t(
      'Connection error. Please check your internet.',
      'Error de conexión. Por favor verifica tu internet.');
  static String get timeoutError => _t('Server took too long to respond.',
      'El servidor tardó demasiado en responder.');
  static String get serverError =>
      _t('Internal server error (500).', 'Error interno del servidor (500).');
  static String get notFoundError =>
      _t('Resource not found (404).', 'Recurso no encontrado (404).');
  static String get unknownError =>
      _t('An unexpected error occurred.', 'Ocurrió un error inesperado.');

  // Authentication Errors
  static String get emailAlreadyExists => _t(
      'This email is already registered.', 'Este correo ya está registrado.');
  static String get invalidCredentials =>
      _t('Incorrect email or password.', 'Correo o contraseña incorrectos.');
  static String get weakPassword =>
      _t('The password is too weak.', 'La contraseña es muy débil.');
  static String get loginSuccess =>
      _t('Welcome back!', '¡Bienvenido de nuevo!');
  static String get registerSuccess =>
      _t('Account created successfully.', 'Cuenta creada con éxito.');
  static String get resetEmailSent => _t('Recovery email has been sent.',
      'Se ha enviado el correo de recuperación.');

  // Search States
  static String get searching =>
      _t('Searching for the best offers...', 'Buscando las mejores ofertas...');
  static String get noResults => _t(
      'We couldn\'t find products for your search.',
      'No encontramos productos para tu búsqueda.');
  static String get emptyQuery => _t('Please type something to search.',
      'Por favor escribe algo para buscar.');

  // UI Messages
  static String get welcomeBack => _t('Hello again', 'Hola de nuevo');
  static String get welcomeTagline => _t('Your intelligent price comparator.',
      'Tu comparador inteligente de precios.');
  static String get termsAndConditionsAgreement => _t(
      'By continuing, you agree to our Terms and Conditions',
      'Al continuar, aceptas nuestros Términos y Condiciones');
  static String get updateBudget =>
      _t('Budget updated successfully.', 'Presupuesto actualizado con éxito.');
  static String get savingsTab => _t('Savings', 'Ahorros');

  // History Messages
  static String get historyTitle =>
      _t('History and Favorites', 'Historial y Favoritos');
  static String get historySubtitle => _t(
      'Only purchase link clicks are saved here.',
      'Aquí solo se guardan los clics al enlace de compra.');
  static String get historyTab => _t('History', 'Historial');
  static String get favoritesTab => _t('Favorites', 'Favoritos');
  static String get noHistory =>
      _t('No recent searches', 'Sin búsquedas recientes');
  static String get noFavorites =>
      _t('No favorite products', 'Sin productos favoritos');
  static String get purchaseAccess =>
      _t('Accessed purchase link', 'Accedió al enlace de compra');
  static String get searchPerformed =>
      _t('Search performed', 'Búsqueda realizada');
  static String get purchaseLabel => _t('PURCHASE', 'COMPRAR');
  static String get productLabel => _t('Product', 'Producto');

  // Auth Screen Messages
  static String get registerSuccessTitle =>
      _t('Account created successfully', 'Cuenta creada con éxito');
  static String get registerErrorTitle =>
      _t('Error creating account', 'Error al crear la cuenta');
  static String get passwordRequired =>
      _t('Password is required', 'La contraseña es requerida');
  static String get minCharacters =>
      _t('Minimum 8 characters', 'Mínimo 8 caracteres');
  static String get uppercaseRequired => _t(
      'Must have at least one uppercase letter',
      'Debe tener al menos una mayúscula');
  static String get lowercaseRequired => _t(
      'Must have at least one lowercase letter',
      'Debe tener al menos una minúscula');
  static String get numberRequired =>
      _t('Must have at least one number', 'Debe tener al menos un número');
  static String get createAccountTitle =>
      _t('Create your\naccount', 'Crea tu\ncuenta');
  static String get joinSmartMarket =>
      _t('Join Smart Market today', 'Únete a Smart Market hoy');
  static String get registerTitle => createAccountTitle;
  static String get registerSubtitle => joinSmartMarket;
  static String get fullNameLabel => _t('Full name', 'Nombre completo');
  static String get fullNameHint => _t('John Doe', 'Juan Pérez');
  static String get nameRequired =>
      _t('Name is required', 'El nombre es requerido');
  static String get minNameCharacters =>
      _t('Minimum 2 characters', 'Mínimo 2 caracteres');
  static String get emailLabel => _t('Email address', 'Correo electrónico');
  static String get emailHint => _t('you@email.com', 'tu@correo.com');
  static String get emailRequired =>
      _t('Email is required', 'El correo es requerido');
  static String get invalidEmail => _t('Invalid email', 'Correo inválido');
  static String get passwordLabel => _t('Password', 'Contraseña');
  static String get confirmPasswordLabel =>
      _t('Confirm password', 'Confirmar contraseña');
  static String get confirmPasswordRequired =>
      _t('Confirm your password', 'Confirma tu contraseña');
  static String get passwordsNoMatch =>
      _t('Passwords do not match', 'Las contraseñas no coinciden');
  static String get alreadyHaveAccount =>
      _t('Already have an account?', '¿Ya tienes una cuenta?');
  static String get signInAction => _t('Sign in', 'Iniciar sesión');

  // Login Screen Messages
  static String get loginErrorTitle =>
      _t('Error signing in', 'Error al iniciar sesión');
  static String get welcomeBackTitle =>
      _t('Welcome\nback', 'Bienvenido\nde nuevo');
  static String get enterCredentials => _t('Enter your credentials to continue',
      'Ingresa tus credenciales para continuar');
  static String get loginTitle => welcomeBackTitle;
  static String get loginSubtitle => enterCredentials;
  static String get forgotPasswordAction =>
      _t('Forgot your password?', '¿Olvidaste tu contraseña?');
  static String get dontHaveAccount =>
      _t('Don\'t have an account?', '¿No tienes una cuenta?');
  static String get signUpAction => _t('Sign up', 'Regístrate');

  // Forgot Password Messages
  static String get recoverPasswordTitle =>
      _t('Recover your\npassword', 'Recupera tu\ncontraseña');
  static String get enterEmailInstructions => _t(
      'Enter your email and we will send you a 6-digit code.',
      'Ingresa tu correo y te enviaremos un código de 6 dígitos.');
  static String get sendCodeAction => _t('Send code', 'Enviar código');
  static String get emailExpiryInfo => _t(
      'If the email exists, you will receive a code valid for 15 minutes.',
      'Si el correo existe, recibirás un código válido por 15 minutos.');

  // New Password Messages
  static String get newPasswordTitle =>
      _t('New\npassword', 'Nueva\ncontraseña');
  static String get newPasswordInstructions => _t(
      'Create a secure password for your account.',
      'Crea una contraseña segura para tu cuenta.');
  static String get newPasswordLabel => _t('New password', 'Nueva contraseña');
  static String get changePasswordAction =>
      _t('Change password', 'Cambiar contraseña');
  static String get passwordUpdatedTitle =>
      _t('Password updated!', '¡Contraseña actualizada!');
  static String get passwordUpdatedDescription => _t(
      'Your password has been successfully reset.',
      'Tu contraseña ha sido restablecida con éxito.');
  static String get passwordRequiredError =>
      _t('Password is required', 'La contraseña es requerida');
  static String get passwordMinLengthError =>
      _t('Minimum 8 characters', 'Mínimo 8 caracteres');
  static String get passwordUppercaseError =>
      _t('Must have uppercase', 'Debe tener mayúscula');
  static String get passwordLowercaseError =>
      _t('Must have lowercase', 'Debe tener minúscula');
  static String get passwordNumberError =>
      _t('Must have numbers', 'Debe tener números');

  // Verification Messages
  static String get verificationTitle =>
      _t('Verification\nCode', 'Código de\nVerificación');
  static String get codeSentTo => _t('Code sent to\n', 'Código enviado a\n');
  static String get verifyCodeTitle => verificationTitle;
  static String get verifyCodeInstructions =>
      _t('Code sent to', 'Código enviado a');
  static String get verifyCodeAction => _t('Verify code', 'Verificar código');
  static String get didNotReceiveCode =>
      _t('Didn\'t receive the code?', '¿No recibiste el código?');
  static String get resendCodeAction => _t('Resend code', 'Reenviar código');

  // Profile Messages
  static String get profileTitle => _t('Profile', 'Perfil');
  static String get monthlyBudgetTitle =>
      _t('Monthly Budget', 'Presupuesto Mensual');
  static String get amountLabel => _t('Amount (COP)', 'Monto (COP)');
  static String get cancelAction => _t('Cancel', 'Cancelar');
  static String get saveAction => _t('Save', 'Guardar');
  static String get purchasesLabel => _t('Purchases', 'Compras');
  static String get goalLabel => _t('Goal', 'Meta');
  static String get recommendationsLabel => _t('Recomm.', 'Recom.');
  static String get notificationsLabel => _t('Notifications', 'Notificaciones');
  static String get notificationsDesc =>
      _t('Price alerts and predictions', 'Alertas de precios y predicciones');
  static String get locationLabel => _t('Location', 'Ubicación');
  static String get locationDesc =>
      _t('Nearby supermarkets', 'Supermercados cercanos');
  static String get budgetLabel => _t('Budget', 'Presupuesto');
  static String get budgetDesc =>
      _t('Manage your monthly spending', 'Gestiona tu gasto mensual');
  static String get languageLabel => _t('Language', 'Idioma');
  static String get languageDesc =>
      _t('Change app language', 'Cambiar idioma de la app');
  static String get selectLanguageTitle =>
      _t('Select Language', 'Seleccionar Idioma');
  static String get englishLabel => _t('English', 'Inglés');
  static String get spanishLabel => _t('Spanish', 'Español');
  static String get statisticsLabel => _t('Statistics', 'Estadísticas');
  static String get statisticsDesc =>
      _t('Detailed consumption analysis', 'Análisis detallado de consumo');
  static String get privacyLabel => _t('Privacy', 'Privacidad');
  static String get privacyDesc =>
      _t('Configure your data', 'Configura tus datos');
  static String get helpLabel => _t('Help', 'Ayuda');
  static String get helpDesc => _t('Support and FAQ', 'Soporte y FAQ');
  static String get signOutAction => _t('Sign out', 'Cerrar sesión');

  // Location Messages
  static String get locationDisabled => _t('Location services are disabled.',
      'Los servicios de ubicación están desactivados.');
  static String get locationDenied => _t('Location permissions are denied.',
      'Los permisos de ubicación fueron denegados.');
  static String get locationPermanentlyDenied => _t(
      'Location permissions are permanently denied.',
      'Los permisos de ubicación están denegados permanentemente.');
  static String get locationError =>
      _t('Error obtaining location: ', 'Error al obtener la ubicación: ');

  // Auth Repository Messages
  static String get registerError =>
      _t('Error in registration', 'Error en el registro');
  static String get emailAlreadyRegistered => _t(
      'This email is already registered. Try logging in.',
      'Este correo ya está registrado. Intenta iniciar sesión.');
  static String get unexpectedError =>
      _t('An unexpected error occurred', 'Ocurrió un error inesperado');
  static String get loginError =>
      _t('Error logging in', 'Error al iniciar sesión');
  static String get passwordResetSent =>
      _t('A recovery email was sent', 'Se envió un correo de recuperación');
  static String get codeVerified =>
      _t('Code verified correctly', 'Código verificado correctamente');
  static String get invalidCode =>
      _t('Invalid or expired code', 'Código inválido o expirado');
  static String get passwordUpdated =>
      _t('Password updated', 'Contraseña actualizada');

  // Home Screen Messages
  static String get hiGreeting => _t('Hi, ', 'Hola, ');
  static String get buyTodayPrompt =>
      _t('What are we buying today?', '¿Qué compramos hoy?');
  static String get searchProductsHint =>
      _t('Search products to compare...', 'Busca productos para comparar...');
  static String get nearbySupermarkets =>
      _t('Nearby supermarkets', 'Supermercados cercanos');
  static String get yourFavorites => _t('Your Favorites', 'Tus Favoritos');
  static String get featuredProducts =>
      _t('Featured products', 'Productos destacados');
  static String get seeAllAction => _t('See all', 'Ver todo');
  static String get notificationsTitle => _t('Notifications', 'Notificaciones');
  static String get noNotifications =>
      _t('No new notifications', 'Sin notificaciones nuevas');
  static String get closeAction => _t('Close', 'Cerrar');
  static String get riceOfferTitle => _t('Rice Offer', 'Oferta de Arroz');
  static String get riceOfferDesc => _t(
      'Price dropped 10% at Éxito today.', 'El precio bajó 10% en Éxito hoy.');
  static String get searchCompletedTitle =>
      _t('Search completed', 'Búsqueda completada');
  static String get searchCompletedDesc =>
      _t('We found 5 new offers.', 'Encontramos 5 ofertas nuevas.');

  // Compare Screen Messages
  static String get compareTitle => _t('Compare prices', 'Comparar precios');
  static String get compareSubtitle => _t('Find the best price per supermarket',
      'Encuentra el mejor precio por supermercado');
  static String get searchProductHint => _t(
      'Search product (e.g. Milk, Rice...)',
      'Buscar producto (ej. Leche, Arroz...)');
  static String get startComparingPrompt => _t(
      'Search something to start comparing',
      'Busca algo para empezar a comparar');
  static String get noProductsFound =>
      _t('No products found', 'No se encontraron productos');
  static String get pricesPerSupermarket =>
      _t('Prices per supermarket:', 'Precios por supermercado:');
  static String get savingsPrefix => _t('You save ', 'Ahorras ');
  static String get buyingAt => _t(' buying at ', ' comprando en ');

  // AI Screen & Banner Messages
  static String get aiTitle => _t('Smart AI', 'IA Inteligente');
  static String get aiSubtitle => _t('Intelligent recommendation engine',
      'Motor de recomendaciones inteligente');
  static String get projectedSavings =>
      _t('Projected savings', 'Ahorros proyectados');
  static String get budgetImpact =>
      _t('Budget impact', 'Impacto en presupuesto');
  static String get activeRecommendations =>
      _t('Active recommendations', 'Recomendaciones activas');
  static String get basedOnPatterns =>
      _t('Based on your purchase patterns', 'Basado en tus patrones de compra');
  static String get notEnoughRecommendations => _t(
      'Not enough recommendations yet',
      'Aún no hay suficientes recomendaciones');
  static String get consumptionAnalysis =>
      _t('Consumption analysis', 'Análisis de consumo');
  static String get searchingToAnalyze => _t('Searching products to analyze...',
      'Buscando productos para analizar...');
  static String get nearestSupermarketRecommendation =>
      _t('⚡ Recommendation: ', '⚡ Recomendación: ');
  static String get nearestSupermarketSuffix => _t(
      ' is the nearest to your current location.',
      ' es el más cercano a tu ubicación actual.');
  static String get aiRecommends => _t('AI Recommends', 'IA Recomienda');
  static String get saveAmountMonthPrefix =>
      _t('You can save ', 'Puedes ahorrar ');
  static String get saveAmountMonthSuffix => _t(
      ' this month by shopping at 2 supermarkets.',
      ' este mes comprando en 2 supermercados.');
  static String get aiRecommendationsTitle =>
      _t('AI Recommendations', 'Recomendaciones de IA');
  static String get understoodAction => _t('Understood', 'Entendido');
  static String get buyGrainsAtExito =>
      _t('📍 Buy grains at Éxito', '📍 Compra granos en Éxito');
  static String get grainsExitoDesc => _t(
      'They are 15% cheaper than other places this week.',
      'Están 15% más baratos que en otros lugares esta semana.');
  static String get dairyAtCarulla =>
      _t('🥛 Dairy at Carulla', '🥛 Lácteos en Carulla');
  static String get dairyCarullaDesc => _t(
      'Take advantage of 2x1 on selected brands.',
      'Aprovecha 2x1 en marcas seleccionadas.');
  static String get proteinAtJumbo =>
      _t('🥩 Proteins at Jumbo', '🥩 Proteínas en Jumbo');
  static String get proteinJumboDesc => _t(
      'Best value for money detected today.',
      'Mejor relación calidad-precio detectada hoy.');

  static String get analyzedLabel => _t('Analyzed', 'Analizado');
  static String get saveOnPrefix => _t('Save on ', 'Ahorra en ');
  static String get bestPriceAtPrefix =>
      _t('Best price is at ', 'El mejor precio está en ');
  static String get comparedToExpensiveSuffix =>
      _t(' compared to the most expensive.', ' comparado con el más caro.');

  static String get comparedProductsTitle =>
      _t('Compared Products', 'Productos Comparados');
  static String get noProductsAvailable =>
      _t('No products available', 'No hay productos disponibles');

  static String get fromLabel => _t('from', 'desde');
  static String get buyAction => _t('Buy', 'Comprar');

  // Savings Card Messages
  static String get budgetSpent => _t('spent', 'gastado');
  static String get ofBudgetPrefix => _t('of ', 'de ');
  static String get ofBudgetSuffix => _t(' budgeted', ' presupuestado');
  static String get usedPercentageSuffix => _t('% used', '% usado');
  static String get editBudgetTitle => _t('Edit Budget', 'Editar Presupuesto');
  static String get saveBudgetSuccess =>
      _t('Budget updated (Simulation)', 'Presupuesto actualizado (Simulación)');

  // Logo Widget Messages
  static String get yourSmartMarket =>
      _t('Your smart market', 'Tu mercado inteligente');
  // Feature Placeholder Messages
  static String get comingSoon => _t('Coming soon', 'Próximamente');

  // Navigation Labels
  static String get navHome => _t('Home', 'Inicio');
  static String get navCompare => _t('Compare', 'Comparar');
  static String get navAi => _t('AI', 'IA');
  static String get navHistory => _t('History', 'Historial');
  static String get navProfile => _t('Profile', 'Perfil');
}
