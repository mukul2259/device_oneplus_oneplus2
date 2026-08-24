/*
 * SPDX-FileCopyrightText: 2026 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

use binder::{Interface, Result as BinderResult, StatusCode};
use std::fs;

use vendor_lineage_touch::aidl::vendor::lineage::touch::Gesture::Gesture;
use vendor_lineage_touch::aidl::vendor::lineage::touch::ITouchscreenGesture::ITouchscreenGesture;

struct GestureInfo {
    id: i32,
    keycode: i32,
    name: &'static str,
    path: &'static str,
}

const GESTURES: &[GestureInfo] = &[
    GestureInfo { id: 0, keycode: 250, name: "down arrow", path: "/proc/touchpanel/draw_v" },
    GestureInfo { id: 1, keycode: 251, name: "up arrow", path: "/proc/touchpanel/draw_reversed_v" },
    GestureInfo { id: 2, keycode: 252, name: "right arrow", path: "/proc/touchpanel/draw_right_v" },
    GestureInfo { id: 3, keycode: 253, name: "left arrow", path: "/proc/touchpanel/draw_left_v" },
    GestureInfo { id: 4, keycode: 254, name: "letter o", path: "/proc/touchpanel/draw_circle" },
    GestureInfo { id: 5, keycode: 255, name: "two finger down swipe", path: "/proc/touchpanel/double_swipe" },
    GestureInfo { id: 6, keycode: 256, name: "one finger right swipe", path: "/proc/touchpanel/right_swipe" },
    GestureInfo { id: 7, keycode: 257, name: "one finger left swipe", path: "/proc/touchpanel/left_swipe" },
    GestureInfo { id: 8, keycode: 258, name: "one finger down swipe", path: "/proc/touchpanel/down_swipe" },
    GestureInfo { id: 9, keycode: 259, name: "one finger up swipe", path: "/proc/touchpanel/up_swipe" },
];

pub struct TouchscreenGestureHal;

impl Interface for TouchscreenGestureHal {}

impl ITouchscreenGesture for TouchscreenGestureHal {
    fn getSupportedGestures(&self) -> BinderResult<Vec<Gesture>> {
        Ok(GESTURES
            .iter()
            .map(|g| Gesture { id: g.id, name: g.name.to_string(), keycode: g.keycode })
            .collect())
    }

    fn setGestureEnabled(&self, gesture: &Gesture, enabled: bool) -> BinderResult<()> {
        let entry = GESTURES
            .iter()
            .find(|g| g.id == gesture.id)
            .ok_or(StatusCode::BAD_VALUE)?;

        let value = if enabled { "1" } else { "0" };
        fs::write(entry.path, value).map_err(|err| {
            log::error!("Failed to write to {}: {}", entry.path, err);
            StatusCode::UNKNOWN_ERROR.into()
        })
    }
}
