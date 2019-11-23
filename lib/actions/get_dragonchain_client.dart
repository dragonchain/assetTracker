import 'package:dragonchain_sdk/dragonchain_sdk.dart';

getDragonchainClient() async {
  return DragonchainClient.createClient(
      dragonchainId: 'bwi8oUzfAKwXWgwCnKHabemnzkvHCFfkUkwgXYMNhmxr',
      authKey: 'D06Cirbq5D4ZZsk0tPgaiD4vS62fGROLWXM2kTLSl0U',
      authKeyId: 'JJCUTFCGSUOV');
}

String smartContractId = '3355df39-53b6-4d6b-853e-06de8f424238';
String transactionType = 'assetTracker';
