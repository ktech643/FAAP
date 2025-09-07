/**
 * FAAP Scan App - Spacing System
 * Based on the comprehensive UI/UX design document
 */

export const Spacing = {
  // Base spacing unit (8px system)
  base: 8,

  // Spacing scale
  xs: 4,    // 0.5 * base
  sm: 8,    // 1 * base
  md: 16,   // 2 * base
  lg: 24,   // 3 * base
  xl: 32,   // 4 * base
  xxl: 48,  // 6 * base
  xxxl: 64, // 8 * base

  // Component-specific spacing
  component: {
    // Button spacing
    buttonPaddingHorizontal: 16,
    buttonPaddingVertical: 12,
    buttonMargin: 8,

    // Card spacing
    cardPadding: 16,
    cardMargin: 8,
    cardGap: 12,

    // Input spacing
    inputPaddingHorizontal: 16,
    inputPaddingVertical: 12,
    inputMargin: 8,

    // Screen spacing
    screenPaddingHorizontal: 16,
    screenPaddingVertical: 24,

    // List spacing
    listItemPadding: 16,
    listItemMargin: 4,

    // Icon spacing
    iconMargin: 8,
    iconPadding: 4,
  },

  // Layout spacing
  layout: {
    containerPadding: 16,
    sectionMargin: 24,
    elementGap: 12,
    componentGap: 16,
  },

  // Safe area spacing (for notches, home indicators, etc.)
  safeArea: {
    top: 44,
    bottom: 34,
    horizontal: 16,
  },
} as const;

export type SpacingKeys = keyof typeof Spacing;
export type ComponentSpacingKeys = keyof typeof Spacing.component;
export type LayoutSpacingKeys = keyof typeof Spacing.layout;