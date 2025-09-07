/**
 * FAAP Scan App - Health Profile Setup Screen
 * Collects user's health information, allergies, and preferences
 */

import React, { useState } from 'react';
import {
  View,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import { Dimensions } from '../../constants/dimensions';
import Button from '../../components/common/Button';
import Card from '../../components/common/Card';
import { H2, H4, BodyLarge, Body } from '../../components/common/Typography';
import { OnboardingStackParamList, DietaryRestriction, HealthGoal } from '../../types';

type HealthProfileScreenNavigationProp = StackNavigationProp<
  OnboardingStackParamList,
  'HealthProfile'
>;

interface Props {
  navigation: HealthProfileScreenNavigationProp;
}

const DIETARY_RESTRICTIONS: { id: DietaryRestriction; label: string }[] = [
  { id: 'vegetarian', label: 'Vegetarian' },
  { id: 'vegan', label: 'Vegan' },
  { id: 'gluten-free', label: 'Gluten-Free' },
  { id: 'dairy-free', label: 'Dairy-Free' },
  { id: 'nut-free', label: 'Nut-Free' },
  { id: 'kosher', label: 'Kosher' },
  { id: 'halal', label: 'Halal' },
  { id: 'keto', label: 'Keto' },
  { id: 'paleo', label: 'Paleo' },
];

const HEALTH_GOALS: { id: HealthGoal; label: string }[] = [
  { id: 'weight-loss', label: 'Weight Loss' },
  { id: 'muscle-gain', label: 'Muscle Gain' },
  { id: 'heart-health', label: 'Heart Health' },
  { id: 'diabetes-management', label: 'Diabetes Management' },
  { id: 'general-wellness', label: 'General Wellness' },
  { id: 'energy-boost', label: 'Energy Boost' },
  { id: 'digestive-health', label: 'Digestive Health' },
];

const COMMON_ALLERGIES = [
  'Peanuts', 'Tree Nuts', 'Milk', 'Eggs', 'Wheat', 'Soy', 'Fish', 'Shellfish'
];

const HealthProfileScreen: React.FC<Props> = ({ navigation }) => {
  const [selectedDietaryRestrictions, setSelectedDietaryRestrictions] = useState<DietaryRestriction[]>([]);
  const [selectedHealthGoals, setSelectedHealthGoals] = useState<HealthGoal[]>([]);
  const [selectedAllergies, setSelectedAllergies] = useState<string[]>([]);
  const [riskTolerance, setRiskTolerance] = useState<'low' | 'medium' | 'high'>('medium');

  const toggleDietaryRestriction = (restriction: DietaryRestriction) => {
    setSelectedDietaryRestrictions(prev =>
      prev.includes(restriction)
        ? prev.filter(r => r !== restriction)
        : [...prev, restriction]
    );
  };

  const toggleHealthGoal = (goal: HealthGoal) => {
    setSelectedHealthGoals(prev =>
      prev.includes(goal)
        ? prev.filter(g => g !== goal)
        : [...prev, goal]
    );
  };

  const toggleAllergy = (allergy: string) => {
    setSelectedAllergies(prev =>
      prev.includes(allergy)
        ? prev.filter(a => a !== allergy)
        : [...prev, allergy]
    );
  };

  const handleContinue = () => {
    // Save health profile data
    const healthProfile = {
      dietaryRestrictions: selectedDietaryRestrictions,
      healthGoals: selectedHealthGoals,
      allergies: selectedAllergies,
      riskTolerance,
    };
    
    console.log('Health Profile:', healthProfile);
    navigation.navigate('Tutorial');
  };

  const renderSelectionChip = (
    label: string,
    selected: boolean,
    onPress: () => void,
    color: string = Colors.primary.green
  ) => (
    <TouchableOpacity
      key={label}
      style={[
        styles.chip,
        selected && { ...styles.chipSelected, backgroundColor: color }
      ]}
      onPress={onPress}
    >
      <Body style={[
        styles.chipText,
        selected && { color: Colors.neutral.white }
      ]}>
        {label}
      </Body>
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        <View style={styles.content}>
          <View style={styles.header}>
            <H2 style={styles.title}>Health Profile</H2>
            <BodyLarge color="secondary" style={styles.subtitle}>
              Help us personalize your food analysis
            </BodyLarge>
          </View>

          {/* Dietary Restrictions */}
          <Card style={styles.section}>
            <H4 style={styles.sectionTitle}>Dietary Restrictions</H4>
            <Body color="secondary" style={styles.sectionDescription}>
              Select any dietary restrictions you follow
            </Body>
            <View style={styles.chipContainer}>
              {DIETARY_RESTRICTIONS.map(restriction =>
                renderSelectionChip(
                  restriction.label,
                  selectedDietaryRestrictions.includes(restriction.id),
                  () => toggleDietaryRestriction(restriction.id)
                )
              )}
            </View>
          </Card>

          {/* Health Goals */}
          <Card style={styles.section}>
            <H4 style={styles.sectionTitle}>Health Goals</H4>
            <Body color="secondary" style={styles.sectionDescription}>
              What are your main health objectives?
            </Body>
            <View style={styles.chipContainer}>
              {HEALTH_GOALS.map(goal =>
                renderSelectionChip(
                  goal.label,
                  selectedHealthGoals.includes(goal.id),
                  () => toggleHealthGoal(goal.id),
                  Colors.primary.blue
                )
              )}
            </View>
          </Card>

          {/* Allergies */}
          <Card style={styles.section}>
            <H4 style={styles.sectionTitle}>Food Allergies</H4>
            <Body color="secondary" style={styles.sectionDescription}>
              Select any food allergies you have
            </Body>
            <View style={styles.chipContainer}>
              {COMMON_ALLERGIES.map(allergy =>
                renderSelectionChip(
                  allergy,
                  selectedAllergies.includes(allergy),
                  () => toggleAllergy(allergy),
                  Colors.primary.red
                )
              )}
            </View>
          </Card>

          {/* Risk Tolerance */}
          <Card style={styles.section}>
            <H4 style={styles.sectionTitle}>Risk Tolerance</H4>
            <Body color="secondary" style={styles.sectionDescription}>
              How cautious do you want to be about food additives?
            </Body>
            <View style={styles.riskToleranceContainer}>
              {[
                { id: 'low', label: 'Very Cautious', description: 'Alert me about any potential risks' },
                { id: 'medium', label: 'Balanced', description: 'Focus on moderate to high risks' },
                { id: 'high', label: 'Relaxed', description: 'Only alert about serious risks' },
              ].map(option => (
                <TouchableOpacity
                  key={option.id}
                  style={[
                    styles.riskOption,
                    riskTolerance === option.id && styles.riskOptionSelected
                  ]}
                  onPress={() => setRiskTolerance(option.id as any)}
                >
                  <View style={styles.riskOptionContent}>
                    <BodyLarge style={styles.riskOptionLabel}>
                      {option.label}
                    </BodyLarge>
                    <Body color="secondary" style={styles.riskOptionDescription}>
                      {option.description}
                    </Body>
                  </View>
                  <View style={[
                    styles.radioButton,
                    riskTolerance === option.id && styles.radioButtonSelected
                  ]} />
                </TouchableOpacity>
              ))}
            </View>
          </Card>
        </View>
      </ScrollView>

      <View style={styles.footer}>
        <Button
          title="Continue"
          onPress={handleContinue}
          variant="primary"
          size="large"
          fullWidth
          testID="health-profile-continue-button"
        />
        
        <Button
          title="Skip for Now"
          onPress={handleContinue}
          variant="tertiary"
          size="medium"
          fullWidth
          style={styles.skipButton}
        />
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.functional.background,
  },
  scrollView: {
    flex: 1,
  },
  content: {
    paddingHorizontal: Spacing.layout.containerPadding,
  },
  header: {
    paddingVertical: Spacing.xl,
    alignItems: 'center',
  },
  title: {
    marginBottom: Spacing.sm,
    textAlign: 'center',
  },
  subtitle: {
    textAlign: 'center',
  },
  section: {
    marginBottom: Spacing.lg,
  },
  sectionTitle: {
    marginBottom: Spacing.xs,
  },
  sectionDescription: {
    marginBottom: Spacing.md,
    lineHeight: 20,
  },
  chipContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: Spacing.sm,
  },
  chip: {
    paddingHorizontal: Spacing.md,
    paddingVertical: Spacing.sm,
    borderRadius: Dimensions.borderRadius.full,
    backgroundColor: Colors.neutral.gray100,
    borderWidth: 1,
    borderColor: Colors.neutral.gray300,
  },
  chipSelected: {
    borderColor: 'transparent',
  },
  chipText: {
    textAlign: 'center',
  },
  riskToleranceContainer: {
    gap: Spacing.sm,
  },
  riskOption: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: Spacing.md,
    borderRadius: Dimensions.borderRadius.md,
    borderWidth: 1,
    borderColor: Colors.neutral.gray300,
    backgroundColor: Colors.functional.surface,
  },
  riskOptionSelected: {
    borderColor: Colors.primary.green,
    backgroundColor: Colors.alpha.primary,
  },
  riskOptionContent: {
    flex: 1,
  },
  riskOptionLabel: {
    marginBottom: Spacing.xs,
  },
  riskOptionDescription: {
    lineHeight: 18,
  },
  radioButton: {
    width: 20,
    height: 20,
    borderRadius: 10,
    borderWidth: 2,
    borderColor: Colors.neutral.gray400,
    backgroundColor: Colors.functional.surface,
  },
  radioButtonSelected: {
    borderColor: Colors.primary.green,
    backgroundColor: Colors.primary.green,
  },
  footer: {
    paddingHorizontal: Spacing.layout.containerPadding,
    paddingVertical: Spacing.lg,
    backgroundColor: Colors.functional.surface,
    borderTopWidth: 1,
    borderTopColor: Colors.neutral.gray200,
  },
  skipButton: {
    marginTop: Spacing.md,
  },
});

export default HealthProfileScreen;