# Bygg & anlegg tilpasninger for Prosjektportalen

NB: Bygg & anlegg tilpasningene er i en test-fase og det gjenstår fortsatt en del forankringsarbeid. Kom gjerne med innspill!

Bygg & anlegg tilpasninger for Prosjektportalen er to valgfrie tilleggspakker som installeres hver for seg på områdesamlinger hvor [Prosjektportalen](https://github.com/Puzzlepart/prosjektportalen) allerede er installert. Etter at tilpasningen er installert kan en opprette områder av type bygg eller anlegg avhengig av hvilken tilleggspakke som er installert på områdesamlingen. Hvert område er et eget område ganske lik et standard prosjektområde, men det har noen ulikheter

* Nytt og tilpasset standardinnhold (dokumenter, fasesjekkpunkter)
* Tilpassede prosjektegenskaper for bygg- og anleggsprosjekter
* Egne faser for prosjektgjennomføring

## Installering

Bygg & anlegg installeres på hver sin egen områdesamling over en Prosjektportalen-installasjon. Det blir altså en portefølje for bygg og en for anlegg, for eksempel https://tenant.sharepoint/sites/prosjektportalen-bygg eller https://tenant.sharepoint/sites/prosjektportalen-anlegg.

Bygg & anlegg tilpasninger for Prosjektportalen installeres med Powershell på følgende måte (eksempel med bygg-tilpasninger). Merk at [Prosjektportalen](https://github.com/Puzzlepart/prosjektportalen) må allerede være installert før dette gjøres.

```PowerShell
./Install.ps1 -Url https://puzzlepart.sharepoint.com/sites/bygg -ProjectType Bygg
```

## Kontakt

Har du spørsmål vedrørende Bygg & anlegg tilpasninger for Prosjektportalen, behov for bistand til installasjon av løsningen eller er interessert i muligheter for videreutvikling og spesialtilpasninger, ta kontakt med [prosjektportalen@puzzlepart.com](mailto:prosjektportalen@puzzlepart.com). Vi gjør oppmerksom på at eventuell bistand vil være en fakturerbar tjeneste.

## Maintainers

* [Tarjei Ormestøyl](tarjeieo@puzzlepart.com)
* [Thomas Granheim](thomasog@puzzlepart.com)
* [Ole Martin Pettersen](olemp@puzzlepart.com)