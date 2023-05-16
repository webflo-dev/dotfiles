
from ast import Subscript
from asyncore import read
from datetime import date
from libqtile import bar, hook
from libqtile.log_utils import logger
from libqtile.widget import base

import asyncio
import subprocess
import concurrent.futures

from utils.commands import local_bin

class Playerctl(base._TextBox):

    defaults = [
        (
            "update_interval",
            600,
            "Update interval in seconds, if none, the " "widget updates whenever it's done.",
        ),
    ] 

    def __init__(self, text="", **config):
        super().__init__(text, **config)
        self.add_defaults(Playerctl.defaults)
        self.proc = None

    # def _configure(self, qtile, bar):
    #     base._TextBox._configure(self, qtile, bar)

    async def _config_async(self):
        self.update('[playerctl widget]')

    async def toto():
        cmd=["/home/florent/.local/bin/spotify-player", "--subscribe", "metadata", "{{ xesam:artist }}|{{ xesam:title }}|{{ mpris:artUrl }}"]
        proc = await asyncio.subprocess.create_subprocess_exec(
            "/home/florent/.local/bin/spotify-player", "--subscribe metadata '{{ xesam:artist }}|{{ xesam:title }}|{{ mpris:artUrl }}'", 
            stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )
        _, _, exit_code = await asyncio.gather(
            self.exec_with_logging_reader(proc.stdout),
            proc.wait(),
        )
        return exit_code


    async def exec_with_logging_reader(self, reader):
        while True:
            output = await reader.readline();
            if not output:
                continue

            text = output.decode("utf-8")
            logger.warning(text)
            if text == '':
                continue
            self.update(text.strip())
            # [artist, album, imageUrl] = output.split("|")
            # text = "Artist: {} | Title: {} | Image: {}".format(artist, album, imageUrl)
            # self.update(text)


    def subscribe(self):
        self.update("hello world !")
        cmd=["/home/florent/.local/bin/spotify-player", "--subscribe", "metadata", "{{ xesam:artist }}|{{ xesam:title }}|{{ mpris:artUrl }}"]
        # cmd=["/usr/bin/playerctl", "-p", "spotify", "--follow", "{{ xesam:artist }}|{{ xesam:title }}|{{ mpris:artUrl }}"]

        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=None);
        while True:
            output = proc.stdout.readline().decode("utf-8").strip()
            if output == '':
                continue
            [artist, album, imageUrl] = output.split("|")
            text = "Artist: {} | Title: {} | Image: {}".format(artist, album, imageUrl)
            self.update(text)

