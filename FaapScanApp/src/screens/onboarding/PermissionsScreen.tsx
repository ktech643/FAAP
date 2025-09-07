/**
 * FAAP Scan App - Permissions Screen
 * Requests necessary permissions for camera and notifications
 */

import React, { useState } from 'react';
import {
  View,
  StyleSheet,
  SafeAreaView,
  Alert,
} from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import Button from '../../components/common/Button';
import Card from '../../components/common/Card';
import { H2, BodyLarge, Body } from '../../components/common/Typography';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { OnboardingStackParamList } from '../../types';

type PermissionsScreenNavigationProp = StackNavigationProp<
  OnboardingStackParamList,
  'Permissions'
>;

interface Props {
  navigation: PermissionsScreenNavigationProp;
}

interface PermissionItem {
  id: string;
  title: string;
  description: string;
  required: boolean;
  granted: boolean;
}

const PermissionsScreen: React.FC<Props> = ({ navigation }) => {
  const [loading, setLoading] = useState(false);
  const [permissions, setPermissions] = useState<PermissionItem[]>([
    {
      id: 'camera',
      title: 'Camera Access',
      description: 'Required to scan product barcodes and take photos',
      required: true,
      granted: false,
    },
    {
      id: 'notifications',
      title: 'Push Notifications',
      description: 'Get alerts about harmful ingredients and health tips',
      required: false,
      granted: false,
    },
  ]);

  const requestPermission = async (permissionId: string) => {
    setLoading(true);
    
    try {
      // Simulate permission request
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      // In a real app, you would use react-native-permissions here
      const granted = Math.random() > 0.2; // 80% success rate for demo
      
      setPermissions(prev => 
        prev.map(p => 
          p.id === permissionId 
            ? { ...p, granted }
            : p
        )
      );

      if (!granted && permissions.find(p => p.id === permissionId)?.required) {
        Alert.alert(
          'Permission Required',
          'This permission is required for the app to function properly. Please grant it in your device settings.',
          [
            { text: 'Settings', onPress: () => {/* Open settings */} },
            { text: 'Try Again', onPress: () => requestPermission(permissionId) },
          ]
        );
      }
    } catch (error) {
      Alert.alert('Error', 'Failed to request permission. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const handleContinue = () => {
    const requiredPermissions = permissions.filter(p => p.required);
    const grantedRequired = requiredPermissions.filter(p => p.granted);
    
    if (grantedRequired.length < requiredPermissions.length) {
      Alert.alert(
        'Required Permissions',
        'Please grant all required permissions to continue.',
        [{ text: 'OK' }]
      );
      return;
    }
    
    navigation.navigate('HealthProfile');
  };

  const allRequiredGranted = permissions
    .filter(p => p.required)
    .every(p => p.granted);

  return (
    <SafeAreaView style={styles.container}>
      {loading && <LoadingSpinner overlay message="Requesting permission..." />}
      
      <View style={styles.content}>
        <View style={styles.header}>
          <H2 style={styles.title}>App Permissions</H2>
          <BodyLarge color="secondary" style={styles.subtitle}>
            We need a few permissions to provide you with the best experience
          </BodyLarge>
        </View>

        <View style={styles.permissionsList}>
          {permissions.map((permission) => (
            <Card key={permission.id} style={styles.permissionCard}>
              <View style={styles.permissionContent}>
                <View style={styles.permissionInfo}>
                  <View style={styles.permissionHeader}>
                    <BodyLarge style={styles.permissionTitle}>
                      {permission.title}
                    </BodyLarge>
                    {permission.required && (
                      <View style={styles.requiredBadge}>
                        <Body style={styles.requiredText}>Required</Body>
                      </View>
                    )}
                  </View>
                  <Body color="secondary" style={styles.permissionDescription}>
                    {permission.description}
                  </Body>
                </View>

                <View style={styles.permissionAction}>
                  {permission.granted ? (
                    <View style={styles.grantedIndicator}>
                      <Body color="success">✓ Granted</Body>
                    </View>
                  ) : (
                    <Button
                      title="Grant"
                      onPress={() => requestPermission(permission.id)}
                      variant="secondary"
                      size="small"
                      disabled={loading}
                    />
                  )}
                </View>
              </View>
            </Card>
          ))}
        </View>

        <View style={styles.footer}>
          <Button
            title="Continue"
            onPress={handleContinue}
            variant="primary"
            size="large"
            fullWidth
            disabled={!allRequiredGranted || loading}
            testID="permissions-continue-button"
          />
          
          <Body color="secondary" style={styles.footerNote}>
            You can change these permissions later in your device settings
          </Body>
        </View>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.functional.background,
  },
  content: {
    flex: 1,
    paddingHorizontal: Spacing.layout.containerPadding,
  },
  header: {
    paddingVertical: Spacing.xl,
    alignItems: 'center',
  },
  title: {
    marginBottom: Spacing.sm,
    textAlign: 'center',
  },
  subtitle: {
    textAlign: 'center',
  },
  permissionsList: {
    flex: 1,
  },
  permissionCard: {
    marginBottom: Spacing.md,
  },
  permissionContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  permissionInfo: {
    flex: 1,
    marginRight: Spacing.md,
  },
  permissionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: Spacing.xs,
  },
  permissionTitle: {
    flex: 1,
  },
  requiredBadge: {
    backgroundColor: Colors.secondary.warning,
    paddingHorizontal: Spacing.xs,
    paddingVertical: 2,
    borderRadius: 4,
  },
  requiredText: {
    color: Colors.neutral.white,
    fontSize: 10,
  },
  permissionDescription: {
    lineHeight: 18,
  },
  permissionAction: {
    alignItems: 'center',
  },
  grantedIndicator: {
    padding: Spacing.sm,
  },
  footer: {
    paddingVertical: Spacing.xl,
  },
  footerNote: {
    textAlign: 'center',
    marginTop: Spacing.md,
  },
});

export default PermissionsScreen;