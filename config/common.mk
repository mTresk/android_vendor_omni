PRODUCT_BRAND ?= omni

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# general properties
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.build.selinux=1 \
    persist.sys.disable_rescue=true

# Tethering - allow without requiring a provisioning app
# (for devices that check this)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    net.tethering.noprovisioning=true

# enable ADB authentication if not on eng build
ifneq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES  += ro.adb.secure=0
endif

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=log

PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/bin/clean_cache.sh:system/bin/clean_cache.sh

# Backup Tool
ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/omni/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/omni/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh

else
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/omni/prebuilt/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/omni/prebuilt/bin/blacklist:system/addon.d/blacklist
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/sysconfig/backup.xml:system/etc/sysconfig/backup.xml

# Init script file with omni extras
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/init.local.rc:system/etc/init/init.omni.rc

# Enable SIP and VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

#permissions
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/permissions/privapp-permissions-omni.xml:system/etc/permissions/privapp-permissions-omni.xml \
    vendor/omni/prebuilt/etc/permissions/privapp-permissions-elgoog.xml:system/etc/permissions/privapp-permissions-elgoog.xml

# default sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.ringtone=The_big_adventure.ogg \
    ro.config.notification_sound=Beginning.ogg \
    ro.config.alarm_alert=Bright_morning.ogg

# mkshrc
PRODUCT_COPY_FILES += \
    vendor/omni/prebuilt/etc/mkshrc:system/etc/mkshrc

# whitelist packages for location providers not in system
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.services.whitelist.packagelist=com.google.android.gms

# Additional packages
-include vendor/omni/config/packages.mk

# Versioning
-include vendor/omni/config/version.mk

# Add our overlays
DEVICE_PACKAGE_OVERLAYS += vendor/omni/overlay/common

# GApps
include vendor/omni/config/gapps.mk

# Pixel Style
include vendor/pixelstyle/config.mk
