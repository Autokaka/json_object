## [0.1.0]

## 任务清单(持续拓展中)

目前还没有非常明确后续对这个插件的拓展方向. 我的初衷是使开发 app 过程中的 model 层完全消失, 为此我们目前需要实现:

- [x] 核心功能, json 转 object. 使用 value = json.key 或者 value = json[index]的方式访问类的成员.
- [x] object 重新转 string. 不是很难, 几小时就能做好.
- [x] ~~实现 Map 和 List 的基础方法封装, 使得能更高效地操作 JsonObject. 具体实现准备直接参考 Map 和 List 有关接口.~~ 考虑到需要实现的接口过多, 现采用appy的方式, 将内部数据转为确定的类型传递出来后进行操作, 最后再返还回去.
- [ ] 默认封装一个统一的 JsonObject 规范. 这个规范在前期将直接写死, 后期可以由开发者自己设定, 用于每个开发团队不同场景下能够适配属于自己的 JsonObject.
- [ ] 创建一个 model 和 JsonObject 的成员关联, 削弱由 dynamic 造成的类型弱化问题. 做点和 JavaScript 里不一样的.
