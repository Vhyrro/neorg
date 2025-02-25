# Changelog

## [9.3.0](https://github.com/nvim-neorg/neorg/compare/v9.2.0...v9.3.0) (2025-02-25)


### Features

* **todo_items:** todo-changed event ([#1651](https://github.com/nvim-neorg/neorg/issues/1651)) ([5f0195d](https://github.com/nvim-neorg/neorg/commit/5f0195d99e21fc1db3d544f7473b34bf41740c16))


### Bug Fixes

* **docgen:** load buffers after opening them ([#1657](https://github.com/nvim-neorg/neorg/issues/1657)) ([18d1a18](https://github.com/nvim-neorg/neorg/commit/18d1a182720fba71ea286d9ce6c3e9970bf7ed51))
* expand tangle paths ([#1622](https://github.com/nvim-neorg/neorg/issues/1622)) ([10bf607](https://github.com/nvim-neorg/neorg/commit/10bf607f11ed94151fb5496e6127d8823d162a7e))
* Tangle should close fd for files ([#1618](https://github.com/nvim-neorg/neorg/issues/1618)) ([cd3056e](https://github.com/nvim-neorg/neorg/commit/cd3056eaf39a838b0a26438ff203bb3123c94aec))
* **tangle:** create missing dirs ([#1644](https://github.com/nvim-neorg/neorg/issues/1644)) ([e1b4bb4](https://github.com/nvim-neorg/neorg/commit/e1b4bb4ff144a953f802f665afdd9a7f7532014f))
* **tangle:** proper error handling for fs_close ([#1647](https://github.com/nvim-neorg/neorg/issues/1647)) ([1a4c20a](https://github.com/nvim-neorg/neorg/commit/1a4c20a5ed3dea4abae20e85d66b5f0f94c96f5b))

## [9.2.0](https://github.com/nvim-neorg/neorg/compare/v9.1.1...v9.2.0) (2025-01-22)


### Features

* automatically typed `module.required` dependencies ([#1537](https://github.com/nvim-neorg/neorg/issues/1537)) ([1985f2d](https://github.com/nvim-neorg/neorg/commit/1985f2d6f152622b0066f48ba8e39d157635dd38))
* **dirman:** dynamically set default workspace ([#1623](https://github.com/nvim-neorg/neorg/issues/1623)) ([29993a7](https://github.com/nvim-neorg/neorg/commit/29993a7bb8279ffa0ba473a3f393daa28c645825))
* **dirman:** in_workspace function ([#1615](https://github.com/nvim-neorg/neorg/issues/1615)) ([62671a7](https://github.com/nvim-neorg/neorg/commit/62671a7b03a1f38a6e5e03b006a9b6f8d804be0e))
* **esupports.hop:** Add tab drop as option for open_mode ([#1580](https://github.com/nvim-neorg/neorg/issues/1580)) ([c7ada78](https://github.com/nvim-neorg/neorg/commit/c7ada7881d7076a235b6323edcd81ae260affb41))
* **export:** copy to clipboard ([#1627](https://github.com/nvim-neorg/neorg/issues/1627)) ([1783928](https://github.com/nvim-neorg/neorg/commit/178392822c8c2ef0911458b7f43c980667784011))
* **introspector:** implement introspector customizability and improvements ([#1539](https://github.com/nvim-neorg/neorg/issues/1539)) ([fd11950](https://github.com/nvim-neorg/neorg/commit/fd11950048d111b837b9f615c5d023e79bd1af9a))
* **keybinds:** add back keybind "gO" for ToC ([#1633](https://github.com/nvim-neorg/neorg/issues/1633)) ([bed58f8](https://github.com/nvim-neorg/neorg/commit/bed58f884ecf9b0b5e855cebe26760bfadbc8f38))
* make journal methods public ([8b59db7](https://github.com/nvim-neorg/neorg/commit/8b59db79307037032c5f83fc79dff5741d6da869))
* support ranges in Neorg command, ([c04bd96](https://github.com/nvim-neorg/neorg/commit/c04bd96eeb3bed19f23d394bebb6193bcd5271da))


### Bug Fixes

* coq_nvim completion integration ([#1597](https://github.com/nvim-neorg/neorg/issues/1597)) ([488507b](https://github.com/nvim-neorg/neorg/commit/488507bb996f75ee29073f50dec32fa220867ca5))
* don't suggest leading chars for file completions ([ba35900](https://github.com/nvim-neorg/neorg/commit/ba35900b21921c439e676b063a79c8fad914eac9))
* intuitive default undone icon ([#1578](https://github.com/nvim-neorg/neorg/issues/1578)) ([13d1d54](https://github.com/nvim-neorg/neorg/commit/13d1d546684c83ba464adbf463a8a272c884e1e8))
* Neorg return to most recent file ([e5e797e](https://github.com/nvim-neorg/neorg/commit/e5e797e6eddcb6efb1d2c3fc2612b31ad9a76cef))
* **summary:** unpack summary category list ([#1637](https://github.com/nvim-neorg/neorg/issues/1637)) ([41aa380](https://github.com/nvim-neorg/neorg/commit/41aa3800cf5d30a5f90520c2a31b34727b443219))
* **toc:** only capture first detached modifier ([#1631](https://github.com/nvim-neorg/neorg/issues/1631)) ([399832e](https://github.com/nvim-neorg/neorg/commit/399832e5437de0cea5efb1d5428de03adc42cc79))
* **ToC:** only try to open when still in norg buffer ([#1549](https://github.com/nvim-neorg/neorg/issues/1549)) ([88dbab5](https://github.com/nvim-neorg/neorg/commit/88dbab5325ce07092ab7a38b160bc8e988830524))
* weird tangle file path logic ([#1604](https://github.com/nvim-neorg/neorg/issues/1604)) ([993f077](https://github.com/nvim-neorg/neorg/commit/993f077f0bff8faa68dbdb89ad95f67116b8007a))

## [9.1.1](https://github.com/nvim-neorg/neorg/compare/v9.1.0...v9.1.1) (2024-07-24)


### Bug Fixes

* non-functional toggling of sublists ([#1492](https://github.com/nvim-neorg/neorg/issues/1492)) ([169495c](https://github.com/nvim-neorg/neorg/commit/169495ca3ed67f919589499d20fa89bfea9e4de4))

## [9.1.0](https://github.com/nvim-neorg/neorg/compare/v9.0.3...v9.1.0) (2024-07-23)


### Features

* add `&lt;LocalLeader&gt;cm` keybind for code block magnification ([c52c00f](https://github.com/nvim-neorg/neorg/commit/c52c00f72c85d3ca258de623e40e64c3e552185a))
* **concealer:** properly display blockquotes, allow entities to set their own clear functions ([28bbefc](https://github.com/nvim-neorg/neorg/commit/28bbefcfce10a51d7d834c6b6c0f7229bc6b38e1))


### Bug Fixes

* **`:h neorg`:** remove `|example` blocks until parser is fixed ([a93190d](https://github.com/nvim-neorg/neorg/commit/a93190db5b804c7db7d2f8f4d1c7edf6414cbe39))
* `insert-date` not working in insert mode ([7af14b3](https://github.com/nvim-neorg/neorg/commit/7af14b30b6ce9321e5a399eb6eb491ad111b0cda))
* **concealer:** don't overflow folds into other, non-norg files ([19e4bea](https://github.com/nvim-neorg/neorg/commit/19e4beabdcd6080ececbd5ffcb7ecb50b1590461))
* **concealer:** properly render quotes ([08277bb](https://github.com/nvim-neorg/neorg/commit/08277bb5cf1b310d2527adcb0d613a8625c7b3d3))
* **concealer:** quote and list rendering bugs ([e292cf5](https://github.com/nvim-neorg/neorg/commit/e292cf5f3d19a8066e13928ff00efece10915124))

## [9.0.3](https://github.com/nvim-neorg/neorg/compare/v9.0.2...v9.0.3) (2024-07-19)


### Bug Fixes

* **keybinds:** fixed tempus insert date insert mode default keybind command ([87e55f3](https://github.com/nvim-neorg/neorg/commit/87e55f3727ad84ecc261f7236892f4dbec82efc1))

## [9.0.2](https://github.com/nvim-neorg/neorg/compare/v9.0.1...v9.0.2) (2024-07-17)


### Bug Fixes

* **keybinds:** correctly get keymap opts ([4a2f5b2](https://github.com/nvim-neorg/neorg/commit/4a2f5b2104169883131646f27ffaeb6af324b05a))

## [9.0.1](https://github.com/nvim-neorg/neorg/compare/v9.0.0...v9.0.1) (2024-07-16)


### Bug Fixes

* **metagen:** proper iteration on metadata fields ([#1518](https://github.com/nvim-neorg/neorg/issues/1518)) ([0306887](https://github.com/nvim-neorg/neorg/commit/0306887c0c6ea302e3a3fecbb36998793f4c27d5))

## [9.0.0](https://github.com/nvim-neorg/neorg/compare/v8.9.0...v9.0.0) (2024-07-16)


### ⚠ BREAKING CHANGES

* tangle files relative to norg file ([#1415](https://github.com/nvim-neorg/neorg/issues/1415))
* remove `traverse-link` and `traverse-heading` modes
* remove all references to `core.mode`
* remove `core.mode`
* move rest of modules to new keybind system
* move core.pivot to new keybind system
* migrate core.promo to new keybind system
* move esupports.hop to the new keybind schema
* move qol.todo_items to new keybind API
* keybind refactor, update core.itero to new changes
* make Neovim 0.10 a requirement for Neorg
* simplify code in preparation of lazy.nvim luarocks support
* remove `ftdetect` file as Neorg is now natively recognized by Neovim ([#1083](https://github.com/nvim-neorg/neorg/issues/1083))

### Features

* add `core.ui.calendar` to the default list of modules ([52a37e0](https://github.com/nvim-neorg/neorg/commit/52a37e01abe059c6431f744eab9f22626fb275c5))
* add descriptions to all Neorg keybinds ([a042515](https://github.com/nvim-neorg/neorg/commit/a042515bc832ecab6d47a18ffc2976ee72f4bc1b))
* add dotrepeat to all common commands ([6b49397](https://github.com/nvim-neorg/neorg/commit/6b49397f1e8bea2f19064012e392cd4b36e00d18))
* auto tangle ([#1413](https://github.com/nvim-neorg/neorg/issues/1413)) ([0f24e4a](https://github.com/nvim-neorg/neorg/commit/0f24e4a53b05328a0ae6496be9867ea5df7b7f40))
* **calendar:** unify exit keybind to always be `q` instead of a mix of `q`/`&lt;Esc&gt;` ([582d7b6](https://github.com/nvim-neorg/neorg/commit/582d7b616d9bdb5e2bbcba4ebd0e82f7fb9130e0))
* **completion:** allow custom completion engines ([04d201d](https://github.com/nvim-neorg/neorg/commit/04d201d56857073efecf79a8be29fae45b57ebeb))
* **docgen:** add default keybinds list ([d762f6d](https://github.com/nvim-neorg/neorg/commit/d762f6dd4cfc7f8337272582abf0459b4c85fe3b))
* **docgen:** add more links to sidebar ([5bef42a](https://github.com/nvim-neorg/neorg/commit/5bef42ab385e0d2da9e68a60e4ba484c583b9aa7))
* **health:** check for keybind clashes in checkhealth ([bbe4243](https://github.com/nvim-neorg/neorg/commit/bbe42438a90afd25a5d52b843ebbcc19d8476cef))
* **intergrations.otter:** update to use otter 2.0 ([1347eeb](https://github.com/nvim-neorg/neorg/commit/1347eebc8a0116524f17a7c33240ae782efb974e))
* keybind refactor, update core.itero to new changes ([3dd946a](https://github.com/nvim-neorg/neorg/commit/3dd946ae976ee45147a60eeb5174f0f951f04f94))
* **keybinds:** add `extend_preset` function ([4f09926](https://github.com/nvim-neorg/neorg/commit/4f0992643b42d544a442f6e1928bd5838e355bcd))
* **keybinds:** don't try to forcefully override user keys ([591b883](https://github.com/nvim-neorg/neorg/commit/591b8831587895b95cbce30ad5a30c53f01b882c))
* **keybinds:** split presets into norg and non-norg, move to buffer-local mappings instead ([113c21b](https://github.com/nvim-neorg/neorg/commit/113c21b2de4f68c150a5778ff754cdbbec04758f))
* support multi-line values in metagen ([#1514](https://github.com/nvim-neorg/neorg/issues/1514)) ([321c435](https://github.com/nvim-neorg/neorg/commit/321c435e96a738a32ba2376f7f8f27b401759236))


### Bug Fixes

* better formatting, properly handle complex keybind descriptions ([c087db0](https://github.com/nvim-neorg/neorg/commit/c087db0473b3d8363e31135ef42d1290994075e6))
* calendar not working with the latest breakages ([c659b09](https://github.com/nvim-neorg/neorg/commit/c659b0901bea4143667489ee2af4c78762fabc5c))
* **docgen:** beautify keybind output in &lt;details&gt; tag ([7a9d54c](https://github.com/nvim-neorg/neorg/commit/7a9d54c3c81bb1c403b3591cbc3b0cf27949fc6b))
* **docgen:** better mnemonic rendering ([b3bf963](https://github.com/nvim-neorg/neorg/commit/b3bf9639d2ebc905f7a99197844bf6da0547a2c9))
* **docgen:** broken wiki ([e23d0d3](https://github.com/nvim-neorg/neorg/commit/e23d0d32ea11d13c9da67b841a809b6cfda02887))
* **docgen:** display keybind data in the form of a dropdown ([572de72](https://github.com/nvim-neorg/neorg/commit/572de724159fcf929f3feb125da72b25ccad7bd2))
* **docgen:** invalid github markdown ([75edcdc](https://github.com/nvim-neorg/neorg/commit/75edcdc68ba9ce4aae5f0df6543f9818c55c5206))
* error in hasmapto() ([dfcc78a](https://github.com/nvim-neorg/neorg/commit/dfcc78a110051aaedef8c19b48fda486960e1089))
* feed keys without remaps ([ecf5f41](https://github.com/nvim-neorg/neorg/commit/ecf5f415c96cf7a12b74a8233b8f6d4ecc3779c4))
* improve startup time by removing pcall on every module load ([7d9bd33](https://github.com/nvim-neorg/neorg/commit/7d9bd33a176fa86c65030776eb9b45cdb729250b))
* itero keybind not functioning, add fallback functions to core.keybinds ([cd950aa](https://github.com/nvim-neorg/neorg/commit/cd950aa89ae2125882b235b8e79afde13c90e1b1))
* make core.promo keybinds functional again ([8a48172](https://github.com/nvim-neorg/neorg/commit/8a48172e94854d364b3cb3ecd2940cbe84b2f7bd))
* properly error when failing to load module using `:Neorg module load` ([721fd28](https://github.com/nvim-neorg/neorg/commit/721fd28f39ba2cb0978e410bd9a7668f8c74ccca))
* remove all references to `core.mode` ([53429c4](https://github.com/nvim-neorg/neorg/commit/53429c497bda64671c7161b3f59d4640415bf145))
* set global keybinds only once, set keys on filetype ([e00042a](https://github.com/nvim-neorg/neorg/commit/e00042af322802f4db38706c5eeee8e77145fe65))
* set keybinds for the appropriate buffer (fixes telescope issues) ([b49c214](https://github.com/nvim-neorg/neorg/commit/b49c214f72ba33d5d76a63f7d70da43c840dc1e2))
* tangle files relative to norg file ([#1415](https://github.com/nvim-neorg/neorg/issues/1415)) ([3c3b977](https://github.com/nvim-neorg/neorg/commit/3c3b977dff916aecf5b2d63747896691c70639df))


### Code Refactoring

* make Neovim 0.10 a requirement for Neorg ([c916501](https://github.com/nvim-neorg/neorg/commit/c91650128130f05c79a2cf1e981a8d87b1f91113))
* migrate core.promo to new keybind system ([faad665](https://github.com/nvim-neorg/neorg/commit/faad665a8e9c32f9dceae613e7c4c2abdbda9585))
* move core.pivot to new keybind system ([0c1222b](https://github.com/nvim-neorg/neorg/commit/0c1222b4aa4faf21a76158fe8de1339700442e08))
* move esupports.hop to the new keybind schema ([cdfbe19](https://github.com/nvim-neorg/neorg/commit/cdfbe19125a5d71288ea5c28f7916f709ca57ddd))
* move qol.todo_items to new keybind API ([b71d8ba](https://github.com/nvim-neorg/neorg/commit/b71d8ba34c53a0a4d022cd72af90513029800b27))
* move rest of modules to new keybind system ([94b860b](https://github.com/nvim-neorg/neorg/commit/94b860b704bceb1180eb82443064e6530e001fae))
* remove `core.mode` ([49e8710](https://github.com/nvim-neorg/neorg/commit/49e8710b3c09b19d69fcce322769fcbbdc4e6f30))
* remove `ftdetect` file as Neorg is now natively recognized by Neovim ([#1083](https://github.com/nvim-neorg/neorg/issues/1083)) ([5c32056](https://github.com/nvim-neorg/neorg/commit/5c320566757d334ab255a287da960d961d7a9012))
* remove `traverse-link` and `traverse-heading` modes ([da3e062](https://github.com/nvim-neorg/neorg/commit/da3e0621e03ad33f62cdd2fa77ba02ffb1b52d2b))
* simplify code in preparation of lazy.nvim luarocks support ([12b7cf2](https://github.com/nvim-neorg/neorg/commit/12b7cf253e60f6ce8552e4498a1598c8b57acf66))

## [8.9.0](https://github.com/nvim-neorg/neorg/compare/v8.8.1...v8.9.0) (2024-07-07)


### Features

* **calendar-ui:** new mappings ([2a4081f](https://github.com/nvim-neorg/neorg/commit/2a4081fe89f8f264c672eff2ab88b79f91aa6898))
* **calendar-ui:** support count in keymappings ([6b4751c](https://github.com/nvim-neorg/neorg/commit/6b4751c2c486578c8a11dfd2f79dfd35cacaa5b8))
* **calendar:** even more keybinds + ; repeat ([a5c2624](https://github.com/nvim-neorg/neorg/commit/a5c2624bc41cb760c4689734b2c3c5a9f17e4c48))


### Bug Fixes

* **promo:** promote/demote range + keybinds ([a94d1e6](https://github.com/nvim-neorg/neorg/commit/a94d1e67f7df3a97c0f57894c107b70a54523a4d))
* **return:** return causing early exit when paired with auto_toc.exit_nvim ([959b8a2](https://github.com/nvim-neorg/neorg/commit/959b8a20114c63097261cd1b48f2dacfbe4ccd5f))
* **summary:** ordering and indentation of nested entries ([9279672](https://github.com/nvim-neorg/neorg/commit/9279672d2b97929fc52d1b182af754497dfd8d8a))
* **text-objects:** node selection inconsistencies ([99b3249](https://github.com/nvim-neorg/neorg/commit/99b32492b836b64a5ff4544d4c466496f0aec9bd))
* **toc:** various fixes ([#1500](https://github.com/nvim-neorg/neorg/issues/1500)) ([83637f1](https://github.com/nvim-neorg/neorg/commit/83637f11295aaaa6db5b0a28d6db8ac727592759))

## [8.8.1](https://github.com/nvim-neorg/neorg/compare/v8.8.0...v8.8.1) (2024-06-26)


### Bug Fixes

* remove `tree-sitter-norg` from the luarocks dependency list momentarily (delegate work to nvim-treesitter for the moment) ([4103d43](https://github.com/nvim-neorg/neorg/commit/4103d43898f0a612f1b702c5a6d2ef1e7fb76058))

## [8.8.0](https://github.com/nvim-neorg/neorg/compare/v8.7.1...v8.8.0) (2024-06-25)


### Features

* **latex-renderer:** add toggle renderer command ([a00628f](https://github.com/nvim-neorg/neorg/commit/a00628f54f895774dde09e4d7a3c99eb8340cbb6))
* **toc:** auto open/enter ToC ([988c2c1](https://github.com/nvim-neorg/neorg/commit/988c2c197c9f431d338519a3b81825cc5690b4e4))
* **toc:** close toc when neorg win is closed ([78e1155](https://github.com/nvim-neorg/neorg/commit/78e1155b8c3cc3f63e98817b7eea85f84ca7f6af))
* **toc:** configurable max width ([b0544ed](https://github.com/nvim-neorg/neorg/commit/b0544ed42c3aa28ceb8edf54a3a71c777de91e5d))
* **toc:** exit nvim when toc is the last window ([baf9934](https://github.com/nvim-neorg/neorg/commit/baf9934832866d28762b59c7e52c82854366d7dd))


### Bug Fixes

* broken true-zen integration ([#1477](https://github.com/nvim-neorg/neorg/issues/1477)) ([ace1cda](https://github.com/nvim-neorg/neorg/commit/ace1cdae9d0a95083bf9bf8cfb5e70dbb38d6351))
* don't update metadata unless buffer is modified ([#1469](https://github.com/nvim-neorg/neorg/issues/1469)) ([286d94b](https://github.com/nvim-neorg/neorg/commit/286d94bf6e30be4a5fc7ce89aa860538d39189a0))
* **hop:** describe which links are currently unsupported instead of "not found" ([9626def](https://github.com/nvim-neorg/neorg/commit/9626def65687a052b0e2c390e9ee9ee599344415))
* insert template at the end of a new journal entry ([#1468](https://github.com/nvim-neorg/neorg/issues/1468)) ([f33a491](https://github.com/nvim-neorg/neorg/commit/f33a4919b3aa2744209d8106886879e5522a38a4))
* **latex-renderer:** fixed renderer breaking when a snippet change made it stop compiling ([7fc91bb](https://github.com/nvim-neorg/neorg/commit/7fc91bbc7c316e0ad33132fb61325adc71d4f260))
* **toc:** don't try to open a toc from a toc ([6cdd6a1](https://github.com/nvim-neorg/neorg/commit/6cdd6a121c113d15c2aa55d79b6ec9915cc47284))
* **toc:** open new win from toc when neorg win was closed ([c2d58da](https://github.com/nvim-neorg/neorg/commit/c2d58da7c4800e9b8cb5b5ed1a6f38cde1a176d7))
* **todo-introspector:** check that the buffer is valid ([369ed28](https://github.com/nvim-neorg/neorg/commit/369ed28b0b0c3f221b46816ad53a509d73c7e7ed))

## [8.7.1](https://github.com/nvim-neorg/neorg/compare/v8.7.0...v8.7.1) (2024-06-12)


### Bug Fixes

* **latex-renderer:** fixed renderer failing silently ([4b22a4e](https://github.com/nvim-neorg/neorg/commit/4b22a4ea798efeeb756a6df52baa369715832a5a))

## [8.7.0](https://github.com/nvim-neorg/neorg/compare/v8.6.0...v8.7.0) (2024-06-11)


### Features

* anchor completion ([9917f99](https://github.com/nvim-neorg/neorg/commit/9917f993c505c3ab7d122e253a3af7cf13820fd0))
* **completion:** additional detached modifier extensions ([6b02bf1](https://github.com/nvim-neorg/neorg/commit/6b02bf156d4cf1ded9b2bb93cb4669a00e6a1e7f))
* link name completions ([8ec38e0](https://github.com/nvim-neorg/neorg/commit/8ec38e07ddffa84d0925faf425d4d52e5c1f91b7))
* **treesitter:** add get_ts_parser ([5221820](https://github.com/nvim-neorg/neorg/commit/5221820166a9cfac67451581ea79a9e2e7680215))
* **treesitter:** get_document_root accepts more sources ([4ebb7c7](https://github.com/nvim-neorg/neorg/commit/4ebb7c7bd62d12b77f0a8a0ec27e2e64ef204d65))


### Bug Fixes

* **concealer:** invalidate extmarks when range is deleted ([51be069](https://github.com/nvim-neorg/neorg/commit/51be06957fc6cc7140b310abd30be6682041962a))
* foreign link completions with item ([8537710](https://github.com/nvim-neorg/neorg/commit/85377108531d4083c0526623023a35aab2509410))
* supress swap file errors ([4420ddc](https://github.com/nvim-neorg/neorg/commit/4420ddc26ab80b42d4735ec78efea39c7cc7f547))
* thoroughly test for current Neovim version ([352570c](https://github.com/nvim-neorg/neorg/commit/352570cb174c73d50a82376f06b05badb1cda338))
* **todo-items:** error when switching from on-hold item with children ([f03435f](https://github.com/nvim-neorg/neorg/commit/f03435f03b5649598fb1478429d4e985dc5789bb))

## [8.6.0](https://github.com/nvim-neorg/neorg/compare/v8.5.0...v8.6.0) (2024-05-31)


### Features

* add `integrations.coq_nvim` as a new completion engine ([b8f9f83](https://github.com/nvim-neorg/neorg/commit/b8f9f834d999a6807ee9476857fb3af2c58f64a2))
* create `deps.json` for a universal list of Neorg dependencies ([a64c6af](https://github.com/nvim-neorg/neorg/commit/a64c6af4ac1ab4aa3a5de93d86111814125e3ed8))
* **latex:** async image rendering ([b1c96a0](https://github.com/nvim-neorg/neorg/commit/b1c96a049da8d534820f7452195fc9d961f3d025))
* **latex:** minimum length to render ([5a9d638](https://github.com/nvim-neorg/neorg/commit/5a9d6381581014c67219a823f149ce871f3af15d))
* modify deps.json to have proper version constraints ([5e9a3ef](https://github.com/nvim-neorg/neorg/commit/5e9a3ef798726fd2001d1596e6134b03f331a333))
* treesitter-based completions ([#1412](https://github.com/nvim-neorg/neorg/issues/1412)) ([79f6a49](https://github.com/nvim-neorg/neorg/commit/79f6a49b869a891bca9ce746f77781af46977e71))


### Bug Fixes

* clear extmarks on disable ([1be7808](https://github.com/nvim-neorg/neorg/commit/1be78080714b6f0cc1d77432629b91328880ce53))
* clear images at cursor after change ([9edd802](https://github.com/nvim-neorg/neorg/commit/9edd802c194ef180587c9c836ea84142927bc887))
* clear package.loaded cache when first installing neorg ([3d50b49](https://github.com/nvim-neorg/neorg/commit/3d50b49e1c1d37182c2ed94e718ecd5eed8cacd4))
* compute image dimensions before rendering ([94abd99](https://github.com/nvim-neorg/neorg/commit/94abd999cbb21d66080ee3970f41303c7093e1a6))
* conceal cursor updates ([2701e07](https://github.com/nvim-neorg/neorg/commit/2701e0770697ca10665277c0afd692567b24103d))
* **dirman:** swapfile error when opening index.norg ([#1451](https://github.com/nvim-neorg/neorg/issues/1451)) ([70d4b89](https://github.com/nvim-neorg/neorg/commit/70d4b899928d72ec9ab7961f69ae47fd24b8c3c4))
* handle switching buffers ([af4001e](https://github.com/nvim-neorg/neorg/commit/af4001ebd8678261e334591be4435f11e1aac294))
* image flashing on text change ([19737b0](https://github.com/nvim-neorg/neorg/commit/19737b02be7aee6c4395439fbd756901adb428a1))
* **latex-renderer:** handle broken latex ([#1438](https://github.com/nvim-neorg/neorg/issues/1438)) ([8140135](https://github.com/nvim-neorg/neorg/commit/81401353dc13ff87f4879b6e0b5f96ff2de14d9c))
* **latex:** predict image size for scale &gt; 1 ([bde2402](https://github.com/nvim-neorg/neorg/commit/bde24023d2b1ae507034c0839144f36e96dc7dc2))
* limages losing track of their extmarks ([f05bce2](https://github.com/nvim-neorg/neorg/commit/f05bce247e53a53a19bfe47c57d6bc8023b5c43b))
* logic when inline = false ([fc8c054](https://github.com/nvim-neorg/neorg/commit/fc8c0542d8676155e8c47d0b735e816a366235b1))
* mark core.links as internal ([22e7151](https://github.com/nvim-neorg/neorg/commit/22e7151f02559cea0320d02b57e59d2fb8294956))
* render images on cursor line on enable ([dc51ff4](https://github.com/nvim-neorg/neorg/commit/dc51ff489a653c292c6bf84751a5d060e8018c6c))
* rendering order for multiple img in one line ([a50c034](https://github.com/nvim-neorg/neorg/commit/a50c03432ba9cd4c370ebedfa6d84db1f0e61b6d))
* **text-objects:** nil check node's parent ([72da6e0](https://github.com/nvim-neorg/neorg/commit/72da6e0773298356f5a83ce52c9efdd88d4147e5))
* use nio.scheduler to avoid double wrap ([2a9c3fa](https://github.com/nvim-neorg/neorg/commit/2a9c3fab1bb6beabc4160264835be7f3b9a579e7))
* various type errors in codebase ([c564e6c](https://github.com/nvim-neorg/neorg/commit/c564e6cd470e1582414b63720ef85f1d0abe1d64))
* virt text disapearing on conceallevel=0 ([acd4293](https://github.com/nvim-neorg/neorg/commit/acd4293ab269c42eb9f3294d182eb87e7a34d66b))
* work on one buffer at a time ([ba41187](https://github.com/nvim-neorg/neorg/commit/ba41187669002622b7f9778e4c49723f47faf69a))


### Reverts

* d8ba19a18c896cc146e7ecbd4d67bdbe03f2e0c4 ([c8e2947](https://github.com/nvim-neorg/neorg/commit/c8e2947bdb71838ce90614cb3d9a0eb530c45fd7))

## [8.5.0](https://github.com/nvim-neorg/neorg/compare/v8.4.1...v8.5.0) (2024-05-17)


### Features

* text-objects and working swap ([#1421](https://github.com/nvim-neorg/neorg/issues/1421)) ([49a3c64](https://github.com/nvim-neorg/neorg/commit/49a3c64c06dae55b5424b218dc7c6e6b643fd4f5))


### Bug Fixes

* **core.todo-introspector:** treesitter highlighter errors ([cb4f25b](https://github.com/nvim-neorg/neorg/commit/cb4f25bca799c49a81e471aeca1d6d95322c87a6))

## [8.4.1](https://github.com/nvim-neorg/neorg/compare/v8.4.0...v8.4.1) (2024-04-13)


### Bug Fixes

* **checkhealth:** add missing parameter to string.format ([#1386](https://github.com/nvim-neorg/neorg/issues/1386)) ([9656757](https://github.com/nvim-neorg/neorg/commit/9656757f7085e9e36d2469b8876f6b27f8e87c7b))
* lack of comma ([65c7550](https://github.com/nvim-neorg/neorg/commit/65c75508626ad02a3cb40a84c4c3df0cde7b0e5a))
* properly check for existence of a given module by trying to load it instead of passively scanning the loaded module list ([727ef2a](https://github.com/nvim-neorg/neorg/commit/727ef2ab4247b52733d1a84d87143257e783d4e9))

## [8.4.0](https://github.com/nvim-neorg/neorg/compare/v8.3.0...v8.4.0) (2024-04-04)


### Features

* add `integrations.otter` for LSP-like behaviours in code blocks ([#1329](https://github.com/nvim-neorg/neorg/issues/1329)) ([ccb7555](https://github.com/nvim-neorg/neorg/commit/ccb75557f8582e044c687452b8b249151f6e7098))


### Bug Fixes

* broken wiki ([68ea6b5](https://github.com/nvim-neorg/neorg/commit/68ea6b53b6cb58c54ac51256cdfd76eec540806c))
* don't load `core.todo-introspector` if not on nightly (oops) ([bc7830e](https://github.com/nvim-neorg/neorg/commit/bc7830ec3e538d381f5361ca80a9bc5f97fc8fa9))

## [8.3.0](https://github.com/nvim-neorg/neorg/compare/v8.2.1...v8.3.0) (2024-04-04)


### Features

* basic checkhealth for configuration checking ([645cd0c](https://github.com/nvim-neorg/neorg/commit/645cd0c257b2fccc655a32d0b04aa706c96fb1a8))
* check for the existence of `vhyrro/luarocks.nvim` ([a5aa931](https://github.com/nvim-neorg/neorg/commit/a5aa93108999de75c8d075a0ee4dcc6a715a9e1a))
* **dirman:** use pathlib for all dirman operations  ([#1354](https://github.com/nvim-neorg/neorg/issues/1354)) ([1190dc7](https://github.com/nvim-neorg/neorg/commit/1190dc78b9785ad75301de9153ed8de83c179b66))
* implement the basics of the new todo introspector ([a7ad515](https://github.com/nvim-neorg/neorg/commit/a7ad51519f2e7a7274c069e35d4396a0a5f88ddc))
* **todo-introspector:** correctly enumerate amounts of done/undone items ([d284488](https://github.com/nvim-neorg/neorg/commit/d2844882ec0d18d59a7b8727b893a964fe76a754))
* **todo-introspector:** display all TODOs on file entry ([80b2d33](https://github.com/nvim-neorg/neorg/commit/80b2d33b1f402b0279009442caf6cfaa9cd308f4))
* **todo-introspector:** finalize display code ([949ae96](https://github.com/nvim-neorg/neorg/commit/949ae962558d43673130159cd6bce89e4bf4febc))
* **todo-introspector:** properly handle nodes broken into two ([76e6443](https://github.com/nvim-neorg/neorg/commit/76e6443c9823470897245951f37cef0cc5b966f0))


### Bug Fixes

* add `core.todo-introspector` to the list of default modules ([5202271](https://github.com/nvim-neorg/neorg/commit/52022710d47fd66c73280f7a8d7fe2013d899224))
* **checkhealth:** fix erroneous boolean check for lazy users ([d523688](https://github.com/nvim-neorg/neorg/commit/d523688ecc6ddf5fbac9b42e0b62515c7655bed3))
* **dirman:** norg link with `.` was misinterpreted as the extension ([96fe2c9](https://github.com/nvim-neorg/neorg/commit/96fe2c92d0e8fb2a2a853847909155aae4d5ca46))
* **dirman:** respect force option in dirman create_file ([0782ca4](https://github.com/nvim-neorg/neorg/commit/0782ca4a221cfd965f05752d7178b2692bb64ae0))
* **introspector:** various bugs related to extmark updates ([e8c9193](https://github.com/nvim-neorg/neorg/commit/e8c9193b10ea946e6f90e06daf0efeafb55fa970))
* issue a warning to users when dependencies cannot be found (instead of silently failing) ([04f4127](https://github.com/nvim-neorg/neorg/commit/04f4127a08a59d110c882464b11294dec0cf1258))
* **luarocks:** pin `pathlib` to `2.0` (as luarocks doesn't like it otherwise) ([5b93840](https://github.com/nvim-neorg/neorg/commit/5b93840d97c2ac0d1534321ca3659f4b8c1342e4))
* **pathlib:** bump pathlib version; fix `path:touch` ([bedbbe2](https://github.com/nvim-neorg/neorg/commit/bedbbe208e61491d1d8be0b6775793b246b444d0))
* **todo-introspector:** correctly handle deletion of lines ([a8b7ad0](https://github.com/nvim-neorg/neorg/commit/a8b7ad08f6e8cd36c83e371ab9a74cc1e5252a0b))
* **todo-introspector:** do not error when a line out of bounds is deleted ([62c7925](https://github.com/nvim-neorg/neorg/commit/62c7925e17ab25cc40c50cd266701a36aa854a50))
* **todo-introspector:** properly clear namespace for refreshed buffers ([5f67407](https://github.com/nvim-neorg/neorg/commit/5f6740795303a03b58c81bf6396ae03d487d5b7c))


### Reverts

* backout of commit 5b93840d97c2ac0d1534321ca3659f4b8c1342e4 ([e0690fa](https://github.com/nvim-neorg/neorg/commit/e0690fa65546bd91f9aa4883f1ce4cbea45e1898))

## [8.2.1](https://github.com/nvim-neorg/neorg/compare/v8.2.0...v8.2.1) (2024-03-28)


### Bug Fixes

* **core.neorgcmd.list:** don't accidentally open a separate file when displaying loaded modules ([eef1705](https://github.com/nvim-neorg/neorg/commit/eef1705ee78ae6e66917901da507a666743de877))
* don't allow TODOs with nested items of the same type to be given the pending status ([5942fdf](https://github.com/nvim-neorg/neorg/commit/5942fdf7eb42b6364ca0a754ac88bd0ca05ae660))
* load default modules even if an empty table is provided as input to setup() ([c1d36ad](https://github.com/nvim-neorg/neorg/commit/c1d36add07364e024dbf39276388741e54f7e955))
* **neorgcmd.modules.list:** add basic escape keybinds ([71e2f05](https://github.com/nvim-neorg/neorg/commit/71e2f05ee19c94705fadbc1f84e11990baf8ff1c))
* **typecheck:** use type definitions from nvim runtime instead ([#1358](https://github.com/nvim-neorg/neorg/issues/1358)) ([e7f393f](https://github.com/nvim-neorg/neorg/commit/e7f393f9e4a17c32289875e273f687863336894c))

## [8.2.0](https://github.com/nvim-neorg/neorg/compare/v8.1.0...v8.2.0) (2024-03-25)


### Features

* **metagen:** add author field to provide persistent custom author name ([#1331](https://github.com/nvim-neorg/neorg/issues/1331)) ([e576308](https://github.com/nvim-neorg/neorg/commit/e576308243b58838ed97309bec60bf180cde3c91))


### Bug Fixes

* **ci:** "could not find upvalue `lib`" error ([486a148](https://github.com/nvim-neorg/neorg/commit/486a148d1bf5b7fd14f52a771a0dacc1e6839174))
* **ci:** supply correct version to the lua setup CI ([c814ef6](https://github.com/nvim-neorg/neorg/commit/c814ef68295baffefed7bfb8a48f8835f73a55a6))
* **core/events:** fall back to the current window ID if it cannot be located ([22df349](https://github.com/nvim-neorg/neorg/commit/22df349df39d9401a95f7dc0e3dc13113f91a60a))
* **dirman:** properly escape directories and filenames ([#1232](https://github.com/nvim-neorg/neorg/issues/1232)) ([e1f5556](https://github.com/nvim-neorg/neorg/commit/e1f5556bfbe50cbae262dffc35f376f7469f68cf))
* do not add the line jump of a link to the jump list ([#1325](https://github.com/nvim-neorg/neorg/issues/1325)) ([918f2a3](https://github.com/nvim-neorg/neorg/commit/918f2a39f96e1447c00871eb611bed2018a047b5))
* **export.markdown:** export `authors` metadata field key as `author` ([#1319](https://github.com/nvim-neorg/neorg/issues/1319)) ([f30ce72](https://github.com/nvim-neorg/neorg/commit/f30ce728e1b99e23320114c3bddb18be2776baf7))
* **export.markdown:** fix incorrect reset of ordered list item count ([#1324](https://github.com/nvim-neorg/neorg/issues/1324)) ([ba58c1b](https://github.com/nvim-neorg/neorg/commit/ba58c1b29c9b013928025db345c6ff170e9693bf))

## [8.1.0](https://github.com/nvim-neorg/neorg/compare/v8.0.1...v8.1.0) (2024-03-24)


### Features

* **todo_items:** convert TODO item to "on hold" if all items are done but the rest are on hold ([#1339](https://github.com/nvim-neorg/neorg/issues/1339)) ([c32b238](https://github.com/nvim-neorg/neorg/commit/c32b238438a8f1130c89c13a2284961fe10e3e68))


### Bug Fixes

* remove old and hacky code related to nvim-treesitter's query cache invalidation ([e8d8d1e](https://github.com/nvim-neorg/neorg/commit/e8d8d1e6608e53e366109fc4f9d7ab364ea0fb5c))

## [8.0.1](https://github.com/nvim-neorg/neorg/compare/v8.0.0...v8.0.1) (2024-03-24)


### Bug Fixes

* broken wiki on github ([d4c10fe](https://github.com/nvim-neorg/neorg/commit/d4c10fe58519ce0d827cfc02f87832c75395045a))
* **ci:** try to fix the wiki generator with luarocks ([27ac595](https://github.com/nvim-neorg/neorg/commit/27ac595d90481bd8fa2d13290289d46287346903))
* **docgen:** invalid upvalues ([84ee928](https://github.com/nvim-neorg/neorg/commit/84ee928cd91db8705111c3d485e2a38ca5de61ec))
* **luarocks:** add proper dependencies ([81328d1](https://github.com/nvim-neorg/neorg/commit/81328d17ed9d5509e7dea8f1efc0fa568535e0e0))


### Reverts

* return back old logger code ([a8151f1](https://github.com/nvim-neorg/neorg/commit/a8151f1e21445739c9574d5eba9f4c635688cf98))

## [8.0.0](https://github.com/nvim-neorg/neorg/compare/v7.0.0...v8.0.0) (2024-03-24)


### ⚠ BREAKING CHANGES

* use decoupled lua-utils instead of the regular neorg utils
* **lib:** deprecate `lib.map`
* deprecate `core.upgrade`
* **concealer:** simpler config for ordered list icon & multichar icon for unordered list ([#1179](https://github.com/nvim-neorg/neorg/issues/1179))
* **neorgcmd:** slowly move away from the deprecated `commands` directory
* **highlights:** updated default groups to match names in treesitter

### Features

* add basic build.lua ([efac9eb](https://github.com/nvim-neorg/neorg/commit/efac9eb8c16cfe5cd1a45705d2add4eca749e63f))
* add lua-utils.nvim to the list of required rocks ([b7b9eda](https://github.com/nvim-neorg/neorg/commit/b7b9edad6a852f33a2ce99051c748823dabd28cc))
* add new dependencies for norgopolis ([0e88310](https://github.com/nvim-neorg/neorg/commit/0e883108d8c782335615cf2108a703847a1295d9))
* add support for inline link targets ([132b73b](https://github.com/nvim-neorg/neorg/commit/132b73bfacd3014dc8afb56ddf7eed8c7acf6d6d))
* auto complete links ([#1295](https://github.com/nvim-neorg/neorg/issues/1295)) ([bd12dac](https://github.com/nvim-neorg/neorg/commit/bd12dacc9cf561cbffc8d6f8f4b76aa9d734665b))
* **concealer:** code block background `min_width` ([#1328](https://github.com/nvim-neorg/neorg/issues/1328)) ([efac835](https://github.com/nvim-neorg/neorg/commit/efac8350f4afe0b49f278129ef92ffb0a02d1c6f))
* **concealer:** simpler config for ordered list icon & multichar icon for unordered list ([#1179](https://github.com/nvim-neorg/neorg/issues/1179)) ([da74d14](https://github.com/nvim-neorg/neorg/commit/da74d14f217dc81bc364758bbecea3c5e934ba60))
* **concealer:** use empty foldmethod on nightly releases (for full folding passthrough) ([086891d](https://github.com/nvim-neorg/neorg/commit/086891d396ac9fccd91faf1520f563b6eb9eb942))
* **export.markdown:** option to export latex `embed` tags ([0abe7b7](https://github.com/nvim-neorg/neorg/commit/0abe7b737d35f2abd082bc6f694cf5a9fc166fb7))
* fix build.lua process (maybe once and for all?) ([eea6263](https://github.com/nvim-neorg/neorg/commit/eea6263ac4f3506d34d6e79839606e60b074757b))
* include plenary as a dependency ([6ea1eff](https://github.com/nvim-neorg/neorg/commit/6ea1eff15d3f1fa947255a94f99cadb298c8b66f))
* **keybinds:** add `opts` arg to `remap(_event)` ([27af839](https://github.com/nvim-neorg/neorg/commit/27af839eb6833f82765bc3066ab7e9b437233dd2))
* prepare neorg.core.lib for extraction ([c4eb7e9](https://github.com/nvim-neorg/neorg/commit/c4eb7e96ea1e2a0a4b6d47e6bda4f6816a908262))
* run sync-parsers as a build step ([9dd8331](https://github.com/nvim-neorg/neorg/commit/9dd8331bc1ad42117c7173cd5501b93570db85d5))
* **summary:** reimplement nested categories ([#1274](https://github.com/nvim-neorg/neorg/issues/1274)) ([6202285](https://github.com/nvim-neorg/neorg/commit/6202285214e70efe0d861c5a4969f8ee817bc985))
* undojoin timestamp updates ([#1272](https://github.com/nvim-neorg/neorg/issues/1272)) ([fe25e93](https://github.com/nvim-neorg/neorg/commit/fe25e93336b6a71b3cb3d7fd53ab6e4cb4a125c1))
* when absolutely no parameters are supplied, load Neorg with core.defaults ([b6fb57b](https://github.com/nvim-neorg/neorg/commit/b6fb57b723c02255a9d0c0f1a8fc957fe007d9c2))


### Bug Fixes

* **build.lua:** install dependencies instead of the actual plugin itself (prevent conflicts) ([da25527](https://github.com/nvim-neorg/neorg/commit/da2552769b572c012ff2f0ee9c11e3a26f061252))
* **build:** attempt to fix build script by deferring code execution ([fb45f83](https://github.com/nvim-neorg/neorg/commit/fb45f836da9dd43940c3fdd182e8255bbce9d9dc))
* bump version of `norgopolis-server` to 1.3.1 ([0d8a7ec](https://github.com/nvim-neorg/neorg/commit/0d8a7ecae258e15f40e88bc3b312d2b92192743f))
* **ci:** fix abs path to libs in luarc ([#1267](https://github.com/nvim-neorg/neorg/issues/1267)) ([0edde97](https://github.com/nvim-neorg/neorg/commit/0edde97b51a5247bd4db351a38d5f36131b642f7))
* **ci:** wrong version on typecheck ([fb23d2e](https://github.com/nvim-neorg/neorg/commit/fb23d2e78bf6ee601ed1de2a9ded23d6201f7506))
* **concealer:** footnote pattern should be matched against full string ([fc09cfc](https://github.com/nvim-neorg/neorg/commit/fc09cfc25e243a82653a758bc137395f4860b6f5))
* **config:** add support for bsd operating systems ([#1281](https://github.com/nvim-neorg/neorg/issues/1281)) ([2bdb89c](https://github.com/nvim-neorg/neorg/commit/2bdb89c388d5c9e1956e7aab949ffb003e9a8ea5))
* **config:** make the type system happy ([27482dc](https://github.com/nvim-neorg/neorg/commit/27482dcee4b14ed61a10ba51261919cb45351dad))
* **core.keybinds:** type errors with events ([dbe2841](https://github.com/nvim-neorg/neorg/commit/dbe28417222e044bcbec5bb016f0d604004bcbb3))
* **core.mode:** type errors with events ([fb2c561](https://github.com/nvim-neorg/neorg/commit/fb2c561f0080b621fd2853a3190d48f885a13b6d))
* **core.neorgcmd:** type errors with events ([1ab6236](https://github.com/nvim-neorg/neorg/commit/1ab6236a954cf2de6fe4b736a66ca5a17d85a6ff))
* **core.promo:** type errors with events ([0016fdd](https://github.com/nvim-neorg/neorg/commit/0016fdd8f2349dec1c1865f3412dbd08232b1bbd))
* **core.syntax:** remove deprecated functions, fix type errors in the code ([221bb2e](https://github.com/nvim-neorg/neorg/commit/221bb2eb10c8d7b7f62537393a9dce385d36b638))
* **core/modules:** reorder comments so that they are properly parsed by luals ([f20b40a](https://github.com/nvim-neorg/neorg/commit/f20b40a44a4e96ff9fa5ed252c3a678629adfda9))
* **docgen:** make the wiki work again ([d44dd38](https://github.com/nvim-neorg/neorg/commit/d44dd387d8f553791671f52f691be7580b98c6db))
* don't try to pull lua-utils when it's not applicable ([bcac799](https://github.com/nvim-neorg/neorg/commit/bcac79933f3930f04d9b1517106646a56efd8606))
* enable source of `nvim-cmp` only norg file type ([#1298](https://github.com/nvim-neorg/neorg/issues/1298)) ([1ab15f4](https://github.com/nvim-neorg/neorg/commit/1ab15f4b30627fd5e6dd175a23c7360c2c08b2bd))
* enforce contraint on norgopolis-server ([4b9f25c](https://github.com/nvim-neorg/neorg/commit/4b9f25ca9760e89702ccbe117d1ce17780b64641))
* error with import loop ([16b5479](https://github.com/nvim-neorg/neorg/commit/16b54794a545d8f80c0e9007952e374df2e417cd))
* **export.markdown:** fix error on unexported verbatim tags without parameters ([#1280](https://github.com/nvim-neorg/neorg/issues/1280)) ([e6d89d3](https://github.com/nvim-neorg/neorg/commit/e6d89d333aff65a771a98955fac9fc178345c01c))
* **export.markdown:** fix html `embed` tags not being exported ([5b2022c](https://github.com/nvim-neorg/neorg/commit/5b2022caaf689dc1c78b8959a2547249f8b05769))
* **export.markdown:** fix markdown `embed` tags not being exported ([f3d4230](https://github.com/nvim-neorg/neorg/commit/f3d4230d37da5d727d3ae13e1bada30e37b433ad))
* **export.markdown:** fix the first `tag` always being exported by default ([bda456d](https://github.com/nvim-neorg/neorg/commit/bda456d6685545893d446e841f2ee41633b6548a))
* **export.markdown:** use proper amount of parameters ([b0b5a43](https://github.com/nvim-neorg/neorg/commit/b0b5a4370228f27bd98516b9061bd6c87386c8f3))
* **highlights:** updated default groups to match names in treesitter ([56ad805](https://github.com/nvim-neorg/neorg/commit/56ad8056b6180dba60ddbd5bca2f29de12f3bd1d))
* **highlights:** updated unordered list, underline and strikethrough groups with standard names ([e7f524c](https://github.com/nvim-neorg/neorg/commit/e7f524c44f1a5d6fba6cced7e4eb3c22b9ff1473))
* incorrect code in upgrade module ([07967f1](https://github.com/nvim-neorg/neorg/commit/07967f1982b589974958689c7a055b33ea194691))
* **integrations.truezen:** use `setup()` instead of `load()` ([26cfe0e](https://github.com/nvim-neorg/neorg/commit/26cfe0e155c35695d2d4af7d938a9ffd160b8797))
* **integrations.truezen:** use `setup()` instead of `load()` ([3506236](https://github.com/nvim-neorg/neorg/commit/3506236e292de6d7989b6d6541ed5fcfa1e73bab))
* invalid vim.cmd syntax ([affdd6f](https://github.com/nvim-neorg/neorg/commit/affdd6fcbc2092fca293817d65e1664afbafe223))
* nobody figured it out so away it goes :) ([7b3e794](https://github.com/nvim-neorg/neorg/commit/7b3e794aa8722826418501608c8a3ffe4e19ea30))
* perform setup after the parsers have been installed ([f90c965](https://github.com/nvim-neorg/neorg/commit/f90c9654352f424690327271e3bd9a2c036489d0))
* properly install parsers ([59b6d61](https://github.com/nvim-neorg/neorg/commit/59b6d619213506e405a8ed13669dc82120653ac5))
* properly log TS error messages ([73db6b5](https://github.com/nvim-neorg/neorg/commit/73db6b51e9e28cce7ef17baf78a8416b563ca53a))
* properly require lua-utils ([b8a78c0](https://github.com/nvim-neorg/neorg/commit/b8a78c0c84dcfd3996480339c3d10c6e1ade8363))
* refactor library to not use lua utils ([5fcae0b](https://github.com/nvim-neorg/neorg/commit/5fcae0b080531ac1438faeefd47ae11e1633b463))
* refresh lua cache upon succesful installation of dependencies ([f1473cf](https://github.com/nvim-neorg/neorg/commit/f1473cf9ab1c1b610758e28fcb9e8a792a51ddf4))
* remove lua-utils from the loaded list to force a refresh ([af1e06c](https://github.com/nvim-neorg/neorg/commit/af1e06c801d6cb5682dde9a63b22053a8cf28665))
* rename Neorg index message to be more insightful ([6d686cd](https://github.com/nvim-neorg/neorg/commit/6d686cdc064489ed17b49b6f1463fc9b3e5ba698))
* **syntax:** ignore type annotation errors in syntax module ([6d94c2a](https://github.com/nvim-neorg/neorg/commit/6d94c2ac08f13208d84ce21b1e3eea13158b6491))
* TSInstallSync not found ([df6cc22](https://github.com/nvim-neorg/neorg/commit/df6cc22f36e347856bc14807b9db396e67b927d7))
* update module name to reflect breaking changes within `luarocks.nvim` ([1779e59](https://github.com/nvim-neorg/neorg/commit/1779e5962badca89505b60e9617b939489c661b0))
* use lua-utils ([b1ce837](https://github.com/nvim-neorg/neorg/commit/b1ce8374a88d638f42f0ce97b3b4b6b2b4e89023))


### Code Refactoring

* deprecate `core.upgrade` ([45f51ed](https://github.com/nvim-neorg/neorg/commit/45f51ed759d9cdd6c69b67e57ecbd054fd4cbaba))
* **lib:** deprecate `lib.map` ([8340274](https://github.com/nvim-neorg/neorg/commit/83402746b8b43190edb360329a023040bd388294))
* **neorgcmd:** slowly move away from the deprecated `commands` directory ([560d5a0](https://github.com/nvim-neorg/neorg/commit/560d5a04fb8143aaa5e64ba8eb100df97631fa36))
* use decoupled lua-utils instead of the regular neorg utils ([5f6bf7e](https://github.com/nvim-neorg/neorg/commit/5f6bf7e5444fe839d739bd376ec5cdb362f02dc6))

## [7.0.0](https://github.com/nvim-neorg/neorg/compare/v6.2.0...v7.0.0) (2023-12-28)


### ⚠ BREAKING CHANGES

* **selection_popup:** modernize code of selection popup

### ref

* **selection_popup:** modernize code of selection popup ([310f3a4](https://github.com/nvim-neorg/neorg/commit/310f3a484d3d98b0d05650a38407dcaa7f090b96))


### Features

* allow upward paths in tangle ([265e6af](https://github.com/nvim-neorg/neorg/commit/265e6af8decbb30b0ee14aee373b1bfe9a78b858))
* **concealer:** add ability to disable spell checking in code blocks ([316403a](https://github.com/nvim-neorg/neorg/commit/316403ad1cbb665e7838f596384d44b1649f6c1b))
* **concealer:** add config for concealing numeric footnote title to superscript ([2a6fc9c](https://github.com/nvim-neorg/neorg/commit/2a6fc9c808f6d643bf7c2f911a767e4aac500560))
* **concealer:** add configuration for hrule start and end position ([3db316a](https://github.com/nvim-neorg/neorg/commit/3db316a33838eb0875eacd659af9d49bbd4aef39))
* **keyinds:** add keybind for entering link traversal mode ([#1177](https://github.com/nvim-neorg/neorg/issues/1177)) ([8cf5205](https://github.com/nvim-neorg/neorg/commit/8cf52058fb7e9c3057882430ade90be5bdfb3a94))
* prefix all keybind descriptions with "neorg" for discoverability ([15c24cd](https://github.com/nvim-neorg/neorg/commit/15c24cdb264807b09e9281e2d72b324145da1d57))
* **selection_popup:** allow keybinds to be processed from another buffer ([603b633](https://github.com/nvim-neorg/neorg/commit/603b633b8df231fe37a338856b1dea7cd955a969))
* **summary:** add strategy which uses workspace subfolders as category ([aa8e66d](https://github.com/nvim-neorg/neorg/commit/aa8e66dd40c07a4de58f9ed93f27ab4dac9a241c))
* **tangle:** add `report_on_empty` option in `core.tangle` ([#1250](https://github.com/nvim-neorg/neorg/issues/1250)) ([cc6d8b1](https://github.com/nvim-neorg/neorg/commit/cc6d8b150de7bf806f3a191867a7f143970b5112))
* **toc:** add config for enabling synchronized cursorline in toc window ([d3cbb45](https://github.com/nvim-neorg/neorg/commit/d3cbb45b66c865b1b92b5f8b2dbd5a5fff7f1a2f))
* **toc:** add toc item filter ([#1195](https://github.com/nvim-neorg/neorg/issues/1195)) ([5c42084](https://github.com/nvim-neorg/neorg/commit/5c420844227c75390cc9fdf6047bfc49466169d9))
* **toc:** auto adjust toc vsplit width upon creation ([81f6330](https://github.com/nvim-neorg/neorg/commit/81f6330af951e89f98e8468d23a648fc32acdd2f))
* **toc:** don't scroll content window when switching to toc ([c4fc7e6](https://github.com/nvim-neorg/neorg/commit/c4fc7e629e8ea7ecc9610107622f46e888764534))
* **toc:** enable folding in toc ([218e7eb](https://github.com/nvim-neorg/neorg/commit/218e7ebbce010846c5ed6da647264c556c6a7ad4))
* **toc:** faster toc generation ([0171df1](https://github.com/nvim-neorg/neorg/commit/0171df1d0f8a6db254020e8b02ac576188ffad23))
* **toc:** support one ToC per tabpage ([d8a456b](https://github.com/nvim-neorg/neorg/commit/d8a456b7fa1b9d860fc36750b6e9a200a8eff5f3))
* **toc:** support todo status ([4ac077b](https://github.com/nvim-neorg/neorg/commit/4ac077b1f19efe63fcec4e6c744bc6a68dfc7f6a))
* **toc:** sync cursor from ToC to content buffer ([47e7c86](https://github.com/nvim-neorg/neorg/commit/47e7c86877aaae4d85c1a2add166ad6c15b8add4))
* **toc:** sync toc cursor after creating toc, scroll content to center when previewing ([cfcb51e](https://github.com/nvim-neorg/neorg/commit/cfcb51ea9a403ee7223e49d4afb0142d6d5e1659))


### Bug Fixes

* "Keybind not found" display causing errors ([#1215](https://github.com/nvim-neorg/neorg/issues/1215)) ([a51abd5](https://github.com/nvim-neorg/neorg/commit/a51abd53d8afc7de81e35d0a4247c3aa6ccfc76a))
* `update-metadata` would fail to work with several parse trees in the document ([#1234](https://github.com/nvim-neorg/neorg/issues/1234)) ([5a44d3f](https://github.com/nvim-neorg/neorg/commit/5a44d3ffbd3b4fff762f8b2712ab1cfd16cff016))
* **action:** run lint action against pr head ([f367396](https://github.com/nvim-neorg/neorg/commit/f36739620410917a3119ee4299894c353a0d88af))
* **autocommands:** pass correct buffer id ([941119d](https://github.com/nvim-neorg/neorg/commit/941119d48a5e354cfbed24a4b314bb4eb401a75b))
* **concealer:** BufNewFile-&gt;FileType, get winid of bufid when rendering ([c0983ca](https://github.com/nvim-neorg/neorg/commit/c0983ca60f02e1a65e5990593726e57678e03c4a))
* **concealer:** do not render on range change if concealer is disabled ([9b0c31a](https://github.com/nvim-neorg/neorg/commit/9b0c31a5179f3881f9ff2350da22c9a5a11f32ab))
* **concealer:** ensure backwards compatibility for `vim.treesitter.foldexpr` ([5921cc4](https://github.com/nvim-neorg/neorg/commit/5921cc48cb3be616db0071fa058cfa4d6633c8a6))
* **concealer:** use vim.treesitter.foldexpr for stabler folding ([53cbffb](https://github.com/nvim-neorg/neorg/commit/53cbffb7ecfcb60f19c10c72c4162978e8021959))
* **config:** delete `neovim_version` as it is no longer in use ([00f9a62](https://github.com/nvim-neorg/neorg/commit/00f9a628683b7b3f738e1d1d1a79d517c26b6ff5))
* **config:** fix luajit version detection ([237abac](https://github.com/nvim-neorg/neorg/commit/237abac43a38e4aa770bb5819f30b3d38ae5f392))
* **export:** better handling of new lines in markdown metadata ([d56cc3c](https://github.com/nvim-neorg/neorg/commit/d56cc3c9a9cd10bfac5eac2514a9457a3e9e848d))
* **export:** fix metadata values being ignored when converting to markdown ([6f9b66c](https://github.com/nvim-neorg/neorg/commit/6f9b66cfa75241d4b8c0890a312872104a2d96a1))
* **export:** handle empty `object`/`array` nodes in markdown metadata ([3afbadb](https://github.com/nvim-neorg/neorg/commit/3afbadb3d116d6f8a5fb0aa3af1c06563c4a038e))
* **hop:** fix range check across lines ([1038016](https://github.com/nvim-neorg/neorg/commit/10380167975732444f21c882e522d15b0ec55b34))
* **journal:** value assigned to variable current_quarter is unused ([0e88151](https://github.com/nvim-neorg/neorg/commit/0e8815116b08bfbceb2b36a8c82d81005e2596e0))
* **latex:** Want image integration ([a80c025](https://github.com/nvim-neorg/neorg/commit/a80c025b231a6acd925d625d6d9ea302bc20bd49))
* **luacheck:** setting non-standard global variables in latex renderer module ([#1176](https://github.com/nvim-neorg/neorg/issues/1176)) ([3f4b279](https://github.com/nvim-neorg/neorg/commit/3f4b279d7505ac854fcd31d1aad24991542ea5d8))
* **modules:** Check the right config key in module.wants ([8b25435](https://github.com/nvim-neorg/neorg/commit/8b25435e8bc60f9e6f665b3a28870d64d20f2b59))
* **neorg.norg:** clarify horizontal line syntax ([#1230](https://github.com/nvim-neorg/neorg/issues/1230)) ([e35bf90](https://github.com/nvim-neorg/neorg/commit/e35bf907533281a6c641505eae3bb42100d7b5a0))
* record that module `upgrade` requires at least 1 arg ([#1207](https://github.com/nvim-neorg/neorg/issues/1207)) ([51f55f5](https://github.com/nvim-neorg/neorg/commit/51f55f5c6d54fa86fdaae805b55ca88aa9607c37))
* **summary:** set correct indentation for list items ([120fb52](https://github.com/nvim-neorg/neorg/commit/120fb52f5fe21c43fcc7285bac4a9bce8a54a6ec))
* **toc:** clear title after assigning prefix ([f446645](https://github.com/nvim-neorg/neorg/commit/f4466457396717d10d2d235d019e0a80e1770087))
* **toc:** fix all stylua errors ([ae38baf](https://github.com/nvim-neorg/neorg/commit/ae38baf90a319488b726ed25166fc00641b3e0ce))
* **toc:** get window id on the fly to avoid assertion errors ([1b0ab75](https://github.com/nvim-neorg/neorg/commit/1b0ab75e8e57b08bc981e0d72fe928b0fff34fe2))
* **toc:** handle buf close ([985364f](https://github.com/nvim-neorg/neorg/commit/985364f561518502cc002494db4d48ec92b00d80))
* **toc:** handle buf close ([2d65f6c](https://github.com/nvim-neorg/neorg/commit/2d65f6cf7a0f40b9a474e17bc347255514dbde0e))
* **toc:** listen cursormoved for all norg files ([19bff13](https://github.com/nvim-neorg/neorg/commit/19bff133659c16973e52546f54a13469bfecb1b6))
* **toc:** stop synching cursor when content window is hidden ([15ed981](https://github.com/nvim-neorg/neorg/commit/15ed981858658796b698f6fc204f1378eef4b01d))
* **typecheck:** fix type errors caused by autoformat ([3f531c3](https://github.com/nvim-neorg/neorg/commit/3f531c362d07d52c4956520e3798e9cfb5aeabdf))

## [6.2.0](https://github.com/nvim-neorg/neorg/compare/v6.1.0...v6.2.0) (2023-11-18)


### Features

* add `traverse-link` Neorg mode ([#1170](https://github.com/nvim-neorg/neorg/issues/1170)) ([ed25267](https://github.com/nvim-neorg/neorg/commit/ed25267eec3b08a3de8bdb4b55243f869ea4b8fd))
* add LaTex rendering for inline equations ([#1133](https://github.com/nvim-neorg/neorg/issues/1133)) ([b5393e8](https://github.com/nvim-neorg/neorg/commit/b5393e8bdcf704f660fa86cace89033c5fc95504))
* allow arguments for `:Neorg generate-workspace-summary` ([#1156](https://github.com/nvim-neorg/neorg/issues/1156)) ([46741ed](https://github.com/nvim-neorg/neorg/commit/46741ede577392f36cad1cb8c8e6029fabb729f6))
* allow nested workspace summaries ([#1144](https://github.com/nvim-neorg/neorg/issues/1144)) ([a923055](https://github.com/nvim-neorg/neorg/commit/a9230559fb6871f1f62996f8e862876169432f08))
* **hop:** feed wslview with decoded link ([c3b9653](https://github.com/nvim-neorg/neorg/commit/c3b965340f380740a12432536d2b23ee6c7564f9))
* **metagen:** customize timezone and its format ([b458149](https://github.com/nvim-neorg/neorg/commit/b4581496328d47ab7912148ec030dcb3ec1951c4))
* option to inject specific metadata instead of defaults ([#1128](https://github.com/nvim-neorg/neorg/issues/1128)) ([5509079](https://github.com/nvim-neorg/neorg/commit/55090798a2eed2dd00fc1b2774bc6bf309a3bd0b))


### Bug Fixes

* **dirman:** add `raw_path` option to work with arbitrary filetype ([#1143](https://github.com/nvim-neorg/neorg/issues/1143)) ([0c9f5de](https://github.com/nvim-neorg/neorg/commit/0c9f5dea0cfe8b7c3d38f26651d82624079774ed))
* **journal:** toc reset month & add link indent ([#1165](https://github.com/nvim-neorg/neorg/issues/1165)) ([16af444](https://github.com/nvim-neorg/neorg/commit/16af444ef804aa7f099c7a5ae03640dfc2b60303))
* remove LaTeX renderer and image.nvim integration from `core.defaults` ([5a88bcb](https://github.com/nvim-neorg/neorg/commit/5a88bcbf60590348e4196493c9c7642f23ba21d7))
* workspace summary ignore closed files and title field of metadata tag ([#1139](https://github.com/nvim-neorg/neorg/issues/1139)) ([d081937](https://github.com/nvim-neorg/neorg/commit/d081937a00e0f0c6966116428117e159a785abb5))

## [6.1.0](https://github.com/nvim-neorg/neorg/compare/v6.0.0...v6.1.0) (2023-10-29)


### Features

* support dotrepeat for `promo` and `todo_items` ([#1105](https://github.com/nvim-neorg/neorg/issues/1105)) ([2c43e6b](https://github.com/nvim-neorg/neorg/commit/2c43e6b3252af198973cbe91f8fa7a762ff61a77))


### Bug Fixes

* **calendar:** display weekdays based on `nvim_strwidth` ([5eadb3c](https://github.com/nvim-neorg/neorg/commit/5eadb3cce8ab490222d12dfbb5c86372c89a5773))
* **calendar:** use `nvim_strwidth` for month names as well ([a081397](https://github.com/nvim-neorg/neorg/commit/a0813979663d5e55c481bb557c250b551042d115))
* **dirman:** open index file in default workspace only if it exists ([d1bda3c](https://github.com/nvim-neorg/neorg/commit/d1bda3caf7d73ec93bed125d2d76ba32ce897789))
* don't autoload `core.neorgcmd` nor `core.keybinds` as dependencies of other modules ([#1051](https://github.com/nvim-neorg/neorg/issues/1051)) ([62ba931](https://github.com/nvim-neorg/neorg/commit/62ba93130eb795ccc2133841ce0e541f8bc51eb7))
* **meta:** fix treesitter deprecation warning ([#1104](https://github.com/nvim-neorg/neorg/issues/1104)) ([#1130](https://github.com/nvim-neorg/neorg/issues/1130)) ([5205f3f](https://github.com/nvim-neorg/neorg/commit/5205f3f1ed23545a3015021be11d35a012e3b02a))
* **utils:** don't dotrepeat insert mode actions ([#1111](https://github.com/nvim-neorg/neorg/issues/1111)) ([969b3f1](https://github.com/nvim-neorg/neorg/commit/969b3f106683c66ab685ecba2a67bf11cb806785))

## [6.0.0](https://github.com/nvim-neorg/neorg/compare/v5.0.0...v6.0.0) (2023-09-23)


### ⚠ BREAKING CHANGES

* adapt to new injection syntax for treesitter
* **codebase:** make the `neorg` object local to a `core` module ([#1001](https://github.com/nvim-neorg/neorg/issues/1001))

### Features

* add blank lines between tangled blocks ([#958](https://github.com/nvim-neorg/neorg/issues/958)) ([1c41592](https://github.com/nvim-neorg/neorg/commit/1c41592ec975189c79987aa32228778c111eb67f))
* **concealer:** add option for opening all folds by default ([#1049](https://github.com/nvim-neorg/neorg/issues/1049)) ([6bfcaeb](https://github.com/nvim-neorg/neorg/commit/6bfcaeb8f36e0e4d2ae52dbde5e18b39d2351d5e))
* delimit tangle code blocks with file content ([#1014](https://github.com/nvim-neorg/neorg/issues/1014)) ([1809236](https://github.com/nvim-neorg/neorg/commit/18092365b21c73a0478b6bd6d9b3a66fd4b77a36))
* delimit tangled code blocks with headings ([#981](https://github.com/nvim-neorg/neorg/issues/981)) ([99bfcb1](https://github.com/nvim-neorg/neorg/commit/99bfcb11dc3fbc72c08259d5516738d3a1f7bd11))
* **document.meta:** indent items of incomplete lists/objects for nicer writing experience ([92f2e9d](https://github.com/nvim-neorg/neorg/commit/92f2e9d4a7bfdbb7ed0e9dcd9b8768db63188149))
* **esupports.hop:** add open mode for external link target ([#1072](https://github.com/nvim-neorg/neorg/issues/1072)) ([851a3a2](https://github.com/nvim-neorg/neorg/commit/851a3a2b3cea5335fca233273d3c8861a017da14))
* **esupports.hop:** support `os_open_link` for WSL ([#963](https://github.com/nvim-neorg/neorg/issues/963)) ([628ba9f](https://github.com/nvim-neorg/neorg/commit/628ba9f58e02db6b2818f68b62a1499c22eb9cd4))
* **esupports:** use `wslview` to open `wsl2` files ([#1038](https://github.com/nvim-neorg/neorg/issues/1038)) ([20502e5](https://github.com/nvim-neorg/neorg/commit/20502e50e9087248f6f8ed8d29fae9c849c1c77f))
* **itero:** allow fallback keys for when there is no object to iterate ([ba2899d](https://github.com/nvim-neorg/neorg/commit/ba2899d6580706cbf727720db2765aead9d342de))
* **keybinds:** allow `core.itero.next-iteration` to fall back to a specific key ([51ca15b](https://github.com/nvim-neorg/neorg/commit/51ca15b13e9a7b107bef54c9bed94b5863b9c5d5))
* **metagen:** allow falling back to the default template functions ([#1079](https://github.com/nvim-neorg/neorg/issues/1079)) ([8200ebc](https://github.com/nvim-neorg/neorg/commit/8200ebc5a5730a14efa2e47751a43539c8a16fb5))
* **metagen:** more precise timestamp with HH:MM:SS and timezone ([#1052](https://github.com/nvim-neorg/neorg/issues/1052)) ([a8f7a9e](https://github.com/nvim-neorg/neorg/commit/a8f7a9eeef5c22eac626e7533eeee0ac9def72ad))


### Bug Fixes

* `:h neorg` not working as intended ([0b3df86](https://github.com/nvim-neorg/neorg/commit/0b3df8633cc1cbb3ffd6f34d4e9073fd6f5083ab))
* **`:h neorg`:** make link point to correct line in specs ([#1092](https://github.com/nvim-neorg/neorg/issues/1092)) ([e20d032](https://github.com/nvim-neorg/neorg/commit/e20d032ea3c485fc499f4dbc4bf7ce6afd6767ba))
* `folke/todo-comments.nvim` comments highlighting (again) ([#1094](https://github.com/nvim-neorg/neorg/issues/1094)) ([d8e2c8e](https://github.com/nvim-neorg/neorg/commit/d8e2c8e309c05a7db4ca84fc1216be38cf6a010f))
* broken configuration merging in modules.lua ([#1062](https://github.com/nvim-neorg/neorg/issues/1062)) ([b4c7935](https://github.com/nvim-neorg/neorg/commit/b4c7935a0e692870f38ff34689fd900de40ea479))
* **calendar:** call `os.date` twice to generate correct weekday ([#1058](https://github.com/nvim-neorg/neorg/issues/1058)) ([61fb605](https://github.com/nvim-neorg/neorg/commit/61fb60508516b224ec78666187e70074397b37f8))
* **calendar:** give calendar enough space to render ([#950](https://github.com/nvim-neorg/neorg/issues/950)) ([6fece15](https://github.com/nvim-neorg/neorg/commit/6fece1546d051a5f2a2d932d5978beec1ef920ab))
* **concealer,indent:** "require'neorg'" missing in v:lua call ([#1010](https://github.com/nvim-neorg/neorg/issues/1010)) ([1d3b425](https://github.com/nvim-neorg/neorg/commit/1d3b4252862cadf80751e0e03463b27a1782ce94))
* **concealer:** avoid conflict between preset and custom icons ([9a0aab0](https://github.com/nvim-neorg/neorg/commit/9a0aab039b174625bfc4ff708ba32f3fc5713649))
* **concealer:** do not render missing node ([#1004](https://github.com/nvim-neorg/neorg/issues/1004)) ([08c7d19](https://github.com/nvim-neorg/neorg/commit/08c7d19125f5f8aa36911bfd3ea166b650e05e07))
* **concealer:** don't rerender at `conceallevel` change when disabled ([#1068](https://github.com/nvim-neorg/neorg/issues/1068)) ([63a7a10](https://github.com/nvim-neorg/neorg/commit/63a7a101387550a220186cab7e85df15635f3356))
* **concealer:** more precise anticonceal feature detection ([#1056](https://github.com/nvim-neorg/neorg/issues/1056)) ([b0117a4](https://github.com/nvim-neorg/neorg/commit/b0117a40675398cb6b7f0967a52e148d5ddb6f42))
* **concealer:** revert a wrong fix, make luacheck ignore empty if branch instead (supercedes [#1080](https://github.com/nvim-neorg/neorg/issues/1080)) ([0c82917](https://github.com/nvim-neorg/neorg/commit/0c82917b89a187662cf8c1f5fc3a17153866df9b))
* **concealer:** tolerate duplicate marks caused by undo during rendering ([#1015](https://github.com/nvim-neorg/neorg/issues/1015)) ([44bb353](https://github.com/nvim-neorg/neorg/commit/44bb3533465d30062b28a334115e37dbbe7e5118))
* **core:** assign custom field ([4b057ad](https://github.com/nvim-neorg/neorg/commit/4b057ad071f0e395fb1e983c9611913e9b46108f))
* **dirman:** correctly create nested directory ([#1061](https://github.com/nvim-neorg/neorg/issues/1061)) ([4f0888b](https://github.com/nvim-neorg/neorg/commit/4f0888bdf98f7b1eeb96365aca17aa08ba4a07ea))
* **docgen:** `neorg.core` not found ([bb29db9](https://github.com/nvim-neorg/neorg/commit/bb29db9320b353da8abdfaebcba74a0a1d6e1a20))
* **docgen:** inline `esupports.metagen` template function definitions ([#945](https://github.com/nvim-neorg/neorg/issues/945)) ([a993b35](https://github.com/nvim-neorg/neorg/commit/a993b357ab86e153ecd50e2d4b704b8dcffedc1f))
* don't use deprecated `query.get_node_text()` call ([#1067](https://github.com/nvim-neorg/neorg/issues/1067)) ([7248c34](https://github.com/nvim-neorg/neorg/commit/7248c347704d658daf0fa0a84706c120e92eb1a5))
* error in loading preventing wiki from generating ([2745ee1](https://github.com/nvim-neorg/neorg/commit/2745ee1371c1029171bb98f2d9fb258e688d2c20))
* fetched get_language_list from utils ([#1003](https://github.com/nvim-neorg/neorg/issues/1003)) ([3db1001](https://github.com/nvim-neorg/neorg/commit/3db10018e8893aee47f3b5eb9f4d7440f8db5136))
* **highlights:** always try to attach highlights when triggered ([#1025](https://github.com/nvim-neorg/neorg/issues/1025)) ([31b3bfd](https://github.com/nvim-neorg/neorg/commit/31b3bfddfc1a4e426b41879bdb1a039babc554e3))
* indents within `document.meta` would not work ([b14334e](https://github.com/nvim-neorg/neorg/commit/b14334e39dcf6d8a6edb18547b7c4580387dce63))
* issue a more friendly error message when user loads tempus pre-Neovim `0.10.0` ([#1035](https://github.com/nvim-neorg/neorg/issues/1035)) ([333a1fd](https://github.com/nvim-neorg/neorg/commit/333a1fd67aad3dee49305b0278bd59f8ae740f13))
* **journal:** expand entry path correctly (fixes [#780](https://github.com/nvim-neorg/neorg/issues/780)) ([#995](https://github.com/nvim-neorg/neorg/issues/995)) ([e76f0cb](https://github.com/nvim-neorg/neorg/commit/e76f0cb6b3ae5e990052343ebb73a5c8d8cac783))
* **journal:** Remove condition from 'toc' subcommand (fixes [#597](https://github.com/nvim-neorg/neorg/issues/597)) ([#996](https://github.com/nvim-neorg/neorg/issues/996)) ([99f33e0](https://github.com/nvim-neorg/neorg/commit/99f33e08fe074126b491e02854e5d00dab10f5ae))
* **looking-glass:** ensure both the target buffer and the source are loaded before pursuing any operations ([fba064d](https://github.com/nvim-neorg/neorg/commit/fba064db88eae3419d20ce35cf3961d02c355a8f))
* **maneoeuvre:** `lib` -&gt; `utils` ([0949a4a](https://github.com/nvim-neorg/neorg/commit/0949a4a2816ef19cb19e0ef8d483d3410dd0895a))
* On close of TOC, only delete buffer if it exists ([#978](https://github.com/nvim-neorg/neorg/issues/978)) ([32bae17](https://github.com/nvim-neorg/neorg/commit/32bae172814611f82e90b696b72cac99ff8de0e9))
* **presenter:** ensure module.private is not overriden ([#1037](https://github.com/nvim-neorg/neorg/issues/1037)) ([c9dd9f7](https://github.com/nvim-neorg/neorg/commit/c9dd9f7d506717b00e99409e4088e5b739c36b39))
* replace `get_filetype` with `vim.filetype.match` ([#982](https://github.com/nvim-neorg/neorg/issues/982)) ([4e6dbb1](https://github.com/nvim-neorg/neorg/commit/4e6dbb184442bc33e20ce760f093c07b32ad4128))
* **summary:** escape ws_root special characters ([#1012](https://github.com/nvim-neorg/neorg/issues/1012)) ([32abc0d](https://github.com/nvim-neorg/neorg/commit/32abc0da29dd5bf4b42d340810b64754fd7a37b8))
* **tags:** make new tags work with updated neorg help document ([#994](https://github.com/nvim-neorg/neorg/issues/994)) ([3f946f8](https://github.com/nvim-neorg/neorg/commit/3f946f8814a59ac16baaf4bc1dd0f4aca3807736))
* **tangle:** accessing unused variable ([0f37ab8](https://github.com/nvim-neorg/neorg/commit/0f37ab86ea82838ddd9feeab94986d6d72d0d85a))
* **toc:** preserve heading hierarchy ([#1053](https://github.com/nvim-neorg/neorg/issues/1053)) ([1c1060f](https://github.com/nvim-neorg/neorg/commit/1c1060f0d187cd0939b05c1310bb58911e84bc22))
* **ui:** remove possible ui noise caused by user's opts ([68eae35](https://github.com/nvim-neorg/neorg/commit/68eae352bf4b936e667b5eb4d454d4d280d2286d))
* Update `get_username` call ([#1005](https://github.com/nvim-neorg/neorg/issues/1005)) ([93bf092](https://github.com/nvim-neorg/neorg/commit/93bf092a817df07f75cee578c74b4eabab3b7c87))


### Code Refactoring

* adapt to new injection syntax for treesitter ([064f8f6](https://github.com/nvim-neorg/neorg/commit/064f8f65dd32f4fe728e76acfa3e4e153b121147))
* **codebase:** make the `neorg` object local to a `core` module ([#1001](https://github.com/nvim-neorg/neorg/issues/1001)) ([5706f1e](https://github.com/nvim-neorg/neorg/commit/5706f1efdcf55f273de8f52deeb35375a303be72))

## [5.0.0](https://github.com/nvim-neorg/neorg/compare/v4.6.0...v5.0.0) (2023-06-07)


### ⚠ BREAKING CHANGES

* **core.ui:** don't use old Neovim APIs, fix errors when using `<LocalLeader>nn`
* **core.highlights:** remove `todo_items_match_color` option
* **highlights:** simplify highlights for performance reasons
* **summary:** fix norg links, use first heading as title if found ([#928](https://github.com/nvim-neorg/neorg/issues/928))
* **core:** remove `real`/imaginary components of modules, improve startup time, remove `imports` from `module.setup`
* remove the `core.news` module
* **concealer:** rewrite for performance and stability ([#834](https://github.com/nvim-neorg/neorg/issues/834))
* since 5.0 do not longer warn about deprecated `core.norg.*` modules
* move to new/improved metadata parser, change highlight queries

### Features

* add extra nesting level, make icons specific to non-anticonceal usage ([84ea792](https://github.com/nvim-neorg/neorg/commit/84ea792d97977b98caab8e63538d3286f58b2b1b))
* add highlights to `&variable&`s ([#710](https://github.com/nvim-neorg/neorg/issues/710)) ([97080f7](https://github.com/nvim-neorg/neorg/commit/97080f798e0872a52510e33cf7f9064af5501da3))
* add neorg to luarocks ([4fceaa6](https://github.com/nvim-neorg/neorg/commit/4fceaa67656a0ebf17daeac133db2387df44552a))
* conceal the `{* }` parts of links ([729e7ac](https://github.com/nvim-neorg/neorg/commit/729e7ac46b5feac7f97826f755695f0e2c4799f9))
* **concealer:** add more icon generators ([49b9788](https://github.com/nvim-neorg/neorg/commit/49b9788a4988235d4357f8ae87d3ce82ee39302e))
* **concealer:** add numeric anticonceal if supported ([55feccf](https://github.com/nvim-neorg/neorg/commit/55feccf37df2b1143ea85151b9430149c617aa99))
* **concealer:** rewrite for performance and stability ([#834](https://github.com/nvim-neorg/neorg/issues/834)) ([151c033](https://github.com/nvim-neorg/neorg/commit/151c0337684a30ab8a9b31683b7a2fa28b0a15b0))
* **esupports.hop:** link jump to line + fixes + refactoring ([#903](https://github.com/nvim-neorg/neorg/issues/903)) ([49610cd](https://github.com/nvim-neorg/neorg/commit/49610cdee13050fc872cc006a690a911dda68413))
* **indent:** add `dedent_excess` configuration option ([#624](https://github.com/nvim-neorg/neorg/issues/624)) ([66d5a22](https://github.com/nvim-neorg/neorg/commit/66d5a2251b0871aa037135644b6fca2a856de5b4))
* **itero:** don't start newline on empty line ([#911](https://github.com/nvim-neorg/neorg/issues/911)) ([4c76b74](https://github.com/nvim-neorg/neorg/commit/4c76b741a0003417ed38bf0f43727810c27fb042))
* **keybinds.lua:** add `desc` fields to task keybinds ([#926](https://github.com/nvim-neorg/neorg/issues/926)) ([978fdc1](https://github.com/nvim-neorg/neorg/commit/978fdc1dede2325374dc5a32db10a4b6dad87bf0))
* **keybinds.lua:** add descriptions to all keybinds ([bb50538](https://github.com/nvim-neorg/neorg/commit/bb505384372b87ae6193c9ceeb02312d50f0df3c))
* move to new/improved metadata parser, change highlight queries ([962e45a](https://github.com/nvim-neorg/neorg/commit/962e45a29f1d61f685a5bacb9a2b00eb0a11d9c5))
* **promo:** promote/demote prefix without following text ([#912](https://github.com/nvim-neorg/neorg/issues/912)) ([544bb06](https://github.com/nvim-neorg/neorg/commit/544bb06c28956c4e21b6d6d32b1b3ea7415be7cd))


### Bug Fixes

* **completion:** selected completion engine not being engaged ([474af82](https://github.com/nvim-neorg/neorg/commit/474af829b0f3e25e09e68d2842ffcb6ca24d359b))
* **concealer:** disable assertion for prefixes until parser changes ([#932](https://github.com/nvim-neorg/neorg/issues/932)) ([92aa737](https://github.com/nvim-neorg/neorg/commit/92aa7373ccdfc5c9d1616027173237ee9cc4098e))
* **concealer:** do not listen vimleavepre ([#920](https://github.com/nvim-neorg/neorg/issues/920)) ([865224a](https://github.com/nvim-neorg/neorg/commit/865224a59982a148e9b11647d23e2de61272c42c))
* **concealer:** fix concealing in anchors, don't error on broken config ([#923](https://github.com/nvim-neorg/neorg/issues/923)) ([f448b58](https://github.com/nvim-neorg/neorg/commit/f448b581c6a6cf2747b33ff6bfece6c21c72b03f))
* **concealer:** minor fixes, plus wiki error fix ([#916](https://github.com/nvim-neorg/neorg/issues/916)) ([5629898](https://github.com/nvim-neorg/neorg/commit/5629898cf24bf25a39723e4113ce87a08f0d9dc1))
* **concealer:** record cursor upon init to fix first line conceal ([#924](https://github.com/nvim-neorg/neorg/issues/924)) ([44ee0cb](https://github.com/nvim-neorg/neorg/commit/44ee0cb8db3d655d45d5ca5cedc2b0745b232659))
* **core.highlights:** fix disappearing highlights when opening up norg files ([9db5645](https://github.com/nvim-neorg/neorg/commit/9db56453e2f7f6bc7e81baa338e09a2565ccaff1))
* **core.highlights:** wrongly placed bracket ([1886d36](https://github.com/nvim-neorg/neorg/commit/1886d363e9f397251060a4d6681fa975ef9d3b64))
* **core.summary:** bugs + flexibility around incomplete metadata ([#927](https://github.com/nvim-neorg/neorg/issues/927)) ([30343db](https://github.com/nvim-neorg/neorg/commit/30343dbdcdb511ecb6f484c46a9ae6f20a66ff7d))
* **docgen:** don't fail on mixed-type tables (lists and dictionaries at the same time) ([1afcaf8](https://github.com/nvim-neorg/neorg/commit/1afcaf804bae0048bfca1c0d49b69c968f2c187b))
* **docgen:** fix incorrect markdown indentation in wiki ([2bf6e63](https://github.com/nvim-neorg/neorg/commit/2bf6e63c299903d6e83fe14a521987dd0745efb0))
* **docgen:** propagate docgen error exit code ([#917](https://github.com/nvim-neorg/neorg/issues/917)) ([0e97976](https://github.com/nvim-neorg/neorg/commit/0e97976417d3e387d9be2f4fb42cd66c72254b6b))
* **highlights:** assert on treesitter being enabled ([#914](https://github.com/nvim-neorg/neorg/issues/914)) ([330f04e](https://github.com/nvim-neorg/neorg/commit/330f04ef693fb379c5ff199a05813e270718c850))
* **highlights:** attempt to reenable highlighting when none is found ([d1fb8c9](https://github.com/nvim-neorg/neorg/commit/d1fb8c94c57161e675402ec06ed80dc9223df655))
* **presenter:** errors on startup ([ea5fe1b](https://github.com/nvim-neorg/neorg/commit/ea5fe1b51d0a5b9f33a2fdd81906c5661b9198d6))
* **summary:** fix norg links, use first heading as title if found ([#928](https://github.com/nvim-neorg/neorg/issues/928)) ([6f893a2](https://github.com/nvim-neorg/neorg/commit/6f893a205a7543f2b7390b31176cf6e4ee2442c0))
* **todo_items:** don't look at child if parent is todo ([#909](https://github.com/nvim-neorg/neorg/issues/909)) ([8e3bcb2](https://github.com/nvim-neorg/neorg/commit/8e3bcb295a834dd57ba1d41ef2903f3dcc53a70e))


### Performance Improvements

* **core.highlights:** remove `todo_items_match_color` option ([7b5d550](https://github.com/nvim-neorg/neorg/commit/7b5d550843a3a2576aa95a90972c2ffc0e5c682f))
* **core.neorgcmd:** unnecessary `vim.tbl_deep_extend` ([71d291f](https://github.com/nvim-neorg/neorg/commit/71d291f97dc7e7fab4ca5740181e25f6d50a6e2d))
* **core.promo:** don't check `v.count`, use `v.count1` instead ([ca98238](https://github.com/nvim-neorg/neorg/commit/ca982387110ce2b796e585a10cd6f6922cec6c69))
* **events:** don't deepcopy a table on each new event ([12198ef](https://github.com/nvim-neorg/neorg/commit/12198efd76ec057be207e567dbeed3c8022d6eb6))
* **hop:** load plenary only when required, remove startup hiccup ([3caca5a](https://github.com/nvim-neorg/neorg/commit/3caca5ac209aa8098a355837b5c4696d16804e19))


### Code Refactoring

* **core.ui:** don't use old Neovim APIs, fix errors when using `&lt;LocalLeader&gt;nn` ([bbb25ff](https://github.com/nvim-neorg/neorg/commit/bbb25ffa380a2c159b0d301df9b81a8fcf3ab67a))
* **core:** remove `real`/imaginary components of modules, improve startup time, remove `imports` from `module.setup` ([593e9b2](https://github.com/nvim-neorg/neorg/commit/593e9b2a0826dfb8068a02277f4a45db00573e9a))
* **highlights:** simplify highlights for performance reasons ([f1ecd61](https://github.com/nvim-neorg/neorg/commit/f1ecd613d9c2911c7f7d5abd7f6f471614d05518))
* remove the `core.news` module ([1b9f8da](https://github.com/nvim-neorg/neorg/commit/1b9f8da57fb3e0bab9d1594fce87808ead8d650d))
* since 5.0 do not longer warn about deprecated `core.norg.*` modules ([19e0e8a](https://github.com/nvim-neorg/neorg/commit/19e0e8a3e983bf0a87c5c791863d4a480f0ff54c))

## [4.6.0](https://github.com/nvim-neorg/neorg/compare/v4.5.0...v4.6.0) (2023-05-25)


### Features

* **todo-items:** add missing "need input" icon and action ([#896](https://github.com/nvim-neorg/neorg/issues/896)) ([4cb0fa9](https://github.com/nvim-neorg/neorg/commit/4cb0fa9e56cf16672c258d1d97545d0526b506b5))


### Bug Fixes

* **esupports:** use structured api to avoid injection ([#899](https://github.com/nvim-neorg/neorg/issues/899)) ([e50b8ae](https://github.com/nvim-neorg/neorg/commit/e50b8aecb61dae1dd726fe00f40d3a554ba1b694))
* **tempus:** supply unprovided parameters from the current date when converting to `osdate` (supercedes [#897](https://github.com/nvim-neorg/neorg/issues/897)) ([f367451](https://github.com/nvim-neorg/neorg/commit/f36745161d82067e0f26865d93858fd3a15d8ad4))

## [4.5.0](https://github.com/nvim-neorg/neorg/compare/v4.4.1...v4.5.0) (2023-05-24)


### Features

* add colouring to TODO items ([238152a](https://github.com/nvim-neorg/neorg/commit/238152ab40ec1fb293fae75744942146876ed08f))


### Bug Fixes

* **metagen:** update generation to use user config for `updated` tag ([#882](https://github.com/nvim-neorg/neorg/issues/882)) ([6ed0f3a](https://github.com/nvim-neorg/neorg/commit/6ed0f3aa088e7b3141f01e3a82f3ec6517c34485)), closes [#865](https://github.com/nvim-neorg/neorg/issues/865)
* TSInstall issues on macOS, hopefully once and for good ([#891](https://github.com/nvim-neorg/neorg/issues/891)) ([4988a6f](https://github.com/nvim-neorg/neorg/commit/4988a6f9166b6ac7b9ba5115e61dc3a2b13e820c))

## [4.4.1](https://github.com/nvim-neorg/neorg/compare/v4.4.0...v4.4.1) (2023-05-17)


### Bug Fixes

* **tempus:** paste correct weekday from calendar ([ba54231](https://github.com/nvim-neorg/neorg/commit/ba54231e14a31c0571ff7baa4828de121a5e3072))
* **tempus:** properly handle conversions w.r.t Sun-Sat/Mon-Sun ([e39fa1b](https://github.com/nvim-neorg/neorg/commit/e39fa1b1626fc6f4bb9f4695b15d7065561c2567))

## [4.4.0](https://github.com/nvim-neorg/neorg/compare/v4.3.0...v4.4.0) (2023-05-16)


### Features

* **journal:** allow `custom` to take in no arguments, in which case ([ea0497a](https://github.com/nvim-neorg/neorg/commit/ea0497aea783507ce640e909b6764be4fcd5a388))


### Bug Fixes

* **promo:** don't add whitespace to empty lines ([#852](https://github.com/nvim-neorg/neorg/issues/852)) ([a7291f4](https://github.com/nvim-neorg/neorg/commit/a7291f4662664d0c3be3016adff6767dc52f907d))
* **tempus:** don't use the `re` module if it doesn't exist ([#872](https://github.com/nvim-neorg/neorg/issues/872)) ([3c99638](https://github.com/nvim-neorg/neorg/commit/3c99638db0ce4293e221216bdda03a55da6ad82b))

## [4.3.0](https://github.com/nvim-neorg/neorg/compare/v4.2.0...v4.3.0) (2023-05-15)


### Features

* **calendar:** add `t` command for "today" ([e53a509](https://github.com/nvim-neorg/neorg/commit/e53a5099b5725162c8f0a626823cac4819a9427d))
* **hop:** allow users to jump to timestamps ([22b12fb](https://github.com/nvim-neorg/neorg/commit/22b12fb2301582fd9552ab10ac0c934cda4d0a14))


### Bug Fixes

* **hop:** assume &lt;current-day&gt; when some parameters to dates are not supplied ([65bf064](https://github.com/nvim-neorg/neorg/commit/65bf06493ecb411b1589ad345771ae29aa17cd33))
* **tempus:** days like `4th`/`2nd` would not get parsed properly ([7368a8a](https://github.com/nvim-neorg/neorg/commit/7368a8ae10a0bab32729bd00dcac6f24cb55a8ef))

## [4.2.0](https://github.com/nvim-neorg/neorg/compare/v4.1.1...v4.2.0) (2023-05-15)


### Features

* **tempus:** add `,id` (insert date) keybinding ([34f13ba](https://github.com/nvim-neorg/neorg/commit/34f13ba253c160e72ef7817a950508430ed050d1))
* **tempus:** add insert mode `&lt;M-d&gt;` keybind to insert a date ([b420f69](https://github.com/nvim-neorg/neorg/commit/b420f69602b23fa8fc2f7f6526f49838f9521b10))
* **tempus:** allow dates to be converted to norg-compatible dates with `tostring()` ([3ec5f96](https://github.com/nvim-neorg/neorg/commit/3ec5f96dfd673c2c2a34b09748518accf61ec677))


### Bug Fixes

* don't allow tempus to load unless the Neovim ver is at least 0.10.0 ([c4429fa](https://github.com/nvim-neorg/neorg/commit/c4429fa1e1eb0c3c5652495b00aa4e1c56068914))
* **tempus:** do not assume `osdate` has all fields set ([c37a104](https://github.com/nvim-neorg/neorg/commit/c37a104c992326f8924de783d667f7c4c34f92b7))

## [4.1.1](https://github.com/nvim-neorg/neorg/compare/v4.1.0...v4.1.1) (2023-05-15)


### Bug Fixes

* remove calendar as a dependency of `core.ui`, fix errors for people not on nightly ([cd26a22](https://github.com/nvim-neorg/neorg/commit/cd26a220e999cc9103a2502299d16ae8e6fab4d9))

## [4.1.0](https://github.com/nvim-neorg/neorg/compare/v4.0.1...v4.1.0) (2023-05-14)


### Features

* add `core.tempus` module for date management ([b73ec2f](https://github.com/nvim-neorg/neorg/commit/b73ec2f5e1b11864ca0628a842a53a617d5851ce))
* add left-right cursor movement ([ea588bb](https://github.com/nvim-neorg/neorg/commit/ea588bbc2cabe37f90652a8cb49bf8b286498d2a))
* add skeleton for the calendar UI element ([3c99106](https://github.com/nvim-neorg/neorg/commit/3c99106d64792533a3cf10ac6ef20a089e94c1ff))
* **calendar:** add `?` help page for custom input ([211b0ba](https://github.com/nvim-neorg/neorg/commit/211b0ba61b5cf8f4520b5e03f5235f6de87e4417))
* **calendar:** add `$` and `0`/`_` navigation keybinds ([0061928](https://github.com/nvim-neorg/neorg/commit/006192808d436c27f8ceca0fffcc4a238ec402a7))
* **calendar:** add `m`/`M`, `L`/`H` and `y`/`Y` keybinds for the monthly view ([9bf562d](https://github.com/nvim-neorg/neorg/commit/9bf562d4633abac71b749ad7380cfe010a4c3bd7))
* **calendar:** add basic help popup when `?` is invoked ([779d089](https://github.com/nvim-neorg/neorg/commit/779d089e17139acfdd2a4988c34eea892f29a475))
* **calendar:** allow many simultaneous calendars ([f816fe7](https://github.com/nvim-neorg/neorg/commit/f816fe77ef2abecff9e98d8d35ff48a453317cf0))
* **calendar:** generalize functions even further, allow for offsets ([d857c34](https://github.com/nvim-neorg/neorg/commit/d857c34fe7a4645501551f2b66dd7915b9575b4f))
* **calendar:** implement basic `i` functionality ([6713f40](https://github.com/nvim-neorg/neorg/commit/6713f40d5d1f9e7a0e8b80ffdc82d4fff79c16c0))
* **calendar:** render as many months as is possible on screen ([fa23767](https://github.com/nvim-neorg/neorg/commit/fa237674cf75bf2bbc62a438b1606b65cc277ebd))
* **core.ui.calendar:** add day of the month rendering ([8bc3364](https://github.com/nvim-neorg/neorg/commit/8bc3364f306d5df528193a8ca68fa8b4a45701ef))
* **core.ui.calendar:** add static calendar ui ([adbb415](https://github.com/nvim-neorg/neorg/commit/adbb4151677bf22c809f9b6dfd35de5e07da6c7a))
* **core.ui.calendar:** highlight the current day differently ([eada386](https://github.com/nvim-neorg/neorg/commit/eada386cc79c122b648580de50b1f825b74a9627))
* **core.ui.calendar:** implement more of the barebones UI ([364f44a](https://github.com/nvim-neorg/neorg/commit/364f44a7d1179d5aa98d1f4ff6b4b6b1b6078bd3))
* **core.ui.calendar:** make the calendar display full month names ([c6cc059](https://github.com/nvim-neorg/neorg/commit/c6cc059992c812712c9a2bb4075b2d9b31f84f5c))
* **core.ui:** let `create_split` take in a `height` variable ([7dbbe9d](https://github.com/nvim-neorg/neorg/commit/7dbbe9d236596d8990827e717ea892cd98e79b23))
* correctly handle year boundaries ([58b55e1](https://github.com/nvim-neorg/neorg/commit/58b55e16366ecd431bece7ba4d42d512b21b972e))
* implement `render_month` function ([343fb8d](https://github.com/nvim-neorg/neorg/commit/343fb8d02422fe2f2a3c791f2bdba0be95c3c96b))
* place cursor over current day when creating calendar ([3ce268b](https://github.com/nvim-neorg/neorg/commit/3ce268b703d321561b86e546c7633326b39fa494))
* **tempus:** add `to_lua_date` function ([ef62e53](https://github.com/nvim-neorg/neorg/commit/ef62e5308c684468a822684382d14de8f8f63193))


### Bug Fixes

* **calendar:** allow the view to be written to on rerender ([8e247d4](https://github.com/nvim-neorg/neorg/commit/8e247d414bcb0d1123b2b12c7ff29bdf36c50cbd))
* **calendar:** fix incorrect movement with `H` across boundaries of months with different lengths ([48face2](https://github.com/nvim-neorg/neorg/commit/48face25855d7844302b13a125363c30b8a6fe9a))
* **calendar:** fix rest of highlight groups ([ead4c4c](https://github.com/nvim-neorg/neorg/commit/ead4c4c53769839b5063fab71ebb92d155d53676))
* **calendar:** if another calendar is open then close it instead of erroring ([9751e7d](https://github.com/nvim-neorg/neorg/commit/9751e7d62af0b7e49ff788058154b966be205e2e))
* **calendar:** make distance between each month uniform and support modifying the distance between each month ([746354d](https://github.com/nvim-neorg/neorg/commit/746354dea70e9657f61531375329e407e7f5a203))
* **calendar:** make month rendering work again ([164028f](https://github.com/nvim-neorg/neorg/commit/164028fd621e3c5b56603d88d6d5e2ba5db51d42))
* **calendar:** overlapping month names in the calendar view ([709cf78](https://github.com/nvim-neorg/neorg/commit/709cf78410b6ea631192ad004d3f2b83761f9953))
* **calendar:** prevent the buffer from being modifiable after it has been filled ([351e103](https://github.com/nvim-neorg/neorg/commit/351e10326e0e2bb6166e165ddb6598e917e6d25c))
* **calendar:** properly display "today's day" in the calendar view ([74ee71a](https://github.com/nvim-neorg/neorg/commit/74ee71a446662f92afa3cbd49f6c980bdf25ae92))
* **calendar:** reversed namespace names ([77b214c](https://github.com/nvim-neorg/neorg/commit/77b214cef220580cdcf527265a15ef980e7bcaf3))
* **core.ui.calendar:** logic error when parsing virt_text length for `set_logical_extmark` ([d5b29ee](https://github.com/nvim-neorg/neorg/commit/d5b29eea8e09d7bd0add778c6818539719914301))
* **core.ui.calendar:** wrong extmark being queried in month render routine ([46624b9](https://github.com/nvim-neorg/neorg/commit/46624b9a02e0d0e928026a0fd4852c4dd3ca7e0d))

## [4.0.1](https://github.com/nvim-neorg/neorg/compare/v4.0.0...v4.0.1) (2023-05-11)


### Bug Fixes

* **highlights.scm:** free form open/close chars would not be concealed ([5de014e](https://github.com/nvim-neorg/neorg/commit/5de014e7cc3dc6eed0a62854fe8ba58f664d97ea))
* **qol.toc:** display headings with TODO statuses unless the status is "cancelled" ([2e44346](https://github.com/nvim-neorg/neorg/commit/2e44346813310de9afc411e2348cf2be8540f70c))
* stop syntax processing if a buffer is already closed ([#859](https://github.com/nvim-neorg/neorg/issues/859)) ([cc2834a](https://github.com/nvim-neorg/neorg/commit/cc2834ae2beb2d5baa75d15848a94dae022faa2c))

## [4.0.0](https://github.com/nvim-neorg/neorg/compare/v3.2.2...v4.0.0) (2023-05-05)


### ⚠ BREAKING CHANGES

* move all `gt*` keybinds to `<LocalLeader>t*`
* remove `core.news`

### Features

* add basic cheatsheet (viewable via `:h neorg-cheatsheet`) ([d3e37a6](https://github.com/nvim-neorg/neorg/commit/d3e37a681743181a34dcfa7adb6ec61fb5aeb63c))
* **keybinds:** warn when a deprecated keybind is used (will be removed with `5.0`) ([e20d3c3](https://github.com/nvim-neorg/neorg/commit/e20d3c324b091cac29ccd7ec8431d24aa9b792c8))


### Bug Fixes

* **concealer:** buggy debounce logic causing visual artifacts (especially on the first line of a buffer) ([45388fc](https://github.com/nvim-neorg/neorg/commit/45388fc0478e8d1273bd80789e7e1af1df76458f))
* **concealer:** stop concealer if buffer is not loaded ([#836](https://github.com/nvim-neorg/neorg/issues/836)) ([6aa9fd3](https://github.com/nvim-neorg/neorg/commit/6aa9fd303c807ed1ca3fb15cdeab1e322d02fd31))
* **dirman.expand_path:** search for both `$/` and `$\` in links to support windows paths ([#830](https://github.com/nvim-neorg/neorg/issues/830)) ([160d40f](https://github.com/nvim-neorg/neorg/commit/160d40f5261be5149842942adbf260d6e359d9ec))
* **esupports.hop:** anchors to files woul dresult in a "link not found" ([#688](https://github.com/nvim-neorg/neorg/issues/688)) ([3009adf](https://github.com/nvim-neorg/neorg/commit/3009adf2cf48aedcbb309d0765e0fbbb64a0fdf4))
* **keybinds.lua:** remove dead `toc` keybinds ([06666f2](https://github.com/nvim-neorg/neorg/commit/06666f298e146d758d691366ca3465a3bd1e3f7f))


### Code Refactoring

* move all `gt*` keybinds to `&lt;LocalLeader&gt;t*` ([f67110d](https://github.com/nvim-neorg/neorg/commit/f67110d11d37fde09756eb2de8a1814d04a4a03b))
* remove `core.news` ([4086d9f](https://github.com/nvim-neorg/neorg/commit/4086d9f17d823cfe5a13e7b12b30e13b5d3b796d))

## [3.2.2](https://github.com/nvim-neorg/neorg/compare/v3.2.1...v3.2.2) (2023-04-27)


### Bug Fixes

* **core.ui:** clear the `winbar` option in Neorg popups to prevent "not enough room" errors ([fcebf9f](https://github.com/nvim-neorg/neorg/commit/fcebf9f6caf0667f99b1481e2c0a49f0eeb68fe9))
* **esupports.hop:** broken definitions and footnotes ([#733](https://github.com/nvim-neorg/neorg/issues/733)) ([94cf7d2](https://github.com/nvim-neorg/neorg/commit/94cf7d2889b386ce1313e80c8c04adf18872c028))

## [3.2.1](https://github.com/nvim-neorg/neorg/compare/v3.2.0...v3.2.1) (2023-04-27)


### Bug Fixes

* **export:** `gsub` export links that contain `#`, `?`. closes [#807](https://github.com/nvim-neorg/neorg/issues/807) ([#816](https://github.com/nvim-neorg/neorg/issues/816)) ([7f3a3b8](https://github.com/nvim-neorg/neorg/commit/7f3a3b850c8d4b73e7f85971aae2a96162bcb150))
* **export:** markdown export for horizontal_line ([#820](https://github.com/nvim-neorg/neorg/issues/820)) ([2178447](https://github.com/nvim-neorg/neorg/commit/217844796e00a1cea7c051435f9c49bee25e7caa))

## [3.2.0](https://github.com/nvim-neorg/neorg/compare/v3.1.0...v3.2.0) (2023-04-22)


### Features

* add `core.pivot` for toggling list types ([cbf383f](https://github.com/nvim-neorg/neorg/commit/cbf383ff4eca0e23a24d4244af20bed415ed400c))
* **keybinds:** add default keybinds for `core.pivot` ([2f49628](https://github.com/nvim-neorg/neorg/commit/2f496283504dcfb30d9ee60101a8290e743c1753))
* **pivot:** add `core.pivot.invert-list-type` keybind ([2d0446a](https://github.com/nvim-neorg/neorg/commit/2d0446a2d8e3789bbd17bbb3cb97e73befccb327))


### Bug Fixes

* **core.summary:** wrong module name in header, wrong internal command names ([a046900](https://github.com/nvim-neorg/neorg/commit/a0469001430a68f521d3292f8a8252655cfda941))
* **docgen:** installation documentation link for wiki ([ba8b31d](https://github.com/nvim-neorg/neorg/commit/ba8b31dc2491f80b9f65fadbafdfd94d6ef26988)), closes [#548](https://github.com/nvim-neorg/neorg/issues/548)
* **summary:** broken wiki entry ([69fbabf](https://github.com/nvim-neorg/neorg/commit/69fbabfb5764cd164453a764174cf5cfa813ae60))

## [3.1.0](https://github.com/nvim-neorg/neorg/compare/v3.0.0...v3.1.0) (2023-04-19)


### Features

* warn access to `core.norg` modules instead of breaking ([ed761a5](https://github.com/nvim-neorg/neorg/commit/ed761a5c5a9100861034b31978049401444fd6fb))

## [3.0.0](https://github.com/nvim-neorg/neorg/compare/v2.0.1...v3.0.0) (2023-04-19)


### ⚠ BREAKING CHANGES

* move all `core.norg.*` modules into `core.*`
* **Makefile:** remove `install_pre_commit` target
* move `core.norg.dirman.summary` -> `core.summary`
* **summary:** refactor of the `core.norg.dirman.summary` module
* **docgen:** wipe whole wiki on every reparse

### Features

* add `dirman.summary` module ([#750](https://github.com/nvim-neorg/neorg/issues/750)) ([93c40f2](https://github.com/nvim-neorg/neorg/commit/93c40f2e38a0770e9ce95787c8363320344a87c3))
* add `Home.md` generation capability ([6bdf557](https://github.com/nvim-neorg/neorg/commit/6bdf557ece33850f9733dddc343369d743a51564))
* **ci:** add `version_in_code.yml` workflow ([5746245](https://github.com/nvim-neorg/neorg/commit/5746245756bac83fcf02338c93bc87f6089e2bf3))
* cleanup, add document comments to all modules, add more error checks ([81284c1](https://github.com/nvim-neorg/neorg/commit/81284c1e2f6e441f6532678b76ff5378396dda2c))
* **config.lua:** add `norg_version`, bump `version` to `3.0.0` ([8d76723](https://github.com/nvim-neorg/neorg/commit/8d767232a571513a3ab8c5c14ddc6f26d09aa98a))
* **core.integrations.treesitter:** Return all same attributes of a tag ([bedf13d](https://github.com/nvim-neorg/neorg/commit/bedf13dbcef63099a52dd4f160d90c46fc1de440))
* **dirman:** add new `use_popup` option for `dirman` ([#743](https://github.com/nvim-neorg/neorg/issues/743)) ([6350254](https://github.com/nvim-neorg/neorg/commit/63502544afde1c15d79ce097ad1928314cb8c7cd))
* **docgen:** add `module` page generator ([17496a8](https://github.com/nvim-neorg/neorg/commit/17496a8e975f1bd9d896d7cc78a6e61d1a131245))
* **docgen:** add basic rendering skeleton logic ([215719e](https://github.com/nvim-neorg/neorg/commit/215719ece560400592c2fef2ed75ab57430baf9b))
* **docgen:** add comment integrity checking logic ([799886f](https://github.com/nvim-neorg/neorg/commit/799886f7ba5a072a453d5a90708686109ce4fa21))
* **docgen:** allow strings as table keys ([4adf04e](https://github.com/nvim-neorg/neorg/commit/4adf04e05d98b6bcb6a3aac4cab60d64fd0d86f9))
* **docgen:** auto-open &lt;details&gt; tags that contain tables or lists ([1f2e0dc](https://github.com/nvim-neorg/neorg/commit/1f2e0dc23f6944bad660553ad4550847cf68e096))
* **docgen:** differentiate between lists and tables ([c0062e5](https://github.com/nvim-neorg/neorg/commit/c0062e5a75226f063b59eb5ee8250cb4da6ea202))
* **docgen:** differentiate empty and nonempty tables/lists ([0ab1a8d](https://github.com/nvim-neorg/neorg/commit/0ab1a8d469667d6b763e299c390a3e9bc7ea1a13))
* **docgen:** implement `Required By` field ([7033c4b](https://github.com/nvim-neorg/neorg/commit/7033c4bd2dc4633d0874b2da05b0ae67928b1117))
* **docgen:** implement `Required By` section ([15bf71b](https://github.com/nvim-neorg/neorg/commit/15bf71b15e07917e0f3a55de44e79fcdfbfc557d))
* **docgen:** implement configuration_options parsing logic ([b34658a](https://github.com/nvim-neorg/neorg/commit/b34658a21602fdd286889c2e57bf2d68d63d4472))
* **docgen:** implement function rendering, fix incorrect interpretation of function calls ([a023488](https://github.com/nvim-neorg/neorg/commit/a023488944473dfcd611308d5e21b7a9b2d7690d))
* **docgen:** implement table rendering ([9074328](https://github.com/nvim-neorg/neorg/commit/907432885e40a16f064d4406cd45efeb895f0962))
* **docgen:** indent nested table keys ([9cf679a](https://github.com/nvim-neorg/neorg/commit/9cf679a24f3bb9db145ae4dfbeb43878a49839e3))
* **docgen:** massive structure changes, implement proper table rendering ([42b8728](https://github.com/nvim-neorg/neorg/commit/42b8728f291072b9d8a11bdf9c7e205ef15fb94d))
* **docgen:** parse config tables ([93c41e1](https://github.com/nvim-neorg/neorg/commit/93c41e1f0aa290d0ad2e2590753312c71a782395))
* **docgen:** perform `[@module](https://github.com/module)` lookups, pasre complex data structures like tables ([19f2381](https://github.com/nvim-neorg/neorg/commit/19f23811ba0366fe3ec9423d26aec33d9d34fcc2))
* **docgen:** properly implement recursive table scanning ([33e06b8](https://github.com/nvim-neorg/neorg/commit/33e06b8d0fc2e7a9b386fc95e6bce4dfb714e56f))
* **docgen:** sort entries when rendering ([b420e70](https://github.com/nvim-neorg/neorg/commit/b420e70532766475bce0bf1d34129e711a31e21a))
* **docgen:** start generating true module pages ([5115d5c](https://github.com/nvim-neorg/neorg/commit/5115d5cd4bd1fefb11f82cb3e3da18b74d4e9b9e))
* **helpers/lib:** add `read_files` and `title` functions ([d59f41b](https://github.com/nvim-neorg/neorg/commit/d59f41b78755b102a41d172d4e3f64d59cb86b8b))
* **helpers:** add `ensure_nested` function ([2c4e8d0](https://github.com/nvim-neorg/neorg/commit/2c4e8d02feb7f1e6878307e7813a9f13ec000a73))
* **helpers:** Add wrapper to vim.notify ([#778](https://github.com/nvim-neorg/neorg/issues/778)) ([c278f6f](https://github.com/nvim-neorg/neorg/commit/c278f6f895c6b2f9ef4fc217ed867675108d804e))
* implement _Sidebar generation ([733b74c](https://github.com/nvim-neorg/neorg/commit/733b74c92481bc955f1f46594e50fb4931ab3cf5))
* implement necessary APIs for complex data structure parsing ([b78f01c](https://github.com/nvim-neorg/neorg/commit/b78f01cd951b8ecfe7e842d31f609e6e4d5ac9db))
* implement new docgen featuring top-comment validation ([b77fbd5](https://github.com/nvim-neorg/neorg/commit/b77fbd52f96db049687901ac1f0a8aea7ab4bdfa))
* **indent:** adapt indentation of nestable detached modifiers when a detached modifier extension is found ([56e59da](https://github.com/nvim-neorg/neorg/commit/56e59daff56ba7f4d76b11ff3fc6dd70c4b54524))
* **makefile:** add `local-documentation` option ([ed20f79](https://github.com/nvim-neorg/neorg/commit/ed20f796f5bb337d230f5d33a3f6ba420a8d30a4))
* **qol.todo_items:** add new `create_todo_items` option ([d810aa4](https://github.com/nvim-neorg/neorg/commit/d810aa43c96301db35af351306eab54e35071d57))
* **qol.todo_items:** add new `create_todo_parents` option (false by default) ([6b6ef04](https://github.com/nvim-neorg/neorg/commit/6b6ef04e5fb0a5b1c3ff59699a9371afd659d9ff))
* **qol.todo_items:** when only done and uncertain items are present in ([1d6b0b0](https://github.com/nvim-neorg/neorg/commit/1d6b0b056b097e9f4bacf8877c49fdacbc445b2c))
* strip leading `--` from comments ([ecea630](https://github.com/nvim-neorg/neorg/commit/ecea6305a82007b6c8c509fd594f8b52c3331021))
* **summary:** implement `metadata` strategy and reimplement summary generation code ([f948288](https://github.com/nvim-neorg/neorg/commit/f9482881315d49d0a35206c7936a7f48c20dfcbf))
* **toc:** add `close_after_use` configuration option ([#785](https://github.com/nvim-neorg/neorg/issues/785)) ([e5d7fbb](https://github.com/nvim-neorg/neorg/commit/e5d7fbb0291e658f78545c29318c9162cf505d15))


### Bug Fixes

* `:Neorg journal today` would fail on alternative path separators ([#749](https://github.com/nvim-neorg/neorg/issues/749)) ([e7a5054](https://github.com/nvim-neorg/neorg/commit/e7a50542ad9921a8c7d652eeca6a9006cc024b79))
* **base.lua:** don't assign the `extension` flag to parent modules, only to the imports themselves ([fa5f561](https://github.com/nvim-neorg/neorg/commit/fa5f56163510eb00a0d75bec81d40d901c175d3b))
* **clipboard.code-blocks:** don't cut off characters from non-visual-line selection ([744ae49](https://github.com/nvim-neorg/neorg/commit/744ae49fe5fab9e54de96282778a202f85a2f37b))
* **code.looking-glass:** Use last attribute as start row of looking-glass (fix [#777](https://github.com/nvim-neorg/neorg/issues/777)) ([beef6fd](https://github.com/nvim-neorg/neorg/commit/beef6fd9420d6a798ddd796779b96f006b14ca12))
* **commands.return:** don't override the workspace to `default` after running `:Neorg return` ([169c7be](https://github.com/nvim-neorg/neorg/commit/169c7bee8a5f101c63c3a473a577dce079f7ddec))
* **concealer:** whenever running any scheduled command ensure that the buffer exists first ([b926416](https://github.com/nvim-neorg/neorg/commit/b9264161d0ef10ee61ace6ebeb0a55ca461b638a))
* **core.clipboard.code-blocks:** module would not work past version `1.0.0` ([ac88283](https://github.com/nvim-neorg/neorg/commit/ac8828369cb2a4b2e1e17e6b495645585ed2a37b))
* **core.clipboard.code-blocks:** visual selection would cut off one character too little ([87ed4bf](https://github.com/nvim-neorg/neorg/commit/87ed4bfde4a00a4cf4279298de02280bf11c7a74))
* **core.export.markdown:** Update markdown exporter for new todo syntax (fix [#757](https://github.com/nvim-neorg/neorg/issues/757)) ([336416f](https://github.com/nvim-neorg/neorg/commit/336416f6c41777a4025cc80b8a085e21e758931f))
* **core.itero:** preserve indentation on continued items ([92c31c4](https://github.com/nvim-neorg/neorg/commit/92c31c491caedd7d1a82b42d4ba6c2227c05d930))
* **core.norg.esupports.hop:** Make hop on anchors work again ([#756](https://github.com/nvim-neorg/neorg/issues/756)) ([d38a229](https://github.com/nvim-neorg/neorg/commit/d38a22940aaa55351cd4dc106540fa302fad4f0d))
* **core.norg.journal:** fixes [#736](https://github.com/nvim-neorg/neorg/issues/736) , now generates TOC correctly ([19c5558](https://github.com/nvim-neorg/neorg/commit/19c555836bc31f482e0ea42f08d150110754644f))
* **core.promo:** don't error when the concealer is not loaded ([#767](https://github.com/nvim-neorg/neorg/issues/767)) ([3e09f69](https://github.com/nvim-neorg/neorg/commit/3e09f698b8a4151f2b4f77ee917e4b54388bc97a))
* **dirman:** automatically create the index file if it exists when running `:Neorg index` ([7ce2db5](https://github.com/nvim-neorg/neorg/commit/7ce2db5d2eeec37b4a4c4bc43009c4741c3755da))
* **dirman:** corrected win width and height calculation ([9766bef](https://github.com/nvim-neorg/neorg/commit/9766bef893ec993af9408ea0d44a8f13adbd1e80))
* **dirman:** don't create `index.norg` files in the default workspace when running `:Neorg index` ([c60747f](https://github.com/nvim-neorg/neorg/commit/c60747fcc567d7eb50b16c2007bcfd3a81a934d1))
* **docgen:** `&lt;h6&gt;` tags not being rendered properly ([d0a0da0](https://github.com/nvim-neorg/neorg/commit/d0a0da017135b48c5f4a325bfaedbcdf1ca79fe3))
* **docgen:** could not find module `neorg` ([b68a945](https://github.com/nvim-neorg/neorg/commit/b68a945d6b1a8c2f8c57e0c366f224a162f391e3))
* **docgen:** display listed modules in alphabetical order ([264b451](https://github.com/nvim-neorg/neorg/commit/264b451d74d3e4bc3f856d087070b9dac46f8e90))
* **docgen:** don't double-render numeric values ([35df191](https://github.com/nvim-neorg/neorg/commit/35df1918de321617972f10edd88d9c32cc8102a2))
* **docgen:** don't render description tags if no description is present ([64dc28d](https://github.com/nvim-neorg/neorg/commit/64dc28deea9a7f9c52c3ba5343f1ce3c754a566e))
* **docgen:** don't unnecessarily copy parsers ([46e7936](https://github.com/nvim-neorg/neorg/commit/46e79366775136592540fbe5f0532c001012daa5))
* **docgen:** incorrect wiki paths ([2dbead6](https://github.com/nvim-neorg/neorg/commit/2dbead687053610147161ecda1a908070720731f))
* **docgen:** internal modules that were part of `core.defaults` would not be displayed in the developer modules section ([c3099eb](https://github.com/nvim-neorg/neorg/commit/c3099ebd595d3ec491613c297f4199e316f85853))
* **docgen:** list items with no summary would break rendering ([b69ea57](https://github.com/nvim-neorg/neorg/commit/b69ea57029a2c62e72ea86c93d295102059c58ab))
* **docgen:** lists within lists would never be rendered ([06894bb](https://github.com/nvim-neorg/neorg/commit/06894bb090ad6deb52ba7b19f7e13bbb41385a63))
* **docgen:** make the spacing nicer to look at ([426ca24](https://github.com/nvim-neorg/neorg/commit/426ca246e310a212cef5f6bba367d7ebc84bf70b))
* **docgen:** remove debug log ([8ffcaed](https://github.com/nvim-neorg/neorg/commit/8ffcaed1095743b8474a16f25855b809cf4fe65d))
* **docgen:** this should work now i think (after 20 tries) ([72d3d49](https://github.com/nvim-neorg/neorg/commit/72d3d4981d85fd1114d3185e40cc135a7892a4a4))
* **docgen:** use minimal_init.vim instead of custom_init.vim ([a7cb7ab](https://github.com/nvim-neorg/neorg/commit/a7cb7ab443c24fbd1d9f696abddd91c16f05d842))
* **docgen:** wrong `require` order in `docgen.lua` ([7494b51](https://github.com/nvim-neorg/neorg/commit/7494b51a61cc31371514cb7b2e1ccdf4cef164e2))
* finalize `version_in_code.yml` CI (it works yay) ([db9ed0b](https://github.com/nvim-neorg/neorg/commit/db9ed0b98ba30e2b783ea9da0fddda4cf6b2a47e))
* **metagen:** use `norg_version` ([a5c2553](https://github.com/nvim-neorg/neorg/commit/a5c25531de2790133310ad874fcbbb976d082c78))
* neovim 0.9 vim.treesitter.parse_query deprecation ([#784](https://github.com/nvim-neorg/neorg/issues/784)) ([f4a9759](https://github.com/nvim-neorg/neorg/commit/f4a9759e53fadaece9d93118a0471ddffd05d394))
* **qol.todo_item:** `&lt;C-space&gt;` would not create a new TODO item with ([fc45beb](https://github.com/nvim-neorg/neorg/commit/fc45bebde0fc9811ca4e770e2ba29c791035c885))
* **qol.todo_items:** `&lt;C-space&gt;` would not respect the `create_todo_items` option ([e764b92](https://github.com/nvim-neorg/neorg/commit/e764b92065ddd6bc206aaefd92837be8d0bd8419))
* **qol.todo_items:** TODO attributes would be erroneously assigned multiple times ([1303097](https://github.com/nvim-neorg/neorg/commit/13030974acee5a49dd02c51bedeac104b4f33cb7))
* **summary:** appropriately indent nested entries ([b725a58](https://github.com/nvim-neorg/neorg/commit/b725a58f25525efc1c39a13a09e6cec0c1c0ba4d))
* **version_in_code.yml:** perform checkout in the current directory ([3d7ad5a](https://github.com/nvim-neorg/neorg/commit/3d7ad5aa4b1277ea0f3ebb93ea79179eda5f6e27))
* **version_in_code.yml:** use `fetch-depth` of `0` ([2e8fa52](https://github.com/nvim-neorg/neorg/commit/2e8fa524d2cc73002378875970048d70ae70cc0b))


### Performance Improvements

* **concealer:** don't rerender the whole file on every single BufEnter ([7419cbb](https://github.com/nvim-neorg/neorg/commit/7419cbb7262200dd94df9d398ee1e7f5b9503a50))


### Miscellaneous Chores

* **docgen:** wipe whole wiki on every reparse ([09cb3e6](https://github.com/nvim-neorg/neorg/commit/09cb3e62022ff0f93965800a728ed698db540240))


### ref

* **Makefile:** remove `install_pre_commit` target ([9a497f5](https://github.com/nvim-neorg/neorg/commit/9a497f5e8195e5b974d520f937a946cb8819f320))
* move `core.norg.dirman.summary` -&gt; `core.summary` ([254b6a6](https://github.com/nvim-neorg/neorg/commit/254b6a60b6c9f845400d2bcb0728ee7f38823781))
* **summary:** refactor of the `core.norg.dirman.summary` module ([a2fe3ee](https://github.com/nvim-neorg/neorg/commit/a2fe3eea24c628fa15b7f854cef6c7acaf9ec3f9))


### Code Refactoring

* move all `core.norg.*` modules into `core.*` ([a5824ed](https://github.com/nvim-neorg/neorg/commit/a5824edf6893b8602e560ed7675c0d4174e263e4))

## [2.0.1](https://github.com/nvim-neorg/neorg/compare/v2.0.0...v2.0.1) (2023-02-02)


### Bug Fixes

* completion for TODO items ([#711](https://github.com/nvim-neorg/neorg/issues/711)) ([9184027](https://github.com/nvim-neorg/neorg/commit/91840274112f1286ff5f4063ac6f515683b6dc67))
* **core.norg.journal:** add proper error handling for `vim.loop.fs_scandir` ([4a9a5fe](https://github.com/nvim-neorg/neorg/commit/4a9a5fe13cd454692fc4db0b27783cd005e6be56))
* **treesitter:** don't constantly log errors about erroneous document syntax trees ([9f8b0a1](https://github.com/nvim-neorg/neorg/commit/9f8b0a1759d883fae901579ea83b3ffbfc81a53b))

## [2.0.0](https://github.com/nvim-neorg/neorg/compare/v1.1.1...v2.0.0) (2023-01-06)


### ⚠ BREAKING CHANGES

* **core.norg.qol.toc:** rewrite the table of contents implementation

### Features

* **core.export:** add `NeorgExportComplete` user autocommand ([8b10e61](https://github.com/nvim-neorg/neorg/commit/8b10e61d2f2c5e626849f9a6f8cb4399c28a1a47))
* **core.norg.qol.toc:** add multiple buffer handling logic ([467e311](https://github.com/nvim-neorg/neorg/commit/467e3113c32b8b9f1950a9425aa7b74c13cd88b8))
* **core.norg.qol.toc:** implement `qflist` generation option ([77c5149](https://github.com/nvim-neorg/neorg/commit/77c514970a9d4648b05b2334a060263666f588e2))
* **treesitter:** add `execute_query` function ([310ebaa](https://github.com/nvim-neorg/neorg/commit/310ebaaef538dfd41d02a2903663be05fd38834b))


### Bug Fixes

* **core.ui:** do not modify the user's `scrolloffset` ([bd2e58c](https://github.com/nvim-neorg/neorg/commit/bd2e58cf6f9d42527aa2b692fb187eafa82bd91e))


### Performance Improvements

* further optimize `toc` infirm tag grabber ([5e8d059](https://github.com/nvim-neorg/neorg/commit/5e8d05968e04f7945576d50a6b1576cc722f96fc))
* optimize the `toc` infirm tag grabber code ([a41bd4a](https://github.com/nvim-neorg/neorg/commit/a41bd4a92afefb7e2630b821b59f7707a054baac))


### ref

* **core.norg.qol.toc:** rewrite the table of contents implementation ([c0104fb](https://github.com/nvim-neorg/neorg/commit/c0104fb9faed3b3213e4e275a55a522a299a2d0e))

## [1.1.1](https://github.com/nvim-neorg/neorg/compare/v1.1.0...v1.1.1) (2023-01-05)


### Bug Fixes

* **core.export:** incorrect exporting of code blocks with no parameters ([#701](https://github.com/nvim-neorg/neorg/issues/701)) ([0922815](https://github.com/nvim-neorg/neorg/commit/0922815837a374bd0b2a3cf0477b54e6668e133d))

## [1.1.0](https://github.com/nvim-neorg/neorg/compare/v1.0.1...v1.1.0) (2023-01-05)


### Features

* keep checkboxes with `core.itero` ([#663](https://github.com/nvim-neorg/neorg/issues/663)) ([00532bd](https://github.com/nvim-neorg/neorg/commit/00532bd997d2aef0384ed8f11500d33d229a7e53))


### Bug Fixes

* **core.export.markdown:** incorrectly exported code blocks ([dd2750c](https://github.com/nvim-neorg/neorg/commit/dd2750c0e4d847b67a6ead79ff5043e671cac8bd))
* **folds:** correctly fold document metadata ([adc000a](https://github.com/nvim-neorg/neorg/commit/adc000aadd41e68e4de8a2d1bb90b2e910ffef1b))

## [1.0.1](https://github.com/nvim-neorg/neorg/compare/1.0.0...v1.0.1) (2022-12-23)


### Bug Fixes

* **core.looking-glass:** buffer being closed for no reason after leaving buffer ([828a37f](https://github.com/nvim-neorg/neorg/commit/828a37fe1f008dbfd70cd7fc0f7ba9d0bc75da2a))
* do not run tests for nightly/neorg-main, as GTD is no longer existent ([37f1f9a](https://github.com/nvim-neorg/neorg/commit/37f1f9a44ba65603b5992fc36761c61d921fab78))
