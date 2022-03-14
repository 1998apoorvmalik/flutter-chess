extension BigIntBinary on BigInt {
  static Map<BigInt, int> pow2Till64 = Map.fromEntries(
      List.generate(64, (index) => index)
          .map((i) => MapEntry(i == 0 ? BigInt.one : BigInt.two << i - 1, i)));

  // Converts to binary.
  String toBin() {
    BigInt number = this;
    List<String> binNum = [];
    while (number > BigInt.zero) {
      binNum.add((number % BigInt.two).toString());
      number = number ~/ BigInt.two;
    }
    return binNum.reversed.join();
  }

  // Get the set (ones) bit indices for a 64 bit integer.
  List<int> getSetBitIndices() {
    BigInt number = this;
    List<int> indices = [];
    while (number > BigInt.zero) {
      indices.add(pow2Till64[number & -number]!);
      number &= number - BigInt.one;
    }
    return indices;
  }

  // Reverse the bits of a given number and returns the new number.
  // Simple method with O(n) time complexity.
  BigInt reverse({int bitLength = 64}) {
    BigInt number = this;
    BigInt reversedNumber = BigInt.zero;
    while (number > BigInt.zero) {
      reversedNumber <<= 1;
      if (number & BigInt.one == BigInt.one) // Equivalent to : number % 2 == 1
      {
        reversedNumber ^= BigInt.one; // Equivalent to : reversedNumber += 1
      }
      number >>= 1; // Equivalent to : number = number ~/ 2
      bitLength--;
    }
    return reversedNumber << bitLength;
  }
}
