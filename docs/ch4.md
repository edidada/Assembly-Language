# ch4
8086 CPU 内部不只有 `CS`、`IP`，还有 AX、BX、CX、DX、SP、BP、SI、DI、DS、SS、ES、FLAGS 等寄存器。

你现在学习的是王爽《汇编语言》，书中主要介绍 Intel 8086 的 16 位寄存器。而你自己电脑如果使用 Intel 或 AMD 的现代 x86-64 CPU，则有更多的 64 位寄存器。

可以在 Windows 11 上使用 Visual Studio 2022、WinDbg 或 x64dbg 查看真实的 CPU 寄存器值。

## 一、8086 CPU 有哪些寄存器？

8086 有 14 个主要的程序可见 16 位寄存器。

| 寄存器   | 英文                  | 主要作用      |
| ----- | ------------------- | --------- |
| AX    | Accumulator         | 累加器，算术运算  |
| BX    | Base                | 基址寄存器     |
| CX    | Count               | 循环计数      |
| DX    | Data                | 数据、乘除法辅助  |
| SP    | Stack Pointer       | 栈顶偏移地址    |
| BP    | Base Pointer        | 栈帧、内存寻址   |
| SI    | Source Index        | 源索引       |
| DI    | Destination Index   | 目标索引      |
| CS    | Code Segment        | 代码段地址     |
| DS    | Data Segment        | 数据段地址     |
| SS    | Stack Segment       | 栈段地址      |
| ES    | Extra Segment       | 附加段地址     |
| IP    | Instruction Pointer | 下一条指令偏移   |
| FLAGS | Flags               | 状态标志和控制标志 |

其中，AX、BX、CX、DX 可以拆分成两个 8 位寄存器，例如：

AX：16 位寄存器结构

例如：

```
mov ax,1234h
```

执行后：

- AX = 1234H
- AH = 12H
- AL = 34H

## 二、现代 CPU 的寄存器有什么不同？

Intel/AMD x86-64 CPU 仍然保留了很多早期寄存器的名称，但扩展到了 64 位。

| 8086（16 位） | x86（32 位） | x86-64（64 位） |
| ---------- | --------- | ------------ |
| AX         | EAX       | RAX          |
| BX         | EBX       | RBX          |
| CX         | ECX       | RCX          |
| DX         | EDX       | RDX          |
| SP         | ESP       | RSP          |
| BP         | EBP       | RBP          |
| SI         | ESI       | RSI          |
| DI         | EDI       | RDI          |
| IP         | EIP       | RIP          |
| FLAGS      | EFLAGS    | RFLAGS       |

现代 x86-64 还增加了 `R8`～`R15` 等通用寄存器，以及 SIMD 向量寄存器 `XMM`、`YMM`、`ZMM`（具体取决于 CPU 支持的指令集）。

例如，RAX 内部的低位部分：

RAX 寄存器的兼容结构

因此，在现代 64 位 CPU 上，仍然可以使用 `AX`、`AH`、`AL`，但不能在所有指令和编码组合中任意混用。

## 三、如何在自己的 Windows 11 电脑上查看寄存器？

最推荐你使用 Visual Studio 2022，因为它可以直接观察每条汇编指令执行后寄存器如何变化。

[x64 Assembly | Brent’s Website](https://images.openai.com/static-rsc-4/skiMCTKbaey5yEcpMhROHLDlmYT7JfFcFCNhvi5JNHE6SA2jZVnqU3O_4iY0aLdZy4E8N5u1fPOmYijfw-pAxgHmOB-rziAE3b99lfj4h5Uy9WXPgQC8So4cWYmcEU2Xrds1GO8X6hNG-l0L6mt6OrgXkXfR6gYXcQFdifTxrqc?purpose=inline)

方法一：Visual Studio 2022

1. 创建 C++ 控制台项目，选择 x64 Debug。
2. 在 `main()` 内设置断点，按 F5。
3. 打开菜单 调试 → 窗口 → 寄存器（Registers）。
4. 按 F11 单步执行，观察 RAX、RBX、RIP 等值。

[x64dbg - Mastering Reverse Engineering \[Book\]](https://images.openai.com/static-rsc-4/ZMvH0n6SG_8jN228jh08T5TEOwXxdytMpwtR_HSJtDy0lswliSreObZk28uztBStLygg0x0YGG_6M64PmcPgwCIBt_jHRvSH6DS-TvZE6W8gAfrF7FaIWU2zFewcYiOqRVeaCzBWWjnbKPDvXdOJIVzlrwwpWVZwMTRLtoJxGag?purpose=inline)

方法二：x64dbg

专门用于观察 Windows x86/x64 程序的汇编指令、寄存器、内存和堆栈。

官网：[x64dbg.com](https://x64dbg.com/?utm_source=chatgpt.com)

可以单步执行并实时查看寄存器变化。

### 四、自己动手做一个实验

在 Visual Studio 中编译下面的 C++ 代码（x64）：

```
#include <cstdio>

int main()
{
    int a = 0x0123;
    int b = 0x0456;
    int c = a + b;
    c = c + c;

    printf("%d\n", c);
    return 0;
}
```

进入调试器，打开反汇编窗口和寄存器窗口，逐步观察编译器生成的指令。注意：编译器不一定使用 AX、BX 来保存 `a`、`b`，实际结果取决于编译模式和优化设置。

如果你想直接操作 CPU 寄存器，在 Windows x64 下可以使用 MASM 编写 `.asm` 文件，或者在 Linux 下用 GCC/Clang 内联汇编。

## 五、能不能查看 CPU 所有寄存器？

需要区分两个概念：

1\. 当前线程的寄存器

Visual Studio、x64dbg、GDB 能在程序暂停时查看当前线程的寄存器快照。切换线程后，看到的是另一个线程的上下文。

2\. 整个 CPU 的所有内部寄存器

普通程序无法直接查看所有 CPU 内部状态，例如部分控制寄存器、调试寄存器、模型专用寄存器（MSR）需要内核权限，而 CPU 的某些微架构内部状态根本不对软件公开。

另外，Windows 任务管理器和 CPU-Z 主要显示 CPU 型号、频率、核心数量和指令集支持情况，不是用来实时查看 AX、RAX、RIP 这些寄存器值的。

建议你下一步做这个实验： 在 Visual Studio 2022 中同时打开“反汇编”“寄存器”“内存”三个窗口，然后单步执行一段加法程序。这样就能直观看到王爽书里介绍的 CPU 指令、寄存器与内存之间的关系。
王爽《汇编语言》第 4 章主要讲的是 第一个程序。这一章演示 `mov`、`add`、`segment`、`assume`、`end` 等代码，并不是为了教你如何做加法，而是为了让你理解：汇编程序如何从源代码变成机器指令，最终由 CPU 执行。

## 一、为什么用这么简单的程序？

例如：

```
assume cs:codesg

codesg segment
    mov ax,0123h
    mov bx,0456h
    add ax,bx
    add ax,ax

    mov ax,4c00h
    int 21h
codesg ends

end
```

这个程序包含了一个完整汇编程序的基本要素。

| 代码                 | 作者想让你理解什么       |
| ------------------ | --------------- |
| `assume cs:codesg` | 汇编器如何关联段与段寄存器   |
| `codesg segment`   | 如何定义程序段         |
| `mov ax,0123h`     | 如何向 CPU 寄存器写数据  |
| `add ax,bx`        | CPU 如何执行运算      |
| `mov ax,4c00h`     | 如何准备 DOS 系统调用参数 |
| `int 21h`          | 如何请求操作系统结束程序    |
| `codesg ends`      | 段定义结束           |
| `end`              | 汇编源程序结束         |

注意：这里的 `int 21h` 是 DOS 环境中的接口，不是现代 Windows/Linux 应用程序通常使用的退出方式。

## 二、第 4 章真正要建立的知识链

1\. 编写汇编源程序

源文件 .asm

2\. 汇编器 MASM 编译

汇编指令 → 机器码，生成 .obj

3\. 链接器 LINK 链接

生成 DOS .exe 可执行文件

4\. DOS 加载程序到内存

设置初始 CS:IP、SS:SP 等运行环境

5\. CPU 取指令、译码、执行

修改 AX、BX、IP、FLAGS 等寄存器

这是第 4 章最核心的内容。

## 三、为什么反复演示 AX、BX、CS、IP？

因为作者想让你从 CPU 的角度理解程序，而不是只从高级语言的角度理解。

例如 C 语言：

```
int a = 10;
int b = 20;
int c = a + b;
```

在 C 语言中，你主要关心变量和运算结果。

但汇编语言要求你进一步理解：

- 数据放在哪里？寄存器还是内存？
- CPU 如何知道下一条指令的位置？
- CPU 执行 `add` 后，哪些寄存器发生变化？
- CPU 如何知道程序已经结束？
- 操作系统如何把程序加载到内存？

这些问题正是学习计算机体系结构、操作系统、编译器的基础。

## 四、第 4 章与现代 C/C++、Linux 有什么关系？

| 王爽书中的知识     | 现代系统编程中的对应知识                    |
| ----------- | ------------------------------- |
| `AX`、`BX`   | `RAX`、`RBX` 等 64 位寄存器           |
| `CS:IP`     | x86-64 的指令地址、RIP                |
| `segment`   | 可执行文件的段与节（概念相关但不完全相同）           |
| `mov`、`add` | 编译器生成的机器指令                      |
| `int 21h`   | DOS 系统调用接口                      |
| DOS EXE 加载  | Linux ELF / Windows PE 加载       |
| Debug 单步执行  | GDB / WinDbg / Visual Studio 调试 |

尤其当你用 GDB 调试 C/C++ 程序，看到：

```
mov eax, 10
add eax, 20
ret
```

就能够理解 CPU 实际执行的是什么，而不只是看到 C 源代码。

## 五、学习第 4 章，重点掌握什么？

我建议重点掌握这五件事：

1. 源程序结构：理解 `assume`、`segment`、`ends`、`end` 的作用。
2. 汇编与链接：理解 `.asm → .obj → .exe`。
3. 程序加载：理解 DOS 如何加载程序、设置 CS:IP。
4. 程序执行：通过 Debug 单步观察 AX、BX、CS、IP 的变化。
5. 程序退出：理解 `mov ax,4c00h` 和 `int 21h`。

至于 `0123H + 0456H` 这样的具体数字，并不重要。

第 4 章真正要回答的问题是：你写在文本文件里的几行汇编代码，究竟怎样变成 CPU 能执行的指令？

这是作者安排这些演示程序的主要目的，也是从“认识 CPU 指令”进入“编写完整程序”的关键一步。
