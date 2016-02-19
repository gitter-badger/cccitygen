
# cccitygen

[![Join the chat at https://gitter.im/viluon/cccitygen](https://badges.gitter.im/viluon/cccitygen.svg)](https://gitter.im/viluon/cccitygen?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
ComputerCraft Procedural City Generation Framework - taking city generation with command computers to the next level.

[![GitHub issues](https://img.shields.io/github/issues/viluon/cccitygen.svg)](https://github.com/viluon/cccitygen/issues)
[![Maintenance](https://img.shields.io/maintenance/yes!/2016.svg)](https://github.com/viluon/cccitygen/commits/master)
[![GitHub license](https://img.shields.io/github/license/viluon/cccitygen.svg)](./LICENSE.md)

This project aims at providing a solid, object-oriented base for procedural city generation in Minecraft. Rather than being a single script (as most of other city generators out there), CCCG mirrors the hierarchy of real world cities in OOP, from districts down to furniture in individual rooms, and uses this pattern to rebuild these structures in Minecraft worlds, procedurally. Apart from being a framework, it also includes example city generation scripts and working assets that can be used freely in any other project (open source FTW! All contents of this repository are licensed under the terms of the GPL v3.0 license).

## WIP Notice
> CCCG is still quite young, most of the planned features are missing! I am working hard on bringing it into a usable state, but that will take quite some time. Once the repo hits the first pre-release (0.1) I'll switch to a [nicer development flow](http://nvie.com/posts/a-successful-git-branching-model/), but for now all commits are dumped straight to `master`.

~ [@viluon](https://github.com/viluon)

## Features
A list of working features implemented to date.
* **Block**
	* Supports full NBT data
	* Separate ID and block value fields
	* `solid` field for distinction between solid and non-solid blocks
* **Point3D**
	* Simply stores 3 values, x, y, z
	* Has overloads for adding Point3Ds or numbers to `self`
* **Grid3D**
	* Stores essentially any data in an array of arrays of arrays (3D)
	* `size` and `origin` fields
	* Can be (un)serialized to/from a file
	* Methods for converting coordinates from global to local and vice versa
	* `Grid3D:iter()` iterates over all elements
	* Constructor automagically fills up the mesh with a `fill` function
* **Structure**
	* Extends Grid3D
	* `Structure:build()` iterates over Grid3D data and places all Blocks encountered
* **Room**
	* Implements IHasChildren
		* Support for any children that have the `:build()` method implemented
	* So far only supports exactly 4 Walls, Walls can be theoretically empty though
	* Ceiling and floor, handled differently than Walls but are in fact instances of Wall
* **Material**
	* Pose as shaders for Rooms (Buildings, Walls, Windows, essentially anything that is made of Blocks)
	* Dynamic values with the Mutator class
* **Mutator**
	* Can affect a Block depending on its relative position
	* Simply pass a function accepting `block, x, y, z` to the constructor to create a Mutator
	* Mutators can be chained (using one Mutator at the beginning of the chain will return a result that passed through the whole chain)
* **MaterialPalette**
	* A palette of Materials for Rooms to pick Materials from
	* Shortcut methods to add Mutators to all Materials in a subpalette


## Credits
Thanks to [@Exerro](https://github.com/Exerro) for his *amazing* class library.
