'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "c88bbdc7e6c56e6b60b0a405af35bba5",
"index.html": "c323d60dbfa2f3576ac21708944d3a93",
"/": "c323d60dbfa2f3576ac21708944d3a93",
"main.dart.js": "85324909c90c3c171e2e06ee3e675ec0",
"README.md": "2e660b0f9ed58ee4cfe2e9ca39ca17ba",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "8eaf947ccd0f84f26a529684b6c74aa4",
".git/config": "fd633f502d61fbadc3624bfd9a732a95",
".git/objects/59/1d9765f3323ce7b8774f989a4530c0d5b63b10": "4b83f6f479c274fe49678b1007e9d428",
".git/objects/9b/d5739cb6ecf1aa74706a0f71c7c4270b3a70e8": "f4c5bcc13447ec7b56d862de5d597316",
".git/objects/32/46ad559eeae0370195978eaed83f1053ee13fd": "a043dbc0a0bda96ce2127799ccc27506",
".git/objects/69/8ab0aafda474e2f84c130cfb115fff2bbdb9c2": "e49a0f434f54f757a701a430e019940d",
".git/objects/67/df58bb24525ea5d5df607ccce4ee3437ae487f": "a9909323035d97165c0a21d7ff26234f",
".git/objects/94/3e72a36e53491b4f07ef6e103bffbc9c16a59b": "b63e37cf036f2db7b3759ea65901f695",
".git/objects/0e/71ba65ef557b920009ad316dfb91e9509717ca": "5d491359d99bc26f0613f887a1b8a07d",
".git/objects/5f/9003de94c255228d3f88bd73ad4a04542b0839": "0fea4f4f5a6442610ebde16d391be336",
".git/objects/a4/96ef7dd91c97e8370ba391d177a88690773b69": "760756b630991017be595f69dc046b3e",
".git/objects/ad/8174d3e3649c8b191fe1b0ea0e3dd336922997": "f09993e837f76db1ad906bf58a7bad2d",
".git/objects/da/b96e953e90dbed549506af5c0ae8e47fd4852a": "9f79f677f9201c1984b3868299d0ade1",
".git/objects/a2/3b01e86fb6a78ae710b2c414e8dcff9c1c5a07": "fa50171539bc74f8ea08f34f6739a632",
".git/objects/bd/ed791129ece1627ed3ce2649de5e52582bc530": "1c52ce3022cd1a8c1c9c81887c5c0efa",
".git/objects/d6/70c6bc3157fe5d0b370e852ca91224c0fe2fa7": "3977861fee792cd8a175824ee0d7382b",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/ab/0e98497a51ead7821d1da35a24968ff314e50f": "557c35fe3928eb2af403d1b3926bb9ba",
".git/objects/e5/900f8cf143cb03dd9a44d29d5e56a169da65c3": "34e7a1720b984544e480a5f76b1ffe7d",
".git/objects/e5/951dfb943474a56e611d9923405cd06c2dd28d": "c6fa51103d8db5478e1a43a661f6c68d",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/eb/543401571c0c7541031e3e846df6a18d1e05e0": "8871d49830418eba96d8d3bbd234d066",
".git/objects/ee/00d2c66ece0f4aaf8d8c0cf77d059e3b8e90cf": "e404cc38e21658263f4b1fe1f8a9f0d0",
".git/objects/f5/b0a8b0d48a657295c6689aee193f46cad4ae96": "de8cf6dd04663e2594348d373c5b054e",
".git/objects/ca/87f5a0a2ecfce03fbbc9ea8293263614ab00f2": "e2b6af1c43d5cc1ff6b5a139ae85d9ef",
".git/objects/18/8bb33c8589e3b0f3d04e2ed03487d747d71306": "9ff95cca88cd961578977f901adac078",
".git/objects/11/9b6d1fb93e52f58f3890b2c56b3138ea990958": "ceb908dcaa65948d86b6cee81af96ca2",
".git/objects/7d/6a05c89bcca5155f0ee73b5d25d394bb2ad9d4": "4da3ca208766297d5e76c5c77f5fb914",
".git/objects/29/a31292ef5d78f509a7d698df96217dabdd19a1": "799313bfe24183229175bc2f1ab6c309",
".git/objects/29/dda6ffaeb87cce11d6f24c9cdf24d91b30c245": "7e6e23e2902732ae1e7e181d3d617c95",
".git/objects/7c/5d7ef76888b5d8eb4f29137b0f5f2ef5e0023a": "0594569135cb9816d1543557b4c7b305",
".git/objects/42/eb2addee0885a531049e0914c20a7822034310": "64131ce5fe71f7384a689f832b335a08",
".git/objects/42/d853e72d45d259e7a49d6370a54a0c0feacb15": "a432975a6faa80c59ca3d0ec76693968",
".git/objects/89/dae4ff870a6d7d4bb0ccf5fc5d1f7e56d0614e": "f185acf8a51e643c402b81e1b7cf5aae",
".git/objects/1f/ca04b356d16818c52c38a07311de74b1062e56": "3dae75d136f709ee72d70d40d21f6a45",
".git/objects/80/bd07260fc920384468332d82410cb06db12926": "d58a9dfa2724173a608f4c55e4eb86f6",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/21/0c7e7b75585ac6b96361017a095ac44b0d4c76": "af2ee471d1febad5546c5dda122a5fdc",
".git/objects/4d/7a987f666782c3aa96a75e2bbc6ea12188c26d": "29168940c1f94f11de8bdae993cc6779",
".git/objects/75/62b3d8dacd80ce5a750b2c6bbb8e0ec9859c70": "4a578601163bee3684d81a299696f6de",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/38/2f9352e351b6b0bda3c6de3f8f470530f33d4d": "4a706392d5e1b5b03730f5314a162fdc",
".git/objects/9a/4caad6ebeddfd8ad7817a42334a2fc581846dc": "6cb4d4de9d11b960f00981703985312c",
".git/objects/36/b9fbb51027f98503944f4f9e5ad9050b3550d3": "947a33a1598bef5595b208cdeef95646",
".git/objects/65/0d39300e92c5c18507c4b91526d585a305cb46": "bee0b3b9f56ffdc5b680df5c5efdccc3",
".git/objects/62/3586facdec26c9790cccf66563e2e85a64ee5e": "4b498326240307348aeffb44b8717153",
".git/objects/62/c5808974efa11b505bc3da385988d53fc9665e": "ff381f32681bd4cae9d21236dbabbb55",
".git/objects/6d/4395015019934253bb18772a3ccd21c57b427a": "bae8c052da4e57d19f0f0572195b45d0",
".git/objects/06/f264d4a425454469eae73942d86cdaed4af7d2": "51edd947bdf84bd3857d09a7f2c961f7",
".git/objects/63/fdf4289a5f34c0870c1db3a1e3473d8bbf04d4": "37e94b7c9bd205569ccb79a74e666808",
".git/objects/90/fa7a6fa9dbbd1a3a14696aeffaa02a32a21668": "f37a15dabf88a9234575f64d119d4abb",
".git/objects/90/910aa7691321d389c5833d0406516edd88acf6": "a92750c757b807c4a8f8c56aed9edb0f",
".git/objects/b1/0e386adb4e96f5c5c48f1b03f04047e7aa6170": "49491cd3fb63f7582f349305b13902fa",
".git/objects/d2/dbd2283f8e52eb8e360b79ba5862ece6b381b8": "96ccb097c5bed8be04fe95ff2c3ca37d",
".git/objects/af/64bc397209eaea5ae6c21f82b672e0c425c654": "37451d7d964cadd551f889f1d56cb669",
".git/objects/af/06264309e8e1c316e90d0b9d7cfbd7ff9af029": "c09675c462126db93c78f50a58c8af1f",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b7/eb33118e6f38e9b1a83986372a08105a742489": "ae1b0ba999ea4a203903e8301fb128c9",
".git/objects/db/1730fe92e846811e26ae15c0f71b926384397e": "46cda8b41321b956cf09d29042a7ae7c",
".git/objects/a8/beffd3ad4fe54d6cabccf83a05477d6a986cd0": "6677888e4a051c7838b5b240c09f0981",
".git/objects/a8/9e9bbde9d558d5c4ce0391ce4705634f5aeee5": "85ecb87d987c0808867062103b6ef31a",
".git/objects/de/c9b7dad95ab6ab98f1b4a9b1d6013499481971": "758814d93ec50373d04637cd63c16123",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/91fd7173edd21f7bef100aa963eb5355742abc": "70cd9b063809c905909a8e0b4cecb7f9",
".git/objects/a1/3837a12450aceaa5c8e807c32e781831d67a8f": "bfe4910ea01eb3d69e9520c3b42a0adf",
".git/objects/ea/cf70f849f3e6c584a07391a485ae301d2e667d": "95afcb81f4745999910e1f7569e9ee85",
".git/objects/ff/b040b773ed0765ddcbc0d62f0945e4d5069c53": "069ad404fd1f42b709b8abaed3397bf1",
".git/objects/f8/1bc9382375bcafbea8bf55e9034d55a5a0273f": "e8a7dbae99a1147295ec58846dc60b19",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/79/ba7ea0836b93b3f178067bcd0a0945dbc26b3f": "f3e31aec622d6cf63f619aa3a6023103",
".git/objects/70/6b40bdc6915c70c2bd89e79f324f5dbf30e11d": "3614ae86c78548ed8ec4a25b9cf7b74f",
".git/objects/85/59027165eb58d2530ce6fc0cb49ca7a992d860": "89714e92a1b5b2f9329885d8a1c1278f",
".git/objects/1d/74ff0c94683dd75e235933d3a43f41ef4b1bfc": "8d40d71822804716f60d78075f214578",
".git/objects/1c/17e95fb1d86efd4e4b6bca66c6d8d1c4d30928": "80f123dbe7d8c4e6d2460d4b19b8108b",
".git/objects/7f/25bce5df03682cdef7abf54ca8ea7a6ed27d63": "11568062c93b0fa916577fb28617d195",
".git/objects/25/890b61ed02e2d5be748e22090d443561ed1815": "b75c82a48e3422c239d374d1e4d5aff9",
".git/HEAD": "14d13d5f2fc7beb4bbe4895397bb0ac0",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "c5b1ca3d9251904948261f4170c7f92a",
".git/logs/refs/heads/web-app": "c5b1ca3d9251904948261f4170c7f92a",
".git/logs/refs/remotes/origin/web-app": "daa95fcbb44ca5d56b65f801d516c143",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/fsmonitor-watchman.sample": "ea587b0fae70333bce92257152996e70",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/refs/heads/web-app": "3e1d55e6cd1fbf92d32be0c99d1e74cc",
".git/refs/remotes/origin/web-app": "3e1d55e6cd1fbf92d32be0c99d1e74cc",
".git/index": "729a5fa0b317c52e715950d09e668bb1",
".git/COMMIT_EDITMSG": "66f21c36d4735b23aaac300097470ded",
".git/FETCH_HEAD": "bfa5dc74cee6d7b7ebf2717f12fe216e",
"assets/AssetManifest.json": "a09d31a14c8739f84770ffee83a94d18",
"assets/NOTICES": "87e91b004719fec7579ded890d87cddd",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/assets/images/bishop/bishop-black.png": "3617c07cd7a775146b13e9adfa11427b",
"assets/assets/images/bishop/bishop-white.png": "8ec67c8c46dfdf29a5235675d4e36972",
"assets/assets/images/chess-pieces.png": "a382d1d9ec3edc3445c53b10633ddee6",
"assets/assets/images/rook/rook-white.png": "e51f80d28e21399d67a79af12040a856",
"assets/assets/images/rook/rook-black.png": "0c56e155ed2baaf3edf7362360606c88",
"assets/assets/images/pawn/pawn-white.png": "6f99d3afdebf5447ab225166eb553ddf",
"assets/assets/images/pawn/pawn-black.png": "89eb190de8e70f9b5e54b45df8a5dbc8",
"assets/assets/images/knight/knight-black.png": "90b23d44b3d2c4ca4057953d206b6dba",
"assets/assets/images/knight/knight-white.png": "331dfa68c5e99b261a20577173b865db",
"assets/assets/images/king/king-black.png": "62676b9fb80ffbe6c339c7a67d62e9eb",
"assets/assets/images/king/king-white.png": "6a2e98f978ca3efa4b831e37d0a0834a",
"assets/assets/images/queen/queen-white.png": "ead30c08131626e25a7d6ef0ff82a88d",
"assets/assets/images/queen/queen-black.png": "2cdc2fbe1a34bb38214ee7a9fb87d4f2",
"canvaskit/canvaskit.js": "43fa9e17039a625450b6aba93baf521e",
"canvaskit/profiling/canvaskit.js": "f3bfccc993a1e0bfdd3440af60d99df4",
"canvaskit/profiling/canvaskit.wasm": "a9610cf39260f60fbe7524a785c66101",
"canvaskit/canvaskit.wasm": "04ed3c745ff1dee16504be01f9623498"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
