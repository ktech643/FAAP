/**
 * FAAP Scan App - Profile Screen
 * User profile and scan history
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

const ProfileScreen: React.FC = () => {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <Card style={styles.card}>
          <H4>My Profile</H4>
          <BodyLarge>User profile and scan history</BodyLarge>
          <Body color="secondary">Profile information and scan history will be displayed here.</Body>
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

export default ProfileScreen;