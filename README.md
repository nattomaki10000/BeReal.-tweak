# BeReal Symbols.framework compatibility shim

This tweak is intended for a jailbroken iOS 16.7.16 target and addresses the exact launch failure shown in the crash log:

- `Library not loaded: /System/Library/Frameworks/Symbols.framework/Symbols`
- Referenced from: .../BeReal.app/BeReal

The app is trying to load a private framework that does not exist on this OS. 
A compatibility tweak can intercept `dlopen` and return a valid handle instead of letting dyld abort the app.

## Build

Use Theos or a similar jailbreak toolchain:

```bash
cd BeRealCompatTweak
make package
```

## Install on device

```bash
scp .theos/obj/debug/iphoneos/Structures.dylib root@<device>:/Library/MobileSubstrate/DynamicLibraries/
```

Then create a corresponding `.plist` file under `/Library/MobileSubstrate/DynamicLibraries/` so it loads automatically.

## Why this works

The app is loading a missing private framework. The tweak hooks `dlopen` and rewrites the request to a valid library so the process can continue instead of terminating at launch.

This is a compatibility workaround, not a full source-level port. It is useful only when the app is otherwise compatible enough to start on iOS 16.7.16.
