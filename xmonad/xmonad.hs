
import Control.Monad (liftM)
import Data.List
import Data.Ratio ((%))

import XMonad

import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import XMonad.Actions.SwapWorkspaces
import XMonad.Actions.WindowBringer

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FloatNext
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.ThreeColumns

import XMonad.ManageHook

import XMonad.Prompt
import XMonad.Prompt.Shell

import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.Scratchpad

import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "konsole"

-- Width of the window border in pixels.
--
myBorderWidth   = 2

-- modm lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
modm       = mod4Mask
modm2        = mod5Mask

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = map show [1..9]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#cd8b00"

--- Whether focus follows the mouse pointer.
--
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myFont  = "-*-verdana-medium-r-*-*-14-*-*-*-*-*-iso10646-1"
--myFont = "-*-dejavu sans mono-medium-r-*-*-16-*-*-*-*-*-iso10646-*"

myStatusbar = "my-dzen.sh"


------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- switch keyboard layout
    [ ((modm .|. shiftMask, xK_Return), spawn "switch-layout")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill1)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    --, ((modm,               xK_n     ), refresh)

    , ((modm .|. shiftMask, xK_s     ), sendMessage ToggleStruts)

    , ((modm,               xK_s     ), scratchpadSpawnActionTerminal myTerminal)

    -- Move focus to the next window
    , ((mod1Mask,           xK_Tab   ), windows W.focusDown)
    , ((modm2,              xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_w     ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_v     ), sendMessage (IncMasterN (-1)))

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), restart "xmonad" True)

    -- goto workspace and focus window
    , ((modm .|. shiftMask, xK_g     ), gotoMenu)

    -- bring and focus window
    , ((modm .|. shiftMask, xK_b     ), bringMenu)

    , ((modm              , xK_n     ), toggleWS)

    , ((modm              , xK_backslash), spawn "openim toggle skype")

    , ((modm              , xK_slash ), spawn "aumix -v -7")
    , ((modm              , xK_equal ), spawn "aumix -v +7")

    , ((0                 , 0x1008FF11), spawn "aumix -v -5")
    , ((0                 , 0x1008FF13), spawn "aumix -v +5")
    , ((0                 , 0x1008FF12), spawn "aumix -v 0")

    , ((0                 , 0x1008FF02), spawn "sudo /usr/sbin/brightness up")
    , ((0                 , 0x1008FF03), spawn "sudo /usr/sbin/brightness down")

    , ((modm2             , xK_less  ), spawn "mpc seek -2%")
    , ((modm2             , xK_semicolon), spawn "mpc seek +2%")
    , ((modm2             , xK_q     ), spawn "mpc prev")
    , ((modm2             , xK_j     ), spawn "mpc next")
    , ((modm2             , xK_k     ), spawn "mpc toggle")
    , ((modm2             , xK_x     ), floatNext True >> (spawn $ myTerminal ++ " -geometry 80x35+480+90 -e ncmpcpp"))

    --, ((modm2             , xK_a     ), spawn "")
    --, ((modm2             , xK_o     ), spawn "")
    --, ((modm2             , xK_e     ), spawn "")
    , ((modm2             , xK_u     ), spawn $ XMonad.terminal conf)
    , ((modm2             , xK_i     ), spawn "openim openchat")

    , ((modm2             , xK_apostrophe), spawn "firefox")
    -- used by xinerama
    --, ((modm2             , xK_comma ), spawn "")
    --, ((modm2             , xK_period), spawn "")
    , ((modm2             , xK_p     ), shellPrompt myXPConfig)
    , ((modm2             , xK_y     ), spawn "thunderbird")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    -- mod-ctrl-[1..9], Swap current workspace to workspace N
    --
    [((m .|. mask, k), windows $ f i)
        | mask <- [mod1Mask, modm2]
        , (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask), (swapWithCurrent, controlMask), (copy, shiftMask .|. controlMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm2, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_period, xK_comma] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

myLayout = avoidStruts $ smartBorders $ (tiled ||| Mirror tiled ||| noBorders Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = (composeAll . concat)
    [ [className =? c --> doFloat | c <- byClass]
    , [(liftM $ isInfixOf t) title --> doFloat | t <- byTitle]
    , [resource =? r --> doFloat | r <- byResource]
    , [isFullscreen --> doFullFloat]
    ] <+> manageHook defaultConfig
      <+> scratchpadManageHook (W.RationalRect 0.25 0.2 0.5 0.6)
      <+> floatNextHook
  where byClass = ["Gimp-2.6", "MPlayer", "Totem", "Pino", "Do", "Pidgin", "Skype", "Qmote"]
        byTitle = ["VLC (XVideo output)", "Downloads", "Preferences", "Save As..."]
        byResource = []

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
--myLogHook = dynamicLogDzen

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = setWMName "LG3D"

------------------------------------------------------------------------

myXPConfig :: XPConfig
myXPConfig = defaultXPConfig
  { font              = myFont
  --, bgColor           = "black"
  --, fgColor           = "#999999"
  --, fgHLight          = "#ffffff"
  --, bgHLight          = "#4c7899"
  , promptBorderWidth = 0
  --, position          = Bottom
  , height            = 20
  , historySize       = 128
  }

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main =
  do dzenOut <- spawnPipe myStatusbar
     xmonad $ defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = modm,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook <+> manageDocks,
        logHook            = dynamicLogWithPP $ myDzenPP dzenOut,
        startupHook        = myStartupHook
    }

myDzenPP h = defaultPP {
  ppOutput = hPutStrLn h,
  ppSep = " ^bg(" ++ myBgBgColor ++ ")^r(1,15)^bg()",
  ppWsSep = "",
  ppCurrent = wrapFgBg myCurrentWsFgColor myCurrentWsBgColor,
  ppVisible = wrapFgBg myVisibleWsFgColor myVisibleWsBgColor,
  ppHidden = wrapFg myHiddenWsFgColor,
  ppHiddenNoWindows = wrapFg myHiddenEmptyWsFgColor,
  ppUrgent = wrapBg myUrgentWsBgColor,
  ppTitle = (\x -> " " ++ wrapFg myTitleFgColor x),
  ppLayout  = dzenColor myFgColor"" .
                (\x -> case x of
                    "Tall" -> wrapBitmap "tall.xpm"
                    "Mirror Tall" -> wrapBitmap "mtall.xpm"
                    "Full" -> wrapBitmap "full.xpm"
                )
  }
  where
    wrapFgBg fgColor bgColor content= wrap ("^fg(" ++ fgColor ++ ")^bg(" ++ bgColor ++ ")") "^fg()^bg()" content
    wrapFg color content = wrap ("^fg(" ++ color ++ ")") "^fg()" content
    wrapBg color content = wrap ("^bg(" ++ color ++ ")") "^bg()" content
    wrapBitmap bitmap = "^i(" ++ myBitmapsPath ++ bitmap ++ ")"

-- Paths
myBitmapsPath = "/home/maik/.dzen/bitmaps/"

-- Colors
myBgBgColor = "black"
myFgColor = "gray80"
myBgColor = "gray20"

myCurrentWsFgColor = "white"
myCurrentWsBgColor = "gray40"
myVisibleWsFgColor = "gray80"
myVisibleWsBgColor = "gray20"
myHiddenWsFgColor = "gray80"
myHiddenEmptyWsFgColor = "gray40"
myUrgentWsBgColor = "brown"
myTitleFgColor = "white"

