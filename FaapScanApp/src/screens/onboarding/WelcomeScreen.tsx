/**
 * FAAP Scan App - Welcome Screen
 * First screen in the onboarding flow with brand identity and value proposition
 */

import React from 'react';
import {
  View,
  StyleSheet,
  Image,
  SafeAreaView,
  Dimensions as RNDimensions,
} from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import { Dimensions } from '../../constants/dimensions';
import Button from '../../components/common/Button';
import { H1, H2, BodyLarge } from '../../components/common/Typography';
import { OnboardingStackParamList } from '../../types';

type WelcomeScreenNavigationProp = StackNavigationProp<
  OnboardingStackParamList,
  'Welcome'
>;

interface Props {
  navigation: WelcomeScreenNavigationProp;
}

const { width: screenWidth, height: screenHeight } = RNDimensions.get('window');

const WelcomeScreen: React.FC<Props> = ({ navigation }) => {
  const handleGetStarted = () => {
    navigation.navigate('Permissions');
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        {/* Hero Section */}
        <View style={styles.heroSection}>
          <View style={styles.logoContainer}>
            {/* Placeholder for app logo */}
            <View style={styles.logoPlaceholder}>
              <H1 color="success">FAAP</H1>
              <BodyLarge color="secondary">SCAN</BodyLarge>
            </View>
          </View>
          
          <View style={styles.titleContainer}>
            <H1 style={styles.title}>
              Know What You're Eating
            </H1>
            <H2 color="secondary" style={styles.subtitle}>
              Scan. Analyze. Stay Healthy.
            </H2>
          </View>
        </View>

        {/* Value Proposition */}
        <View style={styles.featuresSection}>
          <View style={styles.feature}>
            <View style={styles.featureIcon}>
              <View style={[styles.iconPlaceholder, { backgroundColor: Colors.primary.green }]} />
            </View>
            <BodyLarge style={styles.featureText}>
              Instantly identify harmful additives in your food
            </BodyLarge>
          </View>

          <View style={styles.feature}>
            <View style={styles.featureIcon}>
              <View style={[styles.iconPlaceholder, { backgroundColor: Colors.primary.blue }]} />
            </View>
            <BodyLarge style={styles.featureText}>
              Get personalized health recommendations
            </BodyLarge>
          </View>

          <View style={styles.feature}>
            <View style={styles.featureIcon}>
              <View style={[styles.iconPlaceholder, { backgroundColor: Colors.secondary.warning }]} />
            </View>
            <BodyLarge style={styles.featureText}>
              Track your health progress over time
            </BodyLarge>
          </View>
        </View>

        {/* Call to Action */}
        <View style={styles.actionSection}>
          <Button
            title="Get Started"
            onPress={handleGetStarted}
            variant="primary"
            size="large"
            fullWidth
            testID="welcome-get-started-button"
          />
          
          <BodyLarge color="secondary" style={styles.disclaimer}>
            Free to use • No ads • Privacy focused
          </BodyLarge>
        </View>
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
  },
  heroSection: {
    flex: 2,
    justifyContent: 'center',
    alignItems: 'center',
  },
  logoContainer: {
    marginBottom: Spacing.xl,
  },
  logoPlaceholder: {
    alignItems: 'center',
    padding: Spacing.lg,
    borderRadius: Dimensions.borderRadius.xl,
    backgroundColor: Colors.alpha.primary,
  },
  titleContainer: {
    alignItems: 'center',
  },
  title: {
    textAlign: 'center',
    marginBottom: Spacing.sm,
  },
  subtitle: {
    textAlign: 'center',
  },
  featuresSection: {
    flex: 1,
    justifyContent: 'space-around',
    paddingVertical: Spacing.xl,
  },
  feature: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: Spacing.sm,
  },
  featureIcon: {
    marginRight: Spacing.md,
  },
  iconPlaceholder: {
    width: 48,
    height: 48,
    borderRadius: 24,
  },
  featureText: {
    flex: 1,
  },
  actionSection: {
    paddingTop: Spacing.lg,
  },
  disclaimer: {
    textAlign: 'center',
    marginTop: Spacing.md,
  },
});

export default WelcomeScreen;