# Systemy operacyjne

## Zadanie 3

Zadanie polega na przygotowaniu obrazu dysku z systemem __MINIX 3.3 (minix.img)__, za pomocą którego będzie możliwe odtworzenie poniższego scenariusza.

### Opis wymagań - scenariusz

Uruchamiamy program qemu z przygotowanym obrazem:

```bash
$ qemu-system-x86_64 -curses -drive file=minix.img -enable-kvm -localtime -net user -net nic,model=virtio -m 1024M
```

Zanim zostanie uruchomiony bootloader:

1. Na ekranie maszyny wyświetla się napis `"Enter your name\r\n"`.
2. Użytkownik wpisuje imię (`$name`).
    * Zakładamy, że klawiatura użytkownika jest ograniczona do symboli alfabetu łacińskiego (_[a-z]_), symbolu backspace (_0x08_) oraz enter (_0x0d_).
    * Wartością `$name` powinien być ciąg znaków alfabetu łacińskiego (_[a-z]_).
    * Użytkownik zatwierdza wpisane imię za pomocą entera.
    * Symbol backspace w przypadku `$name` o niezerowej długości oznacza usunięcie ostatniego znaku (kursor zostaje przesunięty w lewo).
    * Użytkownik nie może wpisać imienia o __długości większej niż 12 znaków__.
    - Dopóki imię wprowadzone przez użytkownika ma __mniej niż 3 znaki__, nie może zostać zaakceptowane.
    - Na ekranie wyświetlana jest aktualna wersja imienia, którą wpisuje użytkownik.
3. Po zaakceptowaniu imienia na ekranie maszyny wyświetla się napis `"Hello $name\r\n"`.
4. Po upływie 2 sekund zostaje uruchomiony oryginalny bootloader (z oryginalnego obrazu MINIX-a).

Tuż po zalogowaniu się jako użytkownik root:

5. Automatycznie tworzony jest użytkownik o nazwie `$name` w grupie `'users'`.
6. Automatycznie użytkownik root zostaje zalogowany na konto użytkownika `$name`.

### Oddawanie zadań
Przygotowane rozwiązanie należy zaprezentować podczas zajęć, najpóźniej w tygodniu 3-7 kwietnia 2017 r.
Pliki źródłowe z rozwiązaniem należy umieścić w repozytorium SVN w katalogu `studenci/ab123456/zadanie3`
gdzie `ab123456` jest identyfikatorem studenta używanym do logowania w laboratorium komputerowym.

### Punktacja

* Przygotowanie obrazu, który spełnia wymagania 1-4 -> __max. 1 punkt__.
* Przygotowanie obrazu, który spełnia wymagania 1-6 -> __max. 2 punkty__.
