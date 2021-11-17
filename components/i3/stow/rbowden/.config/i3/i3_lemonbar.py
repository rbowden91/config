#!/usr/bin/env python3

#CHROME="%{A:google-chrome &:} %{A}"
#TIME="%{A:echo -e 'export TIME=\n' >
    #\"${I3_LEMONBAR_FIFO}\" &:}%{O8}${TIME}%{A}"

# Use https://www.nerdfonts.com/cheat-sheet
#
# Print i3 workspaces on every change.

colors = {
    'fore': '#FFC5C8C6',
    'wsp': '#FF005555',
    'disable': '#FF001F21',
    'head': '#FF339999'
}
font_size = 16
font = f'Terminess Powerline:size={font_size}'
iconfont = f'Hack Nerd Font:size={font_size}'
geometry = f'x{font_size * 3}'



import sys
import os
import signal
import traceback
from time import localtime, strftime
from subprocess import Popen, PIPE
from collections import defaultdict
from pathlib import Path
import gi
gi.require_version('Wnck', '3.0')
from gi.repository import Wnck, Gtk, GLib

#scr = Wnck.Screen.get_default()
#scr.force_update()

#print(scr.get_active_window().get_name())

class Battery():
    def __init__(self, manager):
        # TODO: do the paths exist?
        self.manager = manager

        self.battery_path = bp = Path('/sys/class/power_supply/BAT0/')
        # Can also find all this in /uevent
        self.charging_path = bp / 'status'
        self.capacity_path = bp / 'capacity'
        self.power_now_path = bp / 'power_now'
        self.energy_now_path = bp / 'energy_now'
        self.voltage_now_path = bp / 'voltage_now'
        self.energy_full_path = bp / 'energy_full'
        self.display_info = False

        self.min_remain = self.hr_remain = 0

        self.manager.register_button_handler('battery_toggle', self.toggle_display_info)

        self.update()

    def get_battery_icon(self):
        icons = {
            97: '',
            90: '',
            80: '',
            70: '',
            60: '',
            50: '',
            40: '',
            30: '',
            20: '',
            10: '',
            0: '',
        }
        for pct, icon in icons.items():
            if self.capacity >= pct:
                return icon

    def get_color(self):
        colors = {
            90: '#FF99EE99',
            60: '#FFAACC99',
            30: '#FFFFFF99',
            10: '#FFFF9933',
            0: '#FFFF6666',

        }
        for pct, color in colors.items():
            if self.capacity >= pct:
                return color




    def update(self):
        self.charging = self.charging_path.read_text()[0]
        self.capacity = int(self.capacity_path.read_text())
        self.min_remain = self.hr_remaining = 0

        power_now = int(self.power_now_path.read_text())
        voltage_now = int(self.voltage_now_path.read_text())
        energy_now = int(self.energy_now_path.read_text())
        energy_full = int(self.energy_full_path.read_text())

        if self.charging == 'C':
            energy = energy_full - energy_now
            divisor = voltage_now
        elif self.charging == 'D':
            energy = energy_now
            divisor = power_now
        else:
            return

        if divisor != 0:
            self.hr_remain = energy // divisor
            energy %= divisor
            self.min_remain = (energy * 60) // divisor

    def toggle_display_info(self):
        self.display_info = not self.display_info

    def display(self):
        if self.display_info:
            self.manager.fg = '#FFFFFFFF'
            self.manager.bg = self.get_color()
        else:
            self.manager.bg = '#00FFFFFF'
            self.manager.fg = self.get_color()

        icon = self.manager.icon(self.get_battery_icon() + ('' if self.charging == 'C' else ''))
        remains = f'{self.hr_remain}h {self.min_remain}m'
        if self.charging == 'C':
            remaining = f'{remains} until charged'
        elif self.charging == 'F':
            remaining = f'Fully Charged'
        else:
            remaining = f'{remains}'


        if self.display_info:
            return '%{A:battery_toggle:}' + self.manager.circ(f'{icon}{self.capacity}% ({remains})') + '%{A}'
        else:
            return '%{A:battery_toggle:}' + icon + '%{A}'

class Workspace():
    def __init__(self, manager):
        self.manager = manager
        self.workspace = None
        self.active = False

    def display(self):
        name = self.workspace.get_name().replace(r'^\d+:', '')
        if self.active:
            return self.manager.circ(name, fg=colors['fore'], bg=colors['wsp'])
        #elif self.focused
            #return f"%{{F{colors['disable']} B{colors['head']} T1}}"
        #elif self.urgent:
            #return f"%{{F{colors['disable']} B{colors['head']} T1}}"
        elif self.workspace is not None:
            # Inactive
            return self.manager.circ(name, fg=colors['disable'], bg=colors['head'])
        else:
            # Dead
            return ''
            #return f"%{{F{colors['disable']} B{colors['head']} T1}}{self.num}"

class Time():
    def __init__(self, manager):
        self.display_seconds = False
        self.manager = manager
        self.manager.register_button_handler('time_toggle', self.toggle_seconds)
        self.update()

    def update(self):
        self.datetime = localtime()

    def toggle_seconds(self):
        self.display_seconds = not self.display_seconds

    def display(self):
        self.manager.bg = '#FF000000'
        self.manager.fg = '#FFFFFFFF'
        date = self.manager.icon('') + self.manager.text(strftime('%a %e %b', self.datetime))

        seconds = ":%S" if self.display_seconds else ""
        time = strftime(f'%I:%M{seconds}%P', self.datetime)
        time = '%{A:time_toggle:}' + self.manager.icon('') + self.manager.text(time) + '%{A}'
        return self.manager.circ(date + time)


class Manager():
    def __init__(self):
        self.button_handlers = {}

        self.bar = Popen(["lemonbar", '-p', '-f', font, '-f', iconfont, '-g', geometry], stdin=PIPE, stdout=PIPE, stderr=PIPE)

        self.workspaces = defaultdict(lambda: Workspace(self))#[Workspace(i) for i in range(1,11)]
        self.active_workspace = None
        self.active_window = None

        self.battery = Battery(self)
        self.time = Time(self)

        scr = Wnck.Screen.get_default()

        for signal in ['active-window-changed', 'active-workspace-changed', 'workspace-created', 'workspace-destroyed']:
            scr.connect(signal, getattr(self, signal.replace('-','_')))

        self.timeout()
        GLib.timeout_add_seconds(1, self.timeout)

        # TODO: glib.IO_ERR, glib.IO_HUP
        GLib.io_add_watch(self.bar.stdout, GLib.IO_IN, self.read_bar)
        GLib.io_add_watch(self.bar.stderr, GLib.IO_IN, self.read_bar)

    def register_button_handler(self, name, func):
        self.button_handlers[name] = func


    def read_bar(self, channel, cond):
        name = channel.readline().decode('utf8').strip()
        if name in self.button_handlers:
            self.button_handlers[name]()
            self.display()
        return True

    def timeout(self):
        self.time.update()
        self.battery.update()
        self.display()
        return True

    def display(self):

        wsp = ''
        for workspace, my_workspace in self.workspaces.items():
            wsp += my_workspace.display()

        bat = self.battery.display()
        time = self.time.display()

        if self.active_window != None:
            title=self.circ(self.active_window.get_name(), fg='#FF000000', bg='#FFFFFFFF',)
        else:
            title = ''

        left=f"{wsp} {title}"
        center=f"{time}"
        right=f"{bat}"
        self.bar.stdin.write(f"%{{S1}}%{{l}}{left}%{{c}}{center}%{{r}}{right}%{{O8}}\n".encode())
        self.bar.stdin.flush()

    #def toggle_scratchpad(self):
        #self.active_window.minimize()
        #self.active_window.unminimize()

    def active_window_changed(self, screen, window):
        self.active_window = screen.get_active_window()
        self.display()

    def active_workspace_changed(self, screen, old_workspace):
        if old_workspace is not None:
            self.workspaces[old_workspace].active = False
        new_workspace = screen.get_active_workspace()
        if new_workspace is not None:
            self.workspaces[new_workspace].active = True
        self.display()

    def workspace_name_changed(self, workspace):
        self.display()

    def workspace_created(self, screen, workspace):
        my_workspace = self.workspaces[workspace]
        my_workspace.signal = workspace.connect('name-changed',
                                                self.workspace_name_changed)
        my_workspace.workspace = workspace
        self.display()

    def workspace_destroyed(self, screen, workspace):
        my_workspace = self.workspaces[workspace]
        workspace.disconnect(my_workspace.signal)
        my_workspace.workspace = None
        del self.workspaces[workspace]
        self.display()

    def icon(self, txt, fg=None, bg=None):
        if fg is None:
            fg = self.fg
        if bg is None:
            bg = self.bg
        color = f"%{{B{bg} F{fg} T2}}"
        return f'{color}{txt}'

    def text(self, txt, fg=None, bg=None):
        if fg is None:
            fg = self.fg
        if bg is None:
            bg = self.bg
        color = f"%{{B{bg} F{fg} T1}}"
        return f'{color}{txt}'

    def circ(self, txt, fg=None, bg=None):
        if bg is None:
            bg = self.bg
        clear = "#00000000"
        left = self.icon("", bg=clear, fg=bg)
        right = self.icon("", bg=clear, fg=bg)
        return f'{left}{self.text(txt, fg=fg, bg=bg)}{right}'

# create new process group, become its leader
os.setpgrp()

try:
    Manager()
    Gtk.main()
except:
    traceback.print_exc()
finally:
    # kill all processes in my group
    os.killpg(0, signal.SIGKILL)
