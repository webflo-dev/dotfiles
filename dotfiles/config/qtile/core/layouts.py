from libqtile import layout
from libqtile.config import Match
from utils.colors import colors


layout_default = dict(
    margin=30,
    border_normal=colors["background"],
    border_focus=colors["yellow"],
    border_width=4,
    border_on_single=True,
)

layouts = [
    layout.MonadTall(**layout_default, 
        ratio = 0.66
    ),
    # layout.RatioTile(**layout_default),
    # layout.Max(**layout_default),
    # layout.Matrix(**layout_default),
    layout.Columns(**layout_default, 
        border_focus_stack = colors["red"], 
        border_normal_stack = colors["light"],
        # fair=True,
    ),
    layout.TreeTab(**layout_default, 
        active_bg = colors["yellow"],
        active_fg = colors["background"],
        bg_color = colors["background"] + "66",
        margin_left=50,
        margin_right=50,
        vspace=5,
        sections=[''],
    ),
    layout.Stack(**layout_default),
    # layout.Floating(**layout_default),
   ]

floating_layout = layout.Floating(**layout_default,
        float_rules=[
            Match(wm_type="utility"),
            Match(wm_type="notification"),
            Match(wm_type="toolbar"),
            Match(wm_type="splash"),
            Match(wm_type="dialog"),
            Match(wm_class="file_progress"),
            Match(wm_class="confirm"),
            Match(wm_class="dialog"),
            Match(wm_class="download"),
            Match(wm_class="error"),
            Match(wm_class="notification"),
            Match(wm_class="splash"),
            Match(wm_class="toolbar"),
            Match(func=lambda c: c.has_fixed_size()),
            Match(func=lambda c: c.has_fixed_ratio()),
            Match(wm_class="xdman-Main"),
            Match(wm_class="nitrogen"),
            Match(wm_class="lxappearance"),
        ])

# floating_layout = layout.Floating(float_rules=[
#     # Run the utility of `xprop` to see the wm class and name of an X client.
#     Match(wm_type='utility'),
#     Match(wm_type='notification'),
#     Match(wm_type='toolbar'),
#     Match(wm_type='splash'),
#     Match(wm_type='dialog'),
#     Match(wm_class='file_progress'),
#     Match(wm_class='confirm'),
#     Match(wm_class='dialog'),
#     Match(wm_class='download'),
#     Match(wm_class='error'),
#     Match(wm_class='notification'),
#     Match(wm_class='splash'),
#     Match(wm_class='toolbar'),
#     Match(wm_class='confirmreset'),  # gitk
#     Match(wm_class='makebranch'),  # gitk
#     Match(wm_class='maketag'),  # gitk
#     Match(wm_class='ssh-askpass'),  # ssh-askpass
#     Match(title='branchdialog'),  # gitk
#     Match(title='pinentry'),  # GPG key password entry
# ],**layout_default)


#floating_layout = layout.Floating(**layout_default, float_rules=[
#    # Run the utility of `xprop` to see the wm class and name of an X client.
#    {"wmclass": "confirm"},
#    {"wmclass": "dialog"},
#    {"wmclass": "download"},
#    {"wmclass": "error"},
#    {"wmclass": "file_progress"},
#    {"wmclass": "notification"},
#    {"wmclass": "splash"},
#    {"wmclass": "toolbar"},
#    {"wname": "pinentry"},  # GPG key password entry
#    {"wmclass": "ssh-askpass"},  # ssh-askpass
#],)
