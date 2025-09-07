/**
 * FAAP Scan App - Typography Components
 * Implements the typography system from the design document
 */

import React from 'react';
import {
  Text,
  TextStyle,
  StyleSheet,
} from 'react-native';
import { Typography as TypographyConstants } from '../../constants/typography';
import { Colors } from '../../constants/colors';

export type TextVariant = keyof typeof TypographyConstants.textStyles;
export type TextColor = 'primary' | 'secondary' | 'error' | 'warning' | 'success' | 'info' | 'disabled';

export interface TypographyProps {
  variant?: TextVariant;
  color?: TextColor;
  children: React.ReactNode;
  style?: TextStyle;
  numberOfLines?: number;
  ellipsizeMode?: 'head' | 'middle' | 'tail' | 'clip';
  testID?: string;
  accessibilityLabel?: string;
  accessibilityHint?: string;
  onPress?: () => void;
}

const Typography: React.FC<TypographyProps> = ({
  variant = 'body',
  color = 'primary',
  children,
  style,
  numberOfLines,
  ellipsizeMode = 'tail',
  testID,
  accessibilityLabel,
  accessibilityHint,
  onPress,
}) => {
  const getTextStyle = (): TextStyle => {
    const baseStyle = { ...TypographyConstants.textStyles[variant] };

    // Color variations
    switch (color) {
      case 'primary':
        baseStyle.color = Colors.functional.onSurface;
        break;
      case 'secondary':
        baseStyle.color = Colors.neutral.gray600;
        break;
      case 'error':
        baseStyle.color = Colors.secondary.error;
        break;
      case 'warning':
        baseStyle.color = Colors.secondary.warning;
        break;
      case 'success':
        baseStyle.color = Colors.secondary.success;
        break;
      case 'info':
        baseStyle.color = Colors.secondary.info;
        break;
      case 'disabled':
        baseStyle.color = Colors.functional.disabled;
        break;
    }

    return baseStyle;
  };

  return (
    <Text
      style={[getTextStyle(), style]}
      numberOfLines={numberOfLines}
      ellipsizeMode={ellipsizeMode}
      testID={testID}
      accessibilityLabel={accessibilityLabel}
      accessibilityHint={accessibilityHint}
      onPress={onPress}
    >
      {children}
    </Text>
  );
};

// Convenience components for common text variants
export const H1: React.FC<Omit<TypographyProps, 'variant'>> = (props) => (
  <Typography {...props} variant="h1" />
);

export const H2: React.FC<Omit<TypographyProps, 'variant'>> = (props) => (
  <Typography {...props} variant="h2" />
);

export const H3: React.FC<Omit<TypographyProps, 'variant'>> = (props) => (
  <Typography {...props} variant="h3" />
);

export const H4: React.FC<Omit<TypographyProps, 'variant'>> = (props) => (
  <Typography {...props} variant="h4" />
);

export const H5: React.FC<Omit<TypographyProps, 'variant'>> = (props) => (
  <Typography {...props} variant="h5" />
);

export const BodyLarge: React.FC<Omit<TypographyProps, 'variant'>> = (props) => (
  <Typography {...props} variant="bodyLarge" />
);

export const Body: React.FC<Omit<TypographyProps, 'variant'>> = (props) => (
  <Typography {...props} variant="body" />
);

export const BodySmall: React.FC<Omit<TypographyProps, 'variant'>> = (props) => (
  <Typography {...props} variant="bodySmall" />
);

export const Caption: React.FC<Omit<TypographyProps, 'variant'>> = (props) => (
  <Typography {...props} variant="caption" />
);

export const Mono: React.FC<Omit<TypographyProps, 'variant'>> = (props) => (
  <Typography {...props} variant="mono" />
);

export default Typography;