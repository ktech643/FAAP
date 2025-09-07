/**
 * FAAP Scan App - Camera Service
 * Handles camera initialization, permissions, and error recovery
 */

import { Alert, Linking, Platform, DeviceEventEmitter } from 'react-native';
import { check, request, PERMISSIONS, RESULTS, PermissionStatus } from 'react-native-permissions';
import { Camera2ApiHandler } from './Camera2ApiHandler';

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
  private camera2Handler: Camera2ApiHandler;
  private activeSession: any = null;
  private retryCount: number = 0;
  private maxRetries: number = 3;

  private constructor() {
    this.currentConfig = {
      quality: 'high',
      flashMode: 'auto',
      focusMode: 'auto',
      whiteBalance: 'auto',
    };
    
    this.camera2Handler = Camera2ApiHandler.getInstance();
    this.setupEventListeners();
  }

  public static getInstance(): CameraService {
    if (!CameraService.instance) {
      CameraService.instance = new CameraService();
    }
    return CameraService.instance;
  }

  /**
   * Setup event listeners for Camera2 API events
   */
  private setupEventListeners(): void {
    DeviceEventEmitter.addListener('CameraRetryRequested', () => {
      this.handleRetryRequest();
    });

    DeviceEventEmitter.addListener('CameraRestartRequested', () => {
      this.handleRestartRequest();
    });

    DeviceEventEmitter.addListener('CameraFallbackRequested', () => {
      this.handleFallbackRequest();
    });
  }

  /**
   * Handle retry requests from Camera2 handler
   */
  private async handleRetryRequest(): Promise<void> {
    if (this.retryCount < this.maxRetries) {
      this.retryCount++;
      console.log(`Camera Service: Retry attempt ${this.retryCount}/${this.maxRetries}`);
      
      try {
        await this.releaseCamera();
        await new Promise(resolve => setTimeout(resolve, 1000)); // Wait before retry
        await this.initializeCamera();
      } catch (error) {
        console.error('Camera Service: Retry failed:', error);
      }
    } else {
      console.log('Camera Service: Max retries reached, enabling fallback mode');
      this.handleFallbackRequest();
    }
  }

  /**
   * Handle restart requests
   */
  private async handleRestartRequest(): Promise<void> {
    console.log('Camera Service: Restarting camera session');
    this.retryCount = 0; // Reset retry count
    await this.releaseCamera();
    await new Promise(resolve => setTimeout(resolve, 2000)); // Longer wait for restart
    await this.initializeCamera();
  }

  /**
   * Handle fallback requests
   */
  private handleFallbackRequest(): void {
    console.log('Camera Service: Enabling fallback mode');
    this.isInitialized = false;
    // Emit event for UI to handle fallback mode
    DeviceEventEmitter.emit('CameraFallbackMode', { enabled: true });
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
   * Handle camera errors with Camera2 API analysis
   */
  public handleCameraError(error: any): void {
    console.error('Camera error:', error);
    
    // Use Camera2 API handler to analyze the error
    const analyzedError = this.camera2Handler.analyzeCameraError(error);
    
    console.log('Camera error analysis:', analyzedError);
    
    // Handle based on analysis
    switch (analyzedError.suggestedAction) {
      case 'ignore':
        // Don't show user dialog for non-critical errors
        console.log('Camera Service: Ignoring non-critical error:', analyzedError.message);
        return;
        
      case 'retry':
        if (this.retryCount < this.maxRetries) {
          console.log('Camera Service: Scheduling retry for recoverable error');
          this.handleRetryRequest();
          return;
        }
        break;
        
      case 'restart':
        console.log('Camera Service: Scheduling restart for device error');
        this.handleRestartRequest();
        return;
        
      case 'fallback':
        console.log('Camera Service: Enabling fallback mode for unrecoverable error');
        this.handleFallbackRequest();
        return;
    }
    
    // Show user dialog only for errors that need user intervention
    this.showUserErrorDialog(analyzedError);
  }

  /**
   * Show error dialog to user
   */
  private showUserErrorDialog(analyzedError: any): void {
    let errorMessage = analyzedError.message || 'An unknown camera error occurred.';
    let recoveryAction = 'Try Again';
    
    if (analyzedError.code === 1) {
      errorMessage = 'Camera access denied. Please check app permissions.';
      recoveryAction = 'Open Settings';
    } else if (analyzedError.code === 4) {
      errorMessage = 'Camera is busy. Please close other camera apps and try again.';
      recoveryAction = 'Try Again';
    } else if (analyzedError.code === 3) {
      errorMessage = 'Camera device error. Please restart the app.';
      recoveryAction = 'Restart App';
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
   * Release camera resources with proper Camera2 cleanup
   */
  public async releaseCamera(): Promise<void> {
    this.isInitialized = false;
    
    if (this.activeSession) {
      try {
        // Use Camera2 handler for safe cleanup
        await this.camera2Handler.safeCloseSession(this.activeSession);
        this.activeSession = null;
      } catch (error) {
        console.log('Camera Service: Cleanup error (non-critical):', error);
        // Don't throw - cleanup errors are often expected on some devices
      }
    }
    
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