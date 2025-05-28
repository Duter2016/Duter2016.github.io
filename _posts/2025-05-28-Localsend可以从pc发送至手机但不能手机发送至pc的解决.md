---
layout:     post
title:      Localsend可以从pc发送至手机但不能手机发送至pc的解决
subtitle:   linux中，localsend不能从手机向pc发送文件
date:       2025-05-28
author:     Duter2016
header-img: img/post-bg-debug.png
catalog: true
music-id: 
music-idfull: 
tags:
    - Linux
---

已经在Gufw防火墙中放行了53317端口，但是仍然不能实现localsend从手机向pc发送文件，但是可以实现pc向手机发送文件。排查是防火墙nftables的设置问题。

以下是针对您当前 `/etc/nftables.conf` 配置的详细修改方案，以允许 LocalSend 的 53317 端口通信：

---

### **修改步骤（基于现有配置）**
1. **编辑配置文件**
   ```bash
   sudo vim /etc/nftables.conf
   ```

2. **在 `chain input` 部分添加以下规则**（置于 `ssh` 规则之后）：
   ```nft
   tcp dport 53317 accept comment "allow LocalSend TCP"
   udp dport 53317 accept comment "allow LocalSend UDP"
   ```
   *最终效果示例*：
   ```nft
   chain input {
     type filter hook input priority filter
     policy drop

     ct state invalid drop comment "early drop of invalid connections"
     ct state {established, related} accept comment "allow tracked connections"
     iif lo accept comment "allow from loopback"
     ip protocol icmp accept comment "allow icmp"
     meta l4proto ipv6-icmp accept comment "allow icmp v6"
     tcp dport ssh accept comment "allow sshd"
     tcp dport 53317 accept comment "allow LocalSend TCP"   # 新增
     udp dport 53317 accept comment "allow LocalSend UDP"   # 新增
     pkttype host limit rate 5/second counter reject with icmpx type admin-prohibited
     counter
   }
   ```
   *注*：
   - 规则需放在 `policy drop` 之后、`limit rate` 之前。
   - 使用 `comment` 标记便于后期维护。

3. **保存并测试配置**
   ```bash
   sudo nft -f /etc/nftables.conf  # 加载新配置
   sudo nft list ruleset | grep "53317"  # 验证规则是否存在
   ```

---

### **关键原理说明**
1. **端口协议选择**
   - LocalSend 同时依赖 TCP（文件传输）和 UDP（设备发现），需同时放行。
   - 若只需单向传输，可仅开放 TCP。

2. **安全考虑**
   - 现有配置已启用 `policy drop` 和连接跟踪（`ct state`），新增规则不会降低安全性。
   - 建议限制源 IP（如局域网网段）以增强防护：
     ```nft
     ip saddr 192.168.1.0/24 tcp dport 53317 accept  # 仅允许本地局域网
     ```

3. **日志调试**
   - 如需记录被拦截的 LocalSend 请求，可添加日志规则：
     ```nft
     tcp dport 53317 log prefix "LocalSend Blocked: " drop
     ```
     日志查看命令：
     ```bash
     journalctl -k | grep "LocalSend Blocked"
     ```

---

### **常见问题应对**
1. **规则未生效？**
   - 检查 LocalSend 是否实际监听 53317 端口：
     ```bash
     ss -tulnp | grep 53317
     ```
   - 确保未启用其他防火墙工具（如 `firewalld`）：
     ```bash
     sudo systemctl stop firewalld  # 临时禁用
     ```

2. **配置持久化**
   - Arch Linux 默认不会自动加载 `/etc/nftables.conf`，需启用服务：
     ```bash
     sudo systemctl enable --now nftables
     ```

3. **回滚修改**
   - 若导致网络异常，快速恢复原配置：
     ```bash
     sudo cp /usr/share/nftables/simple.rules /etc/nftables.conf
     sudo nft -f /etc/nftables.conf
     ```

---

### **最终配置对比**
| 原配置状态               | 修改后增强点                          |
|- | -|
| 仅允许 SSH/ICMP 等基础流量 | 新增 LocalSend 专用端口例外           |
| 严格默认 DROP 策略        | 保持严格策略，仅针对性放行必要端口    |
| 无应用层标记              | 添加注释便于维护，支持日志追踪        |

通过以上调整，既可解决 LocalSend 的传输问题，又符合 Arch Linux 的安全最佳实践。

