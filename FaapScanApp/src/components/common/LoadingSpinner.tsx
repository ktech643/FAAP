/**
 * FAAP Scan App - Loading Spinner Component
 * Advanced loading states with animations
 */

import React from 'react';
import {
  View,
  ActivityIndicator,
  StyleSheet,
  ViewStyle,
} from 'react-native';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import Typography from './Typography';

export interface LoadingSpinnerProps {
  size?: 'small' | 'medium' | 'large';
  color?: string;
  message?: string;
  overlay?: boolean;
  style?: ViewStyle;
  testID?: string;
}

const LoadingSpinner: React.FC<LoadingSpinnerProps> = ({
  size = 'medium',
  color = Colors.primary.green,
  message,
  overlay = false,
  style,
  testID,
}) => {
  const getSpinnerSize = () => {
    switch (size) {
      case 'small':
        return 'small' as const;
      case 'large':
        return 'large' as const;
      default:
        return 'small' as const;
    }
  };

  const containerStyle: ViewStyle = overlay
    ? [styles.overlay, style]
    : [styles.container, style];

  return (
    <View
      style={containerStyle}
      testID={testID}
      accessibilityLabel={message || 'Loading'}
      accessibilityRole="progressbar"
    >
      <View style={styles.content}>
        <ActivityIndicator
          size={getSpinnerSize()}
          color={color}
        />
        {message && (
          <Typography
            variant="body"
            color="secondary"
            style={styles.message}
          >
            {message}
          </Typography>
        )}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    alignItems: 'center',
    padding: Spacing.md,
  },
  overlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: Colors.alpha.white90,
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1000,
  },
  content: {
    alignItems: 'center',
  },
  message: {
    marginTop: Spacing.sm,
    textAlign: 'center',
  },
});

export default LoadingSpinner;