# Onigumo #

## About ##

This is an attempt to build just another web-crawler, also called _Spider_. Its purpose is to get data from a website in a form of a list of objects. This data can be then used to download linked files and place them in a database or a folder structure.

## Architecture ##

### Building blocks ###

The application uses Spiders (Ruby modules) representing a website. A Spider’s public interface consists of hunting strategies (Ruby public methods) containing logic how to get all the wanted data from the server. Typically get a page, parse it and possibly get more pages using the parsed data. A Spider can have more hunting strategies.

Inside the module, a Spider has Flies (Ruby classes) representing an entity a can catch and suck data out of it. This is typically a webpage residing on some URI. A Fly describes how to buld the URI and suck the data from the loaded page. A Fly can have more Bowels (Ruby methods) providing different data.

### Mechanism ###

Initiating a hunting strategy puts events on the queue describing what Fly to catch and what Bowels to suck and what to to with the result. This event has no addintional information.

A spider is wating on the queue. If there is an event containing a Fly, it catches it, sucks outs its Bowels and launches a defined action upon the data.

When a Spider catches a Fly and feed itself on it, it yields the parsed data that can be associated with a following fly. 

## Usage ##

## Credits ##

© Glutexo 2019

Licenced under the MIT license
