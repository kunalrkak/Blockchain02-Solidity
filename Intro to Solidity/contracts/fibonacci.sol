pragma solidity 0.4.19;


contract Fibonacci {
    /* Carry out calculations to find the nth Fibonacci number */
    function fibRecur(uint n) public pure returns (uint) {
      if (n < 2)
          return 1;
      return recursive(n-1) + recursive(n-2);
    }

    /* Carry out calculations to find the nth Fibonacci number */
    function fibIter(uint n) public returns (uint) {
      int i = 1;
      int j = 1;

      if (n < 2)
          return 1;

      for (int k = 2; k <= n; k++) {
          int temp = i;
          i += j;
          j = temp;
      }

      return i;
    }
}
