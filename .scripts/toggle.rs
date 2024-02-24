// mod main;

use std::{format, process::Command, thread, time::Duration};

fn main() {
    loop {
        let touchpad = get_id("Touchpad");
        let mouse = get_id("Haste  ");

        if mouse != 0 {
            let args = [
                format!("{}", touchpad),
                "Device Enabled".to_string(),
                "0".to_string(),
            ];
            spawn_comand(&args);
            mouse_setup(&mouse);
        } else {
            let args = [
                format!("{}", touchpad),
                "Device Enabled".to_string(),
                "1".to_string(),
            ];
            spawn_comand(&args);
            touchpad_setup(&touchpad);
        }
        thread::sleep(Duration::from_secs(1));
    }
}

fn get_id(name: &str) -> i32 {
    let test = Command::new("xinput").output().unwrap();
    let vec = test.stdout;
    let string1 = String::from_utf8(vec).unwrap();
    let string: Vec<&str> = string1.split('\n').collect();

    let test1 = match string.iter().find(|x| x.contains(name)) {
        Some(x) => x,
        None => return 0,
    };
    let res: Vec<&str> = test1.split('\t').collect();
    let res1: Vec<&str> = res[1].split('=').collect();
    match res1[1].parse::<i32>() {
        Ok(i) => return i,
        Err(_) => return 0,
    }
}

fn kill_multiple_instance(instance: &str) {
    let test = Command::new("pgrep")
        .args(["-fc", instance])
        .output()
        .unwrap();
    // println!("{}", test);
}

fn spawn_comand(args: &[String]) {
    Command::new("xinput")
        .args(["set-prop".to_string()])
        .args(args)
        .output()
        .expect("");
}

fn mouse_setup(mouse: &i32) {
    let args1 = [
        mouse.to_string(),
        "libinput Accel Speed".to_string(),
        "0.25".to_string(),
    ];
    let args2 = [
        mouse.to_string(),
        "libinput Accel Profile Enabled".to_string(),
        "0,".to_string(),
        "1,".to_string(),
        "0".to_string(),
    ];
    spawn_comand(&args1);
    spawn_comand(&args2);
}

fn touchpad_setup(touchpad: &i32) {
    let args1 = [
        touchpad.to_string(),
        "libinput Natural Scrolling Enabled".to_string(),
        "1".to_string(),
    ];
    let args2 = [
        touchpad.to_string(),
        "libinput Tapping Enabled".to_string(),
        "1".to_string(),
    ];
    spawn_comand(&args1);
    spawn_comand(&args2);
}
