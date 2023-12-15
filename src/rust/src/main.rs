use std::env;
use std::fs::read;
use std::fs::write;
use std::path::Path;

use crate::webp::encode::EncodingConfig;
use api::*;

mod api;
mod webp;

const TARGET_FILE_SIZE: u32 = 500_000;

fn main() {
    let args: Vec<String> = env::args().collect();
    let path = Path::new(&args[1]);
    let bytes = read(path).unwrap();
    let size_in_kb = bytes.len() as f32 / 1024.;

    let frames = into_frames(bytes);

    let translucency = calc_translucency(frames.clone());

    println!("translucency is {translucency:.10}");
    println!("file size is {size_in_kb:.2}KB");

    let is_small_file = size_in_kb <= 100.;

    let config = EncodingConfig {
        losless: is_small_file,
        method: 4,
        quality: 100.,
        target_size: (TARGET_FILE_SIZE as f32 / frames.len() as f32) as i32,
        pass: 6,
        alpha_compression: true,
        alpha_quality: 0, //TODO: calc from translucency
        ..Default::default()
    };

    let frames = upscale_frames_with_padding(frames, 512, 512);
    let bytes = encode(frames, config);
    let size_in_kb = bytes.len() as f32 / 1024.;
    println!("produced an output of {size_in_kb:.2}KB");
    write(
        path.file_stem().unwrap().to_str().unwrap().to_owned() + "_sticker.webp",
        bytes,
    )
    .expect("Failed to write bytes to file");
}
