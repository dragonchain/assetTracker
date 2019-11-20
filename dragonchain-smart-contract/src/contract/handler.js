const sdk = require('dragonchain-sdk');

const log = (string) => console.error(`STDERR: ${string}`);

module.exports = async input => {
  const client = await sdk.createClient();

  const { method, params } = JSON.parse(input).payload;

  let output = {};

  if (method === 'appendItem') {
    const { barcode } = params;
    const barcodeRes = await client.getSmartContractObject({ key: barcode });
    const allItems = await client.getSmartContractObject({ key: 'allItems' });
    if (barcodeRes.status === 404) {
      output[barcode] = [params];
    } else {
      const barcodeArray = JSON.parse(barcodeRes.response);
      barcodeArray.push(params);
      output[barcode] = barcodeArray;
    }
    if (allItems.status === 404) {
      output['allItems'] = [barcode];
    } else {
      const allItemsArray = JSON.parse(allItems.response);
      allItemsArray.push(params);
      output['allItems'] = allItemsArray;
    }
  }

  if (method === 'deleteItem') {
    const {barcode} = params;
    const {response, status} = await client.getSmartContractObject({key: 'allItems'});
    if (status !== 404) {
      const itemArray = JSON.parse(response);
      output['allItems'] = itemArray.filter(x => x !== barcode);
    }
    output[barcode] = [];
  }

  return output;
};
