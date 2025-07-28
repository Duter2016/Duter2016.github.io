---
layout:     post
title:      在Arch Linux中统一所有软件使用同一个版本的Electron
subtitle:   系统中只保留一个版本的electron
date:       2025-07-28
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Linux
---


在 Arch Linux 中，多个应用程序可能会依赖不同版本的 `electron`，导致系统中安装了多个版本的 `electron`（如 `electron28`、`electron29` 等）。本文使用的**统一所有软件使用同一个版本的 Electron** 的方法是：**在 Arch Linux 中，修改已安装软件的依赖关系**。

该方法通常需要 **手动修改 `PKGBUILD` 并重新构建安装**。以下是详细的方法：

---

### **一、准备工作**
1. **找到系统中安装的所有 Electron 版本**：
   ```bash
   ls /usr/lib/electron*  # 通常位于 /usr/lib/electronXX
   ```
   ```bash
   pacman -Ql electron35  # 检查上一步已经查找到的已安装版本的具体安装路径，如35
   ```

2. **选择你想使用的版本**（如 `electron35`）：
   
   下面我们的操作以`electron35`为例进行操作。

### **二、修改 `PKGBUILD` 并重新构建（推荐）**

1. **获取软件的 `PKGBUILD`**

   切换到 /tmp 临时构建（避免权限问题）

```bash
   cd /tmp
   ```

   ```bash
   # 对于 AUR 软件
   yay -G 软件名
   cd 软件名
   ```

   ```bash
   # 对于官方仓库软件
   asp export 软件名
   cd 软件名
   ```



2. **编辑 `PKGBUILD`，修改 `depends` 数组**
   ```bash
   nano PKGBUILD
   ```
   ```bash
   depends=('依赖1' '依赖2' ...)  # 修改成你想要的依赖
   ```

3. **重新构建安装**
   ```bash
   makepkg -si
   ```
   > **⚠️ 注意**：如果依赖关系变化过大，可能需要手动 `pacman -Rsn` 旧版本后再安装。

3. **修改 `.desktop` 文件**（可选）：

   - 有些应用程序（如 VSCode、Discord）可能会在桌面快捷方式 (`/usr/share/applications/`) 中直接指定 Electron 路径，我们这里以重新指定到 Electron35 路径为例：

     ```bash
     sudo sed -i 's|/usr/lib/electron[0-9]*|/usr/lib/electron35|g' /usr/share/applications/*.desktop
     ```

     ```bash
     sudo sed -i 's|/usr/lib/electron[0-9]*|/usr/lib/electron35|g' /home/dh/.local/share/applications/*.desktop
     ```
---

### **三、验证是否生效**

运行：

```bash
ldd $(which 软件名) | grep electron  # 检查 某个软件 使用的 Electron

```
如果输出均指向 `/usr/lib/electron35`，说明成功统一版本！

最后删除你不再需要的版本的electron就可以了：

```bash
yay -Rs electron34

```

如果是关键系统软件（如 `glibc`, `systemd`），建议不要手动修改依赖，以免系统崩溃！ 🔧