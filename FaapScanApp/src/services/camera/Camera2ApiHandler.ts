/**
 * FAAP Scan App - Camera2 API Handler
 * Handles Camera2 API specific issues and cleanup problems
 */

import { NativeModules, DeviceEventEmitter, Platform } from 'react-native';

export interface Camera2Error {
  code: number;
  message: string;
  isRecoverable: boolean;
  suggestedAction: 'retry' | 'restart' | 'fallback' | 'ignore';
}

export class Camera2ApiHandler {
  private static instance: Camera2ApiHandler;
  private activeSession: any = null;
  private isCleaningUp: boolean = false;
  private cleanupTimeout: NodeJS.Timeout | null = null;

  private constructor() {
    this.setupErrorListeners();
  }

  public static getInstance(): Camera2ApiHandler {
    if (!Camera2ApiHandler.instance) {
      Camera2ApiHandler.instance = new Camera2ApiHandler();
    }
    return Camera2ApiHandler.instance;
  }

  /**
   * Setup native error listeners
   */
  private setupErrorListeners(): void {
    DeviceEventEmitter.addListener('CameraError', (error) => {
      this.handleNativeCameraError(error);
    });

    DeviceEventEmitter.addListener('CameraSessionStateChanged', (state) => {
      this.handleSessionStateChange(state);
    });
  }

  /**
   * Analyze Camera2 API errors and provide recovery strategies
   */
  public analyzeCameraError(error: any): Camera2Error {
    const errorString = error.toString() || '';
    const errorCode = this.extractErrorCode(errorString);

    // Camera session cleanup errors (your specific issue)
    if (errorString.includes('cancelRequest') && errorString.includes('Function not implemented')) {
      return {
        code: -38,
        message: 'Camera session cleanup failed - device API limitation',
        isRecoverable: true,
        suggestedAction: 'ignore', // This is a cleanup error, not functional
      };
    }

    // Camera device errors
    if (errorString.includes('CAMERA_ERROR') && errorCode === 3) {
      return {
        code: 3,
        message: 'Camera device error - hardware or driver issue',
        isRecoverable: true,
        suggestedAction: 'retry',
      };
    }

    // Camera access errors
    if (errorString.includes('CAMERA_ERROR') && errorCode === 1) {
      return {
        code: 1,
        message: 'Camera access error - permission or hardware unavailable',
        isRecoverable: false,
        suggestedAction: 'fallback',
      };
    }

    // Camera busy errors
    if (errorString.includes('CAMERA_ERROR') && errorCode === 4) {
      return {
        code: 4,
        message: 'Camera busy - being used by another application',
        isRecoverable: true,
        suggestedAction: 'retry',
      };
    }

    // Performance monitoring warnings (can be ignored)
    if (errorString.includes('PerfMonitor binderTransact')) {
      return {
        code: 0,
        message: 'Camera performance monitoring warning',
        isRecoverable: true,
        suggestedAction: 'ignore',
      };
    }

    // Generic camera error
    return {
      code: -1,
      message: 'Unknown camera error',
      isRecoverable: true,
      suggestedAction: 'retry',
    };
  }

  /**
   * Extract error code from error message
   */
  private extractErrorCode(errorString: string): number {
    const codeMatch = errorString.match(/code (\d+)/);
    if (codeMatch) {
      return parseInt(codeMatch[1], 10);
    }

    const errorMatch = errorString.match(/CAMERA_ERROR \((\d+)\)/);
    if (errorMatch) {
      return parseInt(errorMatch[1], 10);
    }

    return -1;
  }

  /**
   * Handle native camera errors
   */
  private handleNativeCameraError(error: any): void {
    const analyzedError = this.analyzeCameraError(error);
    
    console.log('Camera2 Error Analysis:', {
      original: error,
      analyzed: analyzedError,
    });

    switch (analyzedError.suggestedAction) {
      case 'ignore':
        // Log but don't take action - these are often cleanup warnings
        console.log('Camera2: Ignoring non-critical error:', analyzedError.message);
        break;
      case 'retry':
        this.scheduleRetry();
        break;
      case 'restart':
        this.restartCameraSession();
        break;
      case 'fallback':
        this.enableFallbackMode();
        break;
    }
  }

  /**
   * Handle camera session state changes
   */
  private handleSessionStateChange(state: any): void {
    console.log('Camera2: Session state changed:', state);
    
    if (state.state === 'closed' || state.state === 'error') {
      this.activeSession = null;
      this.isCleaningUp = false;
    }
  }

  /**
   * Safely close camera session with timeout
   */
  public async safeCloseSession(session: any): Promise<void> {
    if (!session || this.isCleaningUp) {
      return;
    }

    this.isCleaningUp = true;
    this.activeSession = session;

    try {
      // Set a timeout for cleanup to prevent hanging
      const cleanupPromise = new Promise<void>((resolve) => {
        this.cleanupTimeout = setTimeout(() => {
          console.log('Camera2: Cleanup timeout - forcing session close');
          this.isCleaningUp = false;
          this.activeSession = null;
          resolve();
        }, 3000); // 3 second timeout

        // Attempt graceful cleanup
        try {
          if (session.close) {
            session.close();
          }
          if (session.stopRepeating) {
            session.stopRepeating();
          }
        } catch (cleanupError) {
          console.log('Camera2: Cleanup error (expected on some devices):', cleanupError);
        }

        // Clear timeout if cleanup completes normally
        if (this.cleanupTimeout) {
          clearTimeout(this.cleanupTimeout);
          this.cleanupTimeout = null;
        }
        
        this.isCleaningUp = false;
        this.activeSession = null;
        resolve();
      });

      await cleanupPromise;
    } catch (error) {
      console.log('Camera2: Session cleanup failed (non-critical):', error);
      this.isCleaningUp = false;
      this.activeSession = null;
    }
  }

  /**
   * Schedule camera retry with exponential backoff
   */
  private scheduleRetry(): void {
    const retryDelay = Math.min(1000 * Math.pow(2, this.getRetryCount()), 10000);
    
    setTimeout(() => {
      console.log('Camera2: Attempting retry after error');
      // Emit retry event for the camera service to handle
      DeviceEventEmitter.emit('CameraRetryRequested');
    }, retryDelay);
  }

  /**
   * Restart camera session
   */
  private restartCameraSession(): void {
    console.log('Camera2: Restarting camera session');
    DeviceEventEmitter.emit('CameraRestartRequested');
  }

  /**
   * Enable fallback mode
   */
  private enableFallbackMode(): void {
    console.log('Camera2: Enabling fallback mode');
    DeviceEventEmitter.emit('CameraFallbackRequested');
  }

  /**
   * Get retry count (simplified implementation)
   */
  private getRetryCount(): number {
    // In a real implementation, you'd track this per session
    return 1;
  }

  /**
   * Check if device has known Camera2 API issues
   */
  public hasKnownCamera2Issues(): boolean {
    const { brand, model } = this.getDeviceInfo();
    
    // Known problematic devices
    const problematicDevices = [
      { brand: 'xiaomi', models: ['*'] }, // Xiaomi/MIUI devices
      { brand: 'huawei', models: ['*'] }, // Some Huawei devices
      { brand: 'oppo', models: ['*'] },   // Some OPPO devices
    ];

    return problematicDevices.some(device => 
      brand.toLowerCase().includes(device.brand) &&
      (device.models.includes('*') || device.models.some(m => model.toLowerCase().includes(m)))
    );
  }

  /**
   * Get device information
   */
  private getDeviceInfo(): { brand: string; model: string } {
    try {
      // In a real implementation, you'd use react-native-device-info
      return {
        brand: Platform.OS === 'android' ? 'android' : 'ios',
        model: 'unknown',
      };
    } catch (error) {
      return { brand: 'unknown', model: 'unknown' };
    }
  }

  /**
   * Apply device-specific workarounds
   */
  public applyDeviceWorkarounds(): Record<string, any> {
    const config: Record<string, any> = {};

    if (this.hasKnownCamera2Issues()) {
      // Xiaomi/MIUI specific workarounds
      config.enableGracefulCleanup = true;
      config.ignoreCleanupErrors = true;
      config.useTimeoutForCleanup = true;
      config.maxRetryAttempts = 3;
      config.retryDelay = 2000;
      
      console.log('Camera2: Applied device-specific workarounds for known problematic device');
    }

    return config;
  }

  /**
   * Cleanup resources
   */
  public cleanup(): void {
    if (this.cleanupTimeout) {
      clearTimeout(this.cleanupTimeout);
      this.cleanupTimeout = null;
    }
    
    DeviceEventEmitter.removeAllListeners('CameraError');
    DeviceEventEmitter.removeAllListeners('CameraSessionStateChanged');
    DeviceEventEmitter.removeAllListeners('CameraRetryRequested');
    DeviceEventEmitter.removeAllListeners('CameraRestartRequested');
    DeviceEventEmitter.removeAllListeners('CameraFallbackRequested');
    
    this.activeSession = null;
    this.isCleaningUp = false;
  }
}