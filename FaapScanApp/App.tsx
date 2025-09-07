/**
 * FAAP Scan App - Main Application Component
 * Advanced food additive analysis and scanning application
 */

import React from 'react';
import { StatusBar } from 'react-native';
import AppNavigator from './src/navigation/AppNavigator';
import { Colors } from './src/constants/colors';

const App: React.FC = () => {
  return (
    <>
      <StatusBar
        barStyle="dark-content"
        backgroundColor={Colors.functional.surface}
        translucent={false}
      />
      <AppNavigator />
    </>
  );
};

export default App;