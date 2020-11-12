# Rozšírenie SNMP agenta
Autor: Marek Žiška (xziska03)
E-mail: xziska03@stud.fit.vutbr.cz
Dátum: 18.11.2020

## Popis projektu:
------------------
Úlohou projektu bolo vytvorenie vlastného MIB modulu a dynamicky načítateľného rozšírenia SNMP agenta net-snmp. MIB modul je zaregistrovaný pod .1.3.6.1.3(iso.org.dod.internet.experimental), s vlastným číslom 22. MIB modul bol rožšírený o 4 moduly: 
 -    Read-only string s Vaším loginom (.1.3.6.1.3.22.1)
 -    Read-only string, ktorý vráti aktuálny čas naformátovaný podľa RFC 3339 (.1.3.6.1.3.22.2)
 -    Read/write Int32 (.1.3.6.1.3.22.3)
 -    Read-only premennú Vašej voľby, ktorá bude obsahovať nejakú informáciu o systéme (operačný systém, množstvo RAM, ...) (.1.3.6.1.3.22.4)
Modul agenta využívajúci túto MIB bude samostatný binárny súbor, ktorý bude možno dynamicky načítať do bežiaceho agenta (t.j. nie subagent komunikujúci cez IPC).
Priklady
```    
snmpget localhost ISA-SNMP-MIB::IsaLOGIN.0
```

## Priklad vytvorenia kostry:
------------------
```
//skopírovanie MIB modulu do zložky mibs
sudo cp ISA-SNMP-MIB.txt /usr/share/snmp/mibs/
//nastavenie premennej prostredia MIBS, aby sme zaistili že nástroje používajúce možu nájsť  a načítať náš MIB modul. (https://docs.oracle.com/cd/E19253-01/817-3155/writingmodule-33sm/index.html)
export MIBS="+ISA-SNMP-MIB"
// vygenerovanie kostry pomocou mib2c
mib2c -c mib2c.scalar.conf IsaSNMPMIB
```

## Priklad spustenia agenta:
------------------
```
sudo snmpd -f -L -DIsaSNMPMIB,dlmod
```

## Nastavenie dlmod tabulky
```
snmpset localhost UCD-DLMOD-MIB::dlmodStatus.1 i create

snmptable localhost UCD-DLMOD-MIB::dlmodTable 

snmpset localhost UCD-DLMOD-MIB::dlmodName.1 s IsaSNMPMIB UCD-DLMOD-MIB::dlmodPath.1 s /path/to/IsaSNMPMIB.so

snmptable localhost UCD-DLMOD-MIB::dlmodTable 

snmpset localhost UCD-DLMOD-MIB::dlmodStatus.1 i load 

snmptable localhost UCD-DLMOD-MIB::dlmodTable 

```

## Priklad požiadaviek na vytvorené objekty
-------------------------
```
snmpget localhost ISA-SNMP-MIB::IsaLOGIN.0

snmpget localhost ISA-SNMP-MIB::IsaTIME.0

snmpset localhost ISA-SNMP-MIB::IsaINT.0 i 999

snmpset localhost ISA-SNMP-MIB::IsaINT.0 i 999

snmpget localhost ISA-SNMP-MIB::IsaOSINFO.0
```

## Zoznam odovzdaných súborov:
---------------------------
IsaSNMPMIB.c
IsaSNMPMIB.h
ISA-SNMP-MIB.txt
Makefile
manual.pdf
Readme
