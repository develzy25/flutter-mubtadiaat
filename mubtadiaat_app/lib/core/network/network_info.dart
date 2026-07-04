abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  // In a real app, use internet_connection_checker or connectivity_plus
  // For now, always return true as a placeholder
  @override
  Future<bool> get isConnected async => true;
}
