-- Polybolos, a customizable web UI launcher application for Mac OSX --
-- https://github.com/JeffreyUrban/polybolos --
-- This file last updated 2025-08-02 --

on run {input, parameters}

	-- Get the path to this launcher app
	set appPathText to (path to me) as text
	if appPathText ends with ":" then
		set appPathText to text 1 thru -2 of appPathText
	end if
	set posixAppPath to POSIX path of appPathText

	-- Remove trailing ".app" to get base directory for supporting files
	set baseAppPath to posixAppPath
	if baseAppPath ends with ".app" then
		set baseAppPath to text 1 thru ((length of baseAppPath) - 4) of baseAppPath
	end if

	-- Supporting files directory—same name as app (without .app), same parent
	-- (If there’s still a trailing slash, remove it)
	if baseAppPath ends with "/" then
		set baseAppPath to text 1 thru -2 of baseAppPath
	end if

	-- Reference the files:
	set shellScriptPath to baseAppPath & "/launcher.sh"
	set envFilePath to baseAppPath & "/launcher.env"

	-- Read environment variables:
	set targetBase to do shell script "source " & quoted form of envFilePath & " && echo $TARGET_BASE"

	-- Run the target startup and wait for service readiness
	do shell script quoted form of shellScriptPath

	-- Manage Chrome window/tab
	tell application "System Events"
		set chromeRunning to (name of processes) contains "Google Chrome"
	end tell

	if chromeRunning then
		tell application "Google Chrome"
			if (count of windows) is 0 then
				-- No windows, just open new tab in new window
				make new window
				set newWin to front window
				tell newWin to make new tab with properties {URL:targetBase}
				set active tab index of newWin to (count of tabs of newWin)
				activate
				return
			end if

			set found to false
			set targetWindow to missing value
			set targetTabIndex to 1

			repeat with w in windows
				set tabIndex to 1
				repeat with t in tabs of w
					set tabURL to URL of t as string
					if tabURL starts with targetBase then
						set found to true
						set targetWindow to w
						set targetTabIndex to tabIndex
						exit repeat
					end if
					set tabIndex to tabIndex + 1
				end repeat
				if found then exit repeat
			end repeat

			if found then
				-- Restore window if minimized and bring it frontmost
				tell application "System Events"
					tell process "Google Chrome"
						set winIndex to index of targetWindow
						set winRef to window winIndex
						if value of attribute "AXMinimized" of winRef is true then
							set value of attribute "AXMinimized" of winRef to false
						end if
						perform action "AXRaise" of winRef
						set frontmost to true
					end tell
				end tell

				-- Set Chrome focus on the right window and tab
				set index of targetWindow to 1
				set active tab index of targetWindow to targetTabIndex
				activate
			else
				-- Tab not found: open new tab in front window
				tell front window to make new tab with properties {URL:targetBase}
				set active tab index of front window to (count of tabs of front window)
				activate
			end if
		end tell
	else
		-- Chrome not running: start Chrome, wait for it to launch
		do shell script "open -a \"Google Chrome\""

		-- Wait for Chrome process and window to become available
		delay 1
		repeat 10 times
			tell application "System Events"
				if (name of processes) contains "Google Chrome" then exit repeat
			end tell
			delay 0.5
		end repeat

		tell application "Google Chrome"
			if (count of windows) is 0 then
				make new window
			end if

			set frontWin to front window
			set activeTab to active tab of frontWin
			set activeURL to URL of activeTab

			-- If the default new tab page is open, reuse it by changing URL
			if activeURL = "chrome://newtab/" or activeURL = "about:blank" then
				set URL of activeTab to targetBase
			else
				-- Otherwise, open a new tab to targetBase
				tell frontWin to make new tab with properties {URL:targetBase}
				set active tab index of frontWin to (count of tabs of frontWin)
			end if

			activate
		end tell
	end if

	return input
end run

-- MIT License
--
-- Copyright (c) 2025 Jeffrey Urban
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.