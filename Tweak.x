#import <Cocoa/Cocoa.h>
#import <dlfcn.h>
#import <os/log.h>

%config(generator=internal)

void (*_MSHookFunction) (void*, void*, void*);

bool _os_feature_enabled_impl_hook(char* a, char* b){
    if (!strcmp(b, "SpotlightPlus"))
    return false;
    else
    return true;
}

%ctor{
   void* ffh = dlopen("/usr/lib/system/libsystem_featureflags.dylib", RTLD_NOW);
   void* handle = dlopen("/Library/TweakInject/libEllekit.dylib", RTLD_NOW);

    _MSHookFunction = dlsym(handle, "MSHookFunction");

    _MSHookFunction(dlsym(ffh, "_os_feature_enabled_impl"), _os_feature_enabled_impl_hook, NULL);

    os_log(OS_LOG_DEFAULT, "[tweak][launchbad] end");

}

