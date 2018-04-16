var fs = require('fs');

module.exports = {
  ejecutarOpen: function (req, res){
    const cert = fs.readFileSync('./files/aaa010101aaa_FIEL.cer')
    const {exec} = require('child_process');
    exec('openssl enc -in ./files/aaa010101aaa_FIEL.cer  -a -A -out ./files/aaa010101aaa_FIEL.txt', (err) => {
      if (err) {
        console.error(err);
        return;
      }
    });
  }
}