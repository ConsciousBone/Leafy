# Leafy
Leafy is a simple, AI powered app to track and log leaves that you encounter in nature; built for Hack Club's Siege Week 8.  
It supports iPhone and iPad, however for the best experience, it is recommended to use it on an iPhone.

# Proxy down?
My server likes to crash sometimes for no reason, I blame Proxmox.  
If the API requests fail for no apparent reason and you are actually connected to the internet and have tried all the basic typical troubleshooting steps, ping me on Slack or email me at `evan@consciousb.one` and I'll sort it as soon as possible!

# Demos
## Screenshots
TODO: add the thing
## Video
TODO: add the thing

# Backend (proxy server)
The backend is powered by Nginx, running on an Ubuntu Desktop 25.04 VM inside of Proxmox, all hosted locally at my house!    
It takes traffic from this app, authenticates it with a key, and if the key is correct, forwards the request to OpenAI, returning whatever OpenAI spits out.    
*Why not use OpenRouter?* I tried, but couldn't figure out how image input works for the life of me, so having previous experience with the OpenAI API, I decided to switch over to that and it worked perfectly first try.  
For more information on the backend, see [this repo](https://github.com/ConsciousBone/LeafyNginxConfig).

# How to get Leafy
This is the way I recommend, but there are indeed other ways to sideload the IPA onto your iPhone, such as AltStore or SideStore.  
1. Install [Sideloadly](https://sideloadly.io/) and all of its requirements; iirc if you're using macOS there are none, but Windows needs you to have iTunes and iCloud installed **not using the Microsoft Store**. The Sideloadly website will have links to all these.  
2. From the [Releases](https://github.com/ConsciousBone/Leafy/releases/tag/stable) tab, find the latest release (should be the first one at the top) and download the attached `Leafy.ipa` file.  
3. Using a cable that supports both charging and data transfer, connect your iPhone or iPad to your computer, trust it if prompted, and open Sideloadly.
4. Click the file icon with the `IPA` text in Sideloadly, and select the previously downloaded `Leafy.ipa` file from wherever you placed it.
5. Select your device in the `iDevice` dropdown, ensuring the name matches with the device you want to sideload the app on to.
6. Input your Apple Account/ID's email into the `Apple ID` text field. If you are using a free developer account (most people), you will need to resign the app every 7 days, however if you are using a paid developer account, this goes up to 365 days.
7. Click the `Start` button, and enter your Apple Account/ID's password when prompted to. **No one apart from Apple sees this password; not the Sideloadly developers, and not me.**
8. Wait for the app to install to your device, and then launch it! *If this is your first time sideloading an app to your device, you may need to enable Developer Mode in Settings, if this applies to you then your device will prompt you to do so.*

# Inspiration
Using AI in a project has always been an idea of mine, and item identification also being something I've wanted to have a go at, combined with this week's theme being "Fall", I felt it was a perfect time to build something that takes all of these ideas, and build an app to identify leaves using AI!

# Tech stack
- Swift (what practically every modern iOS app is built in)
- SwiftUI (absolutely goated UI library from Apple)
- UIKit (used a tiny bit, handles the images of leaves and that's it)
- SwiftData (used to store the leaves's data, ie name, description, image, etc)
- OpenAI API (how it finds out the leaf information, communication is handled by the proxy, see its repo to find out more about that, I'm using the gpt-4o-mini model because a) it's cheap, and b) it supports image input!)
- Nginx (on the backend server to proxy the api requests)
