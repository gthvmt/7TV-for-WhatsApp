pub use crate::webp::{decode::*, encode::*, shared::*};

use fast_image_resize as fr;
use std::cmp::max;
use std::num::NonZeroU32;

pub fn into_frames(bytes: Vec<u8>) -> Vec<Frame> {
    Decoder::new(bytes.as_slice()).into_frames()
}

pub fn upscale_frames_with_padding(
    frames: Vec<Frame>,
    width: u32,
    height: u32,
    config: EncodingConfig,
) -> Vec<u8> {
    println!("number of frames: {}", frames.len());

    println!("resizing frames...");

    let mut processed_frames: Vec<Frame> = Vec::new();
    for frame in frames.into_iter() {
        let frame_bytes = frame.data.to_vec();

        let resized = padded_resize(
            frame_bytes,
            NonZeroU32::new(frame.width).unwrap(),
            NonZeroU32::new(frame.height).unwrap(),
            NonZeroU32::new(width).unwrap(),
            NonZeroU32::new(height).unwrap(),
        );

        processed_frames.push(Frame::new(resized, width, height, frame.timestamp));
    }

    let encoder = Encoder::new(processed_frames, config);
    println!("encoding bytes...");
    let encoded_bytes = encoder.encode();

    encoded_bytes.to_vec()
}

fn padded_resize(
    image: Vec<u8>,
    cur_width: NonZeroU32,
    cur_height: NonZeroU32,
    new_width: NonZeroU32,
    new_height: NonZeroU32,
) -> Vec<u8> {
    let (dst_view_width, dst_view_height) = resize_dimensions(
        cur_width.get(),
        cur_height.get(),
        new_width.get(),
        new_height.get(),
    );

    let source = fr::Image::from_vec_u8(cur_width, cur_height, image, fr::PixelType::U8x4)
        .expect("Failed to create image from bytes");

    let dst_width = new_width.get();
    let dst_height = new_height.get();

    let mut destination = fr::Image::new(
        NonZeroU32::new(dst_width).unwrap(),
        NonZeroU32::new(dst_height).unwrap(),
        source.pixel_type(),
    );

    let padding_x = (dst_width - dst_view_width) as f32 / 2.;
    let padding_y = (dst_height - dst_view_height) as f32 / 2.;
    let padding_top = (padding_y).ceil();
    let padding_bottom = (padding_y).floor();
    let padding_left = (padding_x).floor();
    let padding_right = (padding_x).ceil();

    let pixels = unsafe {
        destination
            .buffer_mut()
            .align_to_mut::<fr::pixels::U8x4>()
            .1
    };
    let mut destination_view = get_padded_view(
        pixels,
        dst_width as usize,
        dst_height as usize,
        padding_top as usize,
        padding_bottom as usize,
        padding_left as usize,
        padding_right as usize,
    );

    let mut resizer = fr::Resizer::new(fr::ResizeAlg::Nearest);
    resizer
        .resize(&source.view(), &mut destination_view)
        .expect("failed to resize image");
    destination.buffer().to_owned()
}
pub fn calc_translucency(frames: Vec<Frame>) -> f32 {
    let mut trans = vec![];
    for frame in frames {
        let buffer: image::RgbaImage =
            image::ImageBuffer::from_raw(frame.width, frame.height, frame.data.clone())
                .expect("Failed to create image buffer from bytes");
        let translucency: Vec<bool> = buffer
            .pixels()
            .map(|p| -> bool {
                let alpha = p[3];
                alpha < 255 && alpha > 0
            })
            .collect();
        let translucency_count = translucency
            .iter()
            .filter(|is_translucent| **is_translucent)
            .count();
        let translucency: f32 = translucency_count as f32 / translucency.len() as f32;
        trans.push(translucency);
    }
    trans.iter().sum::<f32>() / trans.len() as f32
}

fn resize_dimensions(width: u32, height: u32, nwidth: u32, nheight: u32) -> (u32, u32) {
    let wratio = nwidth as f64 / width as f64;
    let hratio = nheight as f64 / height as f64;

    let ratio = f64::min(wratio, hratio);

    let nw = max((width as f64 * ratio).round() as u64, 1);
    let nh = max((height as f64 * ratio).round() as u64, 1);

    if nw > u64::from(u32::MAX) {
        let ratio = u32::MAX as f64 / width as f64;
        (u32::MAX, max((height as f64 * ratio).round() as u32, 1))
    } else if nh > u64::from(u32::MAX) {
        let ratio = u32::MAX as f64 / height as f64;
        (max((width as f64 * ratio).round() as u32, 1), u32::MAX)
    } else {
        (nw as u32, nh as u32)
    }
}

fn get_padded_view(
    pixels: &mut [fr::pixels::U8x4],
    width: usize,
    height: usize,
    top: usize,
    bottom: usize,
    left: usize,
    right: usize,
) -> fr::DynamicImageViewMut {
    let rows: Vec<&mut [fr::pixels::U8x4]> = pixels
        .chunks_exact_mut(width)
        .skip(top)
        .take(height - top - bottom)
        .map(|row| &mut row[left..width - right])
        .collect();
    let dst_width = NonZeroU32::new((width - left - right) as u32).unwrap();
    let dst_height = NonZeroU32::new((height - top - bottom) as u32).unwrap();
    let image_view = fr::ImageViewMut::new(dst_width, dst_height, rows).unwrap();
    image_view.into()
}
