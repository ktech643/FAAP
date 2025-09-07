/**
 * FAAP Scan App - Advanced Card Component
 * Implements the card system from the design document
 */

import React from 'react';
import {
  View,
  StyleSheet,
  ViewStyle,
  TouchableOpacity,
} from 'react-native';
import { Colors } from '../../constants/colors';
import { Dimensions } from '../../constants/dimensions';
import { Spacing } from '../../constants/spacing';

export type CardVariant = 'default' | 'elevated' | 'outlined' | 'flat';
export type CardSize = 'small' | 'medium' | 'large';

export interface CardProps {
  children: React.ReactNode;
  variant?: CardVariant;
  size?: CardSize;
  onPress?: () => void;
  style?: ViewStyle;
  contentStyle?: ViewStyle;
  disabled?: boolean;
  testID?: string;
  accessibilityLabel?: string;
  accessibilityHint?: string;
}

const Card: React.FC<CardProps> = ({
  children,
  variant = 'default',
  size = 'medium',
  onPress,
  style,
  contentStyle,
  disabled = false,
  testID,
  accessibilityLabel,
  accessibilityHint,
}) => {
  const getCardStyle = (): ViewStyle => {
    const baseStyle: ViewStyle = {
      borderRadius: Dimensions.borderRadius.lg,
      backgroundColor: Colors.functional.surface,
    };

    // Size variations
    switch (size) {
      case 'small':
        baseStyle.padding = Spacing.sm;
        baseStyle.margin = Spacing.xs;
        break;
      case 'large':
        baseStyle.padding = Spacing.lg;
        baseStyle.margin = Spacing.md;
        break;
      default:
        baseStyle.padding = Spacing.component.cardPadding;
        baseStyle.margin = Spacing.component.cardMargin;
    }

    // Variant styles
    switch (variant) {
      case 'default':
        baseStyle.shadowColor = Colors.neutral.black;
        baseStyle.shadowOffset = Dimensions.shadow.md.shadowOffset;
        baseStyle.shadowOpacity = Dimensions.shadow.md.shadowOpacity;
        baseStyle.shadowRadius = Dimensions.shadow.md.shadowRadius;
        baseStyle.elevation = Dimensions.shadow.md.elevation;
        break;
      case 'elevated':
        baseStyle.shadowColor = Colors.neutral.black;
        baseStyle.shadowOffset = Dimensions.shadow.lg.shadowOffset;
        baseStyle.shadowOpacity = Dimensions.shadow.lg.shadowOpacity;
        baseStyle.shadowRadius = Dimensions.shadow.lg.shadowRadius;
        baseStyle.elevation = Dimensions.shadow.lg.elevation;
        break;
      case 'outlined':
        baseStyle.borderWidth = 1;
        baseStyle.borderColor = Colors.neutral.gray300;
        baseStyle.shadowOpacity = 0;
        baseStyle.elevation = 0;
        break;
      case 'flat':
        baseStyle.shadowOpacity = 0;
        baseStyle.elevation = 0;
        break;
    }

    // Disabled state
    if (disabled) {
      baseStyle.opacity = 0.6;
    }

    return baseStyle;
  };

  const CardComponent = onPress ? TouchableOpacity : View;

  return (
    <CardComponent
      style={[getCardStyle(), style]}
      onPress={onPress}
      disabled={disabled}
      activeOpacity={onPress ? 0.8 : 1}
      testID={testID}
      accessibilityLabel={accessibilityLabel}
      accessibilityHint={accessibilityHint}
      accessibilityRole={onPress ? 'button' : undefined}
    >
      <View style={[styles.content, contentStyle]}>
        {children}
      </View>
    </CardComponent>
  );
};

const styles = StyleSheet.create({
  content: {
    flex: 1,
  },
});

export default Card;