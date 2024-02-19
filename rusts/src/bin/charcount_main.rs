use std::env;
use std::fs::File;
use std::io::{self, Read};

fn main() -> io::Result<()> {
    let args: Vec<String> = env::args().collect();
    let mut buffer = Vec::new();

    let mut stream: Box<dyn Read> = if args.len() < 2 {
        println!("Reading character count from stdin");
        // Read from stdin
        Box::new(io::stdin())
    } else {
        // Read from file
        Box::new(File::open(&args[1])?)
    };
    stream.read_to_end(&mut buffer)?;

    // let num_chars = String::from_utf8(buffer).unwrap().chars().count();
    match String::from_utf8(buffer) {
        Ok(s) => {
            println!("Number of characters: {}", s.chars().count());
            Ok(())
        },
        Err(e) => {
            println!("Error: {}", e);
            Result::Err(io::Error::new(io::ErrorKind::Other, "Invalid UTF-8"))
        }
    }
}
