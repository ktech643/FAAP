/**
 * FAAP Scan App - Health Dashboard
 * Comprehensive health tracking with data visualization
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

const HealthDashboard: React.FC = () => {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <Card style={styles.card}>
          <H4>Health Dashboard</H4>
          <BodyLarge>Your health metrics and progress tracking</BodyLarge>
          <Body color="secondary">Data visualization and health insights will be displayed here.</Body>
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

export default HealthDashboard;