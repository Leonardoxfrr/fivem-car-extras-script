# FiveM Car Extras

Kleine ESX-Ressource zum Ein- und Ausschalten von Fahrzeug-Extras über ein NativeUI-Menü. Das Menü steht nur dem Fahrer des aktuellen Fahrzeugs zur Verfügung.

## Funktionen

- Öffnen des Menüs mit `F11` (`Config.OpenKey = 344`)
- Erkennung der Extras `0` bis `20` am aktuellen Fahrzeug
- Umschalten vorhandener Extras über NativeUI
- Beschränkung auf den Fahrersitz

Die Änderungen werden ausschließlich clientseitig am aktuellen Fahrzeug gesetzt. Es gibt keine Datenbank und keine dauerhafte Speicherung nach Respawn oder Neustart.

## Voraussetzungen

- FiveM/FXServer
- ESX
- NativeUI als gestartete Ressource

## Installation

1. Repository als Ordner `fivem-car-extras-script` in `resources` ablegen.
2. Prüfen, ob die in `fxmanifest.lua` referenzierten ESX- und NativeUI-Dateien zu den installierten Versionen passen.
3. Ressourcen in der richtigen Reihenfolge starten:

```cfg
ensure es_extended
ensure NativeUI
ensure fivem-car-extras-script
```

4. Als Fahrer in ein Fahrzeug mit konfigurierten Extras einsteigen und `F11` drücken.

## Konfiguration

Der Öffnungsknopf wird in `config.lua` als FiveM-Control-ID definiert. Für andere Tasten muss die entsprechende Control-ID eingetragen werden.

## Technische Hinweise

- Extras werden mit den GTA/FiveM-Natives für `DoesExtraExist` und `SetVehicleExtra` verarbeitet.
- Der vorhandene Serverteil enthält aktuell keine Geschäftslogik.
- Netzwerkverhalten und Besitzrechte des Fahrzeugs werden nicht serverseitig geprüft.
- Für dauerhafte Zustände wäre eine serverseitig validierte Speicherung pro Fahrzeugkennzeichen erforderlich.

## Status

Die Kernfunktion ist klein, der Bestand sollte aber vor produktiver Nutzung mit der konkreten ESX- und NativeUI-Version getestet werden. Insbesondere sind Synchronisierung, Berechtigungen und Persistenz nicht Bestandteil dieses Projekts.
