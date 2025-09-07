/**
 * FAAP Scan App - Home Screen
 * Main dashboard with quick scan, recent scans, health score, and recommendations
 */

import React, { useState, useEffect } from 'react';
import {
  View,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  TouchableOpacity,
  RefreshControl,
} from 'react-native';
import { BottomTabNavigationProp } from '@react-navigation/bottom-tabs';
import { CompositeNavigationProp } from '@react-navigation/native';
import { StackNavigationProp } from '@react-navigation/stack';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import { Dimensions } from '../../constants/dimensions';
import Button from '../../components/common/Button';
import Card from '../../components/common/Card';
import { H2, H4, BodyLarge, Body, Caption } from '../../components/common/Typography';
import RiskIndicator from '../../components/common/RiskIndicator';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { MainTabParamList, RootStackParamList, ScanResult, Product } from '../../types';

type HomeScreenNavigationProp = CompositeNavigationProp<
  BottomTabNavigationProp<MainTabParamList, 'Home'>,
  StackNavigationProp<RootStackParamList>
>;

interface Props {
  navigation: HomeScreenNavigationProp;
}

// Mock data for demonstration
const mockRecentScans: ScanResult[] = [
  {
    id: '1',
    userId: 'user1',
    product: {
      id: 'p1',
      barcode: '123456789',
      name: 'Organic Whole Milk',
      brand: 'Nature\'s Best',
      category: 'dairy',
      images: [],
      ingredients: [],
      nutritionalInfo: {} as any,
      riskAssessment: {
        overallRisk: 'low',
        riskFactors: [],
        recommendations: [],
        score: 85,
      },
      reviews: [],
      createdAt: new Date(),
      updatedAt: new Date(),
    },
    scannedAt: new Date(Date.now() - 3600000), // 1 hour ago
    confidence: 0.95,
    processingTime: 1200,
  },
  {
    id: '2',
    userId: 'user1',
    product: {
      id: 'p2',
      barcode: '987654321',
      name: 'Energy Drink Ultra',
      brand: 'PowerBoost',
      category: 'beverage',
      images: [],
      ingredients: [],
      nutritionalInfo: {} as any,
      riskAssessment: {
        overallRisk: 'high',
        riskFactors: [],
        recommendations: [],
        score: 25,
      },
      reviews: [],
      createdAt: new Date(),
      updatedAt: new Date(),
    },
    scannedAt: new Date(Date.now() - 7200000), // 2 hours ago
    confidence: 0.98,
    processingTime: 800,
  },
];

const HomeScreen: React.FC<Props> = ({ navigation }) => {
  const [refreshing, setRefreshing] = useState(false);
  const [recentScans, setRecentScans] = useState<ScanResult[]>(mockRecentScans);
  const [healthScore, setHealthScore] = useState(72);
  const [loading, setLoading] = useState(false);

  const handleQuickScan = () => {
    navigation.navigate('Scanning');
  };

  const handleViewAllScans = () => {
    navigation.navigate('Profile'); // Profile contains scan history
  };

  const handleViewHealthDashboard = () => {
    navigation.navigate('Health');
  };

  const handleProductPress = (product: Product) => {
    navigation.navigate('ProductDetails', { productId: product.id });
  };

  const onRefresh = async () => {
    setRefreshing(true);
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 2000));
    setRefreshing(false);
  };

  const getHealthScoreColor = (score: number) => {
    if (score >= 80) return Colors.risk.low;
    if (score >= 60) return Colors.risk.medium;
    return Colors.risk.high;
  };

  const getHealthScoreLabel = (score: number) => {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    return 'Needs Improvement';
  };

  const formatTimeAgo = (date: Date) => {
    const now = new Date();
    const diff = now.getTime() - date.getTime();
    const hours = Math.floor(diff / (1000 * 60 * 60));
    const minutes = Math.floor(diff / (1000 * 60));
    
    if (hours > 0) return `${hours}h ago`;
    if (minutes > 0) return `${minutes}m ago`;
    return 'Just now';
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView
        style={styles.scrollView}
        showsVerticalScrollIndicator={false}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
      >
        {/* Header */}
        <View style={styles.header}>
          <View>
            <H2>Good morning! 👋</H2>
            <Body color="secondary">Ready to scan some products?</Body>
          </View>
          <TouchableOpacity
            style={styles.profileButton}
            onPress={() => navigation.navigate('Profile')}
          >
            <View style={styles.avatar}>
              <Body style={styles.avatarText}>JD</Body>
            </View>
          </TouchableOpacity>
        </View>

        {/* Quick Scan Section */}
        <Card style={styles.quickScanCard}>
          <View style={styles.quickScanContent}>
            <View style={styles.scanIcon}>
              <H2>📱</H2>
            </View>
            <View style={styles.quickScanText}>
              <H4>Quick Scan</H4>
              <Body color="secondary">Scan any product barcode instantly</Body>
            </View>
          </View>
          <Button
            title="Start Scanning"
            onPress={handleQuickScan}
            variant="primary"
            size="large"
            fullWidth
            testID="home-quick-scan-button"
          />
        </Card>

        {/* Health Score Widget */}
        <Card style={styles.healthScoreCard}>
          <View style={styles.healthScoreHeader}>
            <H4>Your Health Score</H4>
            <TouchableOpacity onPress={handleViewHealthDashboard}>
              <Body color="info">View Details</Body>
            </TouchableOpacity>
          </View>
          
          <View style={styles.healthScoreContent}>
            <View style={styles.scoreCircle}>
              <H2 style={[styles.scoreText, { color: getHealthScoreColor(healthScore) }]}>
                {healthScore}
              </H2>
              <Caption color="secondary">out of 100</Caption>
            </View>
            
            <View style={styles.scoreDetails}>
              <Body style={[styles.scoreLabel, { color: getHealthScoreColor(healthScore) }]}>
                {getHealthScoreLabel(healthScore)}
              </Body>
              <Body color="secondary" style={styles.scoreDescription}>
                Based on your recent scans and dietary choices
              </Body>
            </View>
          </View>
        </Card>

        {/* Recent Scans */}
        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <H4>Recent Scans</H4>
            <TouchableOpacity onPress={handleViewAllScans}>
              <Body color="info">View All</Body>
            </TouchableOpacity>
          </View>

          {recentScans.length > 0 ? (
            <View style={styles.recentScansList}>
              {recentScans.slice(0, 3).map((scan) => (
                <Card
                  key={scan.id}
                  style={styles.scanCard}
                  onPress={() => handleProductPress(scan.product)}
                >
                  <View style={styles.scanCardContent}>
                    <View style={styles.productInfo}>
                      <BodyLarge numberOfLines={1}>
                        {scan.product.name}
                      </BodyLarge>
                      <Body color="secondary" numberOfLines={1}>
                        {scan.product.brand}
                      </Body>
                      <Caption color="secondary">
                        {formatTimeAgo(scan.scannedAt)}
                      </Caption>
                    </View>
                    
                    <View style={styles.riskInfo}>
                      <RiskIndicator
                        riskLevel={scan.product.riskAssessment.overallRisk}
                        size="small"
                      />
                      <Body style={styles.scoreValue}>
                        {scan.product.riskAssessment.score}
                      </Body>
                    </View>
                  </View>
                </Card>
              ))}
            </View>
          ) : (
            <Card style={styles.emptyState}>
              <View style={styles.emptyStateContent}>
                <H4 color="secondary">No scans yet</H4>
                <Body color="secondary" style={styles.emptyStateText}>
                  Start scanning products to see your history here
                </Body>
                <Button
                  title="Scan Your First Product"
                  onPress={handleQuickScan}
                  variant="secondary"
                  size="medium"
                  style={styles.emptyStateButton}
                />
              </View>
            </Card>
          )}
        </View>

        {/* Quick Actions */}
        <View style={styles.section}>
          <H4 style={styles.sectionTitle}>Quick Actions</H4>
          <View style={styles.quickActions}>
            <TouchableOpacity
              style={styles.quickAction}
              onPress={() => navigation.navigate('Search')}
            >
              <View style={styles.quickActionIcon}>
                <H4>🔍</H4>
              </View>
              <Body style={styles.quickActionText}>Search Products</Body>
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.quickAction}
              onPress={handleViewHealthDashboard}
            >
              <View style={styles.quickActionIcon}>
                <H4>📊</H4>
              </View>
              <Body style={styles.quickActionText}>Health Trends</Body>
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.quickAction}
              onPress={() => navigation.navigate('Settings')}
            >
              <View style={styles.quickActionIcon}>
                <H4>⚙️</H4>
              </View>
              <Body style={styles.quickActionText}>Settings</Body>
            </TouchableOpacity>
          </View>
        </View>

        {/* Bottom spacing */}
        <View style={styles.bottomSpacing} />
      </ScrollView>

      {loading && <LoadingSpinner overlay />}
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
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: Spacing.layout.containerPadding,
    paddingVertical: Spacing.lg,
  },
  profileButton: {
    padding: Spacing.xs,
  },
  avatar: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: Colors.primary.green,
    justifyContent: 'center',
    alignItems: 'center',
  },
  avatarText: {
    color: Colors.neutral.white,
    fontWeight: '600',
  },
  quickScanCard: {
    marginHorizontal: Spacing.layout.containerPadding,
    marginBottom: Spacing.lg,
    backgroundColor: Colors.primary.green,
  },
  quickScanContent: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: Spacing.lg,
  },
  scanIcon: {
    marginRight: Spacing.md,
  },
  quickScanText: {
    flex: 1,
  },
  healthScoreCard: {
    marginHorizontal: Spacing.layout.containerPadding,
    marginBottom: Spacing.lg,
  },
  healthScoreHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: Spacing.md,
  },
  healthScoreContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  scoreCircle: {
    alignItems: 'center',
    marginRight: Spacing.lg,
  },
  scoreText: {
    fontSize: 32,
    fontWeight: '700',
  },
  scoreDetails: {
    flex: 1,
  },
  scoreLabel: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: Spacing.xs,
  },
  scoreDescription: {
    lineHeight: 18,
  },
  section: {
    marginHorizontal: Spacing.layout.containerPadding,
    marginBottom: Spacing.lg,
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
  recentScansList: {
    gap: Spacing.sm,
  },
  scanCard: {
    marginBottom: 0,
  },
  scanCardContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  productInfo: {
    flex: 1,
  },
  riskInfo: {
    alignItems: 'flex-end',
    gap: Spacing.xs,
  },
  scoreValue: {
    fontSize: 16,
    fontWeight: '600',
  },
  emptyState: {
    alignItems: 'center',
    padding: Spacing.xl,
  },
  emptyStateContent: {
    alignItems: 'center',
  },
  emptyStateText: {
    textAlign: 'center',
    marginVertical: Spacing.md,
  },
  emptyStateButton: {
    marginTop: Spacing.sm,
  },
  quickActions: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  quickAction: {
    alignItems: 'center',
    flex: 1,
  },
  quickActionIcon: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: Colors.alpha.primary,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: Spacing.sm,
  },
  quickActionText: {
    textAlign: 'center',
  },
  bottomSpacing: {
    height: Spacing.xl,
  },
});

export default HomeScreen;