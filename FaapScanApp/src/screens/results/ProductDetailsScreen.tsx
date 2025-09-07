/**
 * FAAP Scan App - Product Details Screen
 * Detailed product information with comprehensive analysis
 */

import React from 'react';
import {
  View,
  StyleSheet,
  SafeAreaView,
  ScrollView,
} from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { RouteProp } from '@react-navigation/native';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import Card from '../../components/common/Card';
import { H4, BodyLarge, Body } from '../../components/common/Typography';
import { RootStackParamList } from '../../types';

type ProductDetailsScreenNavigationProp = StackNavigationProp<RootStackParamList, 'ProductDetails'>;
type ProductDetailsScreenRouteProp = RouteProp<RootStackParamList, 'ProductDetails'>;

interface Props {
  navigation: ProductDetailsScreenNavigationProp;
  route: ProductDetailsScreenRouteProp;
}

const ProductDetailsScreen: React.FC<Props> = ({ navigation, route }) => {
  const { productId } = route.params;

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <Card style={styles.card}>
          <H4>Product Details</H4>
          <BodyLarge>Product ID: {productId}</BodyLarge>
          <Body color="secondary">Detailed product information will be displayed here.</Body>
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

export default ProductDetailsScreen;