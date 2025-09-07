import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/notification_service.dart';
import '../../profile/providers/profile_provider.dart';
import '../models/product_model.dart';
import '../models/scan_history_model.dart';

enum ScanState {
  idle,
  scanning,
  processing,
  success,
  error,
}

class ScanProvider extends ChangeNotifier {
  final ApiService _apiService;
  final MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  
  ScanState _state = ScanState.idle;
  ProductModel? _currentProduct;
  String? _errorMessage;
  bool _isProcessing = false;
  
  // Getters
  ScanState get state => _state;
  ProductModel? get currentProduct => _currentProduct;
  String? get errorMessage => _errorMessage;
  bool get isProcessing => _isProcessing;
  
  ScanProvider(this._apiService);
  
  void startScanning() {
    _state = ScanState.scanning;
    _errorMessage = null;
    _currentProduct = null;
    notifyListeners();
  }
  
  void stopScanning() {
    _state = ScanState.idle;
    notifyListeners();
  }
  
  Future<void> processBarcode(String barcode, ProfileProvider profileProvider) async {
    if (_isProcessing) return;
    
    _isProcessing = true;
    _state = ScanState.processing;
    notifyListeners();
    
    try {
      // Fetch product from API
      final product = await _apiService.getProductByBarcode(barcode);
      
      if (product == null) {
        _state = ScanState.error;
        _errorMessage = 'Product not found in database';
        _isProcessing = false;
        notifyListeners();
        return;
      }
      
      // Calculate risk level based on user's avoid list
      final avoidList = await DatabaseService.instance.getAvoidList();
      final calculatedRiskLevel = product.calculateRiskLevel(avoidList);
      
      _currentProduct = product;
      _state = ScanState.success;
      
      // Save to scan history
      await _saveScanHistory(product, calculatedRiskLevel);
      
      // Log analytics
      await AnalyticsService.instance.logScanEvent(
        barcode: barcode,
        productName: product.name,
        riskLevel: calculatedRiskLevel,
      );
      
      // Update scan count
      profileProvider.incrementScanCount();
      
      // Show notification if high risk
      if (calculatedRiskLevel == 'high') {
        await NotificationService.instance.showHighRiskProductNotification(
          product.name,
        );
      }
      
      _isProcessing = false;
      notifyListeners();
    } catch (e) {
      print('Error processing barcode: $e');
      _state = ScanState.error;
      _errorMessage = 'Failed to process barcode. Please try again.';
      _isProcessing = false;
      notifyListeners();
    }
  }
  
  Future<void> _saveScanHistory(ProductModel product, String riskLevel) async {
    try {
      final scan = ScanHistoryModel(
        barcode: product.barcode,
        productName: product.name,
        brand: product.brand,
        imageUrl: product.imageUrl,
        riskLevel: riskLevel,
        harmfulAdditives: product.additives,
        scanDate: DateTime.now(),
      );
      
      await DatabaseService.instance.insertScanHistory(scan);
    } catch (e) {
      print('Error saving scan history: $e');
    }
  }
  
  void reset() {
    _state = ScanState.idle;
    _currentProduct = null;
    _errorMessage = null;
    _isProcessing = false;
    notifyListeners();
  }
  
  Future<void> toggleTorch() async {
    await scannerController.toggleTorch();
    notifyListeners();
  }
  
  Future<void> switchCamera() async {
    await scannerController.switchCamera();
    notifyListeners();
  }
  
  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }
}