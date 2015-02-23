# Weather APP - Exercise
A small weather app in `ObjC`, iOS8+, is an exercise to work with some different data sources, blocks, async, Storyboards, effects and custom transitions.

## Features
* UI prototyping via Storyboards.
* Blur effects.
* Vibrancy effects.
* Random images from [Flickr](https://www.flickr.com/services/api/).
* Custom bouncy transition.
* Async requests with blocks.
* Retrieves weather data from [OpenWeatherMap](http://openweathermap.org/).
* Get current location via Core Location.
* Auto Layout.
* CocoaPods.
* Environment configurations.
* Unit Tests.

## Setup
First, install some utilities that I made, they are added as a `git submodules`.

	$ git submodule init
	$ git submodule update
	
Configure [JIMEnvironments](https://github.com/nebiros/JIMEnvironments)'s `Environments.plist` file. There's a `Environments.dist.plist` with the keys required.

CocoaPods are include inside the repository so you don't need to install those.

## Run
Open `WeatherAppExercise.xcworkspace` and enjoy it!.
