import 'package:dragonchain_sdk/dragonchain_sdk.dart';

getDragonchainClient() async {
  return DragonchainClient.createClient(
      dragonchainId: 'cMDSkmhMo2g6XDG4wFqp3HvPuoKa4nbgHgm6PUxRtkQ2',
      endpoint: 'https://5d911ea2-1e04-42d2-802c-3a6dd5e1f175.api.dragonchain.com',
      authKey: 'RuAFZUVnLyylvq7uUHr6gwhlHtUsOtOsR5KzsAxTZkT',
      authKeyId: 'GUQMWMMYZEZV');
}

String smartContractId = '69237036-ee50-4e9c-96af-bee563d245eb';
String transactionType = 'assetTracker';
