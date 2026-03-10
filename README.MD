# 🍎 macOS Dotfiles (Nix-Darwin)

Repositori ini menyimpan konfigurasi sistem macOS saya menggunakan **Nix**, **nix-darwin**, dan **Home Manager**. Setup ini bersifat deklaratif, memungkinkan saya untuk melakukan *restore* atau pindah perangkat dengan konsistensi penuh.

---

## 🛠️ Tech Stack
* **Nix:** Package manager & Flakes support.
* **nix-darwin:** Manajemen konfigurasi sistem macOS (System Defaults, Homebrew).
* **Home Manager:** Manajemen konfigurasi user (Shell, Dotfiles, Environment).

---

## 📂 Struktur Konfigurasi

```text
.
├── flake.nix      # Titik masuk utama (System level configuration)
├── home.nix       # Konfigurasi user (Packages, Shell, Environment variables)
└── flake.lock     # Pin versi dependensi untuk reproduktifitas
🚀 Instalasi di Mac Baru
1. Install Homebrew
Diperlukan sebagai bridge untuk aplikasi pihak ketiga (Casks/Formulae).

Bash
/bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"
2. Install Nix
Menggunakan installer dari Determinate Systems:

Bash
curl --proto '=https' --tlsv1.2 -sSf -L [https://install.determinate.systems/nix](https://install.determinate.systems/nix) | sh -s -- install
(Restart terminal setelah instalasi selesai)

3. Clone & Deploy
Bash
# Clone repository
git clone [https://github.com/RicardhoGunawan/dotfiles.git](https://github.com/RicardhoGunawan/dotfiles.git) ~/.dotfiles
cd ~/.dotfiles

# Jalankan inisialisasi pertama kali
nix run nix-darwin -- switch --flake .#mac
🔧 Maintenance
Menerapkan Perubahan
Setiap kali kamu memodifikasi file .nix, jalankan perintah berikut untuk menerapkan perubahan ke sistem:

Bash
sudo darwin-rebuild switch --flake ~/.dotfiles#mac
Pembersihan (Garbage Collection)
Nix menyimpan versi lama setiap kali kamu melakukan rebuild. Gunakan perintah ini untuk menghapus data yang tidak terpakai dan melegakan penyimpanan:

Bash
nix-collect-garbage -d
nix-store --optimise
⚙️ Kustomisasi
flake.nix: Edit bagian environment.systemPackages untuk menambah aplikasi CLI global atau homebrew untuk aplikasi macOS.

home.nix: Edit untuk menambah konfigurasi user-level seperti alias shell, tema, atau konfigurasi aplikasi spesifik.

Dibuat dengan ❤️ menggunakan Nix


---

### Tips untuk Kamu:
* **`flake.nix`**: Pastikan path `--flake ~/.dotfiles#mac` di perintah rebuild sesuai dengan folder tempat kamu menyimpan repo ini. Jika foldernya berbeda, sesuaikan perintahnya.
* **Git:** Jangan lupa untuk menginisialisasi Git di dalam folder tersebut setelah melakukan `git clone` agar perubahanmu bisa di-push ke repositori.