from libqtile import widget

class CustomVolume(widget.PulseVolume):
    def _update_drawer(self):
        if self.volume <= 0:
            self.text = "婢"
        elif self.volume <= 15:
            self.text = "奄 " + str(self.volume)
        elif self.volume < 50:
            self.text = "奔 " + str(self.volume)
        elif self.volume < 80:
            self.text = "墳 " + str(self.volume)
        else:
            self.text = " " + str(self.volume)
        self.draw()

