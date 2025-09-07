/**
 * FAAP Scan App - Type Definitions
 * Comprehensive type system for the application
 */

// User Profile Types
export interface UserProfile {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  preferences: UserPreferences;
  healthProfile: HealthProfile;
  createdAt: Date;
  updatedAt: Date;
}

export interface UserPreferences {
  language: string;
  notifications: NotificationPreferences;
  theme: 'light' | 'dark' | 'auto';
  accessibility: AccessibilityPreferences;
}

export interface NotificationPreferences {
  scanReminders: boolean;
  healthAlerts: boolean;
  productUpdates: boolean;
  communityActivity: boolean;
}

export interface AccessibilityPreferences {
  fontSize: 'small' | 'medium' | 'large' | 'extraLarge';
  highContrast: boolean;
  reducedMotion: boolean;
  voiceOver: boolean;
}

export interface HealthProfile {
  allergies: string[];
  dietaryRestrictions: DietaryRestriction[];
  healthGoals: HealthGoal[];
  avoidanceList: string[];
  riskTolerance: 'low' | 'medium' | 'high';
}

export type DietaryRestriction = 
  | 'vegetarian'
  | 'vegan' 
  | 'gluten-free'
  | 'dairy-free'
  | 'nut-free'
  | 'kosher'
  | 'halal'
  | 'keto'
  | 'paleo';

export type HealthGoal = 
  | 'weight-loss'
  | 'muscle-gain'
  | 'heart-health'
  | 'diabetes-management'
  | 'general-wellness'
  | 'energy-boost'
  | 'digestive-health';

// Product Types
export interface Product {
  id: string;
  barcode: string;
  name: string;
  brand: string;
  category: ProductCategory;
  description?: string;
  images: string[];
  ingredients: Ingredient[];
  nutritionalInfo: NutritionalInfo;
  riskAssessment: RiskAssessment;
  alternatives?: Product[];
  reviews: Review[];
  createdAt: Date;
  updatedAt: Date;
}

export type ProductCategory = 
  | 'food'
  | 'beverage'
  | 'snack'
  | 'dairy'
  | 'meat'
  | 'seafood'
  | 'produce'
  | 'bakery'
  | 'frozen'
  | 'canned'
  | 'condiment'
  | 'supplement';

export interface Ingredient {
  id: string;
  name: string;
  additiveCode?: string;
  category: IngredientCategory;
  riskLevel: RiskLevel;
  description: string;
  healthEffects: HealthEffect[];
  sources: string[];
  alternatives: string[];
}

export type IngredientCategory = 
  | 'preservative'
  | 'colorant'
  | 'flavor-enhancer'
  | 'sweetener'
  | 'emulsifier'
  | 'thickener'
  | 'antioxidant'
  | 'stabilizer'
  | 'natural'
  | 'artificial';

export type RiskLevel = 'low' | 'medium' | 'high' | 'unknown';

export interface HealthEffect {
  type: 'positive' | 'negative' | 'neutral';
  description: string;
  severity: 'mild' | 'moderate' | 'severe';
  affectedSystems: string[];
  studies: StudyReference[];
}

export interface StudyReference {
  title: string;
  authors: string[];
  journal: string;
  year: number;
  url?: string;
}

export interface NutritionalInfo {
  servingSize: string;
  calories: number;
  macronutrients: {
    protein: number;
    carbohydrates: number;
    fat: number;
    fiber: number;
    sugar: number;
    sodium: number;
  };
  vitamins: Record<string, number>;
  minerals: Record<string, number>;
}

export interface RiskAssessment {
  overallRisk: RiskLevel;
  riskFactors: RiskFactor[];
  personalizedRisk?: RiskLevel;
  recommendations: string[];
  score: number; // 0-100
}

export interface RiskFactor {
  ingredient: string;
  riskLevel: RiskLevel;
  reason: string;
  personalRelevance: boolean;
}

// Scanning Types
export interface ScanResult {
  id: string;
  userId: string;
  product: Product;
  scannedAt: Date;
  location?: GeolocationCoordinates;
  confidence: number;
  processingTime: number;
}

export interface ScanHistory {
  id: string;
  userId: string;
  scans: ScanResult[];
  totalScans: number;
  lastScanDate: Date;
}

// Health Tracking Types
export interface HealthMetrics {
  id: string;
  userId: string;
  date: Date;
  dailyRiskScore: number;
  weeklyRiskScore: number;
  monthlyRiskScore: number;
  additiveConsumption: AdditiveConsumption[];
  trends: HealthTrend[];
}

export interface AdditiveConsumption {
  additiveId: string;
  additiveName: string;
  amount: number;
  frequency: number;
  riskLevel: RiskLevel;
}

export interface HealthTrend {
  metric: string;
  direction: 'improving' | 'declining' | 'stable';
  percentage: number;
  timeframe: 'daily' | 'weekly' | 'monthly';
}

// Navigation Types
export type RootStackParamList = {
  Onboarding: undefined;
  Main: undefined;
  Scanning: { productId?: string };
  Results: { scanResult: ScanResult };
  ProductDetails: { productId: string };
  Search: { query?: string };
  Profile: undefined;
  Settings: undefined;
};

export type MainTabParamList = {
  Home: undefined;
  Scan: undefined;
  Health: undefined;
  Search: undefined;
  Profile: undefined;
};

export type OnboardingStackParamList = {
  Welcome: undefined;
  Permissions: undefined;
  HealthProfile: undefined;
  Tutorial: undefined;
  Complete: undefined;
};

// API Types
export interface APIResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
  timestamp: Date;
}

export interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  limit: number;
  hasMore: boolean;
}

// Search Types
export interface SearchQuery {
  query: string;
  filters: SearchFilters;
  sortBy: SearchSortOption;
  page: number;
  limit: number;
}

export interface SearchFilters {
  category?: ProductCategory[];
  riskLevel?: RiskLevel[];
  brand?: string[];
  ingredients?: string[];
}

export type SearchSortOption = 
  | 'relevance'
  | 'name'
  | 'brand'
  | 'risk-level'
  | 'recently-added';

export interface SearchResult {
  products: Product[];
  ingredients: Ingredient[];
  total: number;
  suggestions: string[];
}

// Review Types
export interface Review {
  id: string;
  userId: string;
  productId: string;
  rating: number; // 1-5
  title: string;
  comment: string;
  helpful: number;
  reported: boolean;
  createdAt: Date;
}

// Community Types
export interface CommunityPost {
  id: string;
  userId: string;
  title: string;
  content: string;
  category: 'question' | 'tip' | 'warning' | 'review';
  tags: string[];
  likes: number;
  comments: Comment[];
  createdAt: Date;
}

export interface Comment {
  id: string;
  userId: string;
  content: string;
  likes: number;
  replies: Comment[];
  createdAt: Date;
}

// Error Types
export interface AppError {
  code: string;
  message: string;
  details?: any;
  timestamp: Date;
}

// Camera Types
export interface CameraConfig {
  quality: 'low' | 'medium' | 'high';
  flashMode: 'auto' | 'on' | 'off';
  focusMode: 'auto' | 'manual';
  whiteBalance: 'auto' | 'sunny' | 'cloudy' | 'fluorescent';
}

// Analytics Types
export interface AnalyticsEvent {
  name: string;
  properties: Record<string, any>;
  timestamp: Date;
  userId?: string;
  sessionId: string;
}

// Notification Types
export interface NotificationPayload {
  id: string;
  title: string;
  body: string;
  data?: Record<string, any>;
  type: NotificationType;
  priority: 'low' | 'normal' | 'high';
  scheduledFor?: Date;
}

export type NotificationType = 
  | 'scan-reminder'
  | 'health-alert'
  | 'product-recall'
  | 'ingredient-warning'
  | 'goal-achievement'
  | 'community-update';

// Storage Types
export interface StorageItem<T> {
  key: string;
  value: T;
  expiresAt?: Date;
  encrypted?: boolean;
}

export interface DatabaseSchema {
  users: UserProfile;
  products: Product;
  ingredients: Ingredient;
  scans: ScanResult;
  reviews: Review;
  healthMetrics: HealthMetrics;
}

// Form Types
export interface FormField<T = any> {
  value: T;
  error?: string;
  touched: boolean;
  required: boolean;
  validator?: (value: T) => string | undefined;
}

export interface FormState<T extends Record<string, any>> {
  fields: { [K in keyof T]: FormField<T[K]> };
  isValid: boolean;
  isSubmitting: boolean;
  errors: Record<string, string>;
}

// Component Props Types
export interface BaseComponentProps {
  testID?: string;
  accessibilityLabel?: string;
  accessibilityHint?: string;
  style?: any;
  children?: React.ReactNode;
}

export interface TouchableComponentProps extends BaseComponentProps {
  onPress?: () => void;
  disabled?: boolean;
  loading?: boolean;
}

// Theme Types
export interface ThemeColors {
  primary: string;
  secondary: string;
  background: string;
  surface: string;
  error: string;
  warning: string;
  success: string;
  info: string;
  text: string;
  textSecondary: string;
}

export interface ThemeSpacing {
  xs: number;
  sm: number;
  md: number;
  lg: number;
  xl: number;
}

export interface AppTheme {
  colors: ThemeColors;
  spacing: ThemeSpacing;
  typography: any;
  dimensions: any;
}