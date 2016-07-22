App.info({
  id         : 'com.tap-into-cma-app',
  name       : 'TAP into CMA',
  description: 'Museum exhibition tour',
  author     : 'Jonathan Goley',
  email      : 'jgoley@gmail.com',
  website    : 'http://jonathangoley.com'
});

App.icons({
  'iphone_2x'      : 'public/ios_icons/icon-60@2x.png',
  'iphone_3x'      : 'public/ios_icons/icon-60@3x.png',
  'ipad'           : 'public/ios_icons/icon-76.png',
  'ipad_2x'        : 'public/ios_icons/icon-76@2x.png',
  'ipad_pro'       : 'public/ios_icons/icon-83.5@2x.png',
  'ios_settings'   : 'public/ios_icons/icon-small.png',
  'ios_settings_2x': 'public/ios_icons/icon-small@2x.png',
  'ios_settings_3x': 'public/ios_icons/icon-small@3x.png',
  'ios_spotlight'  : 'public/ios_icons/icon-40.png',
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
