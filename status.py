"""Status bar for i3-wm"""
# -*- coding: utf-8 -*-

from i3pystatus import Status

STATUS = Status(standalone=True)


# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
STATUS.register("clock",
                format="%F W%V %X",)


# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
# status.register("pulseaudio",
#        format="VOL {volume}%",)

STATUS.register("mem",
                format="MEM {used_mem:5.0f} MiB",
                divisor=1048576)

STATUS.register("cpu_usage",
                format="CPU {usage:3.0f}%")

for interface in ["enp0s31f6", "wlp2s0"]:
    STATUS.register(
        "network",
        interface=interface,
        divisor=125000,
        format_up=("{interface}: {essid} {quality:3.0f}% "
                   "↑{bytes_sent}Mbps / ↓{bytes_recv}Mbps")
    )



STATUS.run()
