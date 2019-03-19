# Информация

Краен срок: 01.04.2019г, 23:59

Това е първата задача от курса `Функционално програмиране с Elixir`.
Начинът за предаване на вашия код е като го публикувате в това хранилище. До него имате достъп единствено Вие и преподавалите в курса. По време на работа можете многократно да обновявате вашия код. Препоръчително е да започнете работа навреме и да публикувате често кода си, за да можем да ви даваме насоки.

Когато настъпи крайният срок, то Вие ще можете да достъпвате хранилището единствено за четене, но не и за промяна.

## Изисквания

- Не трябва да използвате библиотеки
- Кодът ви трябва да форматиран (изпълнявате `mix format` в директорията на проекта)

## Deque

Задачата е да направите структура, която реализира структурата от данни **Deque**.

Структурата трябва да е дефинирана в модул с името **Deque** (вече имате създаден такъв във файла `lib/deque.ex`). Всички публични функции за работа с нея, описанин по-надолу, трябва да се намират в същия модул. Няма изисквания за структурирането на помощни модули и функции, от които имате нужда при имплементацията.

### Какво представлява Deque?

Декът е структура, подобна на динамичен масив, с малката разлика, че освен да добавяме елементи в края ѝ може да го правим и в началото на "масива". Друга характеристика е, че лесно можем да достъпваме и променяме елементите на дека, чрез техния индекс (индексацията на елементите в "дек" винаги започва от 0). Всички тези операции трябва да са сравнително "бързи" (логаритмичната сложност изпълнява това условие) - ако не спазите това ограничение, няма да получите част от точките.

### Как трябва да изглежда вашата имплементация?

Структурата, която дефинирате, може да има каквито прецените полета, но трябва да можем да създаваме "дек", посредством **%Deque{}**. (В обяснението на функциите е дадена една примерна реализация за по-лесно илюстриране, тя обаче нарочно не е добра, така че помислете за нещо друго)

### Какви функции трябва да има в модула Deque?

Всички публични функции са описани в следващите параграфи. Вие можете да добавяте колкото искате private функции (**defp**). Всяка публична функция от модула трябва да приема като първи аргумент инстанция на **Deque**.

#### Deque.new()

Аналогично на `%Deque{}` създава празен "дек". Например, ако разгледаме реализация на "дек", съдържаща едно поле (:content) в което държим списък.

```elixir
iex> %Deque{}
%Deque{content: []}
iex> Deque.new()
%Deque{content: []}
iex> %Deque{} == Deque.new()
true
```

#### Deque.size(deque)

Връща броя елементи съдържащи се в **deque**.

```elixir
iex> %Deque{content: [1, 2.0, "three"]} |> Deque.size
3
```

#### Deque.push_back(deque, element)

Връща нов "дек", подобен на **deque**, но с добавен последен елемент **element**.

```elixir
iex> %Deque{content: [1, 2.0, "three"]} |> Deque.push_back(:four)
%Deque{content: [1, 2.0, "three", :four]}
```

#### Deque.push_front(deque, element)

Връща нов "дек", подобен на **deque**, но с добавен първи елемент **element**.

```elixir
iex> %Deque{content: [1, 2.0, "three"]} |> Deque.push_front(:zero)
%Deque{content: [:zero, 1, 2.0, "three"]}
```

#### Deque.pop_back(deque)

Връща нов "дек", подобен на **deque**, но с премахнат последен елемент. Ако елементите на новия "дек" са 0, то да се върне `%Deque{}`. Ако **deque** няма елемент да се върне **deque**.

```elixir
iex> %Deque{content: [1, 2.0, "three"]} |> Deque.pop_back
%Deque{content: [1, 2.0]}
iex> %Deque{content: []} |> Deque.pop_back
%Deque{content: []}
iex> ( %Deque{content: [1]} |> Deque.pop_back ) == %Deque{}
true
```

#### Deque.pop_front(deque)

Връща нов "дек", подобен на **deque**, но с премахнат първи елемент. Ако елементите на новия "дек" са 0, то да се върне `%Deque{}`. Ако **deque** няма елемент да се върне **deque**.

```elixir
iex> %Deque{content: [1, 2.0, "three"]} |> Deque.pop_front
%Deque{content: [2.0, "three"]}
iex> %Deque{content: []} |> Deque.pop_front
%Deque{content: []}
iex> ( %Deque{content: [1]} |> Deque.pop_front ) == %Deque{}
true
```

#### Deque.last(deque)

Връща последния елемент в **deque**. Ако "декът" е празен връща `nil`.

```elixir
iex> %Deque{content: [1, 2.0, "three"]} |> Deque.last
"three"
iex> Deque.new() |> Deque.last
nil
```

#### Deque.first(deque)

Връща първия елемент в **deque**. Ако "декът" е празен връща `nil`.

```elixir
iex> %Deque{content: [1, 2.0, "three"]} |> Deque.first
1
iex> Deque.new() |> Deque.first
nil
```

#### Deque.access_at(deque, n)

Връща елемента на позиция **n** от **deque**. Ако "декът" няма позиция **n** функцията връща `nil`, а ако **n** не е цяло число се случва грешка (каквато и да е).

```elixir
iex> deque = %Deque{content: [1, 2.0, "three"]}
%Deque{content: [1, 2.0, "three"]}
iex> deque |> Deque.access_at(0)
1
iex> deque |> Deque.access_at(1)
2.0
iex> deque |> Deque.access_at(2)
"three"
iex> deque |> Deque.access_at(3)
nil
iex> Deque.access_at(deque, "2")
** (FunctionClauseError) no function clause matching in ...
```

#### Deque.assign_at(deque, n, element)

Връща нов "дек", подобен на **deque**, но елемента на позиция **n** е сменен с **element**. Ако няма елемент с индекс **n** или **n** не е цяло число се случва грешка (каквато и да е).

```elixir
iex> deque = %Deque{content: [1, 2.0, "three"]}
%Deque{content: [1, 2.0, "three"]}
iex> deque |> Deque.assign_at(0, :zero)
%Deque{content: [:zero, 2.0, "three"]}
iex> deque |> Deque.assign_at(1, :one)
%Deque{content: [1, :one, "three"]}
iex> deque |> Deque.assign_at(2, :two)
%Deque{content: [1, 2.0, :two]}
iex> deque |> Deque.assign_at(3)
** (FunctionClauseError) no function clause matching in ...
iex> deque |> Deque.assign_at("2")
** (FunctionClauseError) no function clause matching in ...
```

#### Имплементация на протоколи

За структурата **Deque** да се имплементират протоколите **Collectable** и **Enumerable**. За целта прочетете внимателно документацията на двата модула.

След като имплементирате **Collectable**, трябва да вярно следното поведение :

```elixir
iex> deque = 0..5 |> Enum.into Deque.new
%Deque{content: [0, 1, 2, 3, 4, 5]}
iex> [:a, :b, :c] |> Enum.into deque
%Deque{content: [0, 1, 2, 3, 4, 5, :a, :b, :c]}
```

Протоколът **Enumerable** ви позволява да подавате структурата като първи аргумент на всички други функции от модула **Enum**:

```elixir
iex> deque = %Deque{content: [0, 1, 2, 3, 4, 5]}
%Deque{content: [0, 1, 2, 3, 4, 5]}
iex> deque |> Enum.take 2
[0, 1]
iex> deque |> Enum.drop 3
[3, 4, 5]
iex> deque |> Enum.map &(&1*&1)
[0, 1, 4, 9, 16, 25]
iex> deque |> Enum.reverse
[5, 4, 3, 2, 1, 0]
```
