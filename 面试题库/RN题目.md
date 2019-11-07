## 组件的生命周期


组件装载，组件在渲染之前，会先调用默认的props，ES6就是，static defaultProps；接下来就是组件初始化，constructor（props）组件的构造方法；接下来是 componentWillMount组件在加载之前的方法；render完成组件的渲染；componentDidMount 组件渲染完成。接下来就进入运行阶段啦。（一次调用）

组件更新，在运行中，如果组件的属性发生了改变，就会调用 componentWillReceiveProps 会被调用，然后就会调用   
shouldComponentUpdate ，询问我们是否要渲染组件，如果返回FALSE的话，就不会渲染；如果是TRUE的话，就会调用componentWillUpdate重新渲染组件，然后render，再后来就完成更新啦componentDidUpdate（多次调用）

组件卸载，页面关闭的时候，组件会被卸载，componentWillUnmount，可以完成资源的回收与释放啦。（一次调用）


## state 和 props 区别

```
状态机制 & 属性

```

## 传入setState函数的第二个参数作用是什么

set方法调用刷新完毕后回调

该函数会在setState函数调用完成并且组件开始重渲染的时候被调用，我们可以用该函数来监听渲染是否完成：
```
this.setState(
  { username: 'tylermcginnis33' },
  () => console.log('setState has finished and the component has re-rendered.')
)
```
## 从setState到UI刷新经历怎样的流程？


在代码中调用setState函数之后，React 会将传入的参数对象与组件当前的状态合并，然后触发所谓的调和过程（Reconciliation）。
经过调和过程，React 会以相对高效的方式根据新的状态构建 React 元素树并且着手重新渲染整个UI界面。
在 React 得到元素树之后，React 会自动计算出新的树与老树的节点差异，然后根据差异对界面进行最小化重渲染。
在差异计算算法中，React 能够相对精确地知道哪些位置发生了改变以及应该如何改变，这就保证了按需更新，而不是全部重新渲染。


## FLatList优化


getItemLayout 
可选优化项。但是实际测试中，如果不做该项优化，性能会差很多。所以强烈建议做此项优化！

如果不做该项优化，每个列表都需要事先渲染一次，动态地取得其渲染尺寸，然后再真正地渲染到页面中。
如果预先知道列表中的每一项的高度(ITEM_HEIGHT)和其在父组件中的偏移量(offset)和位置(index)，就能减少一次渲染。这是很关键的性能优化点。
 getItemLayout={(data, index) => (
   {length: ITEM_HEIGHT, offset: ITEM_HEIGHT * index, index}
 )}

FlatList 之所以节约内存、渲染快，是因为它只将用户看到的(和即将看到的)部分真正渲染出来了。而用户看不到的地方，渲染的只是空白元素。渲染空白元素相比渲染真正的列表元素需要内存和计算量会大大减少，这就是性能好的原因。
FlatList 将页面分为 4 部分。初始化部分/上方空白部分/展现部分/下方空白部分。初始化部分，在每次都会渲染；当用户滚动时，根据需求动态的调整(上下)空白部分的高度，并将视窗中的列表元素正确渲染出来。

## ref是什么？

Refs是React提供给我们安全的访问DOM元素或者某个组件实例的句柄,我们可以为元素添加ref属性然后在回调函数中接收该元素在DOM树中的句柄,该值会作为回调函数的第一个参数的返回.

## RN中this所引起的undefined is not an object错误

```
构造方法中添加bind方法
```

## 子组件如何通信
```
一般是控制子组件的显示状态，可以用改变props，或者调用子组件的方法进行。
子组件事件传递给父组件回调就好
```
## 兄弟组件之间如何通信
```
事件用DeviceEventEmitter、数据传递刷新等用Redux、数据库
```

## 如何设计一个好的组件

这道题目中的“组件”不仅限于React组件，广义上看，前端代码模块，独立类库甚至函数在编写时都应该遵循良好的规则。
怎样的组件设计算的上“好”，要从几个层次来看这个问题。我们从宏观到微观依次来看。
首先你要知道组件的出现是为了解决怎样的问题——是为了更好的复用。然而怎样才能能其他的使用者更好的复用你的组件？API够烂肯定不行，这样的话其他人就没法调用；兼容性差也不行，因为同一个系统中可能存在不同版本React编写的组件，甚至还可能和Vue组件发生交互；内部实现差了也不行，这样的话你的下一任接替你职位的人修改起来会非常麻烦，结果不外乎重写。


## 使用过哪些状态管理库（Redux、Vuex）？  如果你使用过Redux与Vuex的话，聊聊他们的区别与你的心得？

## redux有什么缺点

1.一个组件所需要的数据，必须由父组件传过来，而不能像flux中直接从store取。

2.当一个组件相关数据更新时，即使父组件不需要用到这个组件，父组件还是会重新render，可能会有效率影响，或者需要写复杂的shouldComponentUpdate进行判断。

## 和后台进行交互数据进行如何处理

## 和原生通信

## react性能优化是哪个周期函数？

shouldComponentUpdate 这个方法用来判断是否需要调用render方法重新描绘dom。因为dom的描绘非常消耗性能，如果我们能在shouldComponentUpdate方法中能够写出更优化的dom diff算法，可以极大的提高性能。

[汇总](https://blog.csdn.net/qq_42483967/article/details/81015878)
