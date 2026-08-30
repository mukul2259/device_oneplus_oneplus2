/*
 * Minimal libandroid shim for the legacy mm-qcamera-daemon.
 *
 * The Qualcomm camera blobs (libmmcamera2_stats_modules etc.) list
 * libandroid.so in their NEEDED dependencies for historical compatibility but
 * do not actually call any libandroid functions (verified via readelf: no
 * undefined libandroid symbols). Android 16's vendor linker namespace cannot
 * see the system libandroid.so, so the daemon failed to load. Provide a vendor
 * libandroid.so with the SONAME so the linker is satisfied; the few common
 * entry points are stubbed out defensively in case any path calls them.
 */

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ANativeWindow */
typedef struct ANativeWindow ANativeWindow;
void *ANativeWindow_fromSurface(void *env, void *surface) { (void)env; (void)surface; return NULL; }
void ANativeWindow_release(ANativeWindow *win) { (void)win; }

/* AAssetManager */
typedef struct AAssetManager AAssetManager;
AAssetManager *AAssetManager_fromJava(void *env, void *assetManager) { (void)env; (void)assetManager; return NULL; }

/* AConfiguration */
typedef struct AConfiguration AConfiguration;
AConfiguration *AConfiguration_new(void) { return NULL; }

/* Defensive symbol so the library has at least one non-empty symbol. */
int libandroid_vendor_shim_present(void) { return 1; }

#ifdef __cplusplus
}
#endif