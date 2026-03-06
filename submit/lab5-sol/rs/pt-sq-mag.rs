use std::io::{self, Read};
use std::fmt;

/** Return Vec<i32> containing all int's read from stdin */
fn read_ints() -> Vec<i32> {
    let mut stdin_str = String::new();
    io::stdin().read_to_string(&mut stdin_str).unwrap();
    let ints: Vec<i32> =  stdin_str
	.split_whitespace()
	.map(|s| s.parse().unwrap())
	.collect();
    ints
}

/** Convert vec into a string having the string representation of
 *  each entry separated by space.
 */
#[allow(dead_code)]
fn vec_str<T: ToString>(vec: &Vec<T>) -> String {
    vec.into_iter()
	.map(|v| v.to_string())
	.collect::<Vec<String>>()
	.join(" ")
}

#[allow(dead_code)]
struct Point {
    x: i32,
    y: i32,
}

/** Convert a Point into a string for display */
impl fmt::Display for Point {
    
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
	write!(f, "({}, {})", self.x, self.y)
    }
}

fn main() {
    let ints = read_ints();
    assert!(ints.len()%2 == 0);
    
    //TODO: proceed as in int-vec-add.rs main(): declare points and
    //pt_sq_mag vectors.  foreach pair of values x, y in ints, push
    //constructed point (constructed using Point {x: x, y: y } onto
    //points and the square of the magnitude of the point onto
    //pt_sq_mag.  Finally println points and pt_sq_mag.

}
