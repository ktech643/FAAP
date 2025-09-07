/**
 * FAAP Scan App - Risk Indicator Component
 * Displays risk levels with appropriate colors and styling
 */

import React from 'react';
import {
  View,
  StyleSheet,
  ViewStyle,
} from 'react-native';
import { Colors } from '../../constants/colors';
import { Dimensions } from '../../constants/dimensions';
import { Spacing } from '../../constants/spacing';
import Typography from './Typography';
import { RiskLevel } from '../../types';

export interface RiskIndicatorProps {
  riskLevel: RiskLevel;
  size?: 'small' | 'medium' | 'large';
  showText?: boolean;
  style?: ViewStyle;
  testID?: string;
}

const RiskIndicator: React.FC<RiskIndicatorProps> = ({
  riskLevel,
  size = 'medium',
  showText = true,
  style,
  testID,
}) => {
  const getRiskConfig = () => {
    switch (riskLevel) {
      case 'high':
        return {
          color: Colors.risk.high,
          text: 'High Risk',
          accessibilityLabel: 'High risk ingredient',
        };
      case 'medium':
        return {
          color: Colors.risk.medium,
          text: 'Medium Risk',
          accessibilityLabel: 'Medium risk ingredient',
        };
      case 'low':
        return {
          color: Colors.risk.low,
          text: 'Low Risk',
          accessibilityLabel: 'Low risk ingredient',
        };
      case 'unknown':
        return {
          color: Colors.risk.unknown,
          text: 'Unknown',
          accessibilityLabel: 'Unknown risk level',
        };
      default:
        return {
          color: Colors.risk.unknown,
          text: 'Unknown',
          accessibilityLabel: 'Unknown risk level',
        };
    }
  };

  const getSizeConfig = () => {
    switch (size) {
      case 'small':
        return {
          padding: Spacing.xs,
          borderRadius: Dimensions.borderRadius.xs,
          textVariant: 'caption' as const,
        };
      case 'large':
        return {
          padding: Spacing.md,
          borderRadius: Dimensions.borderRadius.md,
          textVariant: 'bodyLarge' as const,
        };
      default:
        return {
          padding: Spacing.sm,
          borderRadius: Dimensions.borderRadius.sm,
          textVariant: 'bodySmall' as const,
        };
    }
  };

  const riskConfig = getRiskConfig();
  const sizeConfig = getSizeConfig();

  const containerStyle: ViewStyle = {
    backgroundColor: riskConfig.color,
    paddingHorizontal: sizeConfig.padding,
    paddingVertical: sizeConfig.padding / 2,
    borderRadius: sizeConfig.borderRadius,
    alignSelf: 'flex-start',
    flexDirection: 'row',
    alignItems: 'center',
  };

  return (
    <View
      style={[containerStyle, style]}
      testID={testID}
      accessibilityLabel={riskConfig.accessibilityLabel}
      accessibilityRole="text"
    >
      {!showText && (
        <View style={[styles.dot, { backgroundColor: Colors.neutral.white }]} />
      )}
      {showText && (
        <Typography
          variant={sizeConfig.textVariant}
          style={styles.text}
        >
          {riskConfig.text}
        </Typography>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  text: {
    color: Colors.neutral.white,
    fontWeight: '600',
  },
});

export default RiskIndicator;