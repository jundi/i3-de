# -*- coding: utf-8 -*-

import subprocess

from i3pystatus import Status

status = Status(standalone=True)



# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
                format="%F W%V %X",)


# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
# status.register("pulseaudio",
#        format="VOL {volume}%",)

status.register("mem",
                format="MEM {used_mem:5.0f} MiB",)

status.register("cpu_usage",
                format="CPU {usage:3.0f}%",)

status.register("network",
                interface="enp0s20f0u1u2",
                divisor=125000,
                format_up="{interface}: ↑{bytes_sent:3.0f}Mbps / ↓{bytes_recv:3.0f}Mbps",)

status.register("network",
                interface="wlp2s0",
                divisor=125000,
                format_up="{essid} {quality:3.0f}%: ↑{bytes_sent:3.0f}Mbps / ↓{bytes_recv:3.0f}Mbps",)




status.run()
