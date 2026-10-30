# Verilog 64 位乘法器实验室

这是一个用 Verilog 从零学习 FPGA 设计和 GitHub 工作流的练习仓库。每一版设计都保留在 Git 历史中，并通过 GitHub 同步。

当前版本：**V1 基线乘法器**

GitHub 仓库：<https://github.com/njueewang/verilog64-multiplier-lab>

## V1 设计

- 输入：两个无符号 64 位数 `a`、`b`
- 输出：128 位乘积 `product`
- 算法：从低位到高位检查 `b` 的每一位；该位为 1 时，把左移对应位数的 `a` 累加到结果
- 结构：纯组合逻辑，没有时钟和流水线
- 目的：先得到容易读懂、容易验证的正确性基线

V1 的重点是理解乘法算法和处理 128 位结果。它不追求面积或时序最优化；这些会在后续版本中逐步改进。

## 目录

```text
rtl/                          Verilog 设计源码
tb/                           仿真测试平台
scripts/                      生成 Vivado 工程和运行仿真的 Tcl 脚本
docs/                         GitHub 学习和版本迭代说明
vivado/multiplier64_v1/       本地 Vivado 工程（生成文件不提交）
```

## 打开工程

当前电脑上的 Vivado 安装位置为：

```text
D:\ProgramFiles\VIVADO\2025.2\Vivado\bin\vivado.bat
```

双击打开：

```text
vivado\multiplier64_v1\multiplier64_v1.xpr
```

如果工程不存在或需要重建，在仓库根目录运行：

```powershell
& 'D:\ProgramFiles\VIVADO\2025.2\Vivado\bin\vivado.bat' `
  -mode batch -source scripts/create_v1_project.tcl `
  -nojournal -nolog
```

运行 V1 自动仿真：

```powershell
& 'D:\ProgramFiles\VIVADO\2025.2\Vivado\bin\vivado.bat' `
  -mode batch -source scripts/run_v1_sim.tcl `
  -nojournal -nolog
```

测试平台会检查零、一、最大值、大数相乘、不同位宽数值以及 200 组随机输入。终端中出现 `MULTIPLIER64 V1 TEST PASSED` 才表示全部通过。

## 打开 Git Bash

从开始菜单打开 **Git Bash**，然后进入本仓库：

```bash
cd /e/Work/AI_Agents
git status
gh auth status
```

本机已经安装 Git 2.56 和 GitHub CLI 2.103。当前 `origin` 使用 GitHub 的 SSH 443 通道，因为这台电脑的网络会阻断普通 Git HTTPS 端点。仓库级 Deploy Key 只授权当前项目，不授权其他 GitHub 仓库。

## Vivado 工程说明

工程器件暂时选择常见的 Artix-7 `xc7a35tcsg324-1`。这不会影响行为仿真；如果要上板，应在 Vivado 中把器件改为你实际开发板上的型号，并补充引脚约束。

本仓库不提交 `.xpr`、仿真结果、综合结果等机器相关生成物。Tcl 脚本才是工程配置的可靠来源，换电脑后也能重建同样的工程。

## GitHub 迭代约定

每个版本都按同一循环完成：

1. 从最新 `main` 创建版本分支，例如 `feature/v2-pipeline`。
2. 修改 RTL、测试和文档。
3. 运行仿真，记录结果。
4. 提交一个描述清楚的 commit。
5. 推送分支到 GitHub，并创建 Pull Request。
6. 评审并合并到 `main`。
7. 更新本地 `main`，并打版本标签，例如 `v2.0-pipeline`。

详细说明见 [docs/GITHUB_LEARNING_PATH.md](docs/GITHUB_LEARNING_PATH.md)，版本路线见 [docs/VERSION_ROADMAP.md](docs/VERSION_ROADMAP.md)。

V1 已记录的功能仿真和综合摘要见 [docs/V1_RESULTS.md](docs/V1_RESULTS.md)。

V1 的代码、测试、工程构建脚本和文档已经推送到 GitHub，并带有 `v1.0-baseline` 标签。
