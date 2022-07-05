# Onigumo #

## About ##

Onigumo je web-crawler.

Onigumo "prolézá" webové stránky či aplikace. Jejich obsah a případná metadata uloží do strukturované podoby, která je vhodná pro další strojové zpracování.

## Architecture ##

Onigumo je rozděleno do tří na sebe vzájemně navazujících částí:

* operator - řízení
* downloader - stahování dat
* parser - zpracování dat

Diagram níže, znázorňuje vzájemnou součinnost těchto celků:

```mermaid
flowchart LR
    START             -->           operator(OPERATOR)
    operator    -- urls.txt --->    downloader(DOWNLOADER)
    downloader  -- *.html --->      parser(PARSER)
    parser      -- *.JSON -->       operator
    operator           -->          MATERIALIZATION
```

### Operator ###

Operator vytváří frontu URL adres určených ke stažení pro _downloader_. Počáteční fronta je Onigumu předaná pluginem. O doplňování nových URL adres se následně už stará plugin. Nové URL adresy plugin získává z naparsované podoby dat, kterou vytváří _parser_.

Činnost _operatoru_ se skládá z:

1. inicializace práce Oniguma na dané aplikaci
2. kontroly stavu zpracovaných a nezpracovaných URL adres z výstupu
_operatoru_, popř. dle zapsaných souborů
3. načítání nezpracovaných URL adres ze strukturovaných dat stažené stránky
4. zařazování nezpracovaných URL adres do fronty pro _downloader_
5. mazání URL adres z fronty od _parseru_ po předání všech nových stránek
v jejím obsahu do fronty pro _downloader_

### Downloader ###

Downloader stahuje obsah a metadata nezpracovaných URL adres.

Činnost _downloaderu_ se skládá z:

1. načítání URL adres ke stažení z fronty
2. stahování obsahu URL adres a případných metadat
4. vytváření fronty stažených URL adres včetně jejich obsahu a metadat
3. mazání zpracovaných URL adres z fronty

### Parser ###

Parsuje potřebná data ze staženého obsahu a metadat do strukturované podoby.

Činnost _parseru_ se skládá z:

1. kontroly stavu fronty se staženými URL adresami
2. parsovat obsah a metadata stažených URL adres do strukturované podoby dat
3. strukturovaná data ukládat do JSON souborů, jejichž jména jsou tvořena
hashem z jejich URL adres
4. aktivace pluginu na strukturovaná data
5. mazat URL adresy z fronty stažených URL adres

#### Aplikace (neboli pavouci) ####

Ze strukturované podoby dat uložené ve formátu JSON, vyscrapuje potřebné informace.

Charakter výstupních dat či informací je závislý na uživatelských potřebách a také podoby internetového obsahu. Je téměř nemožné vytvořit univerzálního pavouka splňujícího všechny požadavky z kombinace obou výše zmíněných. Z tohoto důvodu je možné si nadefinovat vlastní plugin.

## Usage ##

## Credits ##

© Glutexo 2019

Licenced under the MIT license
