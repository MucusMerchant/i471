use std::io::{self, Read};

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
fn vec_str<T: ToString>(vec: &Vec<T>) -> String {
    vec.into_iter()
	.map(|v| v.to_string())
	.collect::<Vec<String>>()
	.join(" ")
}

fn main() {
    let ints = read_ints();
    assert!(ints.len()%2 == 0);
    let mut v1: Vec<i32> = Vec::new();
    let mut v2: Vec<i32> = Vec::new();
    let mut sum: Vec<i32> = Vec::new();
    for i in (0..ints.len()).step_by(2) {
	let i1 = ints[i];
	let i2 = ints[i + 1];
	v1.push(i1); v2.push(i2);
	sum.push(i1 + i2);
    }
    
    println!("{}", vec_str(&v1));
    println!("{}", vec_str(&v2));
    println!("{}", vec_str(&sum));
}
