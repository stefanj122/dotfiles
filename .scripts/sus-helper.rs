use std::process::Command;
use std::thread;
use std::time::Duration;

fn main() {
    thread::sleep(Duration::from_secs(3));
    kill_multiple_instance("xidlehook")
}

fn kill_multiple_instance(instance: &str) {
    let cmd = Command::new("pgrep")
        .args(["-fc", instance])
        .output()
        .unwrap();
    let mut string = String::from_utf8(cmd.stdout).unwrap();
    string.pop();
    let count = string.parse::<i32>().unwrap();
    for _i in 1..count {
        Command::new("pkill")
            .args(["-n", instance])
            .output()
            .unwrap();
    }
}
