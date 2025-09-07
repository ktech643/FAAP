/**
 * FAAP Scan App - Dimensions System
 * Based on the comprehensive UI/UX design document
 */

export const Dimensions = {
  // Border radius
  borderRadius: {
    none: 0,
    xs: 2,
    sm: 4,
    md: 8,
    lg: 12,
    xl: 16,
    xxl: 24,
    full: 9999, // For circular elements
  },

  // Component heights
  height: {
    // Button heights
    buttonPrimary: 44,
    buttonSecondary: 40,
    buttonTertiary: 36,
    buttonSmall: 32,

    // Input heights
    input: 48,
    inputSmall: 40,

    // Navigation
    tabBar: 60,
    header: 56,

    // Cards
    cardSmall: 80,
    cardMedium: 120,
    cardLarge: 160,

    // Touch targets (minimum for accessibility)
    touchTarget: 44,
  },

  // Component widths
  width: {
    // Floating Action Button
    fab: 56,
    fabSmall: 40,

    // Icon sizes
    iconXS: 16,
    iconSM: 20,
    iconMD: 24,
    iconLG: 32,
    iconXL: 48,

    // Avatar sizes
    avatarSmall: 32,
    avatarMedium: 48,
    avatarLarge: 64,

    // Button widths
    buttonSmall: 80,
    buttonMedium: 120,
    buttonLarge: 200,
    buttonFull: '100%',
  },

  // Shadow system
  shadow: {
    none: {
      shadowOffset: { width: 0, height: 0 },
      shadowOpacity: 0,
      shadowRadius: 0,
      elevation: 0,
    },
    sm: {
      shadowOffset: { width: 0, height: 1 },
      shadowOpacity: 0.1,
      shadowRadius: 2,
      elevation: 2,
    },
    md: {
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.15,
      shadowRadius: 4,
      elevation: 4,
    },
    lg: {
      shadowOffset: { width: 0, height: 4 },
      shadowOpacity: 0.2,
      shadowRadius: 8,
      elevation: 8,
    },
    xl: {
      shadowOffset: { width: 0, height: 8 },
      shadowOpacity: 0.25,
      shadowRadius: 16,
      elevation: 16,
    },
  },

  // Animation durations
  animation: {
    fast: 150,
    normal: 250,
    slow: 350,
    slower: 500,
  },

  // Z-index layers
  zIndex: {
    background: -1,
    base: 0,
    content: 1,
    overlay: 10,
    modal: 100,
    toast: 1000,
    tooltip: 1100,
  },
} as const;

export type BorderRadiusKeys = keyof typeof Dimensions.borderRadius;
export type HeightKeys = keyof typeof Dimensions.height;
export type WidthKeys = keyof typeof Dimensions.width;
export type ShadowKeys = keyof typeof Dimensions.shadow;