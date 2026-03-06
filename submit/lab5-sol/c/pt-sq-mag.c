#include <assert.h>
#include <errno.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct {
  size_t capacity; //# of ints which can be stored without realloc
  size_t length;   //current # of stored ints
  int *buffer;    //buffer[capacity] with buffer[length] valid
} IntVec;

/** Add value at end of vec */
static void
push_int_vec(IntVec *vec, int value)
{
  enum { INIT_CAPACITY = 2 }; //small init-value for debugging
  if (vec->length >= vec->capacity) {
    assert(vec->length == vec->capacity);
    size_t new_capacity = vec->capacity == 0 ? INIT_CAPACITY : 2*vec->capacity;
    vec->buffer = realloc(vec->buffer, new_capacity*sizeof(int));
    if (vec->buffer == NULL) {
      fprintf(stderr, "cannot realloc vec[%zu]: %s", new_capacity,
              strerror(errno));
      exit(1);
    }
    vec->capacity = new_capacity;
  }
  assert(vec->length < vec->capacity);
  vec->buffer[vec->length++] = value;
}

/** Return IntVec containing all int's read from stdin */
static IntVec read_ints() {
  FILE *in = stdin;
  IntVec ints = {0}; //all fields initialized to 0
  bool is_done = false;
  do {
    int val;
    is_done = (fscanf(in, "%d", &val) != 1);
    if (!is_done) push_int_vec(&ints, val);
  } while (!is_done);
  return ints;
}

/** Write each int in vec on stdout followed by space.  Output a
 *  newline after all the int's have been written.
 */
static void out_int_vec(FILE *out, const IntVec *vec) {
  enum { VAL_WIDTH = 6 };
  for (int i = 0; i < vec->length; i++) {
    fprintf(out, "%d ", vec->buffer[i]);
  }
  fprintf(out, "\n");
}

typedef struct {
  int x, y;
} Point;

typedef struct {
  size_t capacity; //# of ints which can be stored without realloc
  size_t length;   //current # of stored ints
  Point *buffer;   //buffer[capacity] with buffer[length] valid
} PointVec;


/** Add point at end of vec */
static void
push_point_vec(PointVec *vec, Point point)
{
  //TODO: copy in push_int_vec() definition and make appropriate changes
}


/** Write each point in vec on stdout as (x, y) followed by space;
 *  Output a newline after all the point's have been written.
 */
static void out_point_vec(FILE *out, const PointVec *vec) {
  enum { VAL_WIDTH = 6 };
  for (int i = 0; i < vec->length; i++) {
    fprintf(out, "(%d, %d) ", vec->buffer[i].x, vec->buffer[i].y);
  }
  fprintf(out, "\n");
}

int main() {
  IntVec ints = read_ints();
  assert(ints.length%2 == 0);

  PointVec points = {0};  //init all fields to zero
  IntVec pt_sq_mag = {0};
  for (unsigned i = 0; i < ints.length; i += 2) {
    int val1 = ints.buffer[i], val2 = ints.buffer[i + 1];
    push_point_vec(&points, (Point) { .x=val1, .y=val2});
    push_int_vec(&pt_sq_mag, val1*val1 + val2*val2);
  }

  out_point_vec(stdout, &points);
  out_int_vec(stdout, &pt_sq_mag);


  free(ints.buffer);
  free(points.buffer);
  free(pt_sq_mag.buffer);

}
