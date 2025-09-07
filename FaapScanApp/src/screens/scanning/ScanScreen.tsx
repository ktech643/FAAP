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
  AppState,
  DeviceEventEmitter,
} from 'react-native';
import { StackNavigationProp } from '@react-navigation/stack';
import { Colors } from '../../constants/colors';
import { Spacing } from '../../constants/spacing';
import { Dimensions } from '../../constants/dimensions';
import Button from '../../components/common/Button';
import { H4, Body, Caption } from '../../components/common/Typography';
import LoadingSpinner from '../../components/common/LoadingSpinner';
import { CameraService } from '../../services/camera/CameraService';
import { RootStackParamList, ScanResult } from '../../types';

type ScanScreenNavigationProp = StackNavigationProp<RootStackParamList, 'Scanning'>;

interface Props {
  navigation: ScanScreenNavigationProp;
}

const ScanScreen: React.FC<Props> = ({ navigation }) => {
  const [isScanning, setIsScanning] = useState(false);
  const [isProcessing, setIsProcessing] = useState(false);
  const [flashOn, setFlashOn] = useState(false);
  const [hasPermission, setHasPermission] = useState<boolean | null>(null);
  const [cameraError, setCameraError] = useState<string | null>(null);
  const [fallbackMode, setFallbackMode] = useState<boolean>(false);
  const [currentCameraType, setCurrentCameraType] = useState<'back' | 'front'>('back');
  const [canSwitchCamera, setCanSwitchCamera] = useState<boolean>(false);
  const [isSwitchingCamera, setIsSwitchingCamera] = useState<boolean>(false);
  
  // Animation refs
  const scanLineAnim = useRef(new Animated.Value(0)).current;
  const pulseAnim = useRef(new Animated.Value(1)).current;
  const focusAnim = useRef(new Animated.Value(0)).current;
  
  // Camera service instance
  const cameraService = useRef(CameraService.getInstance()).current;

  useEffect(() => {
    // Initialize camera and request permissions
    initializeCamera();
    
    // Handle app state changes
    const handleAppStateChange = (nextAppState: string) => {
      if (nextAppState === 'active') {
        // App came to foreground, reinitialize camera if needed
        if (hasPermission && !cameraService.isReady()) {
          initializeCamera();
        }
      } else if (nextAppState === 'background') {
        // App went to background, release camera resources
        cameraService.releaseCamera();
        setIsScanning(false);
      }
    };

    const subscription = AppState.addEventListener('change', handleAppStateChange);
    
    // Listen for fallback mode events
    const fallbackListener = DeviceEventEmitter.addListener('CameraFallbackMode', (data) => {
      setFallbackMode(data.enabled);
      if (data.enabled) {
        setIsScanning(false);
        setCameraError('Camera unavailable - using manual entry mode');
      }
    });

    // Listen for camera switch events
    const cameraSwitchListener = DeviceEventEmitter.addListener('CameraSwitched', (data) => {
      setCurrentCameraType(data.to);
      setFlashOn(data.hasFlash && flashOn); // Disable flash if new camera doesn't support it
      console.log(`UI: Camera switched from ${data.from} to ${data.to}`);
    });
    
    return () => {
      subscription?.remove();
      fallbackListener?.remove();
      cameraSwitchListener?.remove();
      cameraService.releaseCamera();
    };
  }, []);

  useEffect(() => {
    if (hasPermission && !isProcessing) {
      // Start animations when camera is ready
      startScanLineAnimation();
      startPulseAnimation();
      setIsScanning(true);
      
      // Start automatic barcode detection
      startBarcodeDetection();
    }
  }, [hasPermission, isProcessing]);

  const initializeCamera = async () => {
    try {
      setCameraError(null);
      const success = await cameraService.initializeCamera();
      setHasPermission(success);
      
      if (!success) {
        setCameraError('Failed to initialize camera. Please check permissions.');
      } else {
        // Update camera capabilities after initialization
        setCanSwitchCamera(cameraService.canSwitchCamera());
        const currentCamera = cameraService.getCurrentCameraInfo();
        if (currentCamera) {
          setCurrentCameraType(currentCamera.type);
        }
      }
    } catch (error) {
      console.error('Camera initialization error:', error);
      setCameraError('Camera initialization failed. Please try again.');
      cameraService.handleCameraError(error);
    }
  };

  const startBarcodeDetection = async () => {
    if (!isScanning || isProcessing || !cameraService.isReady()) {
      return;
    }

    try {
      const barcode = await cameraService.detectBarcode();
      if (barcode && isScanning) {
        handleBarcodeDetected(barcode);
      } else if (isScanning) {
        // Continue scanning if no barcode detected
        setTimeout(startBarcodeDetection, 1000);
      }
    } catch (error) {
      console.error('Barcode detection error:', error);
      if (isScanning) {
        setTimeout(startBarcodeDetection, 2000); // Retry after delay
      }
    }
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
    try {
      cameraService.toggleFlash();
      const newFlashState = cameraService.getConfig().flashMode === 'on';
      setFlashOn(newFlashState);
    } catch (error) {
      console.error('Flash toggle error:', error);
      Alert.alert('Error', 'Failed to toggle flash. Please try again.');
    }
  };

  const handleCameraFocus = async (x: number, y: number) => {
    try {
      await cameraService.focusAt(x, y);
      startFocusAnimation();
    } catch (error) {
      console.error('Focus error:', error);
    }
  };

  const retryCamera = () => {
    setHasPermission(null);
    setCameraError(null);
    initializeCamera();
  };

  const handleCameraSwitch = async () => {
    if (isSwitchingCamera || !canSwitchCamera) {
      return;
    }

    try {
      setIsSwitchingCamera(true);
      setIsScanning(false);

      const success = await cameraService.switchCamera();
      
      if (success) {
        // Update UI state
        const newCameraType = cameraService.getCurrentCameraInfo()?.type;
        if (newCameraType) {
          setCurrentCameraType(newCameraType);
        }
        
        // Restart scanning after switch
        setTimeout(() => {
          setIsScanning(true);
          startBarcodeDetection();
        }, 500);
      } else {
        Alert.alert('Camera Switch Failed', 'Unable to switch camera. Please try again.');
      }
    } catch (error) {
      console.error('Camera switch error:', error);
      Alert.alert('Error', 'Failed to switch camera. Please try again.');
    } finally {
      setIsSwitchingCamera(false);
    }
  };

  const getCameraSwitchIcon = () => {
    return currentCameraType === 'back' ? '🤳' : '📷';
  };

  const getCameraSwitchLabel = () => {
    const nextType = cameraService.getNextCameraType();
    return nextType ? `${nextType === 'front' ? 'Front' : 'Rear'} Cam` : 'Switch';
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

  if (hasPermission === false || cameraError) {
    return (
      <SafeAreaView style={styles.permissionContainer}>
        <View style={styles.permissionContent}>
          <H4 style={styles.permissionTitle}>
            {cameraError ? 'Camera Error' : 'Camera Permission Required'}
          </H4>
          <Body color="secondary" style={styles.permissionText}>
            {cameraError || 'Please grant camera permission to scan barcodes'}
          </Body>
          <Button
            title={cameraError ? 'Retry Camera' : 'Grant Permission'}
            onPress={cameraError ? retryCamera : initializeCamera}
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
      <TouchableOpacity 
        style={styles.cameraContainer}
        onPress={(event) => {
          const { locationX, locationY } = event.nativeEvent;
          handleCameraFocus(locationX, locationY);
        }}
        activeOpacity={1}
      >
        <View style={styles.cameraPlaceholder}>
          <Body color="secondary" style={styles.cameraText}>
            Camera View (Placeholder)
          </Body>
          {cameraError && (
            <Body color="error" style={styles.errorText}>
              {cameraError}
            </Body>
          )}
        </View>
      </TouchableOpacity>

        {/* Scan Overlay */}
        <View style={styles.overlay}>
          {/* Top Controls */}
          <SafeAreaView style={styles.topControls}>
            <TouchableOpacity style={styles.closeButton} onPress={handleClose}>
              <Body style={styles.closeButtonText}>✕</Body>
            </TouchableOpacity>
            
            <View style={styles.topRightControls}>
              {canSwitchCamera && (
                <TouchableOpacity 
                  style={[styles.controlButton, isSwitchingCamera && styles.controlButtonDisabled]} 
                  onPress={handleCameraSwitch}
                  disabled={isSwitchingCamera}
                >
                  <Body style={styles.controlButtonText}>
                    {isSwitchingCamera ? '🔄' : getCameraSwitchIcon()}
                  </Body>
                </TouchableOpacity>
              )}
              
              <TouchableOpacity 
                style={[
                  styles.flashButton, 
                  !cameraService.getCurrentCameraInfo()?.hasFlash && styles.controlButtonDisabled
                ]} 
                onPress={toggleFlash}
                disabled={!cameraService.getCurrentCameraInfo()?.hasFlash}
              >
                <Body style={styles.flashButtonText}>
                  {flashOn ? '🔦' : '💡'}
                </Body>
              </TouchableOpacity>
            </View>
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
                  : fallbackMode
                  ? 'Camera unavailable - use manual entry below'
                  : 'Position barcode within the frame'}
              </Body>
              {!isProcessing && !fallbackMode && (
                <Caption color="secondary" style={styles.instructionSubtext}>
                  Hold steady for automatic scanning
                </Caption>
              )}
              {fallbackMode && (
                <Caption color="warning" style={styles.instructionSubtext}>
                  Camera has issues - manual entry available
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
                title={isProcessing ? 'Processing...' : fallbackMode ? 'Enter Barcode' : 'Manual Scan'}
                onPress={handleManualScan}
                variant={fallbackMode ? 'secondary' : 'primary'}
                disabled={isProcessing}
                loading={isProcessing}
                style={styles.manualScanButton}
              />

              {canSwitchCamera ? (
                <TouchableOpacity 
                  style={styles.switchCameraButton}
                  onPress={handleCameraSwitch}
                  disabled={isSwitchingCamera}
                >
                  <Body style={styles.controlButtonText}>
                    {isSwitchingCamera ? '🔄' : getCameraSwitchIcon()}
                  </Body>
                  <Caption style={styles.controlLabel}>
                    {isSwitchingCamera ? 'Switching...' : getCameraSwitchLabel()}
                  </Caption>
                </TouchableOpacity>
              ) : (
                <TouchableOpacity style={styles.historyButton}>
                  <Body style={styles.controlButtonText}>📋</Body>
                  <Caption style={styles.controlLabel}>History</Caption>
                </TouchableOpacity>
              )}
            </View>

            {/* Tips */}
            <View style={styles.tips}>
              <Caption color="secondary" style={styles.tipText}>
                💡 Tip: Ensure good lighting for best results
              </Caption>
            </View>
          </SafeAreaView>
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
  topRightControls: {
    flexDirection: 'row',
    gap: Spacing.sm,
  },
  controlButton: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: Colors.alpha.black50,
    justifyContent: 'center',
    alignItems: 'center',
  },
  controlButtonDisabled: {
    opacity: 0.5,
  },
  controlButtonText: {
    fontSize: 18,
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
  switchCameraButton: {
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
  errorText: {
    marginTop: Spacing.sm,
    textAlign: 'center',
    color: Colors.secondary.error,
  },
});

export default ScanScreen;