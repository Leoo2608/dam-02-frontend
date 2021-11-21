class APIResponse<T>{
  T data;
  bool error = false;
  String? errorMessage = '';

  APIResponse({required this.data ,this.errorMessage, this.error = false});
}