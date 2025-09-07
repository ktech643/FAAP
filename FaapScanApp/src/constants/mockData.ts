/**
 * FAAP Scan App - Mock Data
 * Sample data for development and testing
 */

import { Product, ScanResult, Ingredient, UserProfile, HealthMetrics } from '../types';

export const mockIngredients: Ingredient[] = [
  {
    id: '1',
    name: 'Sodium Benzoate',
    additiveCode: 'E211',
    category: 'preservative',
    riskLevel: 'medium',
    description: 'A preservative that can form benzene when combined with vitamin C. Commonly used in acidic foods.',
    healthEffects: [
      {
        type: 'negative',
        description: 'May trigger hyperactivity in children',
        severity: 'moderate',
        affectedSystems: ['nervous'],
        studies: [
          {
            title: 'Food additives and hyperactive behaviour in 3-year-old and 8/9-year-old children',
            authors: ['McCann D', Barrett A', 'Cooper A'],
            journal: 'The Lancet',
            year: 2007,
            url: 'https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(07)61306-3/fulltext',
          },
        ],
      },
    ],
    sources: ['FDA', 'EFSA'],
    alternatives: ['Potassium Sorbate', 'Natural Vitamin E', 'Rosemary Extract'],
  },
  {
    id: '2',
    name: 'Artificial Colors (Red 40, Yellow 5)',
    additiveCode: 'E129, E102',
    category: 'colorant',
    riskLevel: 'high',
    description: 'Synthetic food dyes that provide bright colors but have been linked to behavioral issues in children.',
    healthEffects: [
      {
        type: 'negative',
        description: 'Linked to ADHD and hyperactivity in children',
        severity: 'severe',
        affectedSystems: ['nervous', 'behavioral'],
        studies: [
          {
            title: 'Artificial food colors and attention-deficit/hyperactivity disorder symptoms',
            authors: ['Arnold LE', 'Lofthouse N', 'Hurt E'],
            journal: 'Neurotherapeutics',
            year: 2012,
          },
        ],
      },
    ],
    sources: ['FDA', 'European Food Safety Authority'],
    alternatives: ['Natural Beetroot Extract', 'Turmeric', 'Paprika Extract'],
  },
  {
    id: '3',
    name: 'High Fructose Corn Syrup',
    additiveCode: '',
    category: 'sweetener',
    riskLevel: 'medium',
    description: 'A processed sweetener that may contribute to obesity and metabolic issues when consumed in large quantities.',
    healthEffects: [
      {
        type: 'negative',
        description: 'May contribute to obesity and insulin resistance',
        severity: 'moderate',
        affectedSystems: ['metabolic', 'endocrine'],
        studies: [],
      },
    ],
    sources: ['American Heart Association', 'Mayo Clinic'],
    alternatives: ['Cane Sugar', 'Honey', 'Maple Syrup'],
  },
  {
    id: '4',
    name: 'Vitamin C (Ascorbic Acid)',
    additiveCode: 'E300',
    category: 'antioxidant',
    riskLevel: 'low',
    description: 'A natural antioxidant that helps preserve food and provides nutritional benefits.',
    healthEffects: [
      {
        type: 'positive',
        description: 'Provides antioxidant benefits and supports immune system',
        severity: 'mild',
        affectedSystems: ['immune'],
        studies: [],
      },
    ],
    sources: ['FDA', 'WHO'],
    alternatives: [],
  },
];

export const mockProducts: Product[] = [
  {
    id: 'p1',
    barcode: '123456789012',
    name: 'Organic Whole Milk',
    brand: 'Nature\'s Best',
    category: 'dairy',
    description: 'Fresh organic whole milk from grass-fed cows',
    images: [],
    ingredients: [mockIngredients[3]], // Only Vitamin C
    nutritionalInfo: {
      servingSize: '1 cup (240ml)',
      calories: 150,
      macronutrients: {
        protein: 8,
        carbohydrates: 12,
        fat: 8,
        fiber: 0,
        sugar: 12,
        sodium: 120,
      },
      vitamins: {
        'Vitamin A': 10,
        'Vitamin D': 25,
        'Vitamin C': 0,
      },
      minerals: {
        'Calcium': 30,
        'Iron': 0,
      },
    },
    riskAssessment: {
      overallRisk: 'low',
      riskFactors: [],
      recommendations: ['Great choice! This product has minimal additives and good nutritional value.'],
      score: 85,
    },
    reviews: [],
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'p2',
    barcode: '987654321098',
    name: 'Energy Drink Ultra',
    brand: 'PowerBoost',
    category: 'beverage',
    description: 'High-energy drink with caffeine and artificial flavors',
    images: [],
    ingredients: [mockIngredients[0], mockIngredients[1], mockIngredients[2]], // Multiple concerning ingredients
    nutritionalInfo: {
      servingSize: '1 can (355ml)',
      calories: 110,
      macronutrients: {
        protein: 0,
        carbohydrates: 28,
        fat: 0,
        fiber: 0,
        sugar: 27,
        sodium: 200,
      },
      vitamins: {
        'Vitamin B6': 250,
        'Vitamin B12': 8333,
      },
      minerals: {
        'Caffeine': 160,
      },
    },
    riskAssessment: {
      overallRisk: 'high',
      riskFactors: [
        {
          ingredient: 'Artificial Colors',
          riskLevel: 'high',
          reason: 'Linked to hyperactivity in children',
          personalRelevance: true,
        },
        {
          ingredient: 'High Fructose Corn Syrup',
          riskLevel: 'medium',
          reason: 'May contribute to metabolic issues',
          personalRelevance: true,
        },
      ],
      recommendations: [
        'Consider natural energy alternatives like green tea',
        'Look for products without artificial colors',
        'Limit consumption due to high sugar content',
      ],
      score: 25,
    },
    reviews: [],
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: 'p3',
    barcode: '456789123456',
    name: 'Whole Grain Cereal',
    brand: 'Healthy Choice',
    category: 'food',
    description: 'Nutritious whole grain cereal with natural ingredients',
    images: [],
    ingredients: [mockIngredients[3]], // Only natural ingredients
    nutritionalInfo: {
      servingSize: '3/4 cup (30g)',
      calories: 120,
      macronutrients: {
        protein: 4,
        carbohydrates: 25,
        fat: 2,
        fiber: 5,
        sugar: 6,
        sodium: 140,
      },
      vitamins: {
        'Vitamin D': 10,
        'Iron': 45,
        'Vitamin B6': 25,
      },
      minerals: {
        'Zinc': 25,
      },
    },
    riskAssessment: {
      overallRisk: 'low',
      riskFactors: [],
      recommendations: [
        'Excellent choice with high fiber content',
        'Good source of essential vitamins and minerals',
      ],
      score: 78,
    },
    reviews: [],
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

export const mockScanResults: ScanResult[] = [
  {
    id: '1',
    userId: 'user1',
    product: mockProducts[0],
    scannedAt: new Date(Date.now() - 3600000), // 1 hour ago
    confidence: 0.95,
    processingTime: 1200,
  },
  {
    id: '2',
    userId: 'user1',
    product: mockProducts[1],
    scannedAt: new Date(Date.now() - 7200000), // 2 hours ago
    confidence: 0.98,
    processingTime: 800,
  },
  {
    id: '3',
    userId: 'user1',
    product: mockProducts[2],
    scannedAt: new Date(Date.now() - 86400000), // 1 day ago
    confidence: 0.92,
    processingTime: 1500,
  },
];

export const mockUserProfile: UserProfile = {
  id: 'user1',
  name: 'John Doe',
  email: 'john.doe@example.com',
  avatar: '',
  preferences: {
    language: 'en',
    notifications: {
      scanReminders: true,
      healthAlerts: true,
      productUpdates: false,
      communityActivity: true,
    },
    theme: 'light',
    accessibility: {
      fontSize: 'medium',
      highContrast: false,
      reducedMotion: false,
      voiceOver: false,
    },
  },
  healthProfile: {
    allergies: ['Peanuts', 'Shellfish'],
    dietaryRestrictions: ['vegetarian'],
    healthGoals: ['weight-loss', 'heart-health'],
    avoidanceList: ['Artificial Colors', 'High Fructose Corn Syrup'],
    riskTolerance: 'low',
  },
  createdAt: new Date(Date.now() - 2592000000), // 30 days ago
  updatedAt: new Date(),
};

export const mockHealthMetrics: HealthMetrics = {
  id: 'hm1',
  userId: 'user1',
  date: new Date(),
  dailyRiskScore: 45,
  weeklyRiskScore: 52,
  monthlyRiskScore: 48,
  additiveConsumption: [
    {
      additiveId: '1',
      additiveName: 'Sodium Benzoate',
      amount: 2,
      frequency: 3,
      riskLevel: 'medium',
    },
    {
      additiveId: '2',
      additiveName: 'Artificial Colors',
      amount: 1,
      frequency: 1,
      riskLevel: 'high',
    },
  ],
  trends: [
    {
      metric: 'Risk Score',
      direction: 'improving',
      percentage: 15,
      timeframe: 'weekly',
    },
    {
      metric: 'Additive Consumption',
      direction: 'declining',
      percentage: 8,
      timeframe: 'monthly',
    },
  ],
};