---
layout: post
title: Wprowadzenie do SilverStripe
description: Krótki opis czym jest SilverStripe i jak pozycjonuje się w świecie CMSów.
---

[SilverStripe](http://silverstripe.org/) jest open source'owym frameworkiem i CMSem z Nowej Zelandii. Pozwala na szybkie budowanie stron od podstaw, daje do ręki narzędzie do zarządzania ich treścią, jednocześnie pozostawiając władzę programiście tam, gdzie zwyczajny użytkownik byłby zagubiony (na przykład przy instalowaniu modułów, dodawaniu pól do obiektów i konfiguracji kluczy API).

Moim zdaniem SilverStripe sprawdza się zarówno w przypadku pojedynczych programistów-freelancerów (po prostu pracuje się z nim przyjemnie i co ważne - szybko, nie trzeba za bardzo trenować użytkowników), jak i w przypadku zespołów pracujących nad jedną stroną (można oddzielić szablony i design od programowania, jest pokryty testami, poddaje się continuous integration, jest skalowalny). Nadaje się do zastosowań prywatnych i non-profit, ale też do produktów komercyjnych.

### Ogólnie o systemie

Moim zdaniem użyteczność SilverStripe'a opiera się na następujących jego cechach:

* Przyjazny programiście - konfiguracja systemu odbywa się poprzez kod, a nie poprzez trafianie myszką w różne elementy interfejsu. SS wymaga PHP5.2 i napisany jest w pełni obiektowo (no, prawie - np. funkcja wysyłająca maile w 2.4 jest globalna)
* Intuicyjny CMS - słyszałem już wielokrotnie, że użytkownicy zdziwieni byli że CMS może być taki prosty
* Oparty na MVC - wyraźne rozgraniczenie pomiędzy danymi (M - model), logiką wyświetlania (C - controller) oraz wyglądem stron (V - view, czyli szablon)
* ORM - obiekty definiowane są programistycznie, system automatycznie buduje odpowiednie tabele (object relational mapping)
* BSD open source - możesz użyć frameworka do budowy własnej aplikacji, i nie musisz udostępniać kodu źródłowego
* Który stack pan sobie życzy? - obsługuje MySQL, MSSQL, PostgreSQL i SQLite3, działa na Apache i IIS
* Dla małych i dużych - można na nim puścić strony-wizytówki, albo duże portale rządowe

Ostrzę też zęby na wersję 3.0, w której:

* Interfejs CMSa zostanie odświeżony i poddany usability testing
* Framework ("Sapphire") i CMS zostaną rozdzielone
* CMS tam gdzie to możliwe zostanie przeniesiony na jQuery
* Prymitywny język szablonów zostanie zastąpiony prawdziwym parserem
* Pojawi się nowy, bardziej elastyczny ORM
* Pojawi się możliwość ostylowania CMSa, w oparciu o SCSS

Inne warte wspomnienia elementy systemu, które okazują się szczególnie istotne gdy zaczynamy tworzyć coraz większe i większe strony:

* Łatwa migracja pomiędzy wersjami bazy danych (dev/build) - co odpowiada wersjonowanemu schema bazy danych
* Unit testing i code coverage z PHPUnit dla lepszej jakości kodu
* Partial caching - gdy Twoja strona urośnie i trzeba będzie przeprowadzić optymalizację (dostępny jest też static publisher, który kompiluje całą stronę do HTMLa)
* Modułowość - jest kilkadziesiąt open sourcowych modułów do SilverStripe, niektóre bardzo przydatne. Rdzenne moduły najlepiej pobierać z [GitHub](https://github.com/silverstripe/), ale poza tym jest całkiem sporo innych modułów na wolności.

### Pomoc i informacje

Do poczytania i posłuchania:
* [Demo](http://demo.silverstripe.com/) - szybka dawka doświadczenia w formacie wizualnym
* [Tutoriale](http://doc.silverstripe.org/sapphire/en/tutorials/) - dla zupełnie zielonych
* [Dokumentacja](http://doc.silverstripe.org/sapphire/en/) - dla umiarkowanie zielonych
* [Kanał video na Vimeo](http://vimeo.com/silverstripe/videos/sort:date)

Interaktywne formy uzyskania pomocy:
* [IRC](http://www.silverstripe.org/irc-channel/) - dla zdesperowanych i ciekawych - można mnie tam znaleźć jako "mateuszsz" ([szybki dostęp](http://irc.silverstripe.com/))
* [Forum](http://silverstripe.org/forum)
* [Lista mailingowa - core development](http://groups.google.com/group/silverstripe-dev) - tutaj o rozwoju samego frameworka i CMSa
