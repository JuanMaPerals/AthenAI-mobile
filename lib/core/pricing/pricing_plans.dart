/// Pricing plan models and configuration for PersalOne
library;

// Individual plan model
class IndividualPlan {
  final String name;
  final String description;
  final double priceMonth;
  final double priceYear;
  final List<String> features;

  const IndividualPlan({
    required this.name,
    required this.description,
    required this.priceMonth,
    required this.priceYear,
    required this.features,
  });

  bool get isFree => priceMonth == 0 && priceYear == 0;

  String get monthlyPriceText => isFree ? 'Gratis' : '€${priceMonth.toStringAsFixed(2)}/mes';
  String get yearlyPriceText => isFree ? 'Gratis' : '€${priceYear.toStringAsFixed(2)}/año';
}

// Business plan model (per-seat pricing)
class BusinessPlan {
  final String name;
  final String description;
  final double pricePerSeatMonth;
  final List<String> features;

  const BusinessPlan({
    required this.name,
    required this.description,
    required this.pricePerSeatMonth,
    required this.features,
  });

  String get priceText => '€${pricePerSeatMonth.toStringAsFixed(2)}/usuario/mes';
}

// Individual plans
const kPersalOneFree = IndividualPlan(
  name: 'PersalOne Free',
  description: 'Para probar la app y empezar a mejorar tu seguridad',
  priceMonth: 0,
  priceYear: 0,
  features: [
    'Habla con tu aliado de seguridad digital con límites diarios',
    'Checklist básico de seguridad',
    'Recomendaciones introductorias',
  ],
);

const kPersalOneAllyMonthly = IndividualPlan(
  name: 'PersalOne Ally',
  description: 'Tu plan personal para ayuda continua en seguridad digital',
  priceMonth: 8.99,
  priceYear: 89.00,
  features: [
    'Más conversaciones con tu aliado de IA',
    'Planes semanales personalizados de protección digital',
    'Historial de conversaciones y recomendaciones',
    'Análisis más detallado de enlaces y riesgos (cuando esté disponible)',
  ],
);

const kPersalOneAllyYearly = IndividualPlan(
  name: 'PersalOne Ally (Anual)',
  description: 'Tu aliado de seguridad personal con IA - ahorra 2 meses',
  priceMonth: 7.42, // 89/12 = 7.42
  priceYear: 89.00,
  features: [
    'Todo lo de Free',
    'Asistente IA personalizado 24/7',
    'Monitoreo de filtraciones de datos',
    'Gestor de contraseñas integrado',
    'Protección contra phishing',
    'Backups automáticos cifrados',
    'Soporte prioritario',
    '✨ Ahorra 2 meses al pagar anualmente',
  ],
);

// Business plans
const kPersalOneTeamStart = BusinessPlan(
  name: 'PersalOne Team Start',
  description: 'Para pequeños equipos que quieren empezar a mejorar su higiene digital',
  pricePerSeatMonth: 7.00,
  features: [
    'Aliado de seguridad para cada empleado',
    'Checklist básico de equipo',
    'Resumen mensual sencillo para el responsable',
  ],
);

const kPersalOneTeamGuard = BusinessPlan(
  name: 'PersalOne Team Guard',
  description: 'Para equipos que necesitan más visibilidad sobre riesgos',
  pricePerSeatMonth: 12.00,
  features: [
    'Todo lo de Team Start',
    'Análisis reforzado de riesgos y enlaces corporativos (cuando esté disponible)',
    'Alertas básicas a correo o herramientas de equipo',
  ],
);

const kPersalOneTeamShield = BusinessPlan(
  name: 'PersalOne Team Shield',
  description: 'Para pymes con necesidades avanzadas de seguridad',
  pricePerSeatMonth: 18.00,
  features: [
    'Todo lo de Team Guard',
    'Deep-check bajo demanda con herramientas avanzadas',
    'Informes periódicos y soporte prioritario',
  ],
);

// Helper lists for easy UI iteration
const allIndividualPlans = [
  kPersalOneFree,
  kPersalOneAllyMonthly,
  kPersalOneAllyYearly,
];

const allBusinessPlans = [
  kPersalOneTeamStart,
  kPersalOneTeamGuard,
  kPersalOneTeamShield,
];
