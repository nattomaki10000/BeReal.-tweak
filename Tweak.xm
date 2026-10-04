#import <dlfcn.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <substrate.h>

BOOL IsSymbolsPath(const char *path) {
    if (!path) return NO;
    const char *needle = "/System/Library/Frameworks/Symbols.framework/Symbols";
    return strstr(path, needle) != NULL || strstr(path, "Symbols.framework/Symbols") != NULL;
}

static void *(*orig_dlopen)(const char *path, int mode);

void *Hooked_dlopen(const char *path, int mode) {
    if (IsSymbolsPath(path)) {
        void *handle = dlopen("/usr/lib/libobjc.A.dylib", mode);
        if (handle) return handle;
        handle = dlopen("/usr/lib/libSystem.B.dylib", mode);
        if (handle) return handle;
    }
    return orig_dlopen(path, mode);
}

%ctor {
    void *libdyld = dlopen("/usr/lib/libdyld.dylib", RTLD_LAZY);
    if (!libdyld) return;

    orig_dlopen = (void *(*)(const char *, int))dlsym(libdyld, "dlopen");
    if (!orig_dlopen) return;

    MSHookFunction((void *)orig_dlopen, (void *)Hooked_dlopen, (void **)&orig_dlopen);
}
