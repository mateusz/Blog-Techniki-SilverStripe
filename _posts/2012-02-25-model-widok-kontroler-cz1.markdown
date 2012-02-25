---
layout: post
title: Model, widok, kontroler część 1
description: Opis wzorca model, widok, kontroler.
---

Ze wzorcem projektowym "model, widok, kontroler" (ang. *model, view, controller*, MVC) warto się zapoznać, gdyż w świecie SilverStripe bez wiedzy o nim trudno będzie pisać aplikacje ze zrozumieniem.

Wzorzec MVC to sposób na podział programu na logiczne warstwy. Nie dotyczy on tylko aplikacji internetowych - może znaleźć zastosowanie również na desktopie, a nawet w programach terminalowych. Można go użyć wszędzie gdzie znajdziemy dane, logikę przetwarzania, oraz interfejs użytkownika - bo odnosi się do tych właśnie trzech niezbędnych elementów programów interaktywnych.

<!-- more start -->
Zaletą podejścia MVC jest możliwość rozdzielenia zadań na różnych członków zespołu. Ma to też sens logiczny i ułatwia zrozumienie kodu. W aplikacjach internetowych w naturalny sposób kontekstem niektórych operacji są:
* same dane - np. połączenie nazwiska i imienia w "pełne nazwisko" ma sens nawet bez aplikacji i bez użytkownika
* akcje użytkownika - np. prośba o usunięcie rekordu 'Mateusz Uzdowski'
* odpowiedź serwera - np. przekazanie rezultatu w formie wiadomości "Rekord o nazwie 'Mateusz Uzdowski' został usunięty"

## Model

*Model* odzwierciedla strukturę i powiązania danych. W aplikacjach internetowych jest to definicja (schema) bazy danych -  tabele, kolumny, relacje i klucze (indeksy). W SilverStripe *model* tworzony jest poprzez narzędzia dostarczane przez framework - aby na ile to możliwe uniezależnić nas od specyficznych wymagań poszczególnych baz danych. Obiekty bazy danych konstruowane są automatycznie na podstawie definicji klas w PHP.

Oto przykład bardzo prostej klasy używającej frameworka SS3. Powiedzmy że akurat budujemy aplikację dla producentów świeżych sałatek.

{% highlight php %}
<?php

// Już tutaj tworzymy model składnika - poprzez definicję klasy.
class Ingredient extends DataObject {
        // A tutaj są jego właściwości.
        static $db = array(
                'Name' => 'Text',
                'Salad' => 'Text'
        );
}
{% endhighlight %}

Opisawszy model, możemy teraz automatycznie uaktualnić schema bazy danych z linii poleceń (<code>sapphire/sake dev/build</code>). Większość z wymienionych kolumn jest automatycznie dodwana przez framework, ale jak widać zostają także dodane zdefiniowane przez nas właściwości - nazwa składnika <code>Ingredient.Name</code>, oraz nazwa sałatki <code>Ingredient.Salad</code>.

<pre>
$ sapphire/sake dev/build

Building database SS_silverstripe_mblog using MySQL 5.1.49-3

CREATING DATABASE TABLES

 * Ingredient
  + Table Ingredient: created
  + Field Ingredient.ID: created as int(11) not null auto_increment
(...)
  + Field Ingredient.Name: created as mediumtext character set utf8 collate utf8_general_ci
  + Field Ingredient.Salad: created as mediumtext character set utf8 collate utf8_general_ci
(...)

 Database build completed!
</pre>

Baza danych zawiera teraz tabelę Ingredient i odpowiednie kolumny. Akurat w tym projekcie użyłem bazy MySQL, ale mógłby to być też PostgreSQL, MSSQL albo SQLite3.

<pre>
mysql> describe Ingredient;
+------------+--------------------+------+-----+------------+----------------+
| Field      | Type               | Null | Key | Default    | Extra          |
+------------+--------------------+------+-----+------------+----------------+
| ID         | int(11)            | NO   | PRI | NULL       | auto_increment |
| ClassName  | enum('Ingredient') | YES  | MUL | Ingredient |                |
| Created    | datetime           | YES  |     | NULL       |                |
| LastEdited | datetime           | YES  |     | NULL       |                |
| Name       | mediumtext         | YES  |     | NULL       |                |
| Salad      | mediumtext         | YES  |     | NULL       |                |
+------------+--------------------+------+-----+------------+----------------+
6 rows in set (0.00 sec)
</pre>

Oto model składnika - gotowy do przyjęcia wszystkich elementów sałatki. Do pracy z takim modelem nie potrzebujemy użytkownika, serwera, Internetu, ani przeglądarki - wymagana jest tylko baza danych.

## Kontroler

Zdefiniowaliśmy już model składnika, ale jeśli ma on być do czegoś użyteczny, musimy mieć możliwość wchodzić z nim w interakcję. Działania na modelu są domeną kontrolera - stwórzmy więc kuchennego pomocnika który wykona za nas całą ciężką i niewdzięczną robotę.

{% highlight php %}
<?php

class KitchenHelper extends Controller {
    // Definiujemy parametry interakcji
    static $url_handlers = array(
        'makeSalad/$Type' => 'makeSalad'
    );

    // Interakcja "zrób sałatkę"
    function makeSalad() {
        // Pobieramy parametr "Type" zdefiniowany powyżej - jaką sałatkę chcemy?
        $raw_type = trim($this->getRequest()->param('Type'));
        if (!$raw_type) throw new Exception("Nie ma takiej sałatki!");

        // Tworzymy trzyskładnikową sałatkę
        // Uwaga: bezpośrednie przypisanie oczyści $raw_type ze złośliwego kodu automatycznie.
        $one = new Ingredient();
        $one->Name = "sałata";
        $one->Salad = $raw_type;
        $one->write();

        $two = new Ingredient();
        $two->Name = "ogórek";
        $two->Salad = $raw_type;
        $two->write();

        $two = new Ingredient();
        $two->Name = "oliwka";
        $two->Salad = $raw_type;
        $two->write();

        // Sałatka gotowa!
    }
}
{% endhighlight %}

Kontroler jest gotowy i czeka na nasze rozkazy. Możemy je mu przekazać ponownie używając narzędzia <code>sake</code> z linii poleceń:

<pre>
$ sapphire/sake KitchenHelper/makeSalad/grecka
</pre>

Kuchenny pomocnik jest dość cichy - nie daje nam żadnego znaku że polecenie wykonał. I bardzo dobrze, bo to jest rola widoku, którego jeszcze nie mamy. Możemy jednak użyć dostępnych nam narzędzi i zajrzeć co zostało stworzone w bazie danych:

<pre>
mysql> select * from Ingredient where Salad='grecka';
+----+------------+---------------------+---------------------+---------+-------+
| ID | ClassName  | Created             | LastEdited          | Name    | Salad |
+----+------------+---------------------+---------------------+---------+-------+
|  1 | Ingredient | 2012-02-24 15:33:04 | 2012-02-24 15:33:04 | sałata | grecka |
|  2 | Ingredient | 2012-02-24 15:33:04 | 2012-02-24 15:33:04 | ogórek | grecka |
|  3 | Ingredient | 2012-02-24 15:33:04 | 2012-02-24 15:33:04 | oliwka  | grecka |
+----+------------+---------------------+---------------------+---------+-------+
3 rows in set (0.00 sec)
</pre>

A więc wszystko zadziałało bardzo dobrze - mamy teraz sałatkę w bazie! Możemy sobie wyobrazić w jaki sposób można by rozbudować kuchennego pomocnika. Zadania takie jak usuwanie niepotrzebnych sałatek, opcja mieszania różnych składników w losową sałatkę, albo opcja duplikowania sałatek przynależą właśnie do kontrolera. 

To wszystko może dla nas zrobić kontroler. zasadzie mamy już teraz funkcjonujące oprogramowania, brakuje jednak bogatszego interfejsu. 

[Kontunuuj do drugiej części, gdzie zajmiemy się widokiem](2012/02/model-widok-kontroler-cz2).

<!-- more end -->
