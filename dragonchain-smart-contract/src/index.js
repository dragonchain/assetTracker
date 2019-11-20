/**
 * Hi there!
 * You most likely do not want to edit this file.
 *
 * This file is the "wrapper" for your smart contract.
 * The Dragonchain process which invokes this code will
 * pass input to this index.js file via STDIN.
 *
 * This file's sole purpose is to give that input to your
 * SmartContract located in the ./contract/handler.js file.
 *
 * You probably want to edit the business logic there.
 */

const getStdin = require('get-stdin');
const handler = require('./contract/handler');

async function main() {
  const val = await getStdin(); // <-- get input from the blockchain contract invoker.
  try {
    const res = await handler(val); // <-- execute your smart contract.
    process.stdout.write(JSON.stringify(res)); // <-- give the output back to the invoker to modify any state.
  } catch (err) {
    return console.error(err); // <-- log any errors.
  }
}

main().catch(console.error);
