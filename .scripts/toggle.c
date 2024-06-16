#include <X11/X.h>
#include <X11/Xatom.h>
#include <X11/Xlib.h>
#include <X11/extensions/XI.h>
#include <X11/extensions/XI2.h>
#include <X11/extensions/XInput.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define KEYBOARD 1
#define POINTER 2

XDevice *getDevice(Display *display, char *device_name, int num_class);
void setUpTouchpad(Display *display, XDevice *touchpad, float *value);
void changeProperty(Display *display, XDevice *device, char *property,
                    float *value);
void mainLoop(XDevice *mouse, XDevice *touchpad, Display *display,
              float *value);

int main() {
  Display *display;
  XDevice *mouse, *touchpad;
  float value[4] = {};

  display = XOpenDisplay(NULL);
  if (display == NULL) {
    fprintf(stderr, "Unable to open display.\n");
    exit(1);
  }
  touchpad = getDevice(display, "VEN_04F3:00 04F3:32AA Touchpad", POINTER);
  if (touchpad == NULL) {
    fprintf(stderr, "Unable to open touchpad.\n");
    exit(1);
  }
  setUpTouchpad(display, touchpad, value);

  while (1) {
    mainLoop(mouse, touchpad, display, value);
    sleep(1);
  }

  XFlush(display);
  return 0;
}

void setUpTouchpad(Display *display, XDevice *touchpad, float *value) {
  Atom accelSpeedAtom = XInternAtom(display, "Device Enabled", False);
  Atom type;
  int format;
  unsigned char *data = NULL;
  unsigned long nitems, bytes_after;

  XGetDeviceProperty(display, touchpad, accelSpeedAtom, 0, 1000, False,
                     AnyPropertyType, &type, &format, &nitems, &bytes_after,
                     &data);
  if (data[0] == 1) {
    value[0] = 1;
    changeProperty(display, touchpad, "libinput Natural Scrolling Enabled",
                   value);
    changeProperty(display, touchpad, "libinput Tapping Enabled", value);
  }
  free(data);
}

void mainLoop(XDevice *mouse, XDevice *touchpad, Display *display,
              float *value) {
  mouse = getDevice(display, "Kingston HyperX Pulsefire Haste", POINTER);
  if (mouse != NULL) {
    value[0] = 0.25;
    changeProperty(display, mouse, "libinput Accel Speed", value);
    value[0] = 0;
    value[1] = 1;
    value[2] = 0;
    changeProperty(display, mouse, "libinput Accel Profile Enabled", value);
    XCloseDevice(display, mouse);
    value[0] = 0;
  } else {
    value[0] = 1;
  }
  changeProperty(display, touchpad, "Device Enabled", value);
}

XDevice *getDevice(Display *display, char *device_name, int num_class) {
  XDeviceInfo *devices;
  int num_devices;

  devices = XListInputDevices(display, &num_devices);
  if (devices == NULL) {
    fprintf(stderr, "Unable to query devices.\n");
    exit(1);
  }

  int i;
  for (i = 0; i < num_devices; ++i) {
    if (strcmp(devices[i].name, device_name) == 0 &&
        devices[i].num_classes == num_class) {
      // Open the device
      XDevice *device = XOpenDevice(display, devices[i].id);
      if (device == NULL) {
        fprintf(stderr, "Unable to open device.\n");
        exit(1);
      }
      free(devices);
      return device;
    }
  }
  free(devices);
  return NULL;
}

void changeProperty(Display *display, XDevice *device, char *property,
                    float *value) {
  int num_devices;
  Atom prop = None, type;
  int format, skip = 1;
  unsigned char *data = NULL;
  unsigned long nitems, bytes_after;

  Atom accelSpeedAtom = XInternAtom(display, property, False);

  XGetDeviceProperty(display, device, accelSpeedAtom, 0, 1000, False,
                     AnyPropertyType, &type, &format, &nitems, &bytes_after,
                     &data);

  if (type == XA_INTEGER) {
    for (int i = 0; i < nitems; i++) {
      if (data[i] != (int)value[i]) {
        data[i] = (int)value[i];
        skip = 0;
      }
    }
  } else {
    for (int i = 0; i < nitems; i++) {
      if (((float *)data)[i] != value[i]) {
        ((float *)data)[i] = value[i];
        skip = 0;
      }
    }
  }

  if (!skip) {
    XChangeDeviceProperty(display, device, accelSpeedAtom, type, format,
                          PropModeReplace, data, nitems);
  }

  free(data);
}
