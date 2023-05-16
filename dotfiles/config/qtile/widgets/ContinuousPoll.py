import asyncio
import subprocess
from time import sleep

from libqtile import bar, hook
from libqtile.widget import base, TextBox
from libqtile.log_utils import logger

from xdg.IconTheme import getIconPath

class ContinuousPoll(TextBox):

    def __init__(self, cmd="", **config):
        super().__init__(**config)
        self.cmd = cmd
        self._finalized = False

    async def _config_async(self):
        try:
            proc = await asyncio.create_subprocess_shell(self.cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.DEVNULL)
            # proc = await asyncio.create_subprocess_shell(self.cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE)

            while not self._finalized:
                output = await proc.stdout.readline()
                print(f"output here: {output}")
                if not output:
                    self.update("")
                    continue
                text = output.decode("utf-8").strip()
                if text == '':
                    self.update("")
                    continue
                self.process_output(text)
        finally:
            proc.kill()

    def finalize(self):
        self._finalized = True
        TextBox.finalize(self)

    def process_output(self, text):
        pass


class PlayerCtl(ContinuousPoll):

    def __init__(self,  **config):
        super().__init__("/usr/bin/playerctl --follow metadata --format '{{ playerName }}|{{ xesam:artist }}|{{ xesam:title }}|{{ mpris:artUrl }}'", **config)

    def process_output(self, text):
        [playerName, artist, title, imageUrl] = text.split("|")
        if artist == '' and title == '':
            sleep(0.5)
            text = subprocess.check_output(["/usr/bin/playerctl", "metadata", "--format", "'{{ playerName }}|{{ xesam:artist }}|{{ xesam:title }}|{{ mpris:artUrl }}'"], encoding="utf-8")
            if not text or text == '':
                return
            [playerName, artist, title, imageUrl] = text.split("|")
        if artist == '':
            text = f"{title}"
        if title == '':
            text = f"{artist}"
        if artist != '' and title != '':
            text = f"{artist}\n{title}"
        self.update(text)


import cairocffi

class PlayerCtlIcon(ContinuousPoll):
    defaults = [
        ("scale", 1, "Scale factor relative to the bar height.  " "Defaults to 1"),
    ]

    def __init__(self, **config):
        ContinuousPoll.__init__(self, cmd="/usr/bin/playerctl --follow metadata --format '{{ playerName }}'", **config)
        self.add_defaults(PlayerCtlIcon.defaults)
        self.scale = 1.0 / self.scale
        self.length_type = bar.STATIC
        self.length = 0
        self.surfaces = {}

    def _configure(self, qtile, bar):
        ContinuousPoll._configure(self, qtile, bar)
        self.surfaces[self.text] = self.get_surface(True)

    def process_output(self, text):
        if text == 'edge':
            self.text = "microsoft-edge"
        else:
            self.text = text
        self.surfaces[self.text] = self.get_surface()
        self.draw()

    def draw(self):
        try:
            surface = self.surfaces[self.text]
        except KeyError:
            # Fallback to text
            ContinuousPoll.draw(self)
        else:
            self.drawer.clear(self.background or self.bar.background)
            self.drawer.ctx.set_source(surface)
            self.drawer.ctx.paint()
            self.drawer.draw(offsetx=self.offset, offsety=self.offsety, width=self.length)


    def get_surface(self, use_default: bool = False):
        if not use_default:
            fileName = getIconPath(self.text)
        else:
            fileName = "/home/florent/Downloads/remix-logo.png"
        img = cairocffi.ImageSurface.create_from_png(fileName)

        input_width = img.get_width()
        input_height = img.get_height()

        sp = input_height / (self.bar.height - 1)

        width = input_width / sp
        if width > self.length:
            self.length = int(width) + self.actual_padding * 2

        imgpat = cairocffi.SurfacePattern(img)

        scaler = cairocffi.Matrix()

        scaler.scale(sp, sp)
        scaler.scale(self.scale, self.scale)
        factor = (1 - 1 / self.scale) / 2
        scaler.translate(-width * factor, -width * factor)
        scaler.translate(self.actual_padding * -1, 0)
        imgpat.set_matrix(scaler)

        imgpat.set_filter(cairocffi.FILTER_BEST)
        return imgpat
