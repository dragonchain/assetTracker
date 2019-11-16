// // import 'dart:typed_data'; // remove?

// import 'package:crypto/crypto.dart';
// import 'dart:convert'; // for the utf8.encode method

// class DragonchainSdk {
//   String algorithm, dragonchainId, authKey, authKeyId;
//   Hmac hashMethod;

//   DragonchainSdk(String dragonchainId, String authKey, String authKeyId,
//       {String algorythm = 'SHA256'}) {
//     this.algorithm = 'SHA256';
//     this.hashMethod = getHashMethod(this.algorithm);
//   }

//   updateAlgorythm(String algorithm) {
//     this.hashMethod = this.getHashMethod(algorithm);
//     this.algorithm = algorithm;
//     // logger.debug("Updated hashing algorithm to {}".format(algorithm))
//   }

//   Hmac getHashMethod(String algorithm) {
//     var key = utf8.encode(this.authKey);
//     if (algorithm == "SHA256") {
//       return new Hmac(sha256, key);
//     }
//     throw new FailureByDesign("$algorithm is not a supported hash algorithm.");
//   }

//   bytesToBase64String(List<int> unencodedBytes) {
//     return base64.encode(unencodedBytes);
//   }

//   getAuthorization(String httpVerb, String path, String timestamp,
//       {String contentType = "", String content = ""}) {
//     var messageString = this.hmacMessageString(httpVerb, path, timestamp,
//         contentType: contentType, content: content);
//     var digest = this.hashInput(messageString);
//     var hmac = this.bytesToBase64String(digest.bytes);
//     return "DC1-HMAC-{${this.algorithm}} {${this.authKeyId}}:{$hmac}";
//   }

//   List<int> bytesFromInput(dynamic inputData) {
//     if (inputData is String) {
//       return utf8.encode(inputData);
//     }
//     if (inputData is List<int>) {
//       return inputData;
//     }
//     throw new FailureByDesign(
//         'Parameter "input_data" must be of type str or bytes.');
//   }

//   Digest hashInput(dynamic inputData) {
//     return this.hashMethod.convert(this.bytesFromInput(inputData));
//   }

//   String hmacMessageString(String httpVerb, String path, String timestamp,
//       {String contentType = "", dynamic content = ""}) {
//     return "{${httpVerb.toUpperCase()}}\n{$path}\n{${this.dragonchainId}}\n{$timestamp}\n{$contentType}\n{${this.bytesToBase64String(this.hashInput(content).bytes)}}";
//   }
// }

// class FailureByDesign implements Exception {
//   String code;
//   FailureByDesign(String code) {
//     this.code = code;
//   }
// }
