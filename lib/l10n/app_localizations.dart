import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// The title of the application
  ///
  /// In es, this message translates to:
  /// **'PersalOne'**
  String get appTitle;

  /// No description provided for @brandMainTagline.
  ///
  /// In es, this message translates to:
  /// **'IA que protege tus decisiones online. Tú marcas el límite.'**
  String get brandMainTagline;

  /// No description provided for @brandHeroSubtitle.
  ///
  /// In es, this message translates to:
  /// **'PersalOne revisa contigo enlaces, cobros y accesos importantes. Detrás hay un equipo liderado por Juan Ma Perals que traduce la IA más avanzada en recomendaciones claras y accionables.'**
  String get brandHeroSubtitle;

  /// No description provided for @agentHeroTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu agente de confianza para tus cosas online'**
  String get agentHeroTitle;

  /// No description provided for @brandTeamTagline.
  ///
  /// In es, this message translates to:
  /// **'Higiene digital tranquila para tu equipo'**
  String get brandTeamTagline;

  /// Home page main title
  ///
  /// In es, this message translates to:
  /// **'Mi estado de seguridad'**
  String get homeTitle;

  /// Home page hero title
  ///
  /// In es, this message translates to:
  /// **'Tu agente de IA para revisar mensajes, enlaces y accesos sensibles.'**
  String get homeHeroTitle;

  /// Home page hero subtitle
  ///
  /// In es, this message translates to:
  /// **'PersalOne te ayuda a detectar señales de fraude y riesgos digitales antes de que hagas clic o tomes una decisión importante.'**
  String get homeHeroSubtitle;

  /// Button to open agent chat
  ///
  /// In es, this message translates to:
  /// **'Hablar con mi agente IA'**
  String get homeTalkToAgent;

  /// Button to view pricing plans
  ///
  /// In es, this message translates to:
  /// **'Ver planes y precios'**
  String get homeViewPlans;

  /// Button for basic security checklist
  ///
  /// In es, this message translates to:
  /// **'Checklist básico de seguridad'**
  String get homeBasicChecklist;

  /// Beta status message on home page
  ///
  /// In es, this message translates to:
  /// **'Tu panel está en modo beta. Aún no está conectado a todas tus fuentes, pero ya puedes hablar con tu agente IA y seguir un checklist básico.'**
  String get homeBetaMessage;

  /// Quick actions section title
  ///
  /// In es, this message translates to:
  /// **'Acciones rápidas'**
  String get homeQuickActions;

  /// Footer message explaining that the app is in technical beta
  ///
  /// In es, this message translates to:
  /// **'Versión beta técnica. Algunas funciones están en pruebas y pueden cambiar.'**
  String get homeFooterNote;

  /// Home page help section title
  ///
  /// In es, this message translates to:
  /// **'Hoy podemos ayudarte con…'**
  String get homeHelpTodayTitle;

  /// Scam scenario card title
  ///
  /// In es, this message translates to:
  /// **'Mensajes sospechosos y estafas'**
  String get homeScenarioScamsTitle;

  /// Scam scenario card subtitle
  ///
  /// In es, this message translates to:
  /// **'Revisamos contigo SMS, correos o mensajes raros antes de que pulses nada.'**
  String get homeScenarioScamsSubtitle;

  /// Passwords scenario card title
  ///
  /// In es, this message translates to:
  /// **'Contraseñas y accesos'**
  String get homeScenarioPasswordsTitle;

  /// Large text accessibility option
  ///
  /// In es, this message translates to:
  /// **'Texto grande'**
  String get settingsLargeText;

  /// Large text subtitle
  ///
  /// In es, this message translates to:
  /// **'Aumenta el tamaño de la letra en toda la app'**
  String get settingsLargeTextSubtitle;

  /// High contrast accessibility option
  ///
  /// In es, this message translates to:
  /// **'Alto contraste'**
  String get settingsHighContrast;

  /// High contrast subtitle
  ///
  /// In es, this message translates to:
  /// **'Mejora la visibilidad con colores más contrastados'**
  String get settingsHighContrastSubtitle;

  /// Easy reading mode accessibility option
  ///
  /// In es, this message translates to:
  /// **'Modo lectura fácil'**
  String get settingsEasyReading;

  /// Easy reading subtitle
  ///
  /// In es, this message translates to:
  /// **'Reduce elementos visuales y simplifica el diseño'**
  String get settingsEasyReadingSubtitle;

  /// Settings info card message
  ///
  /// In es, this message translates to:
  /// **'Los ajustes de accesibilidad se aplicarán en futuras versiones. Por ahora, esta pantalla solo demuestra la funcionalidad.'**
  String get settingsInfoMessage;

  /// Settings section title for capabilities
  ///
  /// In es, this message translates to:
  /// **'Qué puede hacer PersalOne'**
  String get settingsWhatCanDoTitle;

  /// Intro text for capabilities section
  ///
  /// In es, this message translates to:
  /// **'Para que puedas usar PersalOne con tranquilidad, esto es lo que sí puede hacer y lo que no.'**
  String get settingsWhatCanDoIntro;

  /// Title for what PersalOne can do list
  ///
  /// In es, this message translates to:
  /// **'Puede ayudarte a:'**
  String get settingsWhatCanDoCanTitle;

  /// First item in can-do list
  ///
  /// In es, this message translates to:
  /// **'Entender mensajes o emails que te generan dudas.'**
  String get settingsWhatCanDoCanItem1;

  /// Second item in can-do list
  ///
  /// In es, this message translates to:
  /// **'Decidir qué pasos dar cuando algo te parece raro.'**
  String get settingsWhatCanDoCanItem2;

  /// Third item in can-do list
  ///
  /// In es, this message translates to:
  /// **'Aprender poco a poco a moverte con más seguridad.'**
  String get settingsWhatCanDoCanItem3;

  /// Title for what PersalOne cannot do list
  ///
  /// In es, this message translates to:
  /// **'No puede:'**
  String get settingsWhatCanDoCannotTitle;

  /// Pricing disclaimer message
  ///
  /// In es, this message translates to:
  /// **'Entrar en tus cuentas ni cambiar nada por ti.'**
  String get settingsWhatCanDoCannotItem1;

  /// Bullet en ajustes: aclarar límites del servicio
  ///
  /// In es, this message translates to:
  /// **'No sustituye a la policía, a tu banco ni a los servicios oficiales de emergencia.'**
  String get settingsWhatCanDoCannotItem2;

  /// Bullet en ajustes: no es para espiar móviles ajenos
  ///
  /// In es, this message translates to:
  /// **'No es una herramienta para espiar el móvil de otra persona ni para controlar a terceros sin su permiso.'**
  String get settingsWhatCanDoCannotItem3;

  /// Individual plans section title
  ///
  /// In es, this message translates to:
  /// **'Para ti'**
  String get pricingIndividualSectionTitle;

  /// Free plan title
  ///
  /// In es, this message translates to:
  /// **'PersalOne Free'**
  String get pricingIndividualFreeTitle;

  /// Free plan subtitle
  ///
  /// In es, this message translates to:
  /// **'Para empezar sin prisas, sin pagos y con ayuda cuando lo digital se hace bola.'**
  String get pricingIndividualFreeSubtitle;

  /// Ally plan title
  ///
  /// In es, this message translates to:
  /// **'PersalOne Ally'**
  String get pricingIndividualAllyTitle;

  /// Ally plan subtitle
  ///
  /// In es, this message translates to:
  /// **'Más acompañamiento en tu día a día digital, con pasos claros y sin tecnicismos.'**
  String get pricingIndividualAllySubtitle;

  /// Team plans section title
  ///
  /// In es, this message translates to:
  /// **'Para tu equipo'**
  String get pricingTeamSectionTitle;

  /// Team Start plan title
  ///
  /// In es, this message translates to:
  /// **'PersalOne Team Start'**
  String get pricingTeamStartTitle;

  /// Team Start plan subtitle
  ///
  /// In es, this message translates to:
  /// **'Para equipos pequeños que quieren mejores hábitos digitales sin complicarse.'**
  String get pricingTeamStartSubtitle;

  /// Team Guard plan title
  ///
  /// In es, this message translates to:
  /// **'PersalOne Team Guard'**
  String get pricingTeamGuardTitle;

  /// Team Guard plan subtitle
  ///
  /// In es, this message translates to:
  /// **'Más visibilidad sobre riesgos y enlaces importantes de la empresa.'**
  String get pricingTeamGuardSubtitle;

  /// Team Shield plan title
  ///
  /// In es, this message translates to:
  /// **'PersalOne Team Shield'**
  String get pricingTeamShieldTitle;

  /// Team Shield plan subtitle
  ///
  /// In es, this message translates to:
  /// **'Para pymes con necesidades más avanzadas de cuidado digital para su gente.'**
  String get pricingTeamShieldSubtitle;

  /// Beta label for pricing
  ///
  /// In es, this message translates to:
  /// **'Beta'**
  String get pricingBetaLabel;

  /// Título de la pantalla de precios de PersalOne
  ///
  /// In es, this message translates to:
  /// **'Planes y precios'**
  String get pricingTitle;

  /// Beta disclaimer title
  ///
  /// In es, this message translates to:
  /// **'Estamos en beta'**
  String get pricingBetaDisclaimerTitle;

  /// Beta disclaimer body text
  ///
  /// In es, this message translates to:
  /// **'Los planes y precios son de prueba. No se hará ningún cobro sin avisarte antes y sin tu confirmación explícita.'**
  String get pricingBetaDisclaimerBody;

  /// Individual plans section title
  ///
  /// In es, this message translates to:
  /// **'Para individuos'**
  String get pricingForIndividuals;

  /// Individual plans subtitle
  ///
  /// In es, this message translates to:
  /// **'Protege tu vida digital personal'**
  String get pricingForIndividualsSubtitle;

  /// Business plans section title
  ///
  /// In es, this message translates to:
  /// **'Para equipos y empresas'**
  String get pricingForBusiness;

  /// Business plans subtitle
  ///
  /// In es, this message translates to:
  /// **'Protección escalable para tu organización'**
  String get pricingForBusinessSubtitle;

  /// Popular plan badge
  ///
  /// In es, this message translates to:
  /// **'Popular'**
  String get pricingPopular;

  /// Agent page title
  ///
  /// In es, this message translates to:
  /// **'Tu agente de IA contra fraudes y engaños online'**
  String get agentTitle;

  /// Agent page intro text
  ///
  /// In es, this message translates to:
  /// **'Cuéntame qué ha pasado y revisamos juntos la situación.\\nPuedes pegar aquí el mensaje, enlace o aviso que te preocupa. Yo te ayudo a ver los riesgos y los siguientes pasos.'**
  String get agentIntro;

  /// Agent input field placeholder
  ///
  /// In es, this message translates to:
  /// **'¿En qué puedo ayudarte?'**
  String get agentInputPlaceholder;

  /// Agent welcome message
  ///
  /// In es, this message translates to:
  /// **'¡Hola! Soy tu aliado de seguridad digital.\\n\\nEstoy aquí para ayudarte a entender y mejorar tu seguridad online de forma sencilla y sin tecnicismos.\\n\\nPuedes preguntarme sobre:\\n• Contraseñas y cuentas seguras\\n• Detectar correos o mensajes sospechosos\\n• Proteger tus dispositivos\\n• Usar internet de forma más segura\\n\\n¿En qué puedo ayudarte hoy?'**
  String get agentWelcomeMessage;

  /// Retry button label
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get agentRetry;

  /// Network/backend unreachable error message
  ///
  /// In es, this message translates to:
  /// **'No hemos podido conectar con el servidor. Revisa tu conexión a internet e inténtalo de nuevo.'**
  String get agentErrorNetwork;

  /// Timeout/transient error message
  ///
  /// In es, this message translates to:
  /// **'Ha habido un problema temporal al procesar tu consulta. Vuelve a intentarlo en unos segundos.'**
  String get agentErrorTimeout;

  /// Unexpected error message
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error inesperado. Si se repite, puedes avisarnos para que lo revisemos.'**
  String get agentErrorUnexpected;

  /// Agent suggestion chip for suspicious messages
  ///
  /// In es, this message translates to:
  /// **'He recibido un mensaje sospechoso'**
  String get agentChipSuspiciousMessage;

  /// Agent suggestion chip for bank emails
  ///
  /// In es, this message translates to:
  /// **'No entiendo un email del banco'**
  String get agentChipBankEmail;

  /// Agent suggestion chip for passwords
  ///
  /// In es, this message translates to:
  /// **'Quiero revisar mis contraseñas'**
  String get agentChipPasswords;

  /// Suggestion chip for when the user thinks they may have been hacked
  ///
  /// In es, this message translates to:
  /// **'Creo que me han hackeado, ¿qué hago?'**
  String get agentChipHacked;

  /// Checklist not available message
  ///
  /// In es, this message translates to:
  /// **'Checklist aún no disponible en esta versión.'**
  String get checklistNotAvailable;

  /// Login page title
  ///
  /// In es, this message translates to:
  /// **'Accede a tu agente PersalOne'**
  String get loginTitle;

  /// Subtitle on the login page explaining the purpose in a calm, friendly tone
  ///
  /// In es, this message translates to:
  /// **'Tu agente de IA para revisar contigo mensajes, cobros y accesos que no tienes claros.'**
  String get loginSubtitle;

  /// No description provided for @networkErrorMessage.
  ///
  /// In es, this message translates to:
  /// **'Ahora mismo no me puedo conectar. No es culpa tuya: revisa tu conexión o prueba de nuevo en unos minutos.'**
  String get networkErrorMessage;

  /// Email input label
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get loginEmailLabel;

  /// Password input label
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get loginPasswordLabel;

  /// Login button label
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// Error when email or password is empty
  ///
  /// In es, this message translates to:
  /// **'Se requieren email y contraseña.'**
  String get loginErrorRequired;

  /// Generic login error message
  ///
  /// In es, this message translates to:
  /// **'No se ha podido iniciar sesión. Revisa tus datos e inténtalo de nuevo.'**
  String get loginErrorGeneric;

  /// Session expired error message
  ///
  /// In es, this message translates to:
  /// **'Tu sesión ha caducado. Por favor, inicia sesión de nuevo.'**
  String get loginErrorSessionExpired;

  /// Demo/offline mode button label
  ///
  /// In es, this message translates to:
  /// **'Entrar en modo prueba (sin conexión)'**
  String get loginDemoMode;

  /// Device scenario third card navigation message
  ///
  /// In es, this message translates to:
  /// **'Mi móvil va lento o hace cosas raras'**
  String get homeScenarioDeviceSlowSubtitle;

  /// Profile section title in settings
  ///
  /// In es, this message translates to:
  /// **'Tu perfil en PersalOne'**
  String get settingsProfileSectionTitle;

  /// Name label in profile section
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get settingsProfileNameLabel;

  /// Email label in profile section
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get settingsProfileEmailLabel;

  /// Plan label in profile section
  ///
  /// In es, this message translates to:
  /// **'Plan actual'**
  String get settingsProfilePlanLabel;

  /// Free plan display name
  ///
  /// In es, this message translates to:
  /// **'Free (plan gratuito de inicio)'**
  String get settingsProfilePlanFree;

  /// Loading message for profile section
  ///
  /// In es, this message translates to:
  /// **'Cargando tu perfil…'**
  String get settingsProfileLoading;

  /// Onboarding page intro text
  ///
  /// In es, this message translates to:
  /// **'Configura tu experiencia para que PersalOne te ayude mejor.'**
  String get onboardingIntro;

  /// Question asking who the user is using the app for
  ///
  /// In es, this message translates to:
  /// **'¿Para quién estás usando PersalOne?'**
  String get onboardingQuestionWho;

  /// Option for self use
  ///
  /// In es, this message translates to:
  /// **'Para mí'**
  String get onboardingOptionSelf;

  /// Option for family use
  ///
  /// In es, this message translates to:
  /// **'Para un familiar'**
  String get onboardingOptionFamily;

  /// Option for team use
  ///
  /// In es, this message translates to:
  /// **'Para mi equipo o empresa'**
  String get onboardingOptionTeam;

  /// Question asking for explanation style preference
  ///
  /// In es, this message translates to:
  /// **'¿Cómo prefieres que te expliquemos las cosas?'**
  String get onboardingQuestionStyle;

  /// Option for step-by-step explanation
  ///
  /// In es, this message translates to:
  /// **'Muy paso a paso y despacio'**
  String get onboardingOptionStepByStep;

  /// Option for concise explanation
  ///
  /// In es, this message translates to:
  /// **'Resúmenes cortos y directos'**
  String get onboardingOptionConcise;

  /// Next button label
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get onboardingBtnNext;

  /// Save button label
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get onboardingBtnSave;

  /// Cancel button label
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get onboardingBtnCancel;

  /// No description provided for @landingOverwhelmedTitle.
  ///
  /// In es, this message translates to:
  /// **'Diseñado para tomar decisiones online con criterio'**
  String get landingOverwhelmedTitle;

  /// No description provided for @landingOverwhelmedDesc.
  ///
  /// In es, this message translates to:
  /// **'Ideal para personas y equipos que quieren entender mejor qué hay detrás de mensajes, cobros y accesos sin convertirse en expertos en tecnología. PersalOne te da contexto, ordena la información y te propone pasos concretos a tu medida.'**
  String get landingOverwhelmedDesc;

  /// No description provided for @aboutTeamTitle.
  ///
  /// In es, this message translates to:
  /// **'Quién está detrás de PersalOne'**
  String get aboutTeamTitle;

  /// No description provided for @aboutTeamCreatorHeading.
  ///
  /// In es, this message translates to:
  /// **'Creado y dirigido por Juan Ma Perals'**
  String get aboutTeamCreatorHeading;

  /// No description provided for @aboutTeamCreatorBody.
  ///
  /// In es, this message translates to:
  /// **'PersalOne no es un experimento anónimo. Está creado y dirigido por Juan Ma Perals y un equipo que lleva años ayudando a personas y organizaciones a tomar decisiones digitales con criterio. Nuestro trabajo es traducir tecnología y ciberseguridad en algo que puedas usar en tu día a día.'**
  String get aboutTeamCreatorBody;

  /// No description provided for @aboutTeamValuesTitle.
  ///
  /// In es, this message translates to:
  /// **'Lo que puedes esperar de nosotros'**
  String get aboutTeamValuesTitle;

  /// No description provided for @aboutTeamValuesItem1.
  ///
  /// In es, this message translates to:
  /// **'Rigor: cada recomendación se revisa con criterio profesional.'**
  String get aboutTeamValuesItem1;

  /// No description provided for @aboutTeamValuesItem2.
  ///
  /// In es, this message translates to:
  /// **'Respeto: nunca tratamos a nadie como si “no supiera suficiente”.'**
  String get aboutTeamValuesItem2;

  /// No description provided for @aboutTeamValuesItem3.
  ///
  /// In es, this message translates to:
  /// **'Transparencia: te explicamos qué hacemos y qué NO hacemos con tus datos.'**
  String get aboutTeamValuesItem3;

  /// No description provided for @landingProtectTitle.
  ///
  /// In es, this message translates to:
  /// **'Cómo te protege PersalOne'**
  String get landingProtectTitle;

  /// No description provided for @landingProtectDetectTitle.
  ///
  /// In es, this message translates to:
  /// **'Detecta'**
  String get landingProtectDetectTitle;

  /// No description provided for @landingProtectDetectBody.
  ///
  /// In es, this message translates to:
  /// **'Analizamos los enlaces, mensajes y cobros que nos envías. Reconocemos patrones de fraude, suplantaciones y prácticas dudosas que muchas veces pasan desapercibidas.'**
  String get landingProtectDetectBody;

  /// No description provided for @landingProtectWarnTitle.
  ///
  /// In es, this message translates to:
  /// **'Te advierte'**
  String get landingProtectWarnTitle;

  /// No description provided for @landingProtectWarnBody.
  ///
  /// In es, this message translates to:
  /// **'Antes de que hagas clic o confirmes un pago, te ayudamos a ver los riesgos, te explicamos por qué y te proponemos opciones claras: seguir, parar o preguntar más.'**
  String get landingProtectWarnBody;

  /// No description provided for @landingProtectNeutraliseTitle.
  ///
  /// In es, this message translates to:
  /// **'Neutraliza (planes avanzados)'**
  String get landingProtectNeutraliseTitle;

  /// No description provided for @landingProtectNeutraliseBody.
  ///
  /// In es, this message translates to:
  /// **'En las versiones de pago, PersalOne te ayudará a bloquear dominios, reportar abusos y aplicar medidas técnicas para reducir el riesgo en tus dispositivos y cuentas.'**
  String get landingProtectNeutraliseBody;

  /// No description provided for @landingAdaptTitle.
  ///
  /// In es, this message translates to:
  /// **'Una protección que se adapta a ti'**
  String get landingAdaptTitle;

  /// No description provided for @landingAdaptBody.
  ///
  /// In es, this message translates to:
  /// **'Configuras hasta dónde quieres que PersalOne te acompañe: solo avisos puntuales, seguimiento más proactivo o protección avanzada para tu equipo. Puedes elegir qué temas te preocupan más y si prefieres explicaciones detalladas o resúmenes directos.'**
  String get landingAdaptBody;

  /// No description provided for @landingAdaptBullet1.
  ///
  /// In es, this message translates to:
  /// **'Tú decides qué quiere que vigile con más atención.'**
  String get landingAdaptBullet1;

  /// No description provided for @landingAdaptBullet2.
  ///
  /// In es, this message translates to:
  /// **'Tú marcas el tono: más detalle o solo lo esencial.'**
  String get landingAdaptBullet2;

  /// No description provided for @landingAdaptBullet3.
  ///
  /// In es, this message translates to:
  /// **'Puedes cambiar tus preferencias en cualquier momento.'**
  String get landingAdaptBullet3;

  /// Title of the onboarding page
  ///
  /// In es, this message translates to:
  /// **'Configura cómo quieres que te ayude PersalOne'**
  String get onboardingTitle;

  /// Settings page title
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// Title for onboarding settings section
  ///
  /// In es, this message translates to:
  /// **'Ajustar cómo te ayuda PersalOne'**
  String get settingsOnboardingTitle;

  /// Title for accessibility settings section
  ///
  /// In es, this message translates to:
  /// **'Accesibilidad'**
  String get settingsAccessibility;

  /// Error message when profile fails to load
  ///
  /// In es, this message translates to:
  /// **'No hemos podido cargar tu perfil. Inténtalo de nuevo más tarde.'**
  String get settingsProfileError;

  /// Passwords scenario card subtitle
  ///
  /// In es, this message translates to:
  /// **'Pon orden en tus contraseñas y accesos importantes, sin agobios.'**
  String get homeScenarioPasswordsSubtitle;

  /// Device scenario card title
  ///
  /// In es, this message translates to:
  /// **'Móvil lento o raro'**
  String get homeScenarioDeviceTitle;

  /// Device scenario card subtitle
  ///
  /// In es, this message translates to:
  /// **'Revisamos contigo qué puede estar pasando y cómo arreglarlo paso a paso.'**
  String get homeScenarioDeviceSubtitle;

  /// High risk label for Ally analysis
  ///
  /// In es, this message translates to:
  /// **'Riesgo alto'**
  String get allyRiskHigh;

  /// Medium risk label for Ally analysis
  ///
  /// In es, this message translates to:
  /// **'Riesgo medio'**
  String get allyRiskMedium;

  /// Low risk label for Ally analysis
  ///
  /// In es, this message translates to:
  /// **'Riesgo bajo'**
  String get allyRiskLow;

  /// Title for detected items section in Ally analysis
  ///
  /// In es, this message translates to:
  /// **'He detectado'**
  String get allyDetectedSectionTitle;

  /// Label for detected URLs
  ///
  /// In es, this message translates to:
  /// **'Enlaces'**
  String get allyDetectedUrls;

  /// Label for detected monetary amounts
  ///
  /// In es, this message translates to:
  /// **'Cantidades'**
  String get allyDetectedAmounts;

  /// Label for detected entities (banks, services, etc)
  ///
  /// In es, this message translates to:
  /// **'Entidades mencionadas'**
  String get allyDetectedEntities;

  /// Title for recommended actions section
  ///
  /// In es, this message translates to:
  /// **'Pasos recomendados'**
  String get allyActionsSectionTitle;

  /// Title for conditional guidance section (if/then scenarios)
  ///
  /// In es, this message translates to:
  /// **'Según tu situación'**
  String get allyConditionalGuidanceTitle;

  /// Title of the consent screen
  ///
  /// In es, this message translates to:
  /// **'Antes de empezar'**
  String get consentTitle;

  /// Consent bullet point about copy paste
  ///
  /// In es, this message translates to:
  /// **'Solo veremos lo que tú decides copiar y pegar aquí.'**
  String get consentBulletCopyPasteOnly;

  /// Consent bullet point about backend AI
  ///
  /// In es, this message translates to:
  /// **'Analizamos tus textos en un servidor seguro usando un modelo de IA.'**
  String get consentBulletBackendAI;

  /// Consent bullet point about user control
  ///
  /// In es, this message translates to:
  /// **'Puedes dejar de usar la app cuando quieras; no se escanea tu móvil de forma automática.'**
  String get consentBulletYouControl;

  /// Primary button on consent screen
  ///
  /// In es, this message translates to:
  /// **'Acepto y continuar'**
  String get consentPrimaryButton;

  /// Secondary button on consent screen
  ///
  /// In es, this message translates to:
  /// **'Ver más detalles'**
  String get consentSecondaryButton;

  /// No description provided for @checklistCenterTitle.
  ///
  /// In es, this message translates to:
  /// **'Centro de revisiones'**
  String get checklistCenterTitle;

  /// No description provided for @checklistCenterIntro.
  ///
  /// In es, this message translates to:
  /// **'Usa este espacio para revisar casos con calma y dejar constancia de tus decisiones.'**
  String get checklistCenterIntro;

  /// No description provided for @checklistStartNewReview.
  ///
  /// In es, this message translates to:
  /// **'Empezar nueva revisión'**
  String get checklistStartNewReview;

  /// No description provided for @checklistRecentReviews.
  ///
  /// In es, this message translates to:
  /// **'Revisiones recientes'**
  String get checklistRecentReviews;

  /// No description provided for @checklistNoReviewsYet.
  ///
  /// In es, this message translates to:
  /// **'Sin revisiones todavía'**
  String get checklistNoReviewsYet;

  /// No description provided for @checklistNoReviewsHelp.
  ///
  /// In es, this message translates to:
  /// **'Pulsa \'Empezar nueva revisión\' para crear tu primera revisión.'**
  String get checklistNoReviewsHelp;

  /// No description provided for @reviewNewTitle.
  ///
  /// In es, this message translates to:
  /// **'Nueva revisión'**
  String get reviewNewTitle;

  /// No description provided for @reviewWhatToReview.
  ///
  /// In es, this message translates to:
  /// **'¿Qué quieres revisar?'**
  String get reviewWhatToReview;

  /// No description provided for @reviewCaseType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de caso'**
  String get reviewCaseType;

  /// No description provided for @reviewCaseTypeSuspiciousMessage.
  ///
  /// In es, this message translates to:
  /// **'Mensaje sospechoso'**
  String get reviewCaseTypeSuspiciousMessage;

  /// No description provided for @reviewCaseTypeCallOrVoice.
  ///
  /// In es, this message translates to:
  /// **'Llamada o nota de voz'**
  String get reviewCaseTypeCallOrVoice;

  /// No description provided for @reviewCaseTypeLinkOrWebsite.
  ///
  /// In es, this message translates to:
  /// **'Enlace o página web'**
  String get reviewCaseTypeLinkOrWebsite;

  /// No description provided for @reviewCaseTypePhoneSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajuste de tu teléfono'**
  String get reviewCaseTypePhoneSettings;

  /// No description provided for @reviewCaseTypeOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get reviewCaseTypeOther;

  /// No description provided for @reviewOptionalTitle.
  ///
  /// In es, this message translates to:
  /// **'Título del caso (opcional)'**
  String get reviewOptionalTitle;

  /// No description provided for @reviewTitleHint.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo: SMS banco Caixa 03/12'**
  String get reviewTitleHint;

  /// No description provided for @reviewSignalsReviewed.
  ///
  /// In es, this message translates to:
  /// **'Señales revisadas'**
  String get reviewSignalsReviewed;

  /// No description provided for @reviewChecklistHelp.
  ///
  /// In es, this message translates to:
  /// **'Marca las señales que has identificado'**
  String get reviewChecklistHelp;

  /// No description provided for @reviewRiskAndDecision.
  ///
  /// In es, this message translates to:
  /// **'Riesgo y decisión'**
  String get reviewRiskAndDecision;

  /// No description provided for @reviewHowDoYouSeeRisk.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo ves el riesgo?'**
  String get reviewHowDoYouSeeRisk;

  /// No description provided for @reviewRiskLow.
  ///
  /// In es, this message translates to:
  /// **'Bajo'**
  String get reviewRiskLow;

  /// No description provided for @reviewRiskMedium.
  ///
  /// In es, this message translates to:
  /// **'Medio'**
  String get reviewRiskMedium;

  /// No description provided for @reviewRiskHigh.
  ///
  /// In es, this message translates to:
  /// **'Alto'**
  String get reviewRiskHigh;

  /// No description provided for @reviewWhatDidYouDecide.
  ///
  /// In es, this message translates to:
  /// **'¿Qué has decidido hacer?'**
  String get reviewWhatDidYouDecide;

  /// No description provided for @reviewDecisionHint.
  ///
  /// In es, this message translates to:
  /// **'Por ejemplo: No pulso el enlace y llamaré al banco mañana'**
  String get reviewDecisionHint;

  /// No description provided for @reviewDecisionHelperText.
  ///
  /// In es, this message translates to:
  /// **'Describe brevemente qué acción vas a tomar o ya has tomado'**
  String get reviewDecisionHelperText;

  /// No description provided for @reviewSaveReview.
  ///
  /// In es, this message translates to:
  /// **'Guardar revisión'**
  String get reviewSaveReview;

  /// No description provided for @reviewSummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen de revisión'**
  String get reviewSummaryTitle;

  /// No description provided for @reviewDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get reviewDate;

  /// No description provided for @reviewRiskPerceived.
  ///
  /// In es, this message translates to:
  /// **'Riesgo percibido'**
  String get reviewRiskPerceived;

  /// No description provided for @reviewDecisionTaken.
  ///
  /// In es, this message translates to:
  /// **'Decisión tomada'**
  String get reviewDecisionTaken;

  /// No description provided for @reviewNoDecisionRecorded.
  ///
  /// In es, this message translates to:
  /// **'Sin decisión registrada'**
  String get reviewNoDecisionRecorded;

  /// No description provided for @reviewExportActions.
  ///
  /// In es, this message translates to:
  /// **'Exportar informe'**
  String get reviewExportActions;

  /// No description provided for @reviewCopyReport.
  ///
  /// In es, this message translates to:
  /// **'Copiar informe'**
  String get reviewCopyReport;

  /// No description provided for @reviewPrepareEmail.
  ///
  /// In es, this message translates to:
  /// **'Preparar email con el informe'**
  String get reviewPrepareEmail;

  /// No description provided for @reviewCopiedToClipboard.
  ///
  /// In es, this message translates to:
  /// **'Informe copiado al portapapeles'**
  String get reviewCopiedToClipboard;

  /// No description provided for @reviewEmailNotAvailableYet.
  ///
  /// In es, this message translates to:
  /// **'Función de email en desarrollo. El informe se ha copiado al portapapeles.'**
  String get reviewEmailNotAvailableYet;

  /// No description provided for @reviewDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar esta revisión?'**
  String get reviewDeleteConfirm;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
