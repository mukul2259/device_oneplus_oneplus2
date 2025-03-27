/*
 * SPDX-FileCopyrightText: 2018-2024 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#pragma once

#include <aidl/android/hardware/light/BnLights.h>

#include <fstream>
#include <mutex>
#include <unordered_map>

using ::aidl::android::hardware::light::BnLights;
using ::aidl::android::hardware::light::FlashMode;
using ::aidl::android::hardware::light::HwLight;
using ::aidl::android::hardware::light::HwLightState;
using ::aidl::android::hardware::light::LightType;

namespace aidl {
namespace android {
namespace hardware {
namespace light {

struct Lights : public BnLights {
    Lights(std::pair<std::ofstream, uint32_t>&& lcd_backlight,
          std::vector<std::ofstream>&& button_backlight,
          std::ofstream&& red_led, std::ofstream&& green_led, std::ofstream&& blue_led,
          std::ofstream&& red_duty_pcts, std::ofstream&& green_duty_pcts, std::ofstream&& blue_duty_pcts,
          std::ofstream&& red_start_idx, std::ofstream&& green_start_idx, std::ofstream&& blue_start_idx,
          std::ofstream&& red_pause_lo, std::ofstream&& green_pause_lo, std::ofstream&& blue_pause_lo,
          std::ofstream&& red_pause_hi, std::ofstream&& green_pause_hi, std::ofstream&& blue_pause_hi,
          std::ofstream&& red_ramp_step_ms, std::ofstream&& green_ramp_step_ms, std::ofstream&& blue_ramp_step_ms,
          std::ofstream&& red_blink, std::ofstream&& green_blink, std::ofstream&& blue_blink,
          std::ofstream&& rgb_blink);

     // Methods from ::aidl::android::hardware::light::BnLights follow.
     ndk::ScopedAStatus setLightState(int32_t id, const HwLightState& state) override;
     ndk::ScopedAStatus getLights(std::vector<HwLight> *_aidl_return) override;

  private:
    void setAttentionLight(const HwLightState& state);
    void setBatteryLight(const HwLightState& state);
    void setButtonsBacklight(const HwLightState& state);
    void setLcdBacklight(const HwLightState& state);
    void setNotificationLight(const HwLightState& state);
    void setSpeakerBatteryLightLocked();
    void setSpeakerLightLocked(const HwLightState& state);

    std::pair<std::ofstream, uint32_t> mLcdBacklight;
    std::vector<std::ofstream> mButtonBacklight;
    std::ofstream mRedLed;
    std::ofstream mGreenLed;
    std::ofstream mBlueLed;
    std::ofstream mRedDutyPcts;
    std::ofstream mGreenDutyPcts;
    std::ofstream mBlueDutyPcts;
    std::ofstream mRedStartIdx;
    std::ofstream mGreenStartIdx;
    std::ofstream mBlueStartIdx;
    std::ofstream mRedPauseLo;
    std::ofstream mGreenPauseLo;
    std::ofstream mBluePauseLo;
    std::ofstream mRedPauseHi;
    std::ofstream mGreenPauseHi;
    std::ofstream mBluePauseHi;
    std::ofstream mRedRampStepMs;
    std::ofstream mGreenRampStepMs;
    std::ofstream mBlueRampStepMs;
    std::ofstream mRedBlink;
    std::ofstream mGreenBlink;
    std::ofstream mBlueBlink;
    std::ofstream mRgbBlink;

    HwLightState mAttentionState;
    HwLightState mBatteryState;
    HwLightState mNotificationState;

    std::unordered_map<LightType, std::function<void(const HwLightState&)>> mLights;
    std::mutex mLock;
};

}  // namespace light
}  // namespace hardware
}  // namespace android
}  // namespace aidl
