/**
 * FAAP Scan App - Typography System
 * Based on the comprehensive UI/UX design document
 */

export const Typography = {
  // Font Families
  fontFamily: {
    primary: 'Inter',
    secondary: 'Roboto Mono',
    system: 'System', // Fallback to system font
  },

  // Font Sizes (in pixels)
  fontSize: {
    h1: 32,
    h2: 28,
    h3: 24,
    h4: 20,
    h5: 18,
    bodyLarge: 16,
    body: 14,
    bodySmall: 12,
    caption: 10,
  },

  // Font Weights
  fontWeight: {
    regular: '400' as const,
    medium: '500' as const,
    semiBold: '600' as const,
    bold: '700' as const,
  },

  // Line Heights (relative to font size)
  lineHeight: {
    tight: 1.2,
    normal: 1.4,
    relaxed: 1.6,
    loose: 1.8,
  },

  // Letter Spacing
  letterSpacing: {
    tight: -0.5,
    normal: 0,
    wide: 0.5,
    wider: 1,
  },

  // Text Styles (complete configurations)
  textStyles: {
    h1: {
      fontFamily: 'Inter',
      fontSize: 32,
      fontWeight: '700' as const,
      lineHeight: 38.4, // 32 * 1.2
      letterSpacing: -0.5,
    },
    h2: {
      fontFamily: 'Inter',
      fontSize: 28,
      fontWeight: '700' as const,
      lineHeight: 33.6, // 28 * 1.2
      letterSpacing: -0.5,
    },
    h3: {
      fontFamily: 'Inter',
      fontSize: 24,
      fontWeight: '600' as const,
      lineHeight: 28.8, // 24 * 1.2
      letterSpacing: 0,
    },
    h4: {
      fontFamily: 'Inter',
      fontSize: 20,
      fontWeight: '600' as const,
      lineHeight: 24, // 20 * 1.2
      letterSpacing: 0,
    },
    h5: {
      fontFamily: 'Inter',
      fontSize: 18,
      fontWeight: '500' as const,
      lineHeight: 21.6, // 18 * 1.2
      letterSpacing: 0,
    },
    bodyLarge: {
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: '400' as const,
      lineHeight: 22.4, // 16 * 1.4
      letterSpacing: 0,
    },
    body: {
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: '400' as const,
      lineHeight: 19.6, // 14 * 1.4
      letterSpacing: 0,
    },
    bodySmall: {
      fontFamily: 'Inter',
      fontSize: 12,
      fontWeight: '400' as const,
      lineHeight: 16.8, // 12 * 1.4
      letterSpacing: 0,
    },
    caption: {
      fontFamily: 'Inter',
      fontSize: 10,
      fontWeight: '400' as const,
      lineHeight: 14, // 10 * 1.4
      letterSpacing: 0.5,
    },
    button: {
      fontFamily: 'Inter',
      fontSize: 16,
      fontWeight: '600' as const,
      lineHeight: 19.2, // 16 * 1.2
      letterSpacing: 0.5,
    },
    buttonSmall: {
      fontFamily: 'Inter',
      fontSize: 14,
      fontWeight: '600' as const,
      lineHeight: 16.8, // 14 * 1.2
      letterSpacing: 0.5,
    },
    mono: {
      fontFamily: 'Roboto Mono',
      fontSize: 14,
      fontWeight: '400' as const,
      lineHeight: 19.6, // 14 * 1.4
      letterSpacing: 0,
    },
  },
} as const;

export type TextStyleKeys = keyof typeof Typography.textStyles;
export type FontFamilyKeys = keyof typeof Typography.fontFamily;
export type FontSizeKeys = keyof typeof Typography.fontSize;
export type FontWeightKeys = keyof typeof Typography.fontWeight;