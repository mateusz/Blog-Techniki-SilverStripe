---
layout: post
title: Model, widok, kontroler część 2
description: Opis wzorca model, widok, kontroler.
---

W [poprzedniej części](2012/02/model-widok-kontroler-cz1) zajęliśmy się modelem i kontrolerem (czyli strukturą danych i logiką przetwarzania), tutaj natomiast zajmiemy się wyświetlaniem rezultatu naszych starań (czyli widokiem).

<!-- more start -->
## Widok jako część kontrolera

Aby dopełnić aplikację, potrzebujemy interfejsu zwrotnego - widoku który przesłany zostanie do użytkownika, aby mógł on zorientować się co się właściwie wydarzyło. W niektórych przypadkach kontroler będzie równoczesnie pełnił funkcję widoku. <code>KitchenHelper</code> moglibyśmy zmodyfikować następująco.

{% highlight php startinline %}
    function makeSalad() {
        (...)

        $type = Convert::raw2xml($raw_type);
        return "Sałatka $type jest gotowa do spożycia\nSmacznego!\n";
    }
{% endhighlight %}

Za prymitywny widok służy nam tutaj ostatnia linijka - predefiniowany tekst komunikatu wzbogacony zostaje o typ sałatki i wysłany do użytkownika. Spróbójmy zobaczyć jaką odpowiedź otrzymamy jeśli zażyczymy sobie sałatkę warzywną.

<pre>
$ sapphire/sake KitchenHelper/makeSalad/warzywna
Sałatka warzywna jest gotowa do spożycia.
Smacznego!
</pre>

Nawiasem mówiąc, mamy już wszystkie elementy interaktywnej aplikacji internetowej. Jeśli mamy uruchomiony serwer www, możemy użyć adresu URL aby zrobić sałatkę. Tutaj korzystam z narzędzia wget - jest to m.in. nieinteraktywny klient HTTP (taki sam rezultat uzyskamy używając normalnej przeglądarki).

<pre>
$ wget -qO- http://localhost/sapphire/main.php?url=/KitchenHelper/makeSalad/z%20ogórkiem
Sałatka z ogórkiem jest gotowa do spożycia.
Smacznego!
</pre>

Jednak w bardziej skomplikowanych aplikacjach, widok będzie znacznie bardziej skomplikowany niż pojedyncza linia teskstu. Dlatego warto wydzielić go do osobnego modułu.

## Wydzielony widok

W SilverStripe używamy własnego języka szablonów, pliki takie mają rozszerzenie <code>*.ss</code> i mogą znajdować się albo w katalogu projektu <code>mysite/templates</code>, albo w dedykowanym temacie graficznym w <code>themes/nazwa_szablonu/templates</code>. Zaletą drugiego podejścia jest możliwość zainstalowania kilku różnych tematów graficznych na jednej stronie, co może być użyteczne w przypadku użycia modułu [subsites](https://github.com/silverstripe/silverstripe-subsites).

Tym razem stworzymy bardzo prosty szablon i umieścimy go w <code>mysite/templates/Smacznego.ss</code>.

{% highlight html %}
<html>
<body>
    <h1>$Title</h1>

    <p>Sałatka $Type jest gotowa do spożycia.<p>
    <p>Smacznego!</p>
</body>
</html>
{% endhighlight %}

Otwórzmy zatem <code>http://localhost/sapphire/main.php?url=/KitchenHelper/makeSalad/zdrowa</code> w przeglądarce i zobaczmy co zostanie wyświetlone.

![Sałatka www](images/2012-02-26-kitchen-helper.png)

To wszystko! Mamy gotową użyteczną aplikację, rozdzieloną na trzy logiczne części. Program wykonywany jest od rządania HTTP, poprzez manipulację na modelu za pośrednictwem kontrolera, aż do wyświetlania rezultatu poprzez widok. 

Przy pisaniu aplikacji kontroler może także zwracać dane w inny sposób - na przykład jeśli wywołanie odbyło się poprzez AJAX, możemy zwrócić JSON, które następnie zostanie przetworzony przez frontendowy JavaScript. W tej sytuacji JS da facto pełnił będzie funkcje widoku - może on używać swojego własnego języka szablonów, albo tworzyć interfejs w inny sposób.

## Co dalej?

Kod z tego artykułu możesz znaleźć na [GitHub](https://github.com/mateusz/Techniki-SilverStripe). Jeśli korzystasz z git, wystarczy sklonować kod i skonfigurować kilka parametrów SilverStripe.

<pre>
$ git clone git://github.com/mateusz/Techniki-SilverStripe.git techniki_ss
(...)
$ vim techniki_ss/_ss_environment.php
(...)
$ cd techniki_ss/2012-02-26-model-widok-kontroler
$ sapphire/sake dev/build
</pre>

Jeśli chciałbyś jeszcze popracować z tym kodem, oto kilka użytecznych zadań do wykonania (przydadzą się później w pracy z SilverStripe):
* Skonfiguruj URL Rewriting tak, aby można było uaktywnić pomocnika kuchennego poprzez <code>http://localhost/KitchenHelper/makeSalad/zdrowa</code> - jeśli używasz Apache, obejrzyj plik <code>.htaccess</code> w [silverstripe-installer](https://github.com/silverstripe/silverstripe-installer/blob/master/.htaccess).
* Zmień globalny routing w taki sposób aby można było tą samą operację wykonać poprzez <code>http://localhost/pomocnik/makeSalad/zdrowa</code> - [konfiguracja](http://api.silverstripe.org/trunk/sapphire/control/Director.html#methodaddRules) taka może zostać ustawiona w <code>mysite/_config.php</code>.
* Stwórz własny temat graficzny w katalogu <code>themes</code> i przełącz na niego frameworka - można to zrobić także poprzez [ustawienia](http://api.silverstripe.org/trunk/sapphire/view/SSViewer.html#methodset_theme) w <code>mysite/_config.php</code>.

<!-- more end -->
