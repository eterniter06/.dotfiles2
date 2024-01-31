import           Control.Monad (filterM,liftM, join)

import           Data.Monoid
import           Data.IORef
import           Data.List
import           qualified Data.Set as S
import           qualified XMonad.Util.Hacks as Hacks

import           System.Exit

import           Graphics.X11.ExtraTypes.XF86

import           XMonad

import           XMonad.Actions.CycleWS
import           XMonad.Actions.GridSelect
import           XMonad.Actions.SpawnOn

import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.FadeInactive
import           XMonad.Hooks.InsertPosition
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.ScreenCorners
import           XMonad.Hooks.StatusBar
import           XMonad.Hooks.StatusBar.PP

--import XMonad.Layout.Renamed (renamed, Rename(Replace))
import           XMonad.Layout.IndependentScreens
import           XMonad.Layout.Grid
import           XMonad.Layout.Magnifier
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Spacing
import           XMonad.Layout.ThreeColumns

import           XMonad.Util.ClickableWorkspaces
import           XMonad.Util.Cursor
import           XMonad.Util.EZConfig
import           XMonad.Util.Loggers
import           XMonad.Util.Run
import           XMonad.Util.SpawnOnce

import qualified Data.Map                      as M
import qualified XMonad.StackSet               as W

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

xmobarEscape = concatMap doubleLts
 where
  doubleLts '<' = "<<"
  doubleLts x   = [x]

myClickableWorkspaces :: [String]
myClickableWorkspaces = clickable . (map xmobarEscape) $ myWorkspaces
 where
  clickable l =
    [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>"
    | (i, ws) <- zip [0 .. len] l
    , let n = i
    ]
  len = length myWorkspaces

-- my2MonitorClickableWorkspaces = withScreens 2 myClickableWorkspaces

-- Border colors
borderBlue, borderWhite, borderBlack :: String
borderBlue = "#008bdb"
borderWhite = "#ffffff"
borderBlack = "#000000"

------------------------------------------------------------------------
-- Choose modKey alias
leftAlt, rightAlt, winKey :: KeyMask
leftAlt = mod1Mask
rightAlt = mod3Mask
winKey = mod4Mask

myRofi = "rofi -show drun -theme /$HOME/.config/rofi/launchers/type-3/style-2.rasi"
myRofiBluetooth = "rofi-bluetooth -theme /$HOME/.config/rofi/launchers/type-7/style-4.rasi"

brightnessController = "$HOME/.config/xmonad/brightness "
volumeController = "$HOME/.config/xmonad/volume "

screenshot = "killall picom; flameshot gui; picom --daemon"

myKeys conf@(XConfig { XMonad.modMask = modm }) =
  M.fromList
    $

    [ ((0, xF86XK_AudioRaiseVolume), spawn $ volumeController ++ "--inc")
    , ((0, xF86XK_AudioLowerVolume), spawn $ volumeController ++ "--dec")
    , ((0, xF86XK_AudioPlay),    spawn $ volumeController ++ "--play-pause")
    , ((0, xF86XK_AudioPause),   spawn $ volumeController ++ "--play-pause")
    , ((0, xF86XK_AudioNext),    spawn $ volumeController ++ "--next")
    , ((0, xF86XK_AudioPrev),    spawn $ volumeController ++ "--prev")

    -- Volume mute
    , ((0, xF86XK_AudioMute), spawn $ volumeController ++ "--toggle_mute")

    -- Media play/pause
    , ((modm, xF86XK_AudioMute), spawn "playerctl play-pause")

    -- Media Next
    , ((modm, xF86XK_AudioRaiseVolume), spawn "playerctl next")

    -- Media Previous
    , ((modm, xF86XK_AudioLowerVolume), spawn "playerctl previous")
    ]

    ++

    [ ((0, xF86XK_MonBrightnessUp),     spawn $ brightnessController ++ "-inc")
    , ((0, xF86XK_MonBrightnessDown),   spawn $ brightnessController ++ "-dec")
    ]
    
    ++

    -- Arrow keybinds: Up/Down for layout changes | Left/Right for workspace
    [ ((modm, xK_Up), windows W.focusDown)
    , ((modm, xK_Down), windows W.focusUp)
    , ((modm, xK_Left), prevWS)
    , ((modm, xK_Right), nextWS)

    , ((modm .|. shiftMask, xK_Up), windows W.swapDown)
    , ((modm .|. shiftMask, xK_Down), windows W.swapUp)
    , ((modm .|. shiftMask, xK_Left), shiftToPrev >> prevWS)
    , ((modm .|. shiftMask, xK_Right), shiftToNext >> nextWS)
    ]

    ++

    -- Power keybinds
    [ ((modm .|. shiftMask, xK_s), spawn "systemctl suspend")
    , ((modm .|. shiftMask, xK_u), spawn "systemctl poweroff")
    , ((modm .|. shiftMask, xK_o), spawn "systemctl reboot")
    ]

    ++

    -- Rofi Menu keybinds
    [ ((modm, xK_z), spawn myRofi)
    , ((modm, xK_p), spawn myRofi)
    , ((modm .|. shiftMask, xK_z), spawn myRofiBluetooth)
    , ((modm .|. shiftMask, xK_p), spawn myRofiBluetooth)
    ] ++
    -- launch default terminal
       [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch alacritty
       , ((modm .|. shiftMask, xK_Tab), spawn "alacritty")

    -- Lock Screen
       , ((modm .|. shiftMask, xK_l), spawn "slock")

    -- take full screenshot
       , ((modm, xK_s), spawn screenshot)

    -- close focused window
       , ((modm .|. shiftMask, xK_c), kill)

     -- Rotate through the available layout algorithms
       , ((modm, xK_space), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
       , ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
       , ((modm, xK_n), refresh)

    -- Move focus to the next window
       , ((modm, xK_Tab), windows W.focusDown)

    -- Move focus to the next window
       , ((modm, xK_j), windows W.focusDown)

    -- Move focus to the previous window
       , ((modm, xK_k), windows W.focusUp)

    -- Move focus to the master window
       , ((modm, xK_m), windows W.focusMaster)

    -- Swap the focused window and the master window
       , ((modm, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
       , ((modm .|. shiftMask, xK_j), windows W.swapDown)

    -- swap the focused window with the previous window
       , ((modm .|. shiftMask, xK_k), windows W.swapUp)

    -- Shrink the master area
       , ((modm, xK_h), sendMessage Shrink)

    -- Expand the master area
       , ((modm, xK_l), sendMessage Expand)

    -- Push window back into tiling
       , ((modm, xK_t), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
       , ((modm, xK_comma), sendMessage (IncMasterN 1))

    -- Decrement the number of windows in the master area
       , ((modm, xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
       , ((modm .|. shiftMask, xK_q), io (exitWith ExitSuccess))

    -- Restart xmonad
       , ((modm, xK_q), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
       , ((modm .|. shiftMask, xK_slash)
         , spawn ("echo \"" ++ help ++ "\" | xmessage -file -")
         )
       ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N

       [ ((m .|. modm, k), windows $ f i)
       | (i, k) <- zip (XMonad.workspaces conf) [xK_0 .. xK_9]
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
       ]
    ++

    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
       [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
       | (key, sc) <- zip [xK_w, xK_e, xK_r] [0 ..]
       , (f  , m ) <- [(W.view, 0), (W.shift, shiftMask)]
       ]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings XConfig { XMonad.modMask = modm } =
  M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
      [ ((modm, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
      , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
      , ((modm, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)      , ((0, frontThumbButton), \w -> nextWS)
      
      , ((0, backThumbButton), \w -> prevWS)
      , ((0, backThumbButton), \w -> prevWS)
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
      ]
 where
  backThumbButton  = 8
  frontThumbButton = 9

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

mySpacing = spacingRaw True (Border 0 10 10 10) True (Border 10 10 10 10) True
-- Use at the beginning of myLayout to use spacing between windows
-- myFocusedBorderColor = "#ffffff"

myLayout =
    screenCornerLayoutHook
    $   avoidStruts
    $   smartBorders
    $   tiled
    ||| Mirror tiled
    ||| Grid
    ||| Full
 where
     -- default tiling algorithm partitions the screen into two panes
  tiled   = Tall nmaster delta ratio

  -- The default number of windows in the master pane
  nmaster = 1

  -- Default proportion of screen occupied by master pane
  ratio   = 67 / 100

  -- Percent of screen to increment by when resizing panes
  delta   = 3 / 1000

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
myManageHook = insertPosition End Newer <+> composeAll
  [ className =? "MPlayer" --> doFloat
  , className =? "Onboard" --> doFloat
  , stringProperty "WM_WINDOW_ROLE" =? "GtkFileChooserDialog" --> doCenterFloat
  , resource =? "desktop_window" --> doIgnore
  , resource =? "kdesktop" --> doIgnore
  , manageDocks
  ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook event = screenCornerEventHook event 

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.

-- Potential fix for not fading video players
-- Source: https://superuser.com/questions/260041/override-xmonad-fade-inactive-for-a-window

myFadeHook toggleFadeSet = fadeOutLogHook $ fadeIf (testCondition toggleFadeSet) 0.75
doNotFadeOutWindows = title =? "Call with " <||> className =? "xine" <||> className =? "MPlayer"

testCondition :: IORef (S.Set Window) -> Query Bool
testCondition floats =
    liftM not doNotFadeOutWindows <&&> isUnfocused
    <&&> (join . asks $ \w -> liftX . io $ S.notMember w `fmap` readIORef floats)

toggleFadeOut :: Window -> S.Set Window -> S.Set Window
toggleFadeOut w s | w `S.member` s = S.delete w s
                  | otherwise = S.insert w s

-- End of potential fix


------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
myStartupHook = do
  spawnOnce "volnoti -t 1.4 -a 0.25 -r 25" -- Volume notificaiton daemon | Responsible for the volume indication overlay
  spawnOnce "$HOME/.config/xmonad/caps &"
  spawnOnce "picom &"
  spawnOnce "dunst &"
  spawnOnce "$HOME/.config/nitrogen/start-auto-nitrogen &" -- wallpaper script
  spawnOnce "easyeffects --gapplication-service"
  spawnOnce "copyq &"
  spawnOnce "unclutter --ignore-scrolling --jitter 8 &"
  setDefaultCursor xC_left_ptr
  addScreenCorners
    [ (SCUpperRight, spawn myRofi)
    , (SCLowerRight, nextWS)
    , (SCLowerLeft , prevWS)
    ]

------------------------------------------------------------------------
-- Pretty printing xmobar status info

myXMobarPP = def
  { ppLayout = ppLayoutPrinter
  , ppCurrent = royalBluePP . discardSecondString wsIconFull
  , ppHidden = whitePP . discardSecondString wsIconFull
  , ppHiddenNoWindows = lowWhitePP . discardSecondString wsIconEmpty 
  , ppTitle = myPPTitle

  -- set separator manually for each entry
  , ppSep = ""

  }

discardSecondString :: String -> String -> String
discardSecondString a b = a

wsIconFull, wsIconEmpty, wsIconHidden :: String
wsIconFull   = "   <fn=1>\xf111</fn>   "
wsIconHidden = "   <fn=1>\xf111</fn>   "
wsIconEmpty  = "   <fn=1>\xf10c</fn>   "

wrapIcon :: String -> String
wrapIcon absoluteIconDirectory = wrap "    <icon=" "/>      " absoluteIconDirectory

ppLayoutPrinter :: String -> String
ppLayoutPrinter "Tall" = bluePP $ wrapIcon "/home/infinity/.config/xmobar/xpm/tall_selected.xpm"
ppLayoutPrinter "Mirror Tall" = magentaPP $ wrapIcon "/home/infinity/.config/xmobar/xpm/mirrored_tall_selected.xpm"
ppLayoutPrinter "Grid" = purplePP $ wrapIcon "/home/infinity/.config/xmobar/xpm/grid_selected.xpm"
ppLayoutPrinter "Full" = whitePP $ wrapIcon "/home/infinity/.config/xmobar/xpm/full_selected.xpm"
ppLayoutPrinter x = whitePP "?"

myPPTitle :: String -> String
myPPTitle = xmobarRaw . (\w -> if null w then "Infinity" else w) . shorten 70

magentaPP = xmobarColor "#ff79c6" ""
royalBluePP = xmobarColor "#52b9ff" ""
whitePP = xmobarColor "#f8f8f2" ""
lowWhitePP = xmobarColor "#bbbbbb" ""
purplePP = xmobarColor "#CE7AFF" ""
bluePP = xmobarColor "#0000FF" ""

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
-- Run xmonad with the settings you specify. No need to modify this.

main :: IO()
main = do
  xmonad
    .ewmh
    .ewmhFullscreen
    . withEasySB (statusBarProp "xmobar $HOME/.config/xmobar/bottomrc" (pure myXMobarPP)) defToggleStrutsKey
    . withEasySB (statusBarProp "xmobar $HOME/.config/xmobar/toprc" (pure myXMobarPP)) defToggleStrutsKey
    . docks
    $ defaults -- >= 0.17
defaults = def {
      -- simple stuff
                 terminal           =  "kitty"
               , focusFollowsMouse  = True
               , clickJustFocuses   = False
               , borderWidth        = 2
               , modMask            = winKey
               , workspaces         = myClickableWorkspaces
               , normalBorderColor  = borderBlack
               , focusedBorderColor = borderWhite

      -- key bindings
               , keys               = myKeys
               , mouseBindings      = myMouseBindings

      -- hooks, layouts
               , layoutHook         = myLayout
               , manageHook         = manageSpawn <+> myManageHook
               , handleEventHook    = myEventHook <> Hacks.windowedFullscreenFixEventHook
               -- , logHook            = myLogHook
               , startupHook        = myStartupHook
               }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines
  [ "The default modifier key is 'alt'. Default keybindings:"
  , ""
  , "-- launching and killing programs"
  , "mod-Shift-Enter  Launch xterminal"
  , "mod-p            Launch dmenu"
  , "mod-Shift-p      Launch gmrun"
  , "mod-Shift-c      Close/kill the focused window"
  , "mod-Space        Rotate through the available layout algorithms"
  , "mod-Shift-Space  Reset the layouts on the current workSpace to default"
  , "mod-n            Resize/refresh viewed windows to the correct size"
  , ""
  , "-- move focus up or down the window stack"
  , "mod-Tab        Move focus to the next window"
  , "mod-Shift-Tab  Move focus to the previous window"
  , "mod-j          Move focus to the next window"
  , "mod-k          Move focus to the previous window"
  , "mod-m          Move focus to the master window"
  , ""
  , "-- modifying the window order"
  , "mod-Return   Swap the focused window and the master window"
  , "mod-Shift-j  Swap the focused window with the next window"
  , "mod-Shift-k  Swap the focused window with the previous window"
  , ""
  , "-- resizing the master/slave ratio"
  , "mod-h  Shrink the master area"
  , "mod-l  Expand the master area"
  , ""
  , "-- floating layer support"
  , "mod-t  Push window back into tiling; unfloat and re-tile it"
  , ""
  , "-- increase or decrease number of windows in the master area"
  , "mod-comma  (mod-,)   Increment the number of windows in the master area"
  , "mod-period (mod-.)   Deincrement the number of windows in the master area"
  , ""
  , "-- quit, or restart"
  , "mod-Shift-q  Quit xmonad"
  , "mod-q        Restart xmonad"
  , "mod-[1..9]   Switch to workSpace N"
  , ""
  , "-- Workspaces & screens"
  , "mod-Shift-[1..9]   Move client to workspace N"
  , "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3"
  , "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3"
  , ""
  , "-- Mouse bindings: default actions bound to mouse events"
  , "mod-button1  Set the window to floating mode and move by dragging"
  , "mod-button2  Raise the window to the top of the stack"
  , "mod-button3  Set the window to floating mode and resize by dragging"
  ]
