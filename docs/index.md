---
date: 2024-11-17
categories:
    - Documentation
---
# 🖥️ EryzOS - A Minimalist Unix-Like Operating System  

<!-- ![EryzOS](https://your-image-link.com)   -->

## 🌟 What is EryzOS?  
EryzOS is a **lightweight, Unix-like operating system** built from scratch in **C and Assembly**, designed to explore **low-level systems programming, kernel development, and OS internals**. This project serves as my **learning journey into OS development** 🚀.  

## 🔧 Features  
- 🖥 **Custom kernel** with system call handling  
- 📂 **Minimalist virtual file system (VFS)**  
- 📝 **Basic shell** for executing user commands  
- 🔄 **Round-robin process scheduling**  
- 🧠 **Paging-based virtual memory management**  
- 🌐 **Experimental TCP/IP networking stack** (WIP)  

## 🚀 Getting Started  

### 🛠️ Build & Run  
You can run EryzOS using QEMU:  
```bash
git clone https://github.com/GabriellaGloria/EryzOS.git
cd EryzOS
make qemu
```

### 🖥 Running on Real Hardware  
You can flash EryzOS onto a USB and boot it on a real machine (experimental).  

1. **Build the OS image**  
   ```bash
   make iso
   ```
2. **Write to a USB drive (Replace ***/dev/sdX*** with your USB device)**
    ```bash
    sudo dd if=eryzos.iso of=/dev/sdX bs=4M status=progress && sync
    ```
3. **Reboot and select USB boot in your BIOS/UEFI settings.**

### 📖 Motivation
Hey, I’m Gabriella Gloria, an NUS Computer Science student 🎓, interested in OS dev, systems programming, and cybersecurity. EryzOS is my playground to explore memory management, process scheduling, and low-level hardware interactions.

### 💻 Contribute
This is a personal learning project, but feel free to open issues, suggest improvements, or just chat about OS dev! 😊

### 📬 Contact
🐙 GitHub: GabriellaGloria<br>
📧 Email: <a href="mailto:gabriella@u.nus.edu">gabriella@u.nus.edu</a>

