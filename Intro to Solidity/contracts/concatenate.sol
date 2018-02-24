pragma solidity 0.4.19;


contract Concatenate {
    function concatWithoutImport(string _s, string _t) public returns (string) {
      bytes memory ba = bytes(_s);
      bytes memory bb = bytes(_t);
      string memory AandB = new string(ba.length + bb.length);
      bytes memory bAandB = bytes(AandB);

      uint k = 0;
      for (uint i = 0; i < ba.length; i++) bAandB[k++] = ba[i];
      for (i = 0; i < bb.length; i++) bAandB[k++] = bb[i];

      return string(bAandB);
    }

    /* BONUS */
    function concatWithImport(string s, string t) public returns (string) {
    }
}
