// Rust program to find a prime number between x and y, where x and y are command line arguments

use std::env;

// Function to check if a number is prime
fn is_prime(n: u64) -> bool {
    // loop through 2 to sqrt(n) (inclusive)
    let sqrtn = ((n as f64).sqrt() + 0.1).trunc() as u64;
    if n < 2 {
        return false;
    }
    for i in 2..sqrtn {
        if n % i == 0 {
            return false;
        }
    }
    return true;
}

fn main() {
    // Collect command line arguments
    let args: Vec<String> = env::args().collect();

    // Check for the correct number of arguments
    if args.len() < 3 {
        eprintln!("Usage: prime_finder <x> <y>");
        std::process::exit(1);
    }

    // Parse the command line arguments to numbers
    let x = args[1].parse::<u64>().expect("Please provide a valid number for x");
    let y = args[2].parse::<u64>().expect("Please provide a valid number for y");

    // Find and print prime numbers between x and y
    for num in x..=y {
        if is_prime(num) {
            println!("{}", num);
        }
    }
}

