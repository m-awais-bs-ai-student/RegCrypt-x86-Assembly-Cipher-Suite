# RegCrypt x86: Assembly Cipher Suite

[![Language](https://img.shields.io/badge/language-x86_Assembly_(MASM)-blue.svg)](https://en.wikipedia.org/wiki/X86_assembly_language)
[![Library](https://img.shields.io/badge/library-Irvine32-orange.svg)](http://asmirvine.com/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 📌 Overview

**RegCrypt x86** is a modular encryption and data manipulation tool developed in **x86 Assembly Language** (MASM). It serves as a comprehensive demonstration of low-level programming concepts, including register manipulation, direct memory addressing, and stack-based logic.

Built with the **Irvine32** library, this project implements three distinct cipher algorithms to process text data at the hardware level, bypassing high-level string abstractions to prioritize performance and architectural understanding.

---

## 🚀 Key Features

### 1. Caesar Cipher (Substitution)
A robust implementation of the classic shift cipher.
* **Smart Wrapping:** Uses `DIV` and modulo arithmetic to handle ASCII wrapping (e.g., 'Z' $\to$ 'A') correctly.
* **Case Sensitivity:** Distinguishes between uppercase and lowercase ASCII ranges.
* **Symbol Preservation:** Non-alphabetic characters remain untouched.
* **Decrypt Logic:** Automatically calculates complementary shifts for decryption.

### 2. Bit Rotation Cipher (Binary Obfuscation)
Provides security at the binary level using processor-specific rotation instructions.
* **ROL (Rotate Left):** Scrambles data for encryption.
* **ROR (Rotate Right):** Unscrambles data for decryption.
* **Variable Key:** User-defined rotation count (1-7 bits).

### 3. Reverse String Cipher (Transposition)
* Utilizes pointer arithmetic (`ESI`/`EDI`) to invert the memory buffer of the input string in place.

### 4. Robust Input Validation
* Custom **Macros** (`mReadInt`) protect the program from crashing by validating integer ranges and handling status flags for invalid inputs.

---

## 🛠️ Technical Implementation

This project highlights specific competencies in Computer Architecture and Assembly Language:

* **Macro Definitions:** Streamlined I/O operations and validation logic to reduce code redundancy.
* **Indirect Addressing:** Extensive use of `[ESI]` (Source Index) and `[EDI]` (Destination Index) for efficient array traversal.
* **Bitwise Operations:** utilization of `ROL`, `ROR`, `CMP`, and `TEST` instructions.
* **Stack Management:** Proper preservation of registers (`PUSH`/`POP`) across procedure calls to maintain program stability.

---

## ⚙️ Getting Started

### Prerequisites
To compile and run this project, you need:
1.  **Visual Studio** (with C++ Desktop Development workload).
2.  **MASM** (Microsoft Macro Assembler).
3.  **Irvine32 Library** (installed and linked).

### Installation & Build
1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/your-username/regcrypt-x86.git](https://github.com/your-username/regcrypt-x86.git)
    ```
2.  **Open in Visual Studio:**
    Open the `.sln` file. Ensure the project Build Dependencies are set to **MASM**.
3.  **Link Irvine32:**
    Verify that `Irvine32.lib` is included in your Linker settings and the library path is correct.
4.  **Run:**
    Press `Ctrl+F5` to build and execute.

---

## 💻 Usage Example

```text
===== CIPHER ENCRYPTION/DECRYPTION PROGRAM =====
1. Caesar Cipher
2. Reverse String Cipher
3. Bit Rotation Cipher (ROL/ROR)
4. Exit
Enter your choice (1-4): 3

1. Encrypt
2. Decrypt
Enter operation (1-2): 1

Enter text (max 100 chars): SecretData
Enter rotation count (1-7): 4

Result: [Scrambled Binary Output]

Do you want to perform another operation?
1. Yes (Return to Main Menu)
2. No (Exit Program)
