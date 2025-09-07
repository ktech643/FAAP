/**
 * FAAP Scan App - Main App Navigator
 * Implements the comprehensive navigation structure from the design document
 */

import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Colors } from '../constants/colors';
import { Typography } from '../constants/typography';
import { Dimensions } from '../constants/dimensions';

// Import screens
import OnboardingNavigator from './OnboardingNavigator';
import HomeScreen from '../screens/home/HomeScreen';
import ScanScreen from '../screens/scanning/ScanScreen';
import HealthDashboard from '../screens/health/HealthDashboard';
import SearchScreen from '../screens/search/SearchScreen';
import ProfileScreen from '../screens/profile/ProfileScreen';
import ResultsScreen from '../screens/results/ResultsScreen';
import ProductDetailsScreen from '../screens/results/ProductDetailsScreen';
import SettingsScreen from '../screens/settings/SettingsScreen';

// Types
import { RootStackParamList, MainTabParamList } from '../types';

const RootStack = createStackNavigator<RootStackParamList>();
const MainTab = createBottomTabNavigator<MainTabParamList>();

// Tab Bar Icon Component (placeholder for now)
const TabBarIcon = ({ name, focused }: { name: string; focused: boolean }) => {
  // This would use react-native-vector-icons in a real implementation
  return null;
};

const MainTabNavigator = () => {
  return (
    <MainTab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused }) => (
          <TabBarIcon name={route.name.toLowerCase()} focused={focused} />
        ),
        tabBarActiveTintColor: Colors.primary.green,
        tabBarInactiveTintColor: Colors.neutral.gray500,
        tabBarStyle: {
          height: Dimensions.height.tabBar,
          paddingBottom: 8,
          paddingTop: 8,
          backgroundColor: Colors.functional.surface,
          borderTopWidth: 1,
          borderTopColor: Colors.neutral.gray200,
        },
        tabBarLabelStyle: {
          ...Typography.textStyles.caption,
          fontWeight: Typography.fontWeight.medium,
        },
        headerStyle: {
          backgroundColor: Colors.functional.surface,
          shadowColor: Colors.neutral.black,
          shadowOffset: { width: 0, height: 1 },
          shadowOpacity: 0.1,
          shadowRadius: 2,
          elevation: 4,
        },
        headerTitleStyle: {
          ...Typography.textStyles.h5,
          color: Colors.functional.onSurface,
        },
      })}
    >
      <MainTab.Screen
        name="Home"
        component={HomeScreen}
        options={{
          title: 'Home',
          headerTitle: 'FAAP Scan',
        }}
      />
      <MainTab.Screen
        name="Scan"
        component={ScanScreen}
        options={{
          title: 'Scan',
          headerShown: false, // Camera screen needs full screen
        }}
      />
      <MainTab.Screen
        name="Health"
        component={HealthDashboard}
        options={{
          title: 'Health',
          headerTitle: 'Health Dashboard',
        }}
      />
      <MainTab.Screen
        name="Search"
        component={SearchScreen}
        options={{
          title: 'Search',
          headerTitle: 'Search Products',
        }}
      />
      <MainTab.Screen
        name="Profile"
        component={ProfileScreen}
        options={{
          title: 'Profile',
          headerTitle: 'My Profile',
        }}
      />
    </MainTab.Navigator>
  );
};

const AppNavigator = () => {
  // In a real app, you'd check if the user has completed onboarding
  const hasCompletedOnboarding = false;

  return (
    <NavigationContainer>
      <RootStack.Navigator
        screenOptions={{
          headerStyle: {
            backgroundColor: Colors.functional.surface,
            shadowColor: Colors.neutral.black,
            shadowOffset: { width: 0, height: 1 },
            shadowOpacity: 0.1,
            shadowRadius: 2,
            elevation: 4,
          },
          headerTitleStyle: {
            ...Typography.textStyles.h5,
            color: Colors.functional.onSurface,
          },
          headerBackTitleVisible: false,
          headerTintColor: Colors.primary.green,
        }}
      >
        {!hasCompletedOnboarding ? (
          <RootStack.Screen
            name="Onboarding"
            component={OnboardingNavigator}
            options={{ headerShown: false }}
          />
        ) : null}
        
        <RootStack.Screen
          name="Main"
          component={MainTabNavigator}
          options={{ headerShown: false }}
        />
        
        <RootStack.Screen
          name="Scanning"
          component={ScanScreen}
          options={{
            headerShown: false,
            presentation: 'fullScreenModal',
          }}
        />
        
        <RootStack.Screen
          name="Results"
          component={ResultsScreen}
          options={{
            title: 'Scan Results',
            presentation: 'card',
          }}
        />
        
        <RootStack.Screen
          name="ProductDetails"
          component={ProductDetailsScreen}
          options={{
            title: 'Product Details',
            presentation: 'card',
          }}
        />
        
        <RootStack.Screen
          name="Settings"
          component={SettingsScreen}
          options={{
            title: 'Settings',
            presentation: 'card',
          }}
        />
      </RootStack.Navigator>
    </NavigationContainer>
  );
};

export default AppNavigator;