use rand::seq::SliceRandom;
use std::env;
use std::io::{self, BufRead};

fn main() {
    let k: usize = env::args().nth(1).and_then(|s| s.parse().ok()).unwrap_or(1);
    let lines: Vec<String> = io::stdin().lock().lines().filter_map(Result::ok).collect();
    let results = lines.choose_multiple(&mut rand::thread_rng(), k);
    for line in results {
        println!("{}", line);
    }
}
