use crate::webp::shared::*;
use webp::{AnimEncoder, AnimFrame, WebPConfig, WebPMemory};

pub struct LosslessConfig {
    pub compression: f32,
}

impl LosslessConfig {
    pub fn new(compression: f32) -> Self {
        Self { compression }
    }
}

impl Default for LosslessConfig {
    fn default() -> Self {
        Self { compression: 1. }
    }
}

pub struct LossyConfig {
    pub quality: f32,
    pub target_size: i32,
    pub target_psnr: f32,
    pub segments: u8,      //[0..4]
    pub noise_shaping: u8, //[0..100]
    pub filter: Option<Filter>,
    pub alpha_compression: bool,
    pub alpha_filtering: Option<AlphaFilter>,
    pub alpha_quality: u8, //[0..100]
    pub pass: u8,          //[0..10]
    pub show_compressed: bool,
    pub preprocessing: Option<Preprocessing>,
    pub partitions: u8,      //[0..3]
    pub partition_limit: u8, //[0..100]
    pub use_sharp_yuv: bool,
}

impl Default for LossyConfig {
    fn default() -> Self {
        Self {
            quality: 1.,
            target_size: 0,
            target_psnr: 0.,
            segments: 1,
            noise_shaping: 50,
            filter: Some(Filter::Strong(FilterConfig {
                strength: Some(60),
                sharpness: 0,
            })),
            show_compressed: false,
            alpha_compression: true,
            alpha_filtering: Some(AlphaFilter::Fast),
            alpha_quality: 100,
            preprocessing: None,
            pass: 1,
            partitions: 0,
            partition_limit: 0,
            use_sharp_yuv: false,
        }
    }
}

pub enum Preprocessing {
    SegmentSmooth,
}

pub enum AlphaFilter {
    Fast, //1
    Best, //2
}

pub enum Filter {
    Simple(FilterConfig), //0
    Strong(FilterConfig), //1
}

pub struct FilterConfig {
    pub strength: Option<u8>, //autofilter if None [0..100]
    pub sharpness: u8,        //[0..7]
}

pub struct EncodingConfig {
    pub method: u8, // [0..6]
    pub losless: bool,
    pub quality: f32,
    pub target_size: i32,
    pub target_psnr: f32,
    pub segments: u8,      //[0..4]
    pub noise_shaping: u8, //[0..100]
    pub filter: Option<Filter>,
    pub alpha_compression: bool,
    pub alpha_filtering: Option<AlphaFilter>,
    pub alpha_quality: u8, //[0..100]
    pub pass: u8,          //[0..10]
    pub show_compressed: bool,
    pub preprocessing: Option<Preprocessing>,
    pub partitions: u8,      //[0..3]
    pub partition_limit: u8, //[0..100]
    pub use_sharp_yuv: bool,
}

impl Default for EncodingConfig {
    fn default() -> Self {
        Self {
            method: 4,
            losless: false,
            quality: 1.,
            target_size: 0,
            target_psnr: 0.,
            segments: 1,
            noise_shaping: 50,
            filter: Some(Filter::Strong(FilterConfig {
                strength: Some(60),
                sharpness: 0,
            })),
            show_compressed: false,
            alpha_compression: true,
            alpha_filtering: Some(AlphaFilter::Fast),
            alpha_quality: 100,
            preprocessing: None,
            pass: 1,
            partitions: 0,
            partition_limit: 0,
            use_sharp_yuv: false,
        }
    }
}

impl EncodingConfig {
    fn create(&self) -> WebPConfig {
        let mut config = WebPConfig::new().unwrap();
        config.lossless = self.losless as i32;
        config.quality = self.quality;
        config.method = self.method as i32;

        config.target_size = self.target_size;
        config.target_PSNR = self.target_psnr;
        config.segments = self.segments as i32;
        config.sns_strength = self.noise_shaping as i32;
        let mut filter_config: Option<&FilterConfig> = None;
        match &self.filter {
            Some(filter) => match filter {
                Filter::Simple(cfg) => {
                    config.filter_type = 0;
                    filter_config = Some(cfg);
                }
                Filter::Strong(cfg) => {
                    config.filter_type = 1;
                    filter_config = Some(cfg);
                }
            },
            _ => (),
        };
        if let Some(filter_config) = filter_config {
            config.filter_sharpness = filter_config.sharpness as i32;
            if let Some(filter_strength) = filter_config.strength {
                config.filter_strength = filter_strength as i32;
            } else {
                config.autofilter = true as i32;
            }
        }
        config.alpha_compression = self.alpha_compression as i32;
        config.alpha_filtering = match &self.alpha_filtering {
            Some(f) => match f {
                AlphaFilter::Fast => 1,
                AlphaFilter::Best => 2,
            },
            None => 0,
        };
        config.alpha_quality = self.alpha_quality as i32;
        config.pass = self.pass as i32;
        config.show_compressed = self.show_compressed as i32;
        config.preprocessing = match self.preprocessing {
            None => 0,
            _ => 1,
        };
        config.partitions = self.partitions as i32;
        config.partition_limit = self.partition_limit as i32;
        config.use_sharp_yuv = self.use_sharp_yuv as i32;

        config
    }
}

pub struct Encoder {
    pub config: WebPConfig,
    pub frames: Vec<Frame>,
}

impl Encoder {
    pub fn new(frames: Vec<Frame>, config: EncodingConfig) -> Self {
        Self {
            config: config.create(),
            frames,
        }
    }

    pub fn add_frame(&mut self, frame: Frame) {
        self.frames.push(frame);
    }

    pub fn encode(&self) -> WebPMemory {
        let first_frame = self.frames.first().expect("no frames to encode");
        let mut encoder = AnimEncoder::new(first_frame.width, first_frame.height, &self.config);
        for frame in self.frames.iter() {
            encoder.add_frame(AnimFrame::from_rgba(
                &frame.data,
                first_frame.width,
                first_frame.height,
                frame.timestamp,
            ))
        }
        encoder.encode()
    }
}
