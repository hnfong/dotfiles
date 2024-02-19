use zilib::cantonese;

fn main() {
    // Get the jyutping from each line of stdin

    // For each line of stdin:
    loop {
        let mut s = String::new();
        let did_read = std::io::stdin().read_line(&mut s).unwrap();
        if did_read == 0 {
            break;
        }
        let line = s.trim();

        // Get the jyutping
        let jyutping = cantonese::get_ping3jam1(&line);
        // Print the jyutping
        println!("{}", jyutping);
    }
}
