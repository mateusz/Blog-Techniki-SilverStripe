---
layout: post
title: Testy jednostkowe (unit tests)
description: W jaki sposób uzyskać stabilny kod źródłowy przy pomocy testów.
more: 1
---

Jako programiści, na codzień opieramy się na kodzie który napisaliśmy wcześniej. Mimo iż nie pamiętamy dokładnie w jaki sposób dana funkcja (metoda, klasa) spełnia swoje zadanie, musimy mieć podstawowe zaufanie, że robi to co mówi że robi. Jest to tym ważniejsze, gdy pracujemy w grupie i korzystamy z kodu napisanego przez kogoś innego.

Jednak często funkcje i metody nie działają tak, jak pierwotny twórca zakładał, albo dają nieprzewidywalne rezultaty przy pewnych warunkach brzegowych. To bardzo częste źródło problemów z oprogramowaniem. Jednocześnie łatwo jest temu zaradzić, jeśli dopiero co daną funkcję napisaliśmy i mamy wszystko świeżo w umyśle.

Celem testów jednostkowych jest właśnie zapewnienie, że funkcje nie kłamią i że zachowują się według oczekiwań. To proste: jeśli napisałeś funkcję, udowodnij, że ta funkcja działa.

## Prawdomówne funkcje

Efektem który chcemy uzyskać, jest udowodnienie że dana funkcja - w oderwaniu od reszty systemu - działa. Na początek rozprawmy się z tematem bez mieszania do tego frameworka SilverStripe. Oto prosta funkcja napisana przez pewnego programistę (który dużo programował w Perlu).

{% highlight php startinline %}
// Funkcja dodaje lewy argument do prawego, i zwraca wartosć.
function addTheseTwo($left, $right) {
    $sum = $left + $right;
}
{% endhighlight %}

Programista jest zadowolony z siebie, ale chce się upewnić, że jego funkcja działa poprawnie. Pisze więc nastepujący test.

{% highlight php startinline %}
// Ta funkcja dodaje 1 do 2 i powinna dać 3.
if (addTheseTwo(1,2)!=3) {
    throw new Exception("Test nieudany!");
}
{% endhighlight %}

Po jego uruchomieniu odkrywa ze zgrozą, że funkcja testu nie przeszła.

<pre>
PHP Fatal error:  Uncaught exception 'Exception' with message 'Test nieudany!' in ...
</pre>

Po przejrzeniu oryginalnej funkcji zauważa, że zapomniał zwrócić wartość! Dodaje więc <code>return $sum;</code>, uruchamia test ponownie i upewnia się, że wszystko jest w porządku.

Jest to bardzo prosty przykład który ilustruje przydatność tego podejścia - pomyłki zostają wychwycone wcześnie, a dodatkowo jeśli w przyszłości nie będziemy pewni co do zachowania funkcji, wystarczy, że przejrzymy test.

## Udawane obiekty (mocks)

Zadaniem testów jednostkowych, jest sprawdzenie czy dana funkcja i tylko ta funkcja działa jak należy. Co zatem jeśli w tej funkcji znajdują się wywołania innych funkcji, których sprawdzać nie chcemy?

Z pomocą przychodzą udawane obiekty, które robią tylko to co im powiemy i nic więcej. Oto przykład, w którym wykonujemy pewne operacje na danych pochodzących z zewnętrznej bazy danych (tutaj symulowane przez <code>rand</code>).

{% highlight php startinline %}

// Funkcja która będzie wykorzystana do pobrania aktualnej ceny akcji.
$priceFunction = 'getPrice';

function getPrice() {
        // Ta funkcja wykonuje nieznane operacje na zewnętrznej bazie danych.
        // Symulujemy zewnętrzną bazę za pomocą losowej nieznanej wartości ;)
        return rand(10, 100);
}

// Podaje nam dobrą cenę za którą możemy sprzedać nasze akcje.
function goodPriceToSellFor() {
        global $priceFunction;

        // Domyślnie równoważne: $price = getPrice();
        $price = $priceFunction();
        return $price*1.2;
}

echo goodPriceToSellFor()."\n";

{% endhighlight %}

Uruchamiamy powyższy kod kilka razy, uzyskując <code>44.4</code>, <code>22.8</code> i <code>98.4</code>. Jak sprawdzić czy te wartości są poprawne? Nie wiemy jaką wartość da nam <code>getPrice</code>, a więc nie wiemy czego oczekiwać po <code>goodPriceToSellFor</code>.

Z pomocą spieszą udawane obiekty.

{% highlight php startinline %}
// Udawany dostęp do bazy danych.
function getPriceForTest() {
        return '10';
}
$priceFunction = 'getPriceForTest';

// Testujemy czy goodPriceToSellFor dodaje 20% do aktualnej ceny akcji.
// Zamiast getPrice zostanie użyta nasza podrobiona funkcja która zawsze daje 10.
if (goodPriceToSellFor()!=12) {
        throw new Exception("Test nieudany!");
}
else {
        echo "Funkcja goodPriceToSellFor poprawnie dodała 20% do aktualnej ceny akcji.\n";
}
{% endhighlight %}

W rezultacie uruchomienia tego kodu otrzymujemy krzepiący komunikat.

<pre>
Funkcja goodPriceToSellFor poprawnie dodała 20% do aktualnej ceny akcji.
</pre>

A więc mamy pewność, że zawsze znać będziemy dobrą cenę sprzedaży naszych akcji.

Mam nadzieję, że przybliża to Wam podstawowe koncepcje dotyczące testowania kodu. Poza testami jednostkowymi, możemy testować też integrację elementów, dzięki czemu możemy upewnić się, że wspólny rezultat działania wielu funkcji jest zgodny z oczekiwaniami. Ten typ testów integracyjnych pozwala nam ustrzec się przed problemami regresji - gdy zmiana w jednym miejscu systemu powoduje błędy zupełnie gdzie indziej.

SilverStripe framework przychodzi z wieloma wbudowanymi [testami jednostkowymi i integracyjnymi](https://github.com/silverstripe/sapphire/tree/master/tests) - wszystkie znajdują się w podkatalogach <code>tests</code>, wewnątrz modułów. Dostarcza też <code>SapphireTest</code> - klasę która pozwala na łatwe pisanie testów opartych na [PHPUnit](https://github.com/sebastianbergmann/phpunit/).

W następnej części zajmiemy się uruchomieniem PHPUnit i napisaniem podstawowego testu opartego na <code>SapphireTest</code>.
