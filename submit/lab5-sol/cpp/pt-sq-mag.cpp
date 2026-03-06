#include <cassert>
#include <vector>
#include <iostream>

/** output entries of vec with each entry followed by a single space */
template <typename T>
static std::ostream &operator <<(std::ostream &os, const std::vector<T> &vec) {
  for (const auto& entry : vec) {
    os << entry << " ";
  }
  return os;
}


struct Point {
  int x, y;
};

static std::ostream& operator<<(std::ostream& out, const Point& pt) {
  return out << "(" << pt.x << ", " << pt.y << ")";
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


  //TODO: proceed as in int-vec-add.cpp main(): declare points and
  //pt_sq_mag vectors.  foreach pair of values x, y in ints, push
  //constructed point (constructed using Point(x, y)) onto points and
  //the square of the magnitude of the point onto pt_sq_mag.  Finally
  //print out points and pt_sq_mag (each followed by an endl).


}
