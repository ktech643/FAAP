/**
 * FAAP Scan App - Tutorial Screen
 * Interactive tutorial showing how to use the scanning feature
 */

import React, { useState, useRef } from 'react';
import {
  View,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  Dimensions as RNDimensions,
  Animated,
} from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import { Dimensions } from '../../constants/dimensions';
import Button from '../../components/common/Button';
import { H2, H4, BodyLarge, Body } from '../../components/common/Typography';
import { OnboardingStackParamList } from '../../types';

type TutorialScreenNavigationProp = StackNavigationProp<
  OnboardingStackParamList,
  'Tutorial'
>;

interface Props {
  navigation: TutorialScreenNavigationProp;
}

const { width: screenWidth } = RNDimensions.get('window');

interface TutorialStep {
  id: number;
  title: string;
  description: string;
  illustration: string;
}

const TUTORIAL_STEPS: TutorialStep[] = [
  {
    id: 1,
    title: 'Point Your Camera',
    description: 'Simply point your camera at any product barcode. The app will automatically detect and focus on it.',
    illustration: '📱',
  },
  {
    id: 2,
    title: 'Instant Analysis',
    description: 'Our AI analyzes the product ingredients in seconds, identifying harmful additives and their risks.',
    illustration: '🔍',
  },
  {
    id: 3,
    title: 'Get Recommendations',
    description: 'Receive personalized health insights and find healthier alternatives based on your profile.',
    illustration: '💡',
  },
  {
    id: 4,
    title: 'Track Your Health',
    description: 'Monitor your progress over time and see how your food choices impact your health goals.',
    illustration: '📊',
  },
];

const TutorialScreen: React.FC<Props> = ({ navigation }) => {
  const [currentStep, setCurrentStep] = useState(0);
  const scrollViewRef = useRef<ScrollView>(null);
  const fadeAnim = useRef(new Animated.Value(1)).current;

  const handleNext = () => {
    if (currentStep < TUTORIAL_STEPS.length - 1) {
      // Fade out current step
      Animated.timing(fadeAnim, {
        toValue: 0,
        duration: 200,
        useNativeDriver: true,
      }).start(() => {
        setCurrentStep(currentStep + 1);
        scrollViewRef.current?.scrollTo({
          x: (currentStep + 1) * screenWidth,
          animated: false,
        });
        
        // Fade in new step
        Animated.timing(fadeAnim, {
          toValue: 1,
          duration: 200,
          useNativeDriver: true,
        }).start();
      });
    } else {
      handleFinish();
    }
  };

  const handlePrevious = () => {
    if (currentStep > 0) {
      Animated.timing(fadeAnim, {
        toValue: 0,
        duration: 200,
        useNativeDriver: true,
      }).start(() => {
        setCurrentStep(currentStep - 1);
        scrollViewRef.current?.scrollTo({
          x: (currentStep - 1) * screenWidth,
          animated: false,
        });
        
        Animated.timing(fadeAnim, {
          toValue: 1,
          duration: 200,
          useNativeDriver: true,
        }).start();
      });
    }
  };

  const handleFinish = () => {
    navigation.navigate('Complete');
  };

  const handleSkip = () => {
    navigation.navigate('Complete');
  };

  const currentStepData = TUTORIAL_STEPS[currentStep];

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        {/* Header */}
        <View style={styles.header}>
          <H2 style={styles.title}>How to Use FAAP Scan</H2>
          <View style={styles.progressContainer}>
            {TUTORIAL_STEPS.map((_, index) => (
              <View
                key={index}
                style={[
                  styles.progressDot,
                  index === currentStep && styles.progressDotActive,
                  index < currentStep && styles.progressDotCompleted,
                ]}
              />
            ))}
          </View>
        </View>

        {/* Tutorial Content */}
        <Animated.View style={[styles.tutorialContent, { opacity: fadeAnim }]}>
          <View style={styles.illustrationContainer}>
            <View style={styles.illustration}>
              <H2 style={styles.illustrationEmoji}>
                {currentStepData.illustration}
              </H2>
            </View>
          </View>

          <View style={styles.textContent}>
            <H4 style={styles.stepTitle}>{currentStepData.title}</H4>
            <BodyLarge color="secondary" style={styles.stepDescription}>
              {currentStepData.description}
            </BodyLarge>
          </View>

          {/* Interactive Demo Area */}
          <View style={styles.demoArea}>
            {currentStep === 0 && (
              <View style={styles.cameraDemo}>
                <View style={styles.cameraMockup}>
                  <View style={styles.barcodeFrame} />
                  <Body color="secondary" style={styles.demoText}>
                    Barcode scanning area
                  </Body>
                </View>
              </View>
            )}

            {currentStep === 1 && (
              <View style={styles.analysisDemo}>
                <View style={styles.analysisCard}>
                  <View style={styles.loadingBars}>
                    {[1, 2, 3].map(i => (
                      <View key={i} style={styles.loadingBar} />
                    ))}
                  </View>
                  <Body style={styles.demoText}>Analyzing ingredients...</Body>
                </View>
              </View>
            )}

            {currentStep === 2 && (
              <View style={styles.recommendationsDemo}>
                <View style={styles.riskCard}>
                  <View style={[styles.riskIndicator, { backgroundColor: Colors.risk.medium }]} />
                  <Body style={styles.demoText}>Medium Risk Detected</Body>
                </View>
                <View style={styles.alternativeCard}>
                  <Body style={styles.demoText}>✅ Healthier Alternative Found</Body>
                </View>
              </View>
            )}

            {currentStep === 3 && (
              <View style={styles.trackingDemo}>
                <View style={styles.chartMockup}>
                  <View style={styles.chartBars}>
                    {[0.3, 0.7, 0.5, 0.9, 0.4].map((height, i) => (
                      <View
                        key={i}
                        style={[
                          styles.chartBar,
                          { height: `${height * 100}%` }
                        ]}
                      />
                    ))}
                  </View>
                  <Body color="secondary" style={styles.demoText}>
                    Weekly Health Progress
                  </Body>
                </View>
              </View>
            )}
          </View>
        </Animated.View>

        {/* Navigation */}
        <View style={styles.navigation}>
          <View style={styles.navigationButtons}>
            {currentStep > 0 && (
              <Button
                title="Previous"
                onPress={handlePrevious}
                variant="tertiary"
                size="medium"
              />
            )}
            
            <View style={styles.spacer} />
            
            <Button
              title="Skip"
              onPress={handleSkip}
              variant="tertiary"
              size="medium"
            />
            
            <Button
              title={currentStep === TUTORIAL_STEPS.length - 1 ? "Get Started" : "Next"}
              onPress={handleNext}
              variant="primary"
              size="medium"
              testID="tutorial-next-button"
            />
          </View>
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
  },
  header: {
    paddingVertical: Spacing.xl,
    alignItems: 'center',
  },
  title: {
    marginBottom: Spacing.lg,
    textAlign: 'center',
  },
  progressContainer: {
    flexDirection: 'row',
    gap: Spacing.sm,
  },
  progressDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: Colors.neutral.gray300,
  },
  progressDotActive: {
    backgroundColor: Colors.primary.green,
    width: 24,
  },
  progressDotCompleted: {
    backgroundColor: Colors.primary.green,
  },
  tutorialContent: {
    flex: 1,
    justifyContent: 'center',
  },
  illustrationContainer: {
    alignItems: 'center',
    marginBottom: Spacing.xl,
  },
  illustration: {
    width: 120,
    height: 120,
    borderRadius: 60,
    backgroundColor: Colors.alpha.primary,
    justifyContent: 'center',
    alignItems: 'center',
  },
  illustrationEmoji: {
    fontSize: 48,
  },
  textContent: {
    alignItems: 'center',
    marginBottom: Spacing.xl,
  },
  stepTitle: {
    marginBottom: Spacing.sm,
    textAlign: 'center',
  },
  stepDescription: {
    textAlign: 'center',
    lineHeight: 22,
    paddingHorizontal: Spacing.md,
  },
  demoArea: {
    alignItems: 'center',
    minHeight: 120,
  },
  cameraDemo: {
    alignItems: 'center',
  },
  cameraMockup: {
    width: 200,
    height: 120,
    backgroundColor: Colors.neutral.gray900,
    borderRadius: Dimensions.borderRadius.md,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  barcodeFrame: {
    width: 100,
    height: 60,
    borderWidth: 2,
    borderColor: Colors.primary.green,
    borderRadius: Dimensions.borderRadius.sm,
    marginBottom: Spacing.sm,
  },
  demoText: {
    textAlign: 'center',
    fontSize: 12,
  },
  analysisDemo: {
    alignItems: 'center',
  },
  analysisCard: {
    padding: Spacing.lg,
    backgroundColor: Colors.functional.surface,
    borderRadius: Dimensions.borderRadius.lg,
    alignItems: 'center',
    ...Dimensions.shadow.md,
  },
  loadingBars: {
    flexDirection: 'row',
    gap: Spacing.xs,
    marginBottom: Spacing.sm,
  },
  loadingBar: {
    width: 40,
    height: 4,
    backgroundColor: Colors.primary.green,
    borderRadius: 2,
  },
  recommendationsDemo: {
    alignItems: 'center',
    gap: Spacing.md,
  },
  riskCard: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: Spacing.md,
    backgroundColor: Colors.functional.surface,
    borderRadius: Dimensions.borderRadius.md,
    ...Dimensions.shadow.sm,
  },
  riskIndicator: {
    width: 12,
    height: 12,
    borderRadius: 6,
    marginRight: Spacing.sm,
  },
  alternativeCard: {
    padding: Spacing.md,
    backgroundColor: Colors.alpha.primary,
    borderRadius: Dimensions.borderRadius.md,
  },
  trackingDemo: {
    alignItems: 'center',
  },
  chartMockup: {
    padding: Spacing.lg,
    backgroundColor: Colors.functional.surface,
    borderRadius: Dimensions.borderRadius.lg,
    alignItems: 'center',
    ...Dimensions.shadow.md,
  },
  chartBars: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    height: 60,
    gap: Spacing.xs,
    marginBottom: Spacing.sm,
  },
  chartBar: {
    width: 8,
    backgroundColor: Colors.primary.green,
    borderRadius: 2,
  },
  navigation: {
    paddingVertical: Spacing.lg,
  },
  navigationButtons: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: Spacing.md,
  },
  spacer: {
    flex: 1,
  },
});

export default TutorialScreen;