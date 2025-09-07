/**
 * FAAP Scan App - Search Screen
 * Product and ingredient search functionality
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

const SearchScreen: React.FC = () => {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <Card style={styles.card}>
          <H4>Search Products</H4>
          <BodyLarge>Find products and ingredients</BodyLarge>
          <Body color="secondary">Search functionality will be implemented here.</Body>
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

export default SearchScreen;