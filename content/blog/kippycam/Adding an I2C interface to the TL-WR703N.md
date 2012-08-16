--- 
title: Adding an I2C interface to the TL-WR703N
kind: article
category: Computer stuff
created_at: 15 Aug 2012
summary: I had the wireless router to show the webcam images for the 'kippycam'. Some discussions in the openwrt forms showed, that there are several spare GPIO pins on its chip. So: there is a chance to do all kinds of hardware control. This rekindled some childhood enthusiasm for electronics that I had nearly forgotten. So, how did I add hardware control (specifically, the I2C interface) to the TL-WR703N?
---
# The goal #

To enable the creative use of the wireless router in the garden to do
all kinds of fun stuff. My first insane ideas are things like:

- Closing the chicken coop door (determined by remote control or
  automatically)
- Making a feed dispenser, so that the chickens may be tempted to be
  close to the camera
- Counting and logging the egg laying productivity (and the chickens'
  noise?)
- Monitoring the solar panels and battery charge status.

That's just the start...

# Approach #

Because of the [promising reports for at least 2 GPIO pins in the
TL-WR703N][openwrt-703n-gpio], I was looking for an interface that supports powerful
actions, with the minimum of wires. In the end, I chose I2C because a
cursory web search showed all kinds of cool chips that support it, and
because of the low complexity. SPI needs addressing, that I was not
sure I coud deliver, and 1-wire is only suited to a very limited array
of devices. Serial communication could have worked, but this is not
very robust against jitter (and we will be bit-banging) and demands a
lot from each client. So: I2C it is!

# Proof of principle #





[openwrt-703n-gpio]:https://forum.openwrt.org/viewtopic.php?id=36471
