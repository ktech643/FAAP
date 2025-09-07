/**
 * FAAP Scan App - Settings Screen
 * App settings and preferences
 */

import React from 'react';
import {
  View,
  StyleSheet,
  SafeAreaView,
  ScrollView,
} from 'react-native';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import Card from '../../components/common/Card';
import { H4, BodyLarge, Body } from '../../components/common/Typography';

const SettingsScreen: React.FC = () => {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <Card style={styles.card}>
          <H4>Settings</H4>
          <BodyLarge>App preferences and configuration</BodyLarge>
          <Body color="secondary">Settings and preferences will be configured here.</Body>
        </Card>
      </ScrollView>
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
  card: {
    margin: Spacing.layout.containerPadding,
  },
});

export default SettingsScreen;