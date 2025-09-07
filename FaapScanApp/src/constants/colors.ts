/**
 * FAAP Scan App - Advanced Color System
 * Based on the comprehensive UI/UX design document
 */

export const Colors = {
  // Primary Palette
  primary: {
    green: '#2E7D32',      // Health, Safety
    blue: '#1976D2',       // Trust, Information
    red: '#D32F2F',        // Warning, Danger
    yellow: '#FBC02D',     // Caution, Attention
  },

  // Secondary Palette
  secondary: {
    success: '#388E3C',
    warning: '#F57C00',
    error: '#D32F2F',
    info: '#0288D1',
  },

  // Neutral Palette
  neutral: {
    white: '#FFFFFF',
    gray50: '#FAFAFA',
    gray100: '#F5F5F5',
    gray200: '#EEEEEE',
    gray300: '#E0E0E0',
    gray400: '#BDBDBD',
    gray500: '#9E9E9E',
    gray600: '#757575',
    gray700: '#616161',
    gray800: '#424242',
    gray900: '#212121',
    black: '#000000',
  },

  // Risk Level Colors
  risk: {
    high: '#D32F2F',       // Red - High Risk
    medium: '#F57C00',     // Orange - Medium Risk
    low: '#388E3C',        // Green - Low Risk
    unknown: '#9E9E9E',    // Gray - Unknown Risk
  },

  // Functional Colors
  functional: {
    background: '#FAFAFA',
    surface: '#FFFFFF',
    onSurface: '#212121',
    onBackground: '#212121',
    disabled: '#BDBDBD',
    placeholder: '#9E9E9E',
    divider: '#E0E0E0',
  },

  // Gradient Colors
  gradients: {
    primary: ['#2E7D32', '#388E3C'],
    secondary: ['#1976D2', '#0288D1'],
    warning: ['#F57C00', '#FBC02D'],
    danger: ['#D32F2F', '#F44336'],
  },

  // Transparency variants
  alpha: {
    primary: 'rgba(46, 125, 50, 0.1)',
    secondary: 'rgba(25, 118, 210, 0.1)',
    error: 'rgba(211, 47, 47, 0.1)',
    warning: 'rgba(245, 124, 0, 0.1)',
    black10: 'rgba(0, 0, 0, 0.1)',
    black20: 'rgba(0, 0, 0, 0.2)',
    black50: 'rgba(0, 0, 0, 0.5)',
    white10: 'rgba(255, 255, 255, 0.1)',
    white20: 'rgba(255, 255, 255, 0.2)',
    white90: 'rgba(255, 255, 255, 0.9)',
  },
} as const;

export type ColorKeys = keyof typeof Colors;
export type PrimaryColorKeys = keyof typeof Colors.primary;
export type NeutralColorKeys = keyof typeof Colors.neutral;
export type RiskColorKeys = keyof typeof Colors.risk;