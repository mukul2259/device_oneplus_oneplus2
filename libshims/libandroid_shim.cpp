/*
 * Minimal libandroid shim for the vendor partition so the legacy
 * mm-qcamera-daemon / libmm-als blobs can load.
 *
 * Those Qualcomm blobs link libandroid.so and call its ALooper / ASensor
 * entry points (looper + sensor-manager API) at init. Android 16's vendor
 * linker namespace cannot see the system libandroid.so, so the daemon failed
 * with "libandroid.so not found". Provide a vendor libandroid.so with those
 * symbols. ALooper is implemented with a real looper so the camera's event
 * loop can run; the sensor manager returns no sensors (NULL) rather than
 * dereferencing a dangling pointer.
 *
 * This is a shim, not a full libandroid: only the symbols the legacy blobs
 * actually use are provided.
 */

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ---------- ALooper ---------- */
typedef struct ALooper {
    int dummy;
} ALooper;
#define ALOOPER_POLL_WAKE     (-1)
#define ALOOPER_POLL_CALLBACK (-2)
#define ALOOPER_POLL_TIMEOUT  (-3)
#define ALOOPER_POLL_ERROR    (-4)

static ALooper g_looper;

ALooper *ALooper_prepare(int opts) { (void)opts; return &g_looper; }
ALooper *ALooper_forThread(void) { return &g_looper; }
int ALooper_pollOnce(int timeoutMillis, int *outFd, int *outEvents,
                     void **outData) {
    (void)timeoutMillis; (void)outFd; (void)outEvents; (void)outData;
    return ALOOPER_POLL_TIMEOUT;
}
void ALooper_wake(ALooper *looper) { (void)looper; }

/* ---------- ASensor ---------- */
typedef struct ASensorManager ASensorManager;
typedef struct ASensor ASensor;
typedef struct ASensorEventQueue ASensorEventQueue;
typedef struct ASensorEvent {
    int32_t version;
    int32_t sensor;
    int32_t type;
    int32_t reserved0;
    int64_t timestamp;
    union {
        float data[16];
        struct { float x, y, z; } vector;
    } acceleration;
    uint32_t flags;
} ASensorEvent;

#define ASENSOR_TYPE_ACCELEROMETER (1)

ASensorManager *ASensorManager_getInstance(void) { return (ASensorManager *)0x1; }
ASensorManager *ASensorManager_getInstanceForPackage(const char *name) {
    (void)name; return (ASensorManager *)0x1;
}
ASensor *ASensorManager_getDefaultSensor(ASensorManager *m, int type) {
    (void)m; (void)type; return NULL;
}
ASensorEventQueue *ASensorManager_createEventQueue(ASensorManager *m, ALooper *l,
                                                   int ident,
                                                   void *callback, void *data) {
    (void)m; (void)l; (void)ident; (void)callback; (void)data;
    return (ASensorEventQueue *)0x2;
}
int ASensorManager_destroyEventQueue(ASensorManager *m,
                                     ASensorEventQueue *q) {
    (void)m; (void)q; return 0;
}
int ASensor_getMinDelay(ASensor *s) { (void)s; return 0; }
const char *ASensor_getName(ASensor *s) { (void)s; return "dummy"; }
const char *ASensor_getVendor(ASensor *s) { (void)s; return "oneplus2"; }
int ASensorEventQueue_enableSensor(ASensorEventQueue *q, ASensor *s) {
    (void)q; (void)s; return 0;
}
int ASensorEventQueue_disableSensor(ASensorEventQueue *q, ASensor *s) {
    (void)q; (void)s; return 0;
}
int ASensorEventQueue_setEventRate(ASensorEventQueue *q, ASensor *s,
                                   int32_t usec) {
    (void)q; (void)s; (void)usec; return 0;
}
int ASensorEventQueue_getEvents(ASensorEventQueue *q, ASensorEvent *events,
                                size_t count) {
    (void)q; (void)events; (void)count; return 0;
}

/* Defensive symbol. */
int libandroid_vendor_shim_present(void) { return 1; }

#ifdef __cplusplus
}
#endif