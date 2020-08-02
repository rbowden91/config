import time
import dbus

bus = dbus.SystemBus()

# Get a proxy for the base NetworkManager object
# gdbus introspect -y -d org.freedesktop.NetworkManager -o /org/freedesktop/NetworkManager
proxy = bus.get_object("org.freedesktop.NetworkManager", "/org/freedesktop/NetworkManager")
manager = dbus.Interface(proxy, "org.freedesktop.NetworkManager")

all_aps = []

# Get all network devices
devices = manager.GetDevices()
for d in devices:
    dev_proxy = bus.get_object("org.freedesktop.NetworkManager", d)
    prop_iface = dbus.Interface(dev_proxy, "org.freedesktop.DBus.Properties")

    # Make sure the device is enabled before we try to use it
    state = prop_iface.Get("org.freedesktop.NetworkManager.Device", "State")
    if state <= 2:
        continue

    # Get device's type; we only want wifi devices
    iface = prop_iface.Get("org.freedesktop.NetworkManager.Device", "Interface")
    dtype = prop_iface.Get("org.freedesktop.NetworkManager.Device", "DeviceType")
    if dtype == 2:   # WiFi
        # Get a proxy for the wifi interface
        wifi_iface = dbus.Interface(dev_proxy, "org.freedesktop.NetworkManager.Device.Wireless")
        wifi_prop_iface = dbus.Interface(dev_proxy, "org.freedesktop.DBus.Properties")

        opt = dbus.Dictionary({
        })

        # Get all APs the card can see
        wifi_iface.RequestScan(opt)
        
        time.sleep(1)
        
        aps = wifi_iface.GetAllAccessPoints()
        for path in aps:
            ap_proxy = bus.get_object("org.freedesktop.NetworkManager", path)
            ap_prop_iface = dbus.Interface(ap_proxy, "org.freedesktop.DBus.Properties")
            ssid = bytearray(ap_prop_iface.Get("org.freedesktop.NetworkManager.AccessPoint", "Ssid")).decode()

            # Cache the BSSID
            if not ssid in all_aps:
                print(ap_proxy)
                all_aps.append(ssid)

# and print out all APs the wifi devices can see
print("\nFound APs:")
for bssid in all_aps:
    print(bssid)
