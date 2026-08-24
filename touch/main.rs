/*
 * SPDX-FileCopyrightText: 2026 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

//! This implements the Lineage touch HALs: KeyDisabler, KeySwapper and
//! TouchscreenGesture.
mod keydisabler_hal;
mod keyswapper_hal;
mod touchscreengesture_hal;

use crate::keydisabler_hal::KeyDisablerHal;
use crate::keyswapper_hal::KeySwapperHal;
use crate::touchscreengesture_hal::TouchscreenGestureHal;

use vendor_lineage_touch::aidl::vendor::lineage::touch::IKeyDisabler::{
    BnKeyDisabler, IKeyDisabler,
};
use vendor_lineage_touch::aidl::vendor::lineage::touch::IKeySwapper::{
    BnKeySwapper, IKeySwapper,
};
use vendor_lineage_touch::aidl::vendor::lineage::touch::ITouchscreenGesture::{
    BnTouchscreenGesture, ITouchscreenGesture,
};

use log::LevelFilter;

const LOG_TAG: &str = "TouchHal";

fn main() {
    let logger_success = logger::init(
        logger::Config::default().with_tag_on_device(LOG_TAG).with_max_level(LevelFilter::Trace),
    );
    if !logger_success {
        panic!("{LOG_TAG}: Failed to start logger.");
    }

    binder::ProcessState::start_thread_pool();

    let key_disabler_binder = BnKeyDisabler::new_binder(
        KeyDisablerHal,
        binder::BinderFeatures::default(),
    );
    binder::add_service(
        &format!("{}/default", KeyDisablerHal::get_descriptor()),
        key_disabler_binder.as_binder(),
    )
    .expect("Failed to register KeyDisabler service");

    let key_swapper_binder = BnKeySwapper::new_binder(
        KeySwapperHal,
        binder::BinderFeatures::default(),
    );
    binder::add_service(
        &format!("{}/default", KeySwapperHal::get_descriptor()),
        key_swapper_binder.as_binder(),
    )
    .expect("Failed to register KeySwapper service");

    let touchscreen_gesture_binder = BnTouchscreenGesture::new_binder(
        TouchscreenGestureHal,
        binder::BinderFeatures::default(),
    );
    binder::add_service(
        &format!("{}/default", TouchscreenGestureHal::get_descriptor()),
        touchscreen_gesture_binder.as_binder(),
    )
    .expect("Failed to register TouchscreenGesture service");

    // Does not return.
    binder::ProcessState::join_thread_pool()
}
