/**
 * FAAP Scan App - Advanced Button Component
 * Implements the comprehensive button system from the design document
 */

import React from 'react';
import {
  TouchableOpacity,
  Text,
  StyleSheet,
  ViewStyle,
  TextStyle,
  ActivityIndicator,
  View,
} from 'react-native';
import { Colors } from '../../constants/colors';
import { Typography } from '../../constants/typography';
import { Dimensions } from '../../constants/dimensions';
import { Spacing } from '../../constants/spacing';

export type ButtonVariant = 'primary' | 'secondary' | 'tertiary' | 'danger';
export type ButtonSize = 'small' | 'medium' | 'large';

export interface ButtonProps {
  title: string;
  onPress: () => void;
  variant?: ButtonVariant;
  size?: ButtonSize;
  disabled?: boolean;
  loading?: boolean;
  fullWidth?: boolean;
  icon?: React.ReactNode;
  iconPosition?: 'left' | 'right';
  style?: ViewStyle;
  textStyle?: TextStyle;
  testID?: string;
  accessibilityLabel?: string;
  accessibilityHint?: string;
}

const Button: React.FC<ButtonProps> = ({
  title,
  onPress,
  variant = 'primary',
  size = 'medium',
  disabled = false,
  loading = false,
  fullWidth = false,
  icon,
  iconPosition = 'left',
  style,
  textStyle,
  testID,
  accessibilityLabel,
  accessibilityHint,
}) => {
  const getButtonStyle = (): ViewStyle => {
    const baseStyle: ViewStyle = {
      flexDirection: 'row',
      alignItems: 'center',
      justifyContent: 'center',
      borderRadius: Dimensions.borderRadius.md,
      ...Dimensions.shadow.md,
    };

    // Size variations
    switch (size) {
      case 'small':
        baseStyle.height = Dimensions.height.buttonTertiary;
        baseStyle.paddingHorizontal = Spacing.md;
        break;
      case 'large':
        baseStyle.height = Dimensions.height.buttonPrimary + 8;
        baseStyle.paddingHorizontal = Spacing.lg;
        break;
      default:
        baseStyle.height = Dimensions.height.buttonPrimary;
        baseStyle.paddingHorizontal = Spacing.component.buttonPaddingHorizontal;
    }

    // Variant styles
    switch (variant) {
      case 'primary':
        baseStyle.backgroundColor = Colors.primary.green;
        break;
      case 'secondary':
        baseStyle.backgroundColor = 'transparent';
        baseStyle.borderWidth = 1;
        baseStyle.borderColor = Colors.primary.green;
        break;
      case 'tertiary':
        baseStyle.backgroundColor = 'transparent';
        baseStyle.shadowOpacity = 0;
        baseStyle.elevation = 0;
        break;
      case 'danger':
        baseStyle.backgroundColor = Colors.primary.red;
        break;
    }

    // Disabled state
    if (disabled || loading) {
      baseStyle.opacity = 0.6;
    }

    // Full width
    if (fullWidth) {
      baseStyle.width = '100%';
    }

    return baseStyle;
  };

  const getTextStyle = (): TextStyle => {
    const baseTextStyle: TextStyle = {
      ...Typography.textStyles.button,
    };

    // Size variations
    if (size === 'small') {
      baseTextStyle.fontSize = Typography.fontSize.bodySmall;
    }

    // Variant text colors
    switch (variant) {
      case 'primary':
      case 'danger':
        baseTextStyle.color = Colors.neutral.white;
        break;
      case 'secondary':
        baseTextStyle.color = Colors.primary.green;
        break;
      case 'tertiary':
        baseTextStyle.color = Colors.primary.green;
        break;
    }

    return baseTextStyle;
  };

  const renderContent = () => {
    if (loading) {
      return (
        <ActivityIndicator
          size="small"
          color={variant === 'primary' || variant === 'danger' ? Colors.neutral.white : Colors.primary.green}
        />
      );
    }

    const textElement = (
      <Text style={[getTextStyle(), textStyle]} numberOfLines={1}>
        {title}
      </Text>
    );

    if (!icon) {
      return textElement;
    }

    return (
      <View style={styles.contentContainer}>
        {iconPosition === 'left' && (
          <View style={styles.iconContainer}>
            {icon}
          </View>
        )}
        {textElement}
        {iconPosition === 'right' && (
          <View style={styles.iconContainer}>
            {icon}
          </View>
        )}
      </View>
    );
  };

  return (
    <TouchableOpacity
      style={[getButtonStyle(), style]}
      onPress={onPress}
      disabled={disabled || loading}
      activeOpacity={0.8}
      testID={testID}
      accessibilityLabel={accessibilityLabel || title}
      accessibilityHint={accessibilityHint}
      accessibilityRole="button"
      accessibilityState={{ disabled: disabled || loading }}
    >
      {renderContent()}
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  contentContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  iconContainer: {
    marginHorizontal: Spacing.xs,
  },
});

export default Button;