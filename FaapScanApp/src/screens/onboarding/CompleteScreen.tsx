/**
 * FAAP Scan App - Onboarding Complete Screen
 * Congratulations screen that transitions to the main app
 */

import React, { useEffect, useRef } from 'react';
import {
  View,
  StyleSheet,
  SafeAreaView,
  Animated,
} from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import { Dimensions } from '../../constants/dimensions';
import Button from '../../components/common/Button';
import { H1, H2, BodyLarge } from '../../components/common/Typography';
import { OnboardingStackParamList } from '../../types';

type CompleteScreenNavigationProp = StackNavigationProp<
  OnboardingStackParamList,
  'Complete'
>;

interface Props {
  navigation: CompleteScreenNavigationProp;
}

const CompleteScreen: React.FC<Props> = ({ navigation }) => {
  const fadeAnim = useRef(new Animated.Value(0)).current;
  const scaleAnim = useRef(new Animated.Value(0.8)).current;
  const slideAnim = useRef(new Animated.Value(50)).current;

  useEffect(() => {
    // Animate entrance
    Animated.parallel([
      Animated.timing(fadeAnim, {
        toValue: 1,
        duration: 800,
        useNativeDriver: true,
      }),
      Animated.spring(scaleAnim, {
        toValue: 1,
        tension: 50,
        friction: 7,
        useNativeDriver: true,
      }),
      Animated.timing(slideAnim, {
        toValue: 0,
        duration: 600,
        delay: 200,
        useNativeDriver: true,
      }),
    ]).start();
  }, []);

  const handleGetStarted = () => {
    // Navigate to main app
    // In a real app, you'd update the onboarding completion status
    navigation.reset({
      index: 0,
      routes: [{ name: 'Main' as any }],
    });
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        {/* Success Animation */}
        <Animated.View
          style={[
            styles.successContainer,
            {
              opacity: fadeAnim,
              transform: [{ scale: scaleAnim }],
            },
          ]}
        >
          <View style={styles.successIcon}>
            <H1 style={styles.checkmark}>✓</H1>
          </View>
          
          <View style={styles.confetti}>
            {[...Array(8)].map((_, i) => (
              <Animated.View
                key={i}
                style={[
                  styles.confettiPiece,
                  {
                    backgroundColor: [
                      Colors.primary.green,
                      Colors.primary.blue,
                      Colors.secondary.warning,
                      Colors.secondary.success,
                    ][i % 4],
                    transform: [
                      { rotate: `${i * 45}deg` },
                      { scale: fadeAnim },
                    ],
                  },
                ]}
              />
            ))}
          </View>
        </Animated.View>

        {/* Content */}
        <Animated.View
          style={[
            styles.textContent,
            {
              opacity: fadeAnim,
              transform: [{ translateY: slideAnim }],
            },
          ]}
        >
          <H1 style={styles.title}>You're All Set!</H1>
          <H2 color="secondary" style={styles.subtitle}>
            Welcome to FAAP Scan
          </H2>
          
          <BodyLarge color="secondary" style={styles.description}>
            Your personalized food scanner is ready to help you make healthier choices. 
            Start scanning products to discover what's really in your food.
          </BodyLarge>

          {/* Key Features Reminder */}
          <View style={styles.featuresContainer}>
            <View style={styles.feature}>
              <View style={[styles.featureIcon, { backgroundColor: Colors.primary.green }]} />
              <BodyLarge style={styles.featureText}>Instant barcode scanning</BodyLarge>
            </View>
            
            <View style={styles.feature}>
              <View style={[styles.featureIcon, { backgroundColor: Colors.primary.blue }]} />
              <BodyLarge style={styles.featureText}>Personalized health insights</BodyLarge>
            </View>
            
            <View style={styles.feature}>
              <View style={[styles.featureIcon, { backgroundColor: Colors.secondary.warning }]} />
              <BodyLarge style={styles.featureText}>Progress tracking</BodyLarge>
            </View>
          </View>
        </Animated.View>

        {/* Call to Action */}
        <Animated.View
          style={[
            styles.actionContainer,
            {
              opacity: fadeAnim,
              transform: [{ translateY: slideAnim }],
            },
          ]}
        >
          <Button
            title="Start Scanning"
            onPress={handleGetStarted}
            variant="primary"
            size="large"
            fullWidth
            testID="complete-start-scanning-button"
          />
          
          <BodyLarge color="secondary" style={styles.footerText}>
            Ready to discover what's in your food?
          </BodyLarge>
        </Animated.View>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.functional.background,
  },
  content: {
    flex: 1,
    paddingHorizontal: Spacing.layout.containerPadding,
    paddingVertical: Spacing.layout.sectionMargin,
    justifyContent: 'space-between',
  },
  successContainer: {
    flex: 2,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  successIcon: {
    width: 120,
    height: 120,
    borderRadius: 60,
    backgroundColor: Colors.primary.green,
    justifyContent: 'center',
    alignItems: 'center',
    ...Dimensions.shadow.lg,
  },
  checkmark: {
    color: Colors.neutral.white,
    fontSize: 48,
  },
  confetti: {
    position: 'absolute',
    width: 200,
    height: 200,
  },
  confettiPiece: {
    position: 'absolute',
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  textContent: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    textAlign: 'center',
    marginBottom: Spacing.sm,
  },
  subtitle: {
    textAlign: 'center',
    marginBottom: Spacing.lg,
  },
  description: {
    textAlign: 'center',
    lineHeight: 22,
    marginBottom: Spacing.xl,
    paddingHorizontal: Spacing.md,
  },
  featuresContainer: {
    width: '100%',
    gap: Spacing.md,
  },
  feature: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: Spacing.sm,
  },
  featureIcon: {
    width: 24,
    height: 24,
    borderRadius: 12,
    marginRight: Spacing.md,
  },
  featureText: {
    flex: 1,
  },
  actionContainer: {
    paddingTop: Spacing.xl,
  },
  footerText: {
    textAlign: 'center',
    marginTop: Spacing.md,
  },
});

export default CompleteScreen;