import 'package:dragonchain_sdk/dragonchain_sdk.dart';

getDragonchainClient() async {
  return DragonchainClient.createClient(
      dragonchainId: 'cMDSkmhMo2g6XDG4wFqp3HvPuoKa4nbgHgm6PUxRtkQ2',
      authKey: 'RuAFZUVnLyylvq7uUHr6gwhlHtUsOtOsR5KzsAxTZkT',
      authKeyId: 'GUQMWMMYZEZV');
}

String smartContractId = '69237036-ee50-4e9c-96af-bee563d245eb';
String transactionType = 'assetTracker';
