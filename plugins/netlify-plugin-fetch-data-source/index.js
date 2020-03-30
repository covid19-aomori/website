module.exports = {
  onPreBuild: () => {
    const rp = require('request-promise')
    const fs = require('fs')

    const url =
      'https://covid19-aomori-production-dataset-store.s3-ap-northeast-1.amazonaws.com/data.json'
    const file = fs.createWriteStream('./data/data.json')
    rp(url).pipe(file)
  }
}
