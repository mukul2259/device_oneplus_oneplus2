// Dummy TU so the vendor cc_library that pulls libnetutils into the vendor
// partition has a symbol. The real content is provided by the linked
// shared_libs (libnetutils).
extern "C" int oneplus2_libnetutils_pull_marker() { return 0; }
