class AppMessages {
  // Connection Errors
  static const String connectionError =
      'Connection error. Please check your internet.';
  static const String timeoutError = 'Server took too long to respond.';
  static const String serverError = 'Internal server error (500).';
  static const String notFoundError = 'Resource not found (404).';
  static const String unknownError = 'An unexpected error occurred.';

  // Authentication Errors
  static const String emailAlreadyExists = 'This email is already registered.';
  static const String invalidCredentials = 'Incorrect email or password.';
  static const String weakPassword = 'The password is too weak.';
  static const String loginSuccess = 'Welcome back!';
  static const String registerSuccess = 'Account created successfully.';
  static const String resetEmailSent = 'Recovery email has been sent.';

  // Search States
  static const String searching = 'Searching for the best offers...';
  static const String noResults = 'We couldn\'t find products for your search.';
  static const String emptyQuery = 'Please type something to search.';

  // UI Messages
  static const String welcomeBack = 'Hello again';
  static const String updateBudget = 'Budget updated successfully.';
  static const String savingsTab = 'Savings';

  // History Messages
  static const String historyTitle = 'History and Favorites';
  static const String historyTab = 'History';
  static const String favoritesTab = 'Favorites';
  static const String noHistory = 'No recent searches';
  static const String noFavorites = 'No favorite products';
  static const String purchaseAccess = 'Accessed purchase link';
  static const String searchPerformed = 'Search performed';
  static const String purchaseLabel = 'PURCHASE';
  static const String productLabel = 'Product';

  // Auth Screen Messages
  static const String registerSuccessTitle = 'Account created successfully';
  static const String registerErrorTitle = 'Error creating account';
  static const String passwordRequired = 'Password is required';
  static const String minCharacters = 'Minimum 8 characters';
  static const String uppercaseRequired =
      'Must have at least one uppercase letter';
  static const String lowercaseRequired =
      'Must have at least one lowercase letter';
  static const String numberRequired = 'Must have at least one number';
  static const String createAccountTitle = 'Create your\naccount';
  static const String joinSmartMarket = 'Join Smart Market today';
  static const String fullNameLabel = 'Full name';
  static const String fullNameHint = 'John Doe';
  static const String nameRequired = 'Name is required';
  static const String minNameCharacters = 'Minimum 2 characters';
  static const String emailLabel = 'Email address';
  static const String emailHint = 'you@email.com';
  static const String emailRequired = 'Email is required';
  static const String invalidEmail = 'Invalid email';
  static const String passwordLabel = 'Password';
  static const String confirmPasswordLabel = 'Confirm password';
  static const String confirmPasswordRequired = 'Confirm your password';
  static const String passwordsNoMatch = 'Passwords do not match';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signInAction = 'Sign in';

  // Login Screen Messages
  static const String loginErrorTitle = 'Error signing in';
  static const String welcomeBackTitle = 'Welcome\nback';
  static const String enterCredentials = 'Enter your credentials to continue';
  static const String forgotPasswordAction = 'Forgot your password?';
  static const String dontHaveAccount = 'Don\'t have an account?';
  static const String signUpAction = 'Sign up';

  // Forgot Password Messages
  static const String recoverPasswordTitle = 'Recover your\npassword';
  static const String enterEmailInstructions =
      'Enter your email and we will send you a 6-digit code.';
  static const String sendCodeAction = 'Send code';
  static const String emailExpiryInfo =
      'If the email exists, you will receive a code valid for 15 minutes.';

  // New Password Messages
  static const String newPasswordTitle = 'New\npassword';
  static const String newPasswordInstructions =
      'Create a secure password for your account.';
  static const String newPasswordLabel = 'New password';
  static const String changePasswordAction = 'Change password';
  static const String passwordUpdatedTitle = 'Password updated!';
  static const String passwordUpdatedDescription =
      'Your password has been successfully reset.';
  static const String passwordRequiredError = 'Password is required';
  static const String passwordMinLengthError = 'Minimum 8 characters';
  static const String passwordUppercaseError = 'Must have uppercase';
  static const String passwordLowercaseError = 'Must have lowercase';
  static const String passwordNumberError = 'Must have numbers';

  // Verification Messages
  static const String verificationTitle = 'Verification\nCode';
  static const String codeSentTo = 'Code sent to\n';
  static const String verifyCodeAction = 'Verify code';
  static const String resendCodeAction = 'Resend code';

  // Profile Messages
  static const String profileTitle = 'Profile';
  static const String monthlyBudgetTitle = 'Monthly Budget';
  static const String amountLabel = 'Amount (COP)';
  static const String cancelAction = 'Cancel';
  static const String saveAction = 'Save';
  static const String purchasesLabel = 'Purchases';
  static const String goalLabel = 'Goal';
  static const String recommendationsLabel = 'Recomm.';
  static const String notificationsLabel = 'Notifications';
  static const String notificationsDesc = 'Price alerts and predictions';
  static const String locationLabel = 'Location';
  static const String locationDesc = 'Nearby supermarkets';
  static const String budgetLabel = 'Budget';
  static const String budgetDesc = 'Manage your monthly spending';
  static const String statisticsLabel = 'Statistics';
  static const String statisticsDesc = 'Detailed consumption analysis';
  static const String privacyLabel = 'Privacy';
  static const String privacyDesc = 'Configure your data';
  static const String helpLabel = 'Help';
  static const String helpDesc = 'Support and FAQ';
  static const String signOutAction = 'Sign out';

  // Location Messages
  static const String locationDisabled = 'Location services are disabled.';
  static const String locationDenied = 'Location permissions are denied.';
  static const String locationPermanentlyDenied =
      'Location permissions are permanently denied.';
  static const String locationError = 'Error obtaining location: ';

  // Auth Repository Messages
  static const String registerError = 'Error in registration';
  static const String emailAlreadyRegistered =
      'This email is already registered. Try logging in.';
  static const String unexpectedError = 'An unexpected error occurred';
  static const String loginError = 'Error logging in';
  static const String passwordResetSent = 'A recovery email was sent';
  static const String codeVerified = 'Code verified correctly';
  static const String invalidCode = 'Invalid or expired code';
  static const String passwordUpdated = 'Password updated';

  // Home Screen Messages
  static const String hiGreeting = 'Hi, ';
  static const String buyTodayPrompt = 'What are we buying today?';
  static const String searchProductsHint = 'Search products to compare...';
  static const String nearbySupermarkets = 'Nearby supermarkets';
  static const String yourFavorites = 'Your Favorites';
  static const String featuredProducts = 'Featured products';
  static const String seeAllAction = 'See all';
  static const String notificationsTitle = 'Notifications';
  static const String noNotifications = 'No new notifications';
  static const String closeAction = 'Close';
  static const String riceOfferTitle = 'Rice Offer';
  static const String riceOfferDesc = 'Price dropped 10% at Éxito today.';
  static const String searchCompletedTitle = 'Search completed';
  static const String searchCompletedDesc = 'We found 5 new offers.';

  // Compare Screen Messages
  static const String compareTitle = 'Compare prices';
  static const String compareSubtitle = 'Find the best price per supermarket';
  static const String searchProductHint = 'Search product (e.g. Milk, Rice...)';
  static const String startComparingPrompt =
      'Search something to start comparing';
  static const String noProductsFound = 'No products found';
  static const String pricesPerSupermarket = 'Prices per supermarket:';
  static const String savingsPrefix = 'You save ';
  static const String buyingAt = ' buying at ';

  // AI Screen & Banner Messages
  static const String aiTitle = 'Smart AI';
  static const String aiSubtitle = 'Intelligent recommendation engine';
  static const String projectedSavings = 'Projected savings';
  static const String budgetImpact = 'Budget impact';
  static const String activeRecommendations = 'Active recommendations';
  static const String basedOnPatterns = 'Based on your purchase patterns';
  static const String notEnoughRecommendations =
      'Not enough recommendations yet';
  static const String consumptionAnalysis = 'Consumption analysis';
  static const String searchingToAnalyze = 'Searching products to analyze...';
  static const String nearestSupermarketRecommendation = '⚡ Recommendation: ';
  static const String nearestSupermarketSuffix =
      ' is the nearest to your current location.';
  static const String aiRecommends = 'AI Recommends';
  static const String saveAmountMonthPrefix = 'You can save ';
  static const String saveAmountMonthSuffix =
      ' this month by shopping at 2 supermarkets.';
  static const String aiRecommendationsTitle = 'AI Recommendations';
  static const String understoodAction = 'Understood';
  static const String buyGrainsAtExito = '📍 Buy grains at Éxito';
  static const String grainsExitoDesc =
      'They are 15% cheaper than other places this week.';
  static const String dairyAtCarulla = '🥛 Dairy at Carulla';
  static const String dairyCarullaDesc =
      'Take advantage of 2x1 on selected brands.';
  static const String proteinAtJumbo = '🥩 Proteins at Jumbo';
  static const String proteinJumboDesc = 'Best value for money detected today.';

  // Savings Card Messages
  static const String budgetSpent = 'spent';
  static const String ofBudgetPrefix = 'of ';
  static const String ofBudgetSuffix = ' budgeted';
  static const String usedPercentageSuffix = '% used';
  static const String editBudgetTitle = 'Edit Budget';
  static const String saveBudgetSuccess = 'Budget updated (Simulation)';

  // Logo Widget Messages
  static const String yourSmartMarket = 'Your smart market';
  // Feature Placeholder Messages
  static const String comingSoon = 'Coming soon';
}
