// Generic API Response wrapper class
class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool isSuccess;
  final bool isLoading;

  ApiResponse.success(this.data)
    : message = null,
      isSuccess = true,
      isLoading = false;

  ApiResponse.error(this.message)
    : data = null,
      isSuccess = false,
      isLoading = false;

  ApiResponse.loading()
    : data = null,
      message = null,
      isSuccess = false,
      isLoading = true;

  // Add isError getter to match usage in ScanProductScreen
  bool get isError => !isSuccess;
}
