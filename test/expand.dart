void main() {
  var pairs = [[1, 2], [3, 4], 5, 6];
  var flattened = pairs.expand((pair) => pair).toList();
  print(flattened);
}
