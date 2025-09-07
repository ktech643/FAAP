/**
 * FAAP Scan App - Permissions Utility
 * Handles all app permissions with proper error handling
 */

import { Platform, Alert, Linking } from 'react-native';
import { 
  check, 
  request, 
  PERMISSIONS, 
  RESULTS, 
  PermissionStatus,
  Permission 
} from 'react-native-permissions';

export interface PermissionResult {
  granted: boolean;
  status: PermissionStatus;
  canAskAgain: boolean;
  message?: string;
}

export class PermissionsManager {
  private static instance: PermissionsManager;

  private constructor() {}

  public static getInstance(): PermissionsManager {
    if (!PermissionsManager.instance) {
      PermissionsManager.instance = new PermissionsManager();
    }
    return PermissionsManager.instance;
  }

  /**
   * Get the appropriate permission for the current platform
   */
  private getPermission(type: 'camera' | 'microphone' | 'storage'): Permission {
    switch (type) {
      case 'camera':
        return Platform.OS === 'ios' ? PERMISSIONS.IOS.CAMERA : PERMISSIONS.ANDROID.CAMERA;
      case 'microphone':
        return Platform.OS === 'ios' ? PERMISSIONS.IOS.MICROPHONE : PERMISSIONS.ANDROID.RECORD_AUDIO;
      case 'storage':
        return Platform.OS === 'ios' 
          ? PERMISSIONS.IOS.PHOTO_LIBRARY 
          : PERMISSIONS.ANDROID.WRITE_EXTERNAL_STORAGE;
      default:
        throw new Error(`Unknown permission type: ${type}`);
    }
  }

  /**
   * Check if a permission is granted
   */
  public async checkPermission(type: 'camera' | 'microphone' | 'storage'): Promise<PermissionResult> {
    try {
      const permission = this.getPermission(type);
      const status = await check(permission);
      
      return {
        granted: status === RESULTS.GRANTED,
        status,
        canAskAgain: status !== RESULTS.BLOCKED,
        message: this.getStatusMessage(status, type),
      };
    } catch (error) {
      console.error(`Error checking ${type} permission:`, error);
      return {
        granted: false,
        status: RESULTS.UNAVAILABLE,
        canAskAgain: false,
        message: `Failed to check ${type} permission`,
      };
    }
  }

  /**
   * Request a specific permission
   */
  public async requestPermission(type: 'camera' | 'microphone' | 'storage'): Promise<PermissionResult> {
    try {
      const permission = this.getPermission(type);
      
      // First check current status
      const currentStatus = await check(permission);
      
      if (currentStatus === RESULTS.GRANTED) {
        return {
          granted: true,
          status: currentStatus,
          canAskAgain: true,
          message: `${type} permission already granted`,
        };
      }

      if (currentStatus === RESULTS.BLOCKED) {
        return {
          granted: false,
          status: currentStatus,
          canAskAgain: false,
          message: `${type} permission is blocked. Please enable it in settings.`,
        };
      }

      // Request permission
      const requestStatus = await request(permission);
      
      return {
        granted: requestStatus === RESULTS.GRANTED,
        status: requestStatus,
        canAskAgain: requestStatus !== RESULTS.BLOCKED,
        message: this.getStatusMessage(requestStatus, type),
      };
    } catch (error) {
      console.error(`Error requesting ${type} permission:`, error);
      return {
        granted: false,
        status: RESULTS.UNAVAILABLE,
        canAskAgain: false,
        message: `Failed to request ${type} permission`,
      };
    }
  }

  /**
   * Request camera permission specifically for scanning
   */
  public async requestCameraPermission(): Promise<PermissionResult> {
    const result = await this.requestPermission('camera');
    
    if (!result.granted && !result.canAskAgain) {
      this.showPermissionBlockedDialog('camera');
    }
    
    return result;
  }

  /**
   * Request multiple permissions at once
   */
  public async requestMultiplePermissions(
    types: ('camera' | 'microphone' | 'storage')[]
  ): Promise<Record<string, PermissionResult>> {
    const results: Record<string, PermissionResult> = {};
    
    for (const type of types) {
      results[type] = await this.requestPermission(type);
    }
    
    return results;
  }

  /**
   * Get human-readable message for permission status
   */
  private getStatusMessage(status: PermissionStatus, type: string): string {
    switch (status) {
      case RESULTS.GRANTED:
        return `${type} permission granted`;
      case RESULTS.DENIED:
        return `${type} permission denied`;
      case RESULTS.BLOCKED:
        return `${type} permission blocked. Please enable in settings.`;
      case RESULTS.UNAVAILABLE:
        return `${type} permission unavailable on this device`;
      case RESULTS.LIMITED:
        return `${type} permission granted with limitations`;
      default:
        return `Unknown ${type} permission status`;
    }
  }

  /**
   * Show dialog for blocked permissions
   */
  public showPermissionBlockedDialog(type: string): void {
    const title = `${type.charAt(0).toUpperCase() + type.slice(1)} Permission Blocked`;
    const message = `This app needs ${type} access to function properly. Please enable ${type} permission in your device settings.`;
    
    Alert.alert(
      title,
      message,
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
   * Show dialog for camera-specific errors
   */
  public showCameraErrorDialog(error: string): void {
    let title = 'Camera Error';
    let message = error;
    let actions = [
      {
        text: 'OK',
        style: 'cancel' as const,
      },
    ];

    if (error.includes('CAMERA_ERROR')) {
      title = 'Camera Device Error';
      message = 'The camera device encountered an error. This may be due to the camera being used by another app or a hardware issue.';
      actions = [
        {
          text: 'Cancel',
          style: 'cancel' as const,
        },
        {
          text: 'Retry',
          onPress: () => {
            // Caller should handle retry logic
            console.log('Camera retry requested');
          },
        },
      ];
    } else if (error.includes('Function not implemented')) {
      title = 'Camera Feature Unavailable';
      message = 'Some camera features are not supported on this device. Basic scanning functionality should still work.';
    } else if (error.includes('Access denied')) {
      title = 'Camera Access Denied';
      message = 'Camera access was denied. Please check app permissions in your device settings.';
      actions = [
        {
          text: 'Cancel',
          style: 'cancel' as const,
        },
        {
          text: 'Open Settings',
          onPress: () => {
            Linking.openSettings();
          },
        },
      ];
    }

    Alert.alert(title, message, actions);
  }

  /**
   * Check if the device has camera hardware
   */
  public async hasCameraHardware(): Promise<boolean> {
    try {
      const permission = this.getPermission('camera');
      const status = await check(permission);
      
      // If permission is unavailable, camera hardware might not exist
      return status !== RESULTS.UNAVAILABLE;
    } catch (error) {
      console.error('Error checking camera hardware:', error);
      return false;
    }
  }

  /**
   * Get permission rationale for better UX
   */
  public getPermissionRationale(type: 'camera' | 'microphone' | 'storage'): string {
    switch (type) {
      case 'camera':
        return 'Camera access is required to scan product barcodes and identify food additives.';
      case 'microphone':
        return 'Microphone access may be needed for voice commands and accessibility features.';
      case 'storage':
        return 'Storage access is needed to save scan results and product images.';
      default:
        return `${type} access is required for app functionality.`;
    }
  }
}