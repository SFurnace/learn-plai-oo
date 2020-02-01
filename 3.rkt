#lang racket/base

#|

我觉得这本书第三章讲得有点问题，我比较喜欢以下对ADT的定义（EoPL）：

Data abstraction divides a data type into two pieces:
an interface and an implementation. The interface tells
us what the data of the type represents, what the
operations on the data are, and what properties these
operations may be relied on to have. The implementation
provides a specific representation of the data and code
for the operations that make use of that data representation.

A data type that is abstract in this way is said to be an
abstract data type. The rest of the program, the client of
the data type, manipulates the new data only through the
operations specified in the interface. Thus if we wish
to change the representation of the data, all we must do
is change the implementation of the operations in the interface.

因此ADT与Object不是同一类技术，并不能比较。
可以用Object的方式实现ADT，也可以使用Constructor+Observer的方式。
本书中的比较其实是这两种方式的比较。（况且这两种方式也没有本质上的不同）

使用Constructor+Observer的方式时,不同实现之间其实不能直接共存。
对于一种实现,引入新的接口方法很容易,也比较好进行优化。

使用Object的方式时，函数调用变成了消息派发，很容易引入新实现。
但实现的种类变多之后，增加新的接口方法会相应变麻烦。

总之，就可扩展性而言
增加新接口方法的难度与实现的数量成正比
增加新实现的难度与接口方法的数量成正比

书中模糊地对OOP做了定义 “Any programming model that allows
inspection of the representation of more than one abstraction
at a time is NOT object oriented”，沿着这个定义去思考。
这样也不是不行啦……但是遵循这种定义好像没什么卵用……

|#
