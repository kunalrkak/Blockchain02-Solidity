pragma solidity 0.4.19;

string private greeting;

function Greeter(string _greeter) public {
    greeting = _greeter;
}

function greet() public view returns (string) {
    return greeting;
}
}
