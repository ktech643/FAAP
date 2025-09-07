/**
 * FAAP Scan App - Camera Service
 * Handles camera initialization, permissions, and error recovery
 */

import { Alert, Linking, Platform } from 'react-native';
import { check, request, PERMISSIONS, RESULTS, PermissionStatus } from 'react-native-permissions';

export interface CameraPermissionResult {
  granted: boolean;
  status: PermissionStatus;
  canAskAgain: boolean;
}

export interface CameraConfig {
  quality: 'low' | 'medium' | 'high';
  flashMode: 'auto' | 'on' | 'off';
  focusMode: 'auto' | 'manual';
  whiteBalance: 'auto' | 'sunny' | 'cloudy' | 'fluorescent';
}

export class CameraService {
  private static instance: CameraService;
  private isInitialized: boolean = false;
  private currentConfig: CameraConfig;

  private constructor() {
    this.currentConfig = {
      quality: 'high',
      flashMode: 'auto',
      focusMode: 'auto',
      whiteBalance: 'auto',
    };
  }

  public static getInstance(): CameraService {
    if (!CameraService.instance) {
      CameraService.instance = new CameraService();
    }
    return CameraService.instance;
  }

  /**
   * Request camera permissions
   */
  public async requestCameraPermission(): Promise<CameraPermissionResult> {
    try {
      const permission = Platform.OS === 'ios' 
        ? PERMISSIONS.IOS.CAMERA 
        : PERMISSIONS.ANDROID.CAMERA;

      // Check current permission status
      const currentStatus = await check(permission);
      
      if (currentStatus === RESULTS.GRANTED) {
        return {
          granted: true,
          status: currentStatus,
          canAskAgain: true,
        };
      }

      if (currentStatus === RESULTS.DENIED) {
        // Request permission
        const requestResult = await request(permission);
        return {
          granted: requestResult === RESULTS.GRANTED,
          status: requestResult,
          canAskAgain: requestResult !== RESULTS.BLOCKED,
        };
      }

      // Permission is blocked or unavailable
      return {
        granted: false,
        status: currentStatus,
        canAskAgain: false,
      };
    } catch (error) {
      console.error('Error requesting camera permission:', error);
      return {
        granted: false,
        status: RESULTS.UNAVAILABLE,
        canAskAgain: false,
      };
    }
  }

  /**
   * Show permission denied dialog
   */
  public showPermissionDeniedDialog(): void {
    Alert.alert(
      'Camera Permission Required',
      'This app needs camera access to scan product barcodes. Please enable camera permission in your device settings.',
      [
        {
          text: 'Cancel',
          style: 'cancel',
        },
        {
          text: 'Open Settings',
          onPress: () => {
            Linking.openSettings();
          },
        },
      ]
    );
  }

  /**
   * Initialize camera with error handling
   */
  public async initializeCamera(): Promise<boolean> {
    try {
      const permissionResult = await this.requestCameraPermission();
      
      if (!permissionResult.granted) {
        if (!permissionResult.canAskAgain) {
          this.showPermissionDeniedDialog();
        }
        return false;
      }

      // Simulate camera initialization
      await new Promise(resolve => setTimeout(resolve, 500));
      
      this.isInitialized = true;
      return true;
    } catch (error) {
      console.error('Camera initialization failed:', error);
      this.handleCameraError(error);
      return false;
    }
  }

  /**
   * Handle camera errors with recovery strategies
   */
  public handleCameraError(error: any): void {
    console.error('Camera error:', error);
    
    let errorMessage = 'An unknown camera error occurred.';
    let recoveryAction = 'Try Again';
    
    if (error?.message?.includes('CAMERA_ERROR')) {
      errorMessage = 'Camera device error. Please restart the app or try using a different camera.';
      recoveryAction = 'Restart App';
    } else if (error?.message?.includes('Function not implemented')) {
      errorMessage = 'Camera function not supported on this device. Some features may be limited.';
      recoveryAction = 'Continue';
    } else if (error?.message?.includes('Access denied')) {
      errorMessage = 'Camera access denied. Please check app permissions.';
      recoveryAction = 'Open Settings';
    }

    Alert.alert(
      'Camera Error',
      errorMessage,
      [
        {
          text: 'Cancel',
          style: 'cancel',
        },
        {
          text: recoveryAction,
          onPress: () => {
            if (recoveryAction === 'Open Settings') {
              Linking.openSettings();
            } else if (recoveryAction === 'Restart App') {
              // In a real app, you might use a restart library
              console.log('App restart requested');
            } else {
              // Retry initialization
              this.initializeCamera();
            }
          },
        },
      ]
    );
  }

  /**
   * Check if camera is available and working
   */
  public async isCameraAvailable(): Promise<boolean> {
    try {
      const permissionResult = await this.requestCameraPermission();
      return permissionResult.granted;
    } catch (error) {
      console.error('Camera availability check failed:', error);
      return false;
    }
  }

  /**
   * Get current camera configuration
   */
  public getConfig(): CameraConfig {
    return { ...this.currentConfig };
  }

  /**
   * Update camera configuration
   */
  public updateConfig(config: Partial<CameraConfig>): void {
    this.currentConfig = {
      ...this.currentConfig,
      ...config,
    };
  }

  /**
   * Release camera resources
   */
  public releaseCamera(): void {
    this.isInitialized = false;
    // In a real implementation, you would release camera resources here
    console.log('Camera resources released');
  }

  /**
   * Check if camera is initialized
   */
  public isReady(): boolean {
    return this.isInitialized;
  }

  /**
   * Simulate barcode detection
   */
  public async detectBarcode(): Promise<string | null> {
    if (!this.isInitialized) {
      throw new Error('Camera not initialized');
    }

    try {
      // Simulate barcode detection delay
      await new Promise(resolve => setTimeout(resolve, 1000 + Math.random() * 2000));
      
      // Simulate detection success/failure
      const success = Math.random() > 0.2; // 80% success rate
      
      if (success) {
        // Generate a mock barcode
        const mockBarcodes = [
          '1234567890123',
          '9876543210987',
          '4567891234567',
          '7890123456789',
          '3456789012345',
        ];
        return mockBarcodes[Math.floor(Math.random() * mockBarcodes.length)];
      }
      
      return null;
    } catch (error) {
      console.error('Barcode detection failed:', error);
      throw error;
    }
  }

  /**
   * Toggle flash
   */
  public toggleFlash(): void {
    const currentFlash = this.currentConfig.flashMode;
    const newFlash = currentFlash === 'off' ? 'on' : 'off';
    this.updateConfig({ flashMode: newFlash });
    console.log(`Flash toggled: ${currentFlash} -> ${newFlash}`);
  }

  /**
   * Focus camera at specific point
   */
  public async focusAt(x: number, y: number): Promise<void> {
    if (!this.isInitialized) {
      throw new Error('Camera not initialized');
    }

    try {
      // Simulate focus operation
      await new Promise(resolve => setTimeout(resolve, 300));
      console.log(`Camera focused at (${x}, ${y})`);
    } catch (error) {
      console.error('Focus operation failed:', error);
      throw error;
    }
  }

  /**
   * Take a picture
   */
  public async takePicture(): Promise<string> {
    if (!this.isInitialized) {
      throw new Error('Camera not initialized');
    }

    try {
      // Simulate picture taking
      await new Promise(resolve => setTimeout(resolve, 500));
      
      // Return mock image path
      return `file://mock_image_${Date.now()}.jpg`;
    } catch (error) {
      console.error('Picture taking failed:', error);
      throw error;
    }
  }
}