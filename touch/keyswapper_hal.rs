/*
 * SPDX-FileCopyrightText: 2026 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

use binder::{Interface, Result as BinderResult, StatusCode};
use std::fs;

use vendor_lineage_touch::aidl::vendor::lineage::touch::IKeySwapper::IKeySwapper;

const CONTROL_PATH: &str = "/proc/s1302/key_rep";

pub struct KeySwapperHal;

impl Interface for KeySwapperHal {}

impl IKeySwapper for KeySwapperHal {
    fn getEnabled(&self) -> BinderResult<bool> {
        fs::read_to_string(CONTROL_PATH)
            .map(|mut s| {
                s.pop();
                s == "1"
            })
            .map_err(|err| {
                log::error!("Failed to read from {}: {}", CONTROL_PATH, err);
                StatusCode::UNKNOWN_ERROR.into()
            })
    }

    fn setEnabled(&self, enabled: bool) -> BinderResult<()> {
        let value = if enabled { "1" } else { "0" };

        fs::write(CONTROL_PATH, value).map_err(|err| {
            log::error!("Failed to write to {}: {}", CONTROL_PATH, err);
            StatusCode::UNKNOWN_ERROR.into()
        })
    }
}
