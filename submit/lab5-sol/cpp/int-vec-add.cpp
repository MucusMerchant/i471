#include <cassert>
#include <vector>
#include <iostream>

template <typename T>
static std::ostream &operator <<(std::ostream &os, const std::vector<T> &vec) {
  for (const auto& entry : vec) {
    os << entry << " ";
  }
  return os;
}

/** Return vector<int> containing all int's read from stdin */
static std::vector<int> read_ints() {
  std::vector<int> ints(0); //no elements
  bool is_done = false;
  do {
    int val;
    std::cin >> val;
    is_done = std::cin.eof();
    if (!is_done) ints.push_back(val);
  } while (!is_done);
  return ints;
}

int main() {
  std::vector<int> ints = read_ints();
  assert(ints.size() % 2 == 0);

  
  std::vector<int> vec1(0);
  std::vector<int> vec2(0);
  std::vector<int> sum(0);
  
  for (unsigned i = 0; i < ints.size(); i += 2) {
    int val1 = ints[i], val2 = ints[i + 1];
    vec1.push_back(val1);
    vec2.push_back(val2);
    sum.push_back(val1 + val2);
  }

  std::cout << vec1 << std::endl;
  std::cout << vec2 << std::endl;
  std::cout << sum << std::endl;
}
