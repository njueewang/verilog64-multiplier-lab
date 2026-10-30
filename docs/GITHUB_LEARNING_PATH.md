# GitHub 学习路线

这份练习把 Git 的版本控制与 GitHub 的远程协作放在真实的 Verilog 迭代中使用。命令都在仓库根目录执行。

## 0. 先安装并配置 Git

安装 Git for Windows 后重新打开终端，确认：

```powershell
git --version
git config --global user.name "你的名字"
git config --global user.email "你的 GitHub 邮箱"
```

`user.name` 会写进每次 commit；`user.email` 是提交者身份，不会自动公开，但会成为提交元数据。

## 1. 仓库、工作区、暂存区、提交

- 工作区：磁盘上正在编辑的文件。
- 暂存区：下一次提交准备包含的快照。
- 提交（commit）：本地的一条不可变历史记录。
- 仓库：由提交和分支组成的历史。

常用检查命令：

```powershell
git status
git diff
git log --oneline --decorate --graph --all
```

`git status` 只展示当前状态，不会上传文件。看完后可以用 `git diff` 检查尚未暂存的具体修改。

## 2. 创建第一次提交

确认远程仓库已经在 GitHub 上创建。如果仓库是空的，首次提交可以这样完成：

```powershell
git init
git add .
git status
git commit -m "feat(v1): add baseline 64-bit shift-add multiplier"
git branch -M main
git remote add origin https://github.com/njueewang/REPOSITORY_NAME.git
git push -u origin main
git tag -a v1.0-baseline -m "V1: baseline 64-bit shift-add multiplier"
git push origin v1.0-baseline
```

提交前必须检查 `git status` 和 `git diff --staged`。不要把 Vivado 的构建缓存、波形或包含本机路径的工程生成文件提交进去。

## 3. 新增 V2 的完整 GitHub 流程

```powershell
git switch main
git pull --ff-only
git switch -c feature/v2-pipeline
```

修改设计并运行仿真后：

```powershell
git status
git diff
git add rtl tb docs scripts README.md
git diff --staged
git commit -m "feat(v2): pipeline the multiplier"
git push -u origin feature/v2-pipeline
```

然后到 GitHub 仓库页面点击 **Compare & pull request**：

1. 标题写清版本和目的。
2. 描述中写设计改动、仿真结果以及资源/时序对比。
3. 自己审阅 Files changed。
4. 合并 Pull Request。
5. 在本地更新并打标签：

```powershell
git switch main
git pull --ff-only
git tag -a v2.0-pipeline -m "V2: two-stage pipelined multiplier"
git push origin v2.0-pipeline
```

## 4. 每一版必须回答的问题

- 输入和输出位宽是什么？有符号还是无符号？
- 预测结果如何计算？
- 是组合逻辑还是时序逻辑？延迟和吞吐率是多少？
- 仿真覆盖了哪些边界值和随机值？
- 综合后的 LUT、FF、DSP 数量是多少？
- 时序约束是否满足？最差负裕量（WNS）是多少？
- 这一版相对上一版改进了什么，又付出了什么代价？

## 5. 出问题时的恢复方式

查看文件在上一提交中的内容，不会修改工作区：

```powershell
git show HEAD:rtl/multiplier64.v
```

舍弃某一个文件尚未提交的修改前，先查看差异：

```powershell
git diff -- rtl/multiplier64.v
git restore rtl/multiplier64.v
```

`git restore` 会覆盖该文件中未提交的修改，执行前一定要确认。
