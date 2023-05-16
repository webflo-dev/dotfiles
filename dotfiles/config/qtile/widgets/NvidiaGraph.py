from libqtile.widget.graph import _Graph
from libqtile.widget import base

import subprocess


class NvidiaGraph(_Graph):

    fixed_upper_bound = True
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        _Graph.__init__(self, interval=2, **config)
        self.maxvalue = 100

    def _get_value(self):
        command = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits"
        raw = subprocess.check_output(command, shell=True, encoding="utf-8").strip()
        return int(raw)

    def update_graph(self):
        val = self._get_value()
        self.push(val)

