# 三角棋(Triangular Nim)

棋盤是由 15 個圓圈所構成。

```
    O
   O O
  O O O
 O O O O
O O O O O
```

玩家使用筆輪流進行消除圓圈，一筆畫直線可以畫 1～3 顆。

畫下最後一顆的玩家就輸了。

# Environment 介紹

```
    1
   2 3
  4 5 6
 7 8 9 A
B C D E F
```

本環境使用一個 int 代表遊戲狀態(state)，使用 15 個 bit 分別表示 15 個圓圈是否被消除。

使用 0 代表未消除，1 代表已消除。

依照上圖所示，初始遊戲狀態值為 0。

state 值為 1，代表位於 1 的圓圈已消除，其他圓圈則是未消除。

state 值為 2，代表位於 2 的圓圈已消除，其他圓圈則是未消除。

state 值為 3，代表位於 1 和 2 的圓圈已消除，其他圓圈則是未消除。

state 值為 4，代表位於 3 的圓圈已消除，其他圓圈則是未消除。

以此類推，當 state 值為 32767 (0b111111111111111) 時，遊戲結束。

在 Environment 類別中提供了幾個轉換方法：

```
Environment::positions_to_state('123')
# => 7  (0b111)

Environment::positions_to_binarys('123')
# => "111000000000000"

Environment::state_to_positions(7)
# => "123"
```
在實作 Agent 時可搭配使用。

# Agent 的實作

Agent 需要實作 move 方法。

move 方法的輸入是 state 和當下可用的所有 action。

Agent 必須傳回其中一個 action 作為這次的行動。

state 以及 action 都是以 int 的形式傳遞，若需要顯示 positions 或是 binarys ，可以使用上述的方法來做轉換。

在遊戲結束時，Agent 可以從 receive_reward 獲得來自環境的回饋，若是 1 代表贏， -1 代表輸。