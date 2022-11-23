use crate::webp::shared::*;
use webp::{AnimDecoder, BitstreamFeatures};

pub struct Decoder<'a> {
    data: &'a [u8],
    decoder: AnimDecoder<'a>,
}

impl<'a> Decoder<'a> {
    pub fn new(data: &'a [u8]) -> Self {
        Self {
            data,
            decoder: AnimDecoder::new(data),
        }
    }

    pub fn into_frames(&self) -> Vec<Frame> {
        let decoded = self.decoder.decode().unwrap();
        decoded
            .into_iter()
            .map(|frame| {
                Frame::new(
                    frame.get_image().to_owned(),
                    frame.width(),
                    frame.height(),
                    frame.get_time_ms(),
                )
            })
            .collect()
    }

    pub fn is_animated(&self) -> bool {
        let features = BitstreamFeatures::new(self.data).expect("bytes are not a valid webp");
        features.has_animation()
    }
}
