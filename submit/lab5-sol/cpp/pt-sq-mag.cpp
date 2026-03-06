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

  std::vector<Point> points(0);
  std::vector<int> pt_sq_mag(0);
  assert(ints.size()%2 == 0);

  for (unsigned i = 0; i < ints.size(); i += 2) {
    int val1 = ints[i], val2 = ints[i + 1];
    points.push_back(Point(val1, val2));
    pt_sq_mag.push_back(val1*val1 + val2*val2);
  }
  std::cout << points << std::endl;
  std::cout << pt_sq_mag << std::endl;

}
