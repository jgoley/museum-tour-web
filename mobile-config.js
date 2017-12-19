App.info({
  id         : 'com.tap-into-cma-app',
  name       : 'TAP into CMA',
  description: 'Museum exhibition tour',
  author     : 'Jonathan Goley',
  email      : 'jgoley@gmail.com',
  website    : 'http://jonathangoley.com'
});

App.icons({
  'iphone_legacy'           : 'public/ios_icons/icon-57.png', // 57x57
  'iphone_legacy_2x'        : 'public/ios_icons/icon-114.png', // 114x114
  'iphone_2x'               : 'public/ios_icons/icon-60@2x.png', // 120x120
  'iphone_3x'               : 'public/ios_icons/icon-60@3x.png', // 180x180
  'ipad'                    : 'public/ios_icons/icon-76.png', // 76x76
  'ipad_2x'                 : 'public/ios_icons/icon-76@2x.png', // 152x152
  'ipad_pro'                : 'public/ios_icons/icon-83.5@2x.png', // 176x176
  'ipad_app_legacy'         : 'public/ios_icons/icon-72.png', // 72x72
  'ipad_app_legacy_2x'      : 'public/ios_icons/icon-144.png', // 144x144
  'ios_settings'            : 'public/ios_icons/icon-small.png', // 29x29
  'ios_settings_2x'         : 'public/ios_icons/icon-small@2x.png', // 59x59
  'ios_settings_3x'         : 'public/ios_icons/icon-small@3x.png', // 87x87
  'ios_notification'        : 'public/ios_icons/icon-20.png', // 20x20
  'ios_notification_2x'     : 'public/ios_icons/icon-40.png', // 40x40
  'ios_notification_3x'     : 'public/ios_icons/icon-60.png', // 60x60
  'ios_spotlight'           : 'public/ios_icons/icon-40.png', // 40x40
  'ios_spotlight_2x'        : 'public/ios_icons/icon-40.png', // 40x40
  'ios_spotlight_3x'        : 'public/ios_icons/icon-60.png', // 60x60
  'ipad_spotlight_legacy'   : 'public/ios_icons/icon-50.png', // 50x50
  'ipad_spotlight_legacy_2x': 'public/ios_icons/icon-100.png', // 100x100
  // 'iTunesArtwork'           : 'public/ios_icons/icon-40.png', // 40x40
  // 'iTunesArtwork@2x'        : 'public/ios_icons/icon-40@2x.png', // 80x80
  'app_store'               : 'public/ios_icons/app_store.png', // 1024x1024
});

App.launchScreens({
  'iphone_2x'         : 'public/ios_lauchScreens/iphone@2x.png',
  'iphone5'           : 'public/ios_lauchScreens/iphone-568h@2x.png',
  'iphone6'           : 'public/ios_lauchScreens/667h.png',
  'iphone6p_portrait' : 'public/ios_lauchScreens/736h.png',
  'iphone6p_landscape': 'public/ios_lauchScreens/736h-Landscape.png',
  'ipad_portrait'     : 'public/ios_lauchScreens/ipad-Portrait.png',
  'ipad_portrait_2x'  : 'public/ios_lauchScreens/ipad-Portrait@2x.png',
  'ipad_landscape'    : 'public/ios_lauchScreens/ipad-Landscape.png',
  'ipad_landscape_2x' : 'public/ios_lauchScreens/ipad-Landscape@2x.png',
});

App.setPreference('Fullscreen', true);
App.setPreference('HideKeyboardFormAccessoryBar', true);
App.setPreference('Orientation', 'portrait', 'ios');

App.setPreference('WebAppStartupTimeout', 30);
