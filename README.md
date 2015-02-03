# SMLoginItems

**Download the most recent release [here](https://github.com/Keithbsmiley/SMLoginItems/releases)**

A simple OS X app to show you login items that were enabled (probably)
with [`SMLoginItemSetEnabled`](https://developer.apple.com/library/mac/documentation/ServiceManagement/Reference/SMLoginItem_header_reference/).
[By](http://stackoverflow.com/questions/15484394/adding-a-sandboxed-app-to-login-items)
[design](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLoginItems.html#//apple_ref/doc/uid/10000172i-SW5-BAJJBJEG)
these items do not show up in System Preferences. Some of these APIs are
[deprecated without replacement](https://gist.github.com/Keithbsmiley/4776dd13113fa2df7b49)
but in the meantime I think it's useful to be able to see what sandboxed
applications are set to launch at login on your machine.
