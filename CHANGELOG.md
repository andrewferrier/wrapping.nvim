# Changelog

## [2.1.1](https://github.com/andrewferrier/wrapping.nvim/compare/v2.1.0...v2.1.1) (2026-01-24)


### Bug Fixes

* Handle no UIs attached ([1cd42a9](https://github.com/andrewferrier/wrapping.nvim/commit/1cd42a960abf82f04e104125c6bfa7f145e0aef4))

## [2.1.0](https://github.com/andrewferrier/wrapping.nvim/compare/v2.0.0...v2.1.0) (2026-01-24)


### Features

* log pid - closes [#55](https://github.com/andrewferrier/wrapping.nvim/issues/55) ([c704bc0](https://github.com/andrewferrier/wrapping.nvim/commit/c704bc052217b0abd5b883437c81a74d3ea43add))


### Bug Fixes

* line2byte() to get buf size faster ([5307e29](https://github.com/andrewferrier/wrapping.nvim/commit/5307e291a8b33592bf3ef2f26beaa894fc42f3e4))
* Remove math.max() as discussed ([506aa2a](https://github.com/andrewferrier/wrapping.nvim/commit/506aa2a55232025e1a5c89a3000913f11419472d))

## [2.0.0](https://github.com/andrewferrier/wrapping.nvim/compare/v1.2.0...v2.0.0) (2025-09-07)


### ⚠ BREAKING CHANGES

* No longer support NeoVim 0.8 as nvim-treesitter no longer supports it

### Features

* Add lazy spec - closes [#46](https://github.com/andrewferrier/wrapping.nvim/issues/46) ([67f93f2](https://github.com/andrewferrier/wrapping.nvim/commit/67f93f2fd12ce58d202815223223863518f02df9))


### Bug Fixes

* definitionProvider no longer implies non-textual - closes [#49](https://github.com/andrewferrier/wrapping.nvim/issues/49) ([d7c6854](https://github.com/andrewferrier/wrapping.nvim/commit/d7c68548fe23eb95dde28cbd9539b6325cd0bde9))
* No longer support NeoVim 0.8 as nvim-treesitter no longer supports it ([79e0a87](https://github.com/andrewferrier/wrapping.nvim/commit/79e0a8755577f702b2cc9cac1a28d23b6b56a67b))
* Support minimum NeoVim 0.10 ([c0cf84e](https://github.com/andrewferrier/wrapping.nvim/commit/c0cf84eec9169d271eba758c4b442694cd526d3a))

## [1.2.0](https://github.com/andrewferrier/wrapping.nvim/compare/v1.1.0...v1.2.0) (2024-05-25)


### Features

* Support a buftype_allowlist ([4c87a23](https://github.com/andrewferrier/wrapping.nvim/commit/4c87a23f6ae11c0ddc1a93405d0e62c1a5f198c4))


### Bug Fixes

* Stop using deprecated buf_get_clients ([8b1a814](https://github.com/andrewferrier/wrapping.nvim/commit/8b1a814522e89dcc24abf81922f4898e63817e02))
* Stop using deprecated nvim_get_option ([d202b8f](https://github.com/andrewferrier/wrapping.nvim/commit/d202b8faa8c596f9ddd83a055cd1a6c23cb6c006))
* Support OptionSet as an event ([2491326](https://github.com/andrewferrier/wrapping.nvim/commit/24913268b7f8fd83309a528c424b96ef48a40726))
* Wrap get_parser with a pcall ([eb62d18](https://github.com/andrewferrier/wrapping.nvim/commit/eb62d1816e66494d9fceb8619203eaf5985f17cb))

## [1.1.0](https://github.com/andrewferrier/wrapping.nvim/compare/v1.0.0...v1.1.0) (2024-02-25)


### Features

* Add support for `typst` files - closes [#42](https://github.com/andrewferrier/wrapping.nvim/issues/42) ([6d7df51](https://github.com/andrewferrier/wrapping.nvim/commit/6d7df512c89343b72643b1290068b95cb94201da))
* Ensure appropriate keymaps are unique ([748449b](https://github.com/andrewferrier/wrapping.nvim/commit/748449bb188bf0ceb5592f4cbb8ae744ee2bab83))
* Make 'help' a whitelisted filetype - closes [#28](https://github.com/andrewferrier/wrapping.nvim/issues/28) ([8a0e4ec](https://github.com/andrewferrier/wrapping.nvim/commit/8a0e4ec5b35871360d90daa0aabfa22114187142))

## 1.0.0 (2023-05-28)


### ⚠ BREAKING CHANGES

* Require NeoVim 0.8+

### Features

* Add additional markdown query ([48895fe](https://github.com/andrewferrier/wrapping.nvim/commit/48895fe61403070a403b2c969f8c75d94f219e5b))
* Add descriptions to commands ([4a55a2b](https://github.com/andrewferrier/wrapping.nvim/commit/4a55a2b63f2fd761c438d779c814e3b2b2763389))
* Add descriptions to keymaps ([ac85a98](https://github.com/andrewferrier/wrapping.nvim/commit/ac85a982d60e994438827b69a97818f56d5bf7fd))
* Add heuristic for checking LSP ([cbb0226](https://github.com/andrewferrier/wrapping.nvim/commit/cbb02268ba108d8693d0c8ac6163fd65882f9899))
* Add logging ([91b0ff2](https://github.com/andrewferrier/wrapping.nvim/commit/91b0ff22fcfc3fdebc34cc6fbf28e0428d7f2b23))
* Add optional notifications ([3cc3fa4](https://github.com/andrewferrier/wrapping.nvim/commit/3cc3fa4f0977de28b7a6d7acbda9d612f92475dc))
* Add pipe tables to excluded - closes [#25](https://github.com/andrewferrier/wrapping.nvim/issues/25) ([67c9c61](https://github.com/andrewferrier/wrapping.nvim/commit/67c9c61c0643b6c6f298ea51c25b4ca015ed943c))
* Add reStructuredText (rst) - closes [#23](https://github.com/andrewferrier/wrapping.nvim/issues/23) ([6fc3d6a](https://github.com/andrewferrier/wrapping.nvim/commit/6fc3d6aae57133462b7a6300bb9afe20fec40c57))
* Add sensible default for gitcommit ([e99bb6e](https://github.com/andrewferrier/wrapping.nvim/commit/e99bb6eec7cd3f8beb7a9bb8ac2a344edac48b18))
* Add support for latex ([df8b719](https://github.com/andrewferrier/wrapping.nvim/commit/df8b71991ec8aa5a27497e16c7b47138a439b524))
* Allow softener to be true/false ([2d1a8ce](https://github.com/andrewferrier/wrapping.nvim/commit/2d1a8ce77e7f8e05eb2d8142aa15bb70b091e2a9))
* Allow softener values to be funcs ([052b5bc](https://github.com/andrewferrier/wrapping.nvim/commit/052b5bc610beabb17988bc9463e73f9781af2f8f))
* Check textwidth local ~= global ([1067bfd](https://github.com/andrewferrier/wrapping.nvim/commit/1067bfdbaa5906c4424c425bd2097a825a1a0ce5))
* Different softener values per-filetype ([d4d0e52](https://github.com/andrewferrier/wrapping.nvim/commit/d4d0e523e9fdc444a2cf7f59122b90d584d78284))
* Enable gitlint ([ef9b977](https://github.com/andrewferrier/wrapping.nvim/commit/ef9b97701f96af4ef36b9f5f0bda49d7e7a24b5e))
* Exclude code blocks in markdown ([5f786df](https://github.com/andrewferrier/wrapping.nvim/commit/5f786df712ef302b9031ac5d1c8be27ca72abe34))
* Have heuristic look at textwidth ([fba5251](https://github.com/andrewferrier/wrapping.nvim/commit/fba5251d6e26633c08a88384df40c036c14f4442))
* Log exclusions ([5ed7904](https://github.com/andrewferrier/wrapping.nvim/commit/5ed790467b705a383e156bb1006320485084aa52))
* Log options being used ([b1b764f](https://github.com/andrewferrier/wrapping.nvim/commit/b1b764f2f0ab0af40d4c028ae3263f89729cb103))
* Option for auto-heuristic detection ([2cf07c7](https://github.com/andrewferrier/wrapping.nvim/commit/2cf07c74ed40ce7711926157edc080b339bc7d37))
* Provide control over set_nvim_opt_defaults ([12f96e6](https://github.com/andrewferrier/wrapping.nvim/commit/12f96e63b9e42280b3c1318f835d4b1841a15583))
* Support allow/denylist ([28c76f8](https://github.com/andrewferrier/wrapping.nvim/commit/28c76f8ac8840f2371da8c8cc7e9894a6988e157))
* Tweaks to README and expose toggle_wrap_mode() ([61fb181](https://github.com/andrewferrier/wrapping.nvim/commit/61fb1812f685473e4b1440dc7e40309ab2ac550f))
* Use BufWinEnter so modelines can be processed ([47cbe5b](https://github.com/andrewferrier/wrapping.nvim/commit/47cbe5b51d45874b5bb53b925b60d7e86c6ec577))


### Bug Fixes

* 0.7.2 cannot use log stdpath ([169209a](https://github.com/andrewferrier/wrapping.nvim/commit/169209aedd05f9cd3a02e95b8fea1b5c3631fa9e))
* Add placeholder empty file ([7d2cb5e](https://github.com/andrewferrier/wrapping.nvim/commit/7d2cb5ea1e04a5b8c69c57e9e35f83e4fbd38d08))
* Branch name ([282044f](https://github.com/andrewferrier/wrapping.nvim/commit/282044f9feeb22e8ab4087f6cfab0abc0076630e))
* Check softener value first for consistency ([7d2c26e](https://github.com/andrewferrier/wrapping.nvim/commit/7d2c26e40e21aa557929f1ed6ef42ebc89ea7df5))
* Correct buf-&gt;win for 'wrap' option ([ccf12ee](https://github.com/andrewferrier/wrapping.nvim/commit/ccf12ee731aa9155bcada913534b34c781e0f629))
* Correct project name ([212114f](https://github.com/andrewferrier/wrapping.nvim/commit/212114f23d69bea19426a19593866c2cead7b5d5))
* Don't handle non-real buffers ([f16f95c](https://github.com/andrewferrier/wrapping.nvim/commit/f16f95cac51f1074bb1be47bb27d4e84094d9a2e))
* Ensure test resets wrapping mode ([4f2a623](https://github.com/andrewferrier/wrapping.nvim/commit/4f2a6233fe0d1a0ed5fbbaa54405115d80593c0d))
* Handle 0 textwidth better ([5b16e3d](https://github.com/andrewferrier/wrapping.nvim/commit/5b16e3d445c8c3c51e92b1c3d18edced7497c110))
* Handle deprecated parse_query ([d14af05](https://github.com/andrewferrier/wrapping.nvim/commit/d14af05b9ae6776adfc31fad84d8708795404e13))
* Handle wrapping.nvim already active ([00d8fad](https://github.com/andrewferrier/wrapping.nvim/commit/00d8fadb1a1a6ac9bc3fe23dbaa593eafbfebc4c))
* Hide spell/diagnostics ([02ffb86](https://github.com/andrewferrier/wrapping.nvim/commit/02ffb86026d18676c282e9db4a0f9ad31022c739))
* If likely nontextual, we should not set mode ([494b0c6](https://github.com/andrewferrier/wrapping.nvim/commit/494b0c69015bb6808418b4d8ef03890f74e1db78))
* Ignore any generated tags ([a438c24](https://github.com/andrewferrier/wrapping.nvim/commit/a438c24c2fd566e02c3699faaed2abbd6903edc2))
* Make 'return false' explicit ([e7c3bf1](https://github.com/andrewferrier/wrapping.nvim/commit/e7c3bf179826cfd41743ca5c61830ef88542b7ee))
* Make linebreak/wrap true defaults ([dd88c97](https://github.com/andrewferrier/wrapping.nvim/commit/dd88c97dfdb8ecf72ce05b01d4865374fc9a8ac4))
* Names of branches ([b3604ff](https://github.com/andrewferrier/wrapping.nvim/commit/b3604ff9bbd767c71ff72a93b01ce2d88e962d64))
* No default mode ([0923333](https://github.com/andrewferrier/wrapping.nvim/commit/0923333855c3067dcdfc9612503dc5745c011a0d))
* Passive voice ([e9c43cc](https://github.com/andrewferrier/wrapping.nvim/commit/e9c43cc2f9f4590293b44263441eadb9cafb66b0))
* Require NeoVim 0.8+ ([36d7044](https://github.com/andrewferrier/wrapping.nvim/commit/36d704438fd2316735c239df87cc0f20199584b3))
* Return immediately ([23eb73d](https://github.com/andrewferrier/wrapping.nvim/commit/23eb73dc925f713961d13f5389cb0e78b56ec566))
* Support other versions, add treesitter ([0ff46c8](https://github.com/andrewferrier/wrapping.nvim/commit/0ff46c84a73371b588e720850dffce26111bcf9b))
* Try not doing ln ([45d7189](https://github.com/andrewferrier/wrapping.nvim/commit/45d718943ed07232a95692c2aae5b862d7c0e53a))
* Try running tests directly ([b562fc8](https://github.com/andrewferrier/wrapping.nvim/commit/b562fc852f6708754d63958a1425f4087db3ce98))
* Try to fix video ([8bc4e41](https://github.com/andrewferrier/wrapping.nvim/commit/8bc4e410a2485f23754cd2d0072f7a5fdd242651))
* Use API functions to count blank lines ([81c2e1c](https://github.com/andrewferrier/wrapping.nvim/commit/81c2e1cfb1dbf2ba2ce725456d850fc943c059a5))
* Use logic to calculate size of buffer ([7198419](https://github.com/andrewferrier/wrapping.nvim/commit/71984195d30364c2af2c78ec7618798fd2ab2a42))
* Version of stylua action ([5cffca9](https://github.com/andrewferrier/wrapping.nvim/commit/5cffca97db8edd0509205ef41707509b9e648fe3))
