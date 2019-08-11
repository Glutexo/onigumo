# Onigumo #

## About ##

This is an attempt to build just another web-crawler, also called _Spider_. Its purpose is to get data from a website in a form of a list of objects. This data can be then used to download linked files and place them in a database or a folder structure.

## Architecture ##

### Building blocks ###

The application uses Spiders (Ruby modules) containing workflow and data-mining methods to get data from a website. A Spider’s public interface consists of workflows how to get all the wanted data from the server. Typically get a page, parse it and possibly get more pages using the parsed data.

### Mechanism ###

Scraping starts by inserting the first workflow action on a queue. This action doesn’t take any input an thus doesn’t have to wait for any data to be parsed. Any action can queue another action that uses the data parsed from a download page. Downloading and parsing ends when there is no more actions to be launched.

## Usage ##

## Credits ##

© Glutexo 2019

Licenced under the MIT license
