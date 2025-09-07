/**
 * FAAP Scan App - Theme System
 * Combines all design tokens into a unified theme
 */

import { Colors } from './colors';
import { Typography } from './typography';
import { Spacing } from './spacing';
import { Dimensions } from './dimensions';

export const Theme = {
  colors: Colors,
  typography: Typography,
  spacing: Spacing,
  dimensions: Dimensions,

  // Component-specific theme configurations
  components: {
    button: {
      primary: {
        backgroundColor: Colors.primary.green,
        color: Colors.neutral.white,
        borderRadius: Dimensions.borderRadius.md,
        height: Dimensions.height.buttonPrimary,
        paddingHorizontal: Spacing.component.buttonPaddingHorizontal,
        ...Typography.textStyles.button,
        ...Dimensions.shadow.md,
      },
      secondary: {
        backgroundColor: 'transparent',
        color: Colors.primary.green,
        borderColor: Colors.primary.green,
        borderWidth: 1,
        borderRadius: Dimensions.borderRadius.md,
        height: Dimensions.height.buttonSecondary,
        paddingHorizontal: Spacing.component.buttonPaddingHorizontal,
        ...Typography.textStyles.button,
        ...Dimensions.shadow.sm,
      },
      tertiary: {
        backgroundColor: 'transparent',
        color: Colors.primary.green,
        borderRadius: Dimensions.borderRadius.sm,
        height: Dimensions.height.buttonTertiary,
        paddingHorizontal: Spacing.component.buttonPaddingHorizontal,
        ...Typography.textStyles.buttonSmall,
      },
      danger: {
        backgroundColor: Colors.primary.red,
        color: Colors.neutral.white,
        borderRadius: Dimensions.borderRadius.md,
        height: Dimensions.height.buttonPrimary,
        paddingHorizontal: Spacing.component.buttonPaddingHorizontal,
        ...Typography.textStyles.button,
        ...Dimensions.shadow.md,
      },
    },
    
    card: {
      default: {
        backgroundColor: Colors.functional.surface,
        borderRadius: Dimensions.borderRadius.lg,
        padding: Spacing.component.cardPadding,
        margin: Spacing.component.cardMargin,
        ...Dimensions.shadow.md,
      },
      elevated: {
        backgroundColor: Colors.functional.surface,
        borderRadius: Dimensions.borderRadius.lg,
        padding: Spacing.component.cardPadding,
        margin: Spacing.component.cardMargin,
        ...Dimensions.shadow.lg,
      },
    },

    input: {
      default: {
        backgroundColor: Colors.functional.surface,
        borderColor: Colors.neutral.gray300,
        borderWidth: 1,
        borderRadius: Dimensions.borderRadius.md,
        height: Dimensions.height.input,
        paddingHorizontal: Spacing.component.inputPaddingHorizontal,
        paddingVertical: Spacing.component.inputPaddingVertical,
        ...Typography.textStyles.body,
      },
      focused: {
        borderColor: Colors.primary.blue,
        borderWidth: 2,
        ...Dimensions.shadow.sm,
      },
      error: {
        borderColor: Colors.primary.red,
        borderWidth: 2,
      },
    },

    riskIndicator: {
      high: {
        backgroundColor: Colors.risk.high,
        color: Colors.neutral.white,
        borderRadius: Dimensions.borderRadius.sm,
        padding: Spacing.xs,
      },
      medium: {
        backgroundColor: Colors.risk.medium,
        color: Colors.neutral.white,
        borderRadius: Dimensions.borderRadius.sm,
        padding: Spacing.xs,
      },
      low: {
        backgroundColor: Colors.risk.low,
        color: Colors.neutral.white,
        borderRadius: Dimensions.borderRadius.sm,
        padding: Spacing.xs,
      },
    },
  },

  // Animation configurations
  animations: {
    fadeIn: {
      duration: Dimensions.animation.normal,
      easing: 'ease-out',
    },
    slideIn: {
      duration: Dimensions.animation.fast,
      easing: 'ease-out',
    },
    bounce: {
      duration: Dimensions.animation.slow,
      easing: 'ease-in-out',
    },
  },
} as const;

export type ThemeType = typeof Theme;
export default Theme;