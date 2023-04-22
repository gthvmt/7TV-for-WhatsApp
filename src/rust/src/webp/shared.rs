#[derive(Clone)]
pub struct Frame {
    pub data: Vec<u8>,
    pub width: u32,
    pub height: u32,
    pub timestamp: i32,
}

impl Frame {
    pub fn new(data: Vec<u8>, width: u32, height: u32, timestamp: i32) -> Self {
        Self {
            data,
            width,
            height,
            timestamp,
        }
    }
}
