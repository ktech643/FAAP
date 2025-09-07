/**
 * FAAP Scan App - Results Screen
 * Displays comprehensive scan results with risk assessment and recommendations
 */

import React, { useState, useEffect } from 'react';
import {
  View,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  TouchableOpacity,
  Share,
  Alert,
} from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { RouteProp } from '@react-navigation/native';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import { Dimensions } from '../../constants/dimensions';
import Button from '../../components/common/Button';
import Card from '../../components/common/Card';
import { H2, H4, BodyLarge, Body, Caption } from '../../components/common/Typography';
import RiskIndicator from '../../components/common/RiskIndicator';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { RootStackParamList, ScanResult, Ingredient, RiskLevel } from '../../types';

type ResultsScreenNavigationProp = StackNavigationProp<RootStackParamList, 'Results'>;
type ResultsScreenRouteProp = RouteProp<RootStackParamList, 'Results'>;

interface Props {
  navigation: ResultsScreenNavigationProp;
  route: ResultsScreenRouteProp;
}

// Mock ingredients data
const mockIngredients: Ingredient[] = [
  {
    id: '1',
    name: 'Sodium Benzoate',
    additiveCode: 'E211',
    category: 'preservative',
    riskLevel: 'medium',
    description: 'A preservative that can form benzene when combined with vitamin C',
    healthEffects: [
      {
        type: 'negative',
        description: 'May trigger hyperactivity in children',
        severity: 'moderate',
        affectedSystems: ['nervous'],
        studies: [],
      },
    ],
    sources: ['FDA', 'EFSA'],
    alternatives: ['Potassium Sorbate', 'Natural Vitamin E'],
  },
  {
    id: '2',
    name: 'Artificial Colors',
    additiveCode: 'E102, E129',
    category: 'colorant',
    riskLevel: 'high',
    description: 'Synthetic food dyes linked to behavioral issues',
    healthEffects: [
      {
        type: 'negative',
        description: 'Linked to ADHD and hyperactivity in children',
        severity: 'severe',
        affectedSystems: ['nervous', 'behavioral'],
        studies: [],
      },
    ],
    sources: ['FDA', 'European Food Safety Authority'],
    alternatives: ['Natural Beetroot Extract', 'Turmeric'],
  },
];

const ResultsScreen: React.FC<Props> = ({ navigation, route }) => {
  const { scanResult } = route.params;
  const [loading, setLoading] = useState(true);
  const [expandedIngredients, setExpandedIngredients] = useState<Set<string>>(new Set());
  const [savedToHistory, setSavedToHistory] = useState(false);

  useEffect(() => {
    // Simulate loading detailed analysis
    setTimeout(() => {
      setLoading(false);
    }, 1000);
  }, []);

  const handleSaveToHistory = async () => {
    setSavedToHistory(true);
    // Simulate saving to history
    setTimeout(() => {
      Alert.alert('Saved!', 'Product has been saved to your scan history.');
    }, 500);
  };

  const handleShare = async () => {
    try {
      const message = `I scanned ${scanResult.product.name} with FAAP Scan. Risk Level: ${scanResult.product.riskAssessment.overallRisk.toUpperCase()}. Score: ${scanResult.product.riskAssessment.score}/100`;
      await Share.share({
        message,
        title: 'Product Scan Results',
      });
    } catch (error) {
      console.error('Error sharing:', error);
    }
  };

  const handleFindAlternatives = () => {
    navigation.navigate('Search', { query: scanResult.product.category });
  };

  const handleViewProductDetails = () => {
    navigation.navigate('ProductDetails', { productId: scanResult.product.id });
  };

  const toggleIngredientExpansion = (ingredientId: string) => {
    const newExpanded = new Set(expandedIngredients);
    if (newExpanded.has(ingredientId)) {
      newExpanded.delete(ingredientId);
    } else {
      newExpanded.add(ingredientId);
    }
    setExpandedIngredients(newExpanded);
  };

  const getRiskColor = (riskLevel: RiskLevel) => {
    switch (riskLevel) {
      case 'high': return Colors.risk.high;
      case 'medium': return Colors.risk.medium;
      case 'low': return Colors.risk.low;
      default: return Colors.risk.unknown;
    }
  };

  const getRiskMessage = (riskLevel: RiskLevel, score: number) => {
    switch (riskLevel) {
      case 'high':
        return 'This product contains ingredients that may pose health risks. Consider alternatives.';
      case 'medium':
        return 'This product has some concerning ingredients. Use in moderation.';
      case 'low':
        return 'This product appears to be relatively safe for consumption.';
      default:
        return 'Unable to fully assess the risk level of this product.';
    }
  };

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <LoadingSpinner
          overlay
          size="large"
          message="Analyzing ingredients and health impacts..."
        />
      </SafeAreaView>
    );
  }

  const { product } = scanResult;
  const { riskAssessment } = product;

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Product Header */}
        <Card style={styles.productHeader}>
          <View style={styles.productImagePlaceholder}>
            <H4>📦</H4>
          </View>
          
          <View style={styles.productInfo}>
            <H4 numberOfLines={2}>{product.name}</H4>
            <BodyLarge color="secondary">{product.brand}</BodyLarge>
            <Body color="secondary">Category: {product.category}</Body>
          </View>

          <View style={styles.productActions}>
            <TouchableOpacity
              style={styles.actionButton}
              onPress={handleSaveToHistory}
              disabled={savedToHistory}
            >
              <Body style={[
                styles.actionButtonText,
                savedToHistory && { color: Colors.secondary.success }
              ]}>
                {savedToHistory ? '✓' : '💾'}
              </Body>
            </TouchableOpacity>
            
            <TouchableOpacity style={styles.actionButton} onPress={handleShare}>
              <Body style={styles.actionButtonText}>📤</Body>
            </TouchableOpacity>
          </View>
        </Card>

        {/* Risk Assessment Summary */}
        <Card style={styles.riskSummary}>
          <View style={styles.riskHeader}>
            <H4>Risk Assessment</H4>
            <View style={styles.riskScore}>
              <H2 style={[styles.scoreText, { color: getRiskColor(riskAssessment.overallRisk) }]}>
                {riskAssessment.score}
              </H2>
              <Caption color="secondary">/ 100</Caption>
            </View>
          </View>

          <View style={styles.riskIndicatorContainer}>
            <RiskIndicator
              riskLevel={riskAssessment.overallRisk}
              size="large"
            />
          </View>

          <BodyLarge color="secondary" style={styles.riskMessage}>
            {getRiskMessage(riskAssessment.overallRisk, riskAssessment.score)}
          </BodyLarge>

          {riskAssessment.recommendations.length > 0 && (
            <View style={styles.quickRecommendations}>
              <Body style={styles.recommendationTitle}>Quick Recommendations:</Body>
              {riskAssessment.recommendations.slice(0, 2).map((rec, index) => (
                <Body key={index} color="secondary" style={styles.recommendation}>
                  • {rec}
                </Body>
              ))}
            </View>
          )}
        </Card>

        {/* Harmful Ingredients */}
        <Card style={styles.ingredientsSection}>
          <View style={styles.sectionHeader}>
            <H4>Concerning Ingredients</H4>
            <Caption color="secondary">
              {mockIngredients.filter(ing => ing.riskLevel !== 'low').length} found
            </Caption>
          </View>

          {mockIngredients
            .filter(ingredient => ingredient.riskLevel !== 'low')
            .map((ingredient) => (
              <TouchableOpacity
                key={ingredient.id}
                style={styles.ingredientCard}
                onPress={() => toggleIngredientExpansion(ingredient.id)}
              >
                <View style={styles.ingredientHeader}>
                  <View style={styles.ingredientInfo}>
                    <BodyLarge>{ingredient.name}</BodyLarge>
                    {ingredient.additiveCode && (
                      <Body color="secondary">Code: {ingredient.additiveCode}</Body>
                    )}
                  </View>
                  
                  <View style={styles.ingredientRisk}>
                    <RiskIndicator
                      riskLevel={ingredient.riskLevel}
                      size="small"
                    />
                    <Body style={styles.expandIcon}>
                      {expandedIngredients.has(ingredient.id) ? '▼' : '▶'}
                    </Body>
                  </View>
                </View>

                {expandedIngredients.has(ingredient.id) && (
                  <View style={styles.ingredientDetails}>
                    <Body color="secondary" style={styles.ingredientDescription}>
                      {ingredient.description}
                    </Body>
                    
                    {ingredient.healthEffects.map((effect, index) => (
                      <View key={index} style={styles.healthEffect}>
                        <Body style={styles.effectDescription}>
                          ⚠️ {effect.description}
                        </Body>
                        <Caption color="secondary">
                          Severity: {effect.severity} | Systems: {effect.affectedSystems.join(', ')}
                        </Caption>
                      </View>
                    ))}

                    {ingredient.alternatives.length > 0 && (
                      <View style={styles.alternatives}>
                        <Body style={styles.alternativesTitle}>Healthier alternatives:</Body>
                        <Body color="secondary">
                          {ingredient.alternatives.join(', ')}
                        </Body>
                      </View>
                    )}
                  </View>
                )}
              </TouchableOpacity>
            ))}
        </Card>

        {/* Action Buttons */}
        <View style={styles.actionButtons}>
          <Button
            title="Find Alternatives"
            onPress={handleFindAlternatives}
            variant="primary"
            fullWidth
            style={styles.actionButton}
          />
          
          <Button
            title="View Full Product Details"
            onPress={handleViewProductDetails}
            variant="secondary"
            fullWidth
            style={styles.actionButton}
          />
        </View>

        {/* Scan Details */}
        <Card style={styles.scanDetails}>
          <H4 style={styles.sectionTitle}>Scan Details</H4>
          <View style={styles.scanInfo}>
            <View style={styles.scanInfoItem}>
              <Body color="secondary">Scanned:</Body>
              <Body>{scanResult.scannedAt.toLocaleTimeString()}</Body>
            </View>
            <View style={styles.scanInfoItem}>
              <Body color="secondary">Confidence:</Body>
              <Body>{Math.round(scanResult.confidence * 100)}%</Body>
            </View>
            <View style={styles.scanInfoItem}>
              <Body color="secondary">Processing Time:</Body>
              <Body>{scanResult.processingTime}ms</Body>
            </View>
          </View>
        </Card>

        <View style={styles.bottomSpacing} />
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
  productHeader: {
    marginHorizontal: Spacing.layout.containerPadding,
    marginTop: Spacing.md,
    flexDirection: 'row',
    alignItems: 'center',
  },
  productImagePlaceholder: {
    width: 60,
    height: 60,
    borderRadius: 8,
    backgroundColor: Colors.neutral.gray200,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: Spacing.md,
  },
  productInfo: {
    flex: 1,
  },
  productActions: {
    flexDirection: 'row',
    gap: Spacing.sm,
  },
  actionButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: Colors.alpha.primary,
    justifyContent: 'center',
    alignItems: 'center',
  },
  actionButtonText: {
    fontSize: 18,
  },
  riskSummary: {
    marginHorizontal: Spacing.layout.containerPadding,
    marginTop: Spacing.lg,
  },
  riskHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: Spacing.md,
  },
  riskScore: {
    alignItems: 'center',
  },
  scoreText: {
    fontSize: 32,
    fontWeight: '700',
  },
  riskIndicatorContainer: {
    alignItems: 'center',
    marginBottom: Spacing.md,
  },
  riskMessage: {
    textAlign: 'center',
    lineHeight: 20,
    marginBottom: Spacing.md,
  },
  quickRecommendations: {
    backgroundColor: Colors.alpha.primary,
    padding: Spacing.md,
    borderRadius: Dimensions.borderRadius.md,
  },
  recommendationTitle: {
    fontWeight: '600',
    marginBottom: Spacing.xs,
  },
  recommendation: {
    marginBottom: Spacing.xs,
    lineHeight: 18,
  },
  ingredientsSection: {
    marginHorizontal: Spacing.layout.containerPadding,
    marginTop: Spacing.lg,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: Spacing.md,
  },
  sectionTitle: {
    marginBottom: Spacing.md,
  },
  ingredientCard: {
    backgroundColor: Colors.functional.surface,
    borderRadius: Dimensions.borderRadius.md,
    padding: Spacing.md,
    marginBottom: Spacing.sm,
    borderWidth: 1,
    borderColor: Colors.neutral.gray200,
  },
  ingredientHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  ingredientInfo: {
    flex: 1,
  },
  ingredientRisk: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: Spacing.sm,
  },
  expandIcon: {
    color: Colors.neutral.gray500,
  },
  ingredientDetails: {
    marginTop: Spacing.md,
    paddingTop: Spacing.md,
    borderTopWidth: 1,
    borderTopColor: Colors.neutral.gray200,
  },
  ingredientDescription: {
    marginBottom: Spacing.sm,
    lineHeight: 18,
  },
  healthEffect: {
    marginBottom: Spacing.sm,
  },
  effectDescription: {
    marginBottom: Spacing.xs,
    lineHeight: 18,
  },
  alternatives: {
    marginTop: Spacing.sm,
    padding: Spacing.sm,
    backgroundColor: Colors.alpha.primary,
    borderRadius: Dimensions.borderRadius.sm,
  },
  alternativesTitle: {
    fontWeight: '600',
    marginBottom: Spacing.xs,
  },
  actionButtons: {
    paddingHorizontal: Spacing.layout.containerPadding,
    marginTop: Spacing.lg,
    gap: Spacing.md,
  },
  scanDetails: {
    marginHorizontal: Spacing.layout.containerPadding,
    marginTop: Spacing.lg,
  },
  scanInfo: {
    gap: Spacing.sm,
  },
  scanInfoItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  bottomSpacing: {
    height: Spacing.xl,
  },
});

export default ResultsScreen;