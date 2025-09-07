/**
 * FAAP Scan App - Scan Screen
 * Camera interface for barcode scanning with advanced UI
 */

import React, { useState, useEffect, useRef } from 'react';
import {
  View,
  StyleSheet,
  SafeAreaView,
  TouchableOpacity,
  Animated,
  Vibration,
  Alert,
} from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import { Dimensions } from '../../constants/dimensions';
import Button from '../../components/common/Button';
import { H4, Body, Caption } from '../../components/common/Typography';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { RootStackParamList, ScanResult } from '../../types';

type ScanScreenNavigationProp = StackNavigationProp<RootStackParamList, 'Scanning'>;

interface Props {
  navigation: ScanScreenNavigationProp;
}

const ScanScreen: React.FC<Props> = ({ navigation }) => {
  const [isScanning, setIsScanning] = useState(true);
  const [isProcessing, setIsProcessing] = useState(false);
  const [flashOn, setFlashOn] = useState(false);
  const [hasPermission, setHasPermission] = useState<boolean | null>(null);
  
  // Animation refs
  const scanLineAnim = useRef(new Animated.Value(0)).current;
  const pulseAnim = useRef(new Animated.Value(1)).current;
  const focusAnim = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    // Request camera permission
    requestCameraPermission();
    
    // Start scan line animation
    startScanLineAnimation();
    
    // Start pulse animation for scan area
    startPulseAnimation();
  }, []);

  const requestCameraPermission = async () => {
    // In a real app, use react-native-permissions
    // For now, simulate permission request
    setTimeout(() => {
      setHasPermission(true);
    }, 500);
  };

  const startScanLineAnimation = () => {
    Animated.loop(
      Animated.sequence([
        Animated.timing(scanLineAnim, {
          toValue: 1,
          duration: 2000,
          useNativeDriver: false,
        }),
        Animated.timing(scanLineAnim, {
          toValue: 0,
          duration: 100,
          useNativeDriver: false,
        }),
      ])
    ).start();
  };

  const startPulseAnimation = () => {
    Animated.loop(
      Animated.sequence([
        Animated.timing(pulseAnim, {
          toValue: 1.05,
          duration: 1000,
          useNativeDriver: true,
        }),
        Animated.timing(pulseAnim, {
          toValue: 1,
          duration: 1000,
          useNativeDriver: true,
        }),
      ])
    ).start();
  };

  const startFocusAnimation = () => {
    Animated.sequence([
      Animated.timing(focusAnim, {
        toValue: 1,
        duration: 200,
        useNativeDriver: true,
      }),
      Animated.timing(focusAnim, {
        toValue: 0,
        duration: 200,
        useNativeDriver: true,
      }),
    ]).start();
  };

  const handleBarcodeDetected = async (barcode: string) => {
    if (isProcessing) return;

    setIsProcessing(true);
    setIsScanning(false);
    
    // Haptic feedback
    Vibration.vibrate(100);
    
    // Focus animation
    startFocusAnimation();

    try {
      // Simulate API call to process barcode
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      // Mock successful scan result
      const mockScanResult: ScanResult = {
        id: `scan_${Date.now()}`,
        userId: 'user1',
        product: {
          id: `product_${Date.now()}`,
          barcode,
          name: 'Sample Product',
          brand: 'Sample Brand',
          category: 'food',
          images: [],
          ingredients: [],
          nutritionalInfo: {} as any,
          riskAssessment: {
            overallRisk: 'medium',
            riskFactors: [],
            recommendations: ['Consider alternatives with fewer additives'],
            score: 65,
          },
          reviews: [],
          createdAt: new Date(),
          updatedAt: new Date(),
        },
        scannedAt: new Date(),
        confidence: 0.95,
        processingTime: 2000,
      };

      navigation.replace('Results', { scanResult: mockScanResult });
    } catch (error) {
      Alert.alert(
        'Scan Failed',
        'Could not process the barcode. Please try again.',
        [
          { text: 'Retry', onPress: () => setIsProcessing(false) },
          { text: 'Cancel', onPress: () => navigation.goBack() },
        ]
      );
    } finally {
      setIsProcessing(false);
    }
  };

  const handleManualScan = () => {
    // Simulate barcode detection
    handleBarcodeDetected('1234567890123');
  };

  const toggleFlash = () => {
    setFlashOn(!flashOn);
  };

  const handleClose = () => {
    navigation.goBack();
  };

  if (hasPermission === null) {
    return (
      <View style={styles.permissionContainer}>
        <LoadingSpinner message="Requesting camera permission..." />
      </View>
    );
  }

  if (hasPermission === false) {
    return (
      <SafeAreaView style={styles.permissionContainer}>
        <View style={styles.permissionContent}>
          <H4 style={styles.permissionTitle}>Camera Permission Required</H4>
          <Body color="secondary" style={styles.permissionText}>
            Please grant camera permission to scan barcodes
          </Body>
          <Button
            title="Grant Permission"
            onPress={requestCameraPermission}
            variant="primary"
            style={styles.permissionButton}
          />
          <Button
            title="Cancel"
            onPress={handleClose}
            variant="tertiary"
            style={styles.permissionButton}
          />
        </View>
      </SafeAreaView>
    );
  }

  return (
    <View style={styles.container}>
      {/* Camera View Placeholder */}
      <View style={styles.cameraContainer}>
        <View style={styles.cameraPlaceholder}>
          <Body color="secondary" style={styles.cameraText}>
            Camera View (Placeholder)
          </Body>
        </View>

        {/* Scan Overlay */}
        <View style={styles.overlay}>
          {/* Top Controls */}
          <SafeAreaView style={styles.topControls}>
            <TouchableOpacity style={styles.closeButton} onPress={handleClose}>
              <Body style={styles.closeButtonText}>✕</Body>
            </TouchableOpacity>
            
            <TouchableOpacity style={styles.flashButton} onPress={toggleFlash}>
              <Body style={styles.flashButtonText}>
                {flashOn ? '🔦' : '💡'}
              </Body>
            </TouchableOpacity>
          </SafeAreaView>

          {/* Scan Area */}
          <View style={styles.scanAreaContainer}>
            <Animated.View
              style={[
                styles.scanArea,
                {
                  transform: [{ scale: pulseAnim }],
                },
              ]}
            >
              {/* Corner brackets */}
              <View style={[styles.corner, styles.topLeft]} />
              <View style={[styles.corner, styles.topRight]} />
              <View style={[styles.corner, styles.bottomLeft]} />
              <View style={[styles.corner, styles.bottomRight]} />

              {/* Scan line */}
              {isScanning && (
                <Animated.View
                  style={[
                    styles.scanLine,
                    {
                      top: scanLineAnim.interpolate({
                        inputRange: [0, 1],
                        outputRange: ['0%', '100%'],
                      }),
                    },
                  ]}
                />
              )}

              {/* Focus indicator */}
              <Animated.View
                style={[
                  styles.focusIndicator,
                  {
                    opacity: focusAnim,
                    transform: [
                      {
                        scale: focusAnim.interpolate({
                          inputRange: [0, 1],
                          outputRange: [1, 1.2],
                        }),
                      },
                    ],
                  },
                ]}
              />
            </Animated.View>

            {/* Instructions */}
            <View style={styles.instructions}>
              <Body style={styles.instructionText}>
                {isProcessing
                  ? 'Processing barcode...'
                  : 'Position barcode within the frame'}
              </Body>
              {!isProcessing && (
                <Caption color="secondary" style={styles.instructionSubtext}>
                  Hold steady for automatic scanning
                </Caption>
              )}
            </View>
          </View>

          {/* Bottom Controls */}
          <SafeAreaView style={styles.bottomControls}>
            <View style={styles.controlsContainer}>
              <TouchableOpacity style={styles.galleryButton}>
                <Body style={styles.controlButtonText}>📷</Body>
                <Caption style={styles.controlLabel}>Gallery</Caption>
              </TouchableOpacity>

              <Button
                title={isProcessing ? 'Processing...' : 'Manual Scan'}
                onPress={handleManualScan}
                variant="primary"
                disabled={isProcessing}
                loading={isProcessing}
                style={styles.manualScanButton}
              />

              <TouchableOpacity style={styles.historyButton}>
                <Body style={styles.controlButtonText}>📋</Body>
                <Caption style={styles.controlLabel}>History</Caption>
              </TouchableOpacity>
            </View>

            {/* Tips */}
            <View style={styles.tips}>
              <Caption color="secondary" style={styles.tipText}>
                💡 Tip: Ensure good lighting for best results
              </Caption>
            </View>
          </SafeAreaView>
        </View>
      </View>

      {/* Processing overlay */}
      {isProcessing && (
        <View style={styles.processingOverlay}>
          <LoadingSpinner
            size="large"
            color={Colors.neutral.white}
            message="Analyzing product..."
          />
        </View>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.neutral.black,
  },
  cameraContainer: {
    flex: 1,
    position: 'relative',
  },
  cameraPlaceholder: {
    flex: 1,
    backgroundColor: Colors.neutral.gray800,
    justifyContent: 'center',
    alignItems: 'center',
  },
  cameraText: {
    color: Colors.neutral.white,
  },
  overlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
  topControls: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: Spacing.lg,
    paddingTop: Spacing.md,
  },
  closeButton: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: Colors.alpha.black50,
    justifyContent: 'center',
    alignItems: 'center',
  },
  closeButtonText: {
    color: Colors.neutral.white,
    fontSize: 18,
  },
  flashButton: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: flashOn ? Colors.primary.yellow : Colors.alpha.black50,
    justifyContent: 'center',
    alignItems: 'center',
  },
  flashButtonText: {
    fontSize: 18,
  },
  scanAreaContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: Spacing.xl,
  },
  scanArea: {
    width: 250,
    height: 150,
    position: 'relative',
  },
  corner: {
    position: 'absolute',
    width: 20,
    height: 20,
    borderColor: Colors.primary.green,
    borderWidth: 3,
  },
  topLeft: {
    top: 0,
    left: 0,
    borderRightWidth: 0,
    borderBottomWidth: 0,
  },
  topRight: {
    top: 0,
    right: 0,
    borderLeftWidth: 0,
    borderBottomWidth: 0,
  },
  bottomLeft: {
    bottom: 0,
    left: 0,
    borderRightWidth: 0,
    borderTopWidth: 0,
  },
  bottomRight: {
    bottom: 0,
    right: 0,
    borderLeftWidth: 0,
    borderTopWidth: 0,
  },
  scanLine: {
    position: 'absolute',
    left: 0,
    right: 0,
    height: 2,
    backgroundColor: Colors.primary.green,
    shadowColor: Colors.primary.green,
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 0.8,
    shadowRadius: 4,
  },
  focusIndicator: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    width: 60,
    height: 60,
    marginTop: -30,
    marginLeft: -30,
    borderWidth: 2,
    borderColor: Colors.primary.green,
    borderRadius: 30,
  },
  instructions: {
    marginTop: Spacing.xl,
    alignItems: 'center',
  },
  instructionText: {
    color: Colors.neutral.white,
    textAlign: 'center',
    marginBottom: Spacing.xs,
  },
  instructionSubtext: {
    color: Colors.neutral.gray400,
    textAlign: 'center',
  },
  bottomControls: {
    paddingHorizontal: Spacing.lg,
    paddingBottom: Spacing.lg,
  },
  controlsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: Spacing.lg,
  },
  galleryButton: {
    alignItems: 'center',
    flex: 1,
  },
  historyButton: {
    alignItems: 'center',
    flex: 1,
  },
  controlButtonText: {
    fontSize: 24,
    marginBottom: Spacing.xs,
  },
  controlLabel: {
    color: Colors.neutral.gray400,
  },
  manualScanButton: {
    flex: 2,
    marginHorizontal: Spacing.lg,
  },
  tips: {
    alignItems: 'center',
  },
  tipText: {
    color: Colors.neutral.gray400,
    textAlign: 'center',
  },
  processingOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: Colors.alpha.black50,
    justifyContent: 'center',
    alignItems: 'center',
  },
  permissionContainer: {
    flex: 1,
    backgroundColor: Colors.functional.background,
    justifyContent: 'center',
    alignItems: 'center',
  },
  permissionContent: {
    padding: Spacing.xl,
    alignItems: 'center',
  },
  permissionTitle: {
    marginBottom: Spacing.md,
    textAlign: 'center',
  },
  permissionText: {
    textAlign: 'center',
    marginBottom: Spacing.xl,
  },
  permissionButton: {
    marginBottom: Spacing.md,
    minWidth: 200,
  },
});

export default ScanScreen;