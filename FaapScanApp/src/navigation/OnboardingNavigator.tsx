/**
 * FAAP Scan App - Onboarding Navigator
 * Implements the 5-screen onboarding flow from the design document
 */

import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import { Colors } from '../constants/colors';
import { Typography } from '../constants/typography';

// Import onboarding screens
import WelcomeScreen from '../screens/onboarding/WelcomeScreen';
import PermissionsScreen from '../screens/onboarding/PermissionsScreen';
import HealthProfileScreen from '../screens/onboarding/HealthProfileScreen';
import TutorialScreen from '../screens/onboarding/TutorialScreen';
import CompleteScreen from '../screens/onboarding/CompleteScreen';

// Types
import { OnboardingStackParamList } from '../types';

const OnboardingStack = createStackNavigator<OnboardingStackParamList>();

const OnboardingNavigator = () => {
  return (
    <OnboardingStack.Navigator
      screenOptions={{
        headerStyle: {
          backgroundColor: Colors.functional.surface,
          shadowOpacity: 0,
          elevation: 0,
        },
        headerTitleStyle: {
          ...Typography.textStyles.h5,
          color: Colors.functional.onSurface,
        },
        headerBackTitleVisible: false,
        headerTintColor: Colors.primary.green,
        gestureEnabled: false, // Prevent swiping back during onboarding
      }}
    >
      <OnboardingStack.Screen
        name="Welcome"
        component={WelcomeScreen}
        options={{
          headerShown: false,
        }}
      />
      
      <OnboardingStack.Screen
        name="Permissions"
        component={PermissionsScreen}
        options={{
          title: 'Permissions',
          headerLeft: () => null, // Remove back button
        }}
      />
      
      <OnboardingStack.Screen
        name="HealthProfile"
        component={HealthProfileScreen}
        options={{
          title: 'Health Profile',
        }}
      />
      
      <OnboardingStack.Screen
        name="Tutorial"
        component={TutorialScreen}
        options={{
          title: 'How to Scan',
        }}
      />
      
      <OnboardingStack.Screen
        name="Complete"
        component={CompleteScreen}
        options={{
          headerShown: false,
        }}
      />
    </OnboardingStack.Navigator>
  );
};

export default OnboardingNavigator;