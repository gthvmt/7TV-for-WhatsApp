use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_into_frames(port_: i64, bytes: *mut wire_uint_8_list) {
    wire_into_frames_impl(port_, bytes)
}

#[no_mangle]
pub extern "C" fn wire_upscale_frames_with_padding(
    port_: i64,
    frames: *mut wire_list_frame,
    width: u32,
    height: u32,
    config: *mut wire_EncodingConfig,
) {
    wire_upscale_frames_with_padding_impl(port_, frames, width, height, config)
}

#[no_mangle]
pub extern "C" fn wire_calc_translucency(port_: i64, frames: *mut wire_list_frame) {
    wire_calc_translucency_impl(port_, frames)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_alpha_filter_0(value: i32) -> *mut i32 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_encoding_config_0() -> *mut wire_EncodingConfig {
    support::new_leak_box_ptr(wire_EncodingConfig::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_filter_0() -> *mut wire_Filter {
    support::new_leak_box_ptr(wire_Filter::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_filter_config_0() -> *mut wire_FilterConfig {
    support::new_leak_box_ptr(wire_FilterConfig::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_preprocessing_0(value: i32) -> *mut i32 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_u8_0(value: u8) -> *mut u8 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_list_frame_0(len: i32) -> *mut wire_list_frame {
    let wrap = wire_list_frame {
        ptr: support::new_leak_vec_ptr(<wire_Frame>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<AlphaFilter> for *mut i32 {
    fn wire2api(self) -> AlphaFilter {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<AlphaFilter>::wire2api(*wrap).into()
    }
}
impl Wire2Api<EncodingConfig> for *mut wire_EncodingConfig {
    fn wire2api(self) -> EncodingConfig {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<EncodingConfig>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Filter> for *mut wire_Filter {
    fn wire2api(self) -> Filter {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Filter>::wire2api(*wrap).into()
    }
}
impl Wire2Api<FilterConfig> for *mut wire_FilterConfig {
    fn wire2api(self) -> FilterConfig {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<FilterConfig>::wire2api(*wrap).into()
    }
}
impl Wire2Api<Preprocessing> for *mut i32 {
    fn wire2api(self) -> Preprocessing {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<Preprocessing>::wire2api(*wrap).into()
    }
}
impl Wire2Api<u8> for *mut u8 {
    fn wire2api(self) -> u8 {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}
impl Wire2Api<EncodingConfig> for wire_EncodingConfig {
    fn wire2api(self) -> EncodingConfig {
        EncodingConfig {
            method: self.method.wire2api(),
            losless: self.losless.wire2api(),
            quality: self.quality.wire2api(),
            target_size: self.target_size.wire2api(),
            target_psnr: self.target_psnr.wire2api(),
            segments: self.segments.wire2api(),
            noise_shaping: self.noise_shaping.wire2api(),
            filter: self.filter.wire2api(),
            alpha_compression: self.alpha_compression.wire2api(),
            alpha_filtering: self.alpha_filtering.wire2api(),
            alpha_quality: self.alpha_quality.wire2api(),
            pass: self.pass.wire2api(),
            show_compressed: self.show_compressed.wire2api(),
            preprocessing: self.preprocessing.wire2api(),
            partitions: self.partitions.wire2api(),
            partition_limit: self.partition_limit.wire2api(),
            use_sharp_yuv: self.use_sharp_yuv.wire2api(),
        }
    }
}

impl Wire2Api<Filter> for wire_Filter {
    fn wire2api(self) -> Filter {
        match self.tag {
            0 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Simple);
                Filter::Simple(ans.field0.wire2api())
            },
            1 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Strong);
                Filter::Strong(ans.field0.wire2api())
            },
            _ => unreachable!(),
        }
    }
}
impl Wire2Api<FilterConfig> for wire_FilterConfig {
    fn wire2api(self) -> FilterConfig {
        FilterConfig {
            strength: self.strength.wire2api(),
            sharpness: self.sharpness.wire2api(),
        }
    }
}
impl Wire2Api<Frame> for wire_Frame {
    fn wire2api(self) -> Frame {
        Frame {
            data: self.data.wire2api(),
            width: self.width.wire2api(),
            height: self.height.wire2api(),
            timestamp: self.timestamp.wire2api(),
        }
    }
}

impl Wire2Api<Vec<Frame>> for *mut wire_list_frame {
    fn wire2api(self) -> Vec<Frame> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_EncodingConfig {
    method: u8,
    losless: bool,
    quality: f32,
    target_size: i32,
    target_psnr: f32,
    segments: u8,
    noise_shaping: u8,
    filter: *mut wire_Filter,
    alpha_compression: bool,
    alpha_filtering: *mut i32,
    alpha_quality: u8,
    pass: u8,
    show_compressed: bool,
    preprocessing: *mut i32,
    partitions: u8,
    partition_limit: u8,
    use_sharp_yuv: bool,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_FilterConfig {
    strength: *mut u8,
    sharpness: u8,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Frame {
    data: *mut wire_uint_8_list,
    width: u32,
    height: u32,
    timestamp: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_frame {
    ptr: *mut wire_Frame,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Filter {
    tag: i32,
    kind: *mut FilterKind,
}

#[repr(C)]
pub union FilterKind {
    Simple: *mut wire_Filter_Simple,
    Strong: *mut wire_Filter_Strong,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Filter_Simple {
    field0: *mut wire_FilterConfig,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Filter_Strong {
    field0: *mut wire_FilterConfig,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_EncodingConfig {
    fn new_with_null_ptr() -> Self {
        Self {
            method: Default::default(),
            losless: Default::default(),
            quality: Default::default(),
            target_size: Default::default(),
            target_psnr: Default::default(),
            segments: Default::default(),
            noise_shaping: Default::default(),
            filter: core::ptr::null_mut(),
            alpha_compression: Default::default(),
            alpha_filtering: core::ptr::null_mut(),
            alpha_quality: Default::default(),
            pass: Default::default(),
            show_compressed: Default::default(),
            preprocessing: core::ptr::null_mut(),
            partitions: Default::default(),
            partition_limit: Default::default(),
            use_sharp_yuv: Default::default(),
        }
    }
}

impl Default for wire_EncodingConfig {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_Filter {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: -1,
            kind: core::ptr::null_mut(),
        }
    }
}

#[no_mangle]
pub extern "C" fn inflate_Filter_Simple() -> *mut FilterKind {
    support::new_leak_box_ptr(FilterKind {
        Simple: support::new_leak_box_ptr(wire_Filter_Simple {
            field0: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_Filter_Strong() -> *mut FilterKind {
    support::new_leak_box_ptr(FilterKind {
        Strong: support::new_leak_box_ptr(wire_Filter_Strong {
            field0: core::ptr::null_mut(),
        }),
    })
}

impl NewWithNullPtr for wire_FilterConfig {
    fn new_with_null_ptr() -> Self {
        Self {
            strength: core::ptr::null_mut(),
            sharpness: Default::default(),
        }
    }
}

impl Default for wire_FilterConfig {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_Frame {
    fn new_with_null_ptr() -> Self {
        Self {
            data: core::ptr::null_mut(),
            width: Default::default(),
            height: Default::default(),
            timestamp: Default::default(),
        }
    }
}

impl Default for wire_Frame {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
