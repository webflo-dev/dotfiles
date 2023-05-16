# from libqtile import bar, widget
from libqtile import bar
from libqtile.config import Screen
from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration
from qtile_extras.widget import modify


from utils.settings import wallpaper
from utils.colors import colors

from widgets.Nvidia import Nvidia
from widgets.NvidiaGraph import NvidiaGraph
from widgets.ContinuousPoll import PlayerCtl,PlayerCtlIcon

widget_defaults = dict(
    background=colors["background"] + "66"
)

extension_defaults = widget_defaults.copy()


def _left_decor():
    return [
        RectDecoration(
            use_widget_background=True,
            radius=[10, 0, 0, 10],
            filled=True,
        ),
    ]


def _right_decor():
    return [
        RectDecoration(
            colour=widget_defaults["background"],
            radius=[0, 10, 10, 0],
            filled=True,
        ),
    ]

def _rounded_decor():
    return [
        RectDecoration(
            colour=widget_defaults["background"],
            radius=10, 
            filled=True
        )
    ]


screens = [
    Screen(
        #wallpaper=wallpaper,
        #wallpaper_mode="fill",
        top=bar.Bar([ 
            widget.Spacer(300),
             widget.GroupBox(
                disable_drag=True,
                highlight_method="text",
                active=colors["sky"],
                inactive=colors["gray"],
                this_current_screen_border=colors["yellow"],
                this_screen_border=colors["yellow"],
                urgent_alert_method="text",
                urgent_text=colors["urgent"],
                fontsize=18,
                margin_x=20,
                spacing=4,
                decorations=_rounded_decor()
            ),
            widget.Spacer(100),

            widget.CurrentLayoutIcon(scale=0.5, 
                background=colors["yellow"],
                decorations=_left_decor(),
            ),
            widget.CurrentLayout(decorations=_right_decor(), fontsize=14, padding=10),

            widget.Spacer(10),
            widget.Chord(fmt=' {}', fontsize=14, foreground=colors["dark"], background=colors["orange"], decorations=[RectDecoration(radius=10, filled=True, use_widget_background=True)]),


            widget.Spacer(30),
            widget.TextBox(text="", font="webflo-glyph", fontsize=18, padding=10,  foreground=colors["gray"], background=colors["lime"], decorations=_left_decor()),
            # modify(PlayerCtlIcon, scale=0.7, background=widget_defaults["background"]),
            #PlayerCtlIcon(scale=0.7),
            modify(PlayerCtl, padding=10, fontsize=14,  decorations=_right_decor()),
            # PlayerCtlIcon(decoration=_right_decor()),
            # ContinuousPoll(),
            #widget.Spacer(50),
            #Playerctl(),
            #widget.TextBox(text="", font="webflo-glyph", fontsize=20, padding=10,  foreground=colors["gray"], background=colors["yellow"], decorations=_left_decor()),
            # widget.Mpris2(name="spotify", objname="org.mpris.MediaPlayer2.spotify", scroll_chars=300, background=colors["background"], decorations=_right_decor()),
            #modify(Playerctl, text="hello world !!", decorations=_right_decor()),
            widget.Spacer(),

            widget.TextBox(text="", font="webflo-glyph", fontsize=18, padding=10,  foreground=colors["gray"], background=colors["yellow"], decorations=_left_decor()),
            widget.Clock(format="%H:%M",  fontsize=18, padding=10, decorations=_right_decor()),
            widget.Spacer(30),
            widget.TextBox(text="", font="webflo-glyph",  fontsize=18, padding=10, foreground=colors["gray"],  background=colors["yellow"], decorations=_left_decor()),
            widget.Clock(format="%A %d %B",  fontsize=18, padding=10, decorations=_right_decor()),


            widget.Spacer(),

            widget.Systray(**widget_defaults, decorations=_rounded_decor()),


            widget.Spacer(100),

            widget.Net(format='NETWORK\n{down} ↓↑ {up}', use_bits=True, fontsize=14, padding=10,  foreground=colors["gray"], background=colors["yellow"], decorations=_left_decor()),
            widget.NetGraph(margin_x=10, border_width=0, graph_color=colors["lime"], fill_color=colors["green"],  decorations=_right_decor()),

            widget.Spacer(30),

            widget.CPU(format='CPU\n{load_percent}%', fontsize=14, padding=10,  foreground=colors["gray"], background=colors["yellow"], decorations=_left_decor()),
            widget.CPUGraph(margin_x=10, border_width=0, graph_color=colors["lime"], fill_color=colors["green"],  decorations=_right_decor()),

            widget.Spacer(30),

            widget.Memory(measure_mem='G', format='RAM\n{MemPercent}%', fontsize=14, padding=10,  foreground=colors["gray"], background=colors["yellow"], decorations=_left_decor()),
            widget.MemoryGraph(margin_x=10, border_width=0, graph_color=colors["lime"],  fill_color=colors["green"],  decorations=_right_decor()),

            widget.Spacer(30),

            modify(Nvidia, format='GPU\n{usage} | {temp}°C', fontsize=14, padding=10,  foreground=colors["gray"], background=colors["yellow"], decorations=_left_decor()),
            modify(NvidiaGraph,margin_x=10, border_width=0, graph_color=colors["lime"],  fill_color=colors["green"],  decorations=_right_decor()),

            widget.Spacer(300),
        ],
        40,
        margin=[10, 0, 0, 0],
        opacity=0.9,
        background=colors["background"] + "00",
        )
    )
]


