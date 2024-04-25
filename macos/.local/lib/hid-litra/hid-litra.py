#!/usr/bin/env python3
from subprocess import run as sysrun, CalledProcessError
from enum import IntEnum
from argparse import ArgumentParser
import platform
import math
import sys
import os

print(os.path.dirname(os.path.realpath(__file__)))

class Device(IntEnum):
    GLOW = 0xC900
    BEAM = 0xC901


class Light(object):
    HID_BIN=f'{os.path.dirname(os.path.realpath(__file__))}/hidapitester-{platform.machine()}'
    LITRA_PREFIX=[0x11, 0xff, 0x04]
    LITRA_CMD_POWER=[0x1C]
    LITRA_CMD_BRIGHTNESS=[0x4c, 0x00]
    LITRA_CMD_TEMPERATURE=[0x9c]

    def __init__(self, device_id=Device.GLOW):
        self.device_id = device_id
        self._brightness = None
        self._temperature = None
        self._power = None
        if not isinstance(self.device_id, Device):
            raise ValueError(f'{device_id} not a recognized device')

    @staticmethod
    def _bytes_to_string(data_bytes):
        return ','.join([f"0x{s:02X}" for s in data_bytes])

    def _run_hid(self, command, value):
        if type(value) not in (list, tuple):
            value = [value]

        data_bytes = self.LITRA_PREFIX + command + value
        hid_cmd=[
            self.HID_BIN,
            '--vidpid', f'046D/{self.device_id:04X}',
            '--open',
            '--length', '20',
            '--send-output', f'{Light._bytes_to_string(data_bytes)}'
            ]
        completed = sysrun(hid_cmd, capture_output=True)

        # hidapitester doesn't give non-zero return codes on error
        if (b'Error' in completed.stdout) or (completed.returncode != 0):
            print(completed.stdout.decode('utf8'))
            raise CalledProcessError(1, self.HID_BIN)


    def set_brightness(self, bright_percent):
        MIN_BRIGHTNESS = 0x14
        MAX_BRIGHTNESS = 0xfa
        level = math.floor(
            MIN_BRIGHTNESS
            + ((bright_percent/100) * (MAX_BRIGHTNESS - MIN_BRIGHTNESS)))
        self._run_hid(self.LITRA_CMD_BRIGHTNESS, level)
        self._brightness = bright_percent


    def set_temperature(self, color_temp):
        MIN_TEMP = 2700
        MAX_TEMP = 6500
        if color_temp < MIN_TEMP:
            raise ValueError(f"{color_temp} is below {MIN_TEMP}K")
        if color_temp > MAX_TEMP:
            raise ValueError(f"{color_temp} is above {MAX_TEMP}K")

        self._run_hid(
            self.LITRA_CMD_TEMPERATURE,
            [int(b) for b in color_temp.to_bytes(2, 'big')])
        self._temperature = color_temp


    def on(self):
        self._run_hid(self.LITRA_CMD_POWER, 0x01)
        self._power = 1


    def off(self):
        self._run_hid(self.LITRA_CMD_POWER, 0x00)
        self._power = 0


    @property
    def power(self):
        return self._power


    @power.setter
    def power(self, value):
        if value == 0:
            self.off()
        else:
            self.on()


    @property
    def brightness(self):
        return self._brightness

    @brightness.setter
    def brightness(self, bright_percent):
        self.set_brightness(bright_percent)


    @property
    def temperature(self):
        return self._temperature

    @temperature.setter
    def temperature(self, temp):
        self.set_temperature(temp)


# Command-line mode
if __name__ == '__main__':
    if os.getenv('DEBUG', 0) == 0:
        sys.tracebacklimit = 0

    arg_parser = ArgumentParser(description="Control Litra Glow and Litra Beam Devices on macOS")
    arg_parser.add_argument(
        'power', nargs='?', choices=['on', 'off'], default='on',
        help='Set the light on or off (defaults to on)'
        )
    arg_parser.add_argument(
        '-d', '--device', choices=['glow', 'beam'], default='glow',
        help='Specify Litra Glow or Beam [default "glow"]'
        )
    arg_parser.add_argument(
        '-t', '--color-temp', type=int, choices=range(2700, 6501),
        metavar='TEMP',
        help='Set color temp in ºK; allowed values between 2700 and 6500, inclusive'
        )
    arg_parser.add_argument(
        '-b', '--brightness', type=int, choices=range(0,101),
        metavar='PERCENT',
        help='Set brightness percentage'
        )

    args = arg_parser.parse_args()

    if args.device == 'glow':
        light = Light(Device.GLOW)
    elif args.device == 'beam':
        light = Light(Device.BEAM)

    if args.color_temp is not None:
        light.temperature = args.color_temp

    if args.brightness is not None:
        light.brightness = args.brightness

    if args.power == 'on':
        light.power = 1
    elif args.power == 'off':
        light.power = 0
