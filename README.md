# mips 流水线cpu

在单周期示例代码的基础上进行修改，实现了对数据冒险与控制冒险的处理。

### 参考资料

计算机组成与设计（硬件/软件接口）（原书第5版）中文版

### 实现指令

add/sub/and/or/slt/sltu/addu/subu/addi/ori/lw/sw/beq/j/jal/sll/nor/lui/slti/bne/andi/srl/sllv/srlv/jr/jalr

### 处理方式

1. 数据冒险处理部分采用旁路与阻塞的方式实现。

2. 控制冒险处理部分在ID级判断是否跳转，假如检测到跳转需要的寄存器的值还未更新则会自动阻塞，并在跳转的时候清除IF/ID寄存器的值。

### 使用方法

- 使用SIMtop和final内的Verilog文件可以在modelsim中进行仿真。

- 使用FPGAtop和final内的Verilog文件与引脚配置文件可以下载到FPGA开发板上进行实验。
