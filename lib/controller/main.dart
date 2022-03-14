import 'extensions.dart';

// BigInt generateAttack(BigInt sld, BigInt occ, BigInt? mask) {
//   BigInt leftAttacks = occ ^ (occ - BigInt.two * sld);
//   BigInt rightAttacks =
//       occ ^ (occ.reverse() - BigInt.two * sld.reverse()).reverse();
//   return leftAttacks ^ rightAttacks;
// }

BigInt getLineAttacks(BigInt s, BigInt o, BigInt m) =>
    (((o & m) - (BigInt.two * s)) ^
        ((o & m).reverse() - (BigInt.two * s.reverse())).reverse()) &
    m;

void main() {
  BigInt occ = BigInt.parse('11000101', radix: 2);
  BigInt sld = BigInt.parse('00000100', radix: 2);
  BigInt msk = BigInt.parse('11111111', radix: 2);

  print(getLineAttacks(sld, occ, msk).toBin());
}
