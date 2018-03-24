All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [unreleased]

### Added

* Tie in Travis-CI for testing.
* New `bin/release` script to make sure tests are ran before release.

### Fixed

* Include comments immediately following a method definition when auto-correcting.
* Correct source range calculation if looping over start or end of file.

## [0.2.1] - 2018-03-22

### Fixed

* Fix bug when trying to work with last method in file if there is no blank
  ending line in the file.

## [0.2.0] - 2018-03-22

### Fixed

* Autocorrect of method order would not replace all incorrectly ordered nodes in
  certain combinations.

## [0.1.0] - 2018-03-21

### Added

* Initial version of the extension.

[unreleased]: https://github.com/CoffeeAndCode/rubocop_method_order/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/CoffeeAndCode/rubocop_method_order/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/CoffeeAndCode/rubocop_method_order/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/CoffeeAndCode/rubocop_method_order/releases/tag/v0.1.0
