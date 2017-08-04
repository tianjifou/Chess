
##棋类游戏对战的实现

* 六洲棋
* 五子棋
* AI对战
* 蓝牙对战
* 在线对战




###六洲棋

六洲棋，又称：泥棋、插方、来马、五福棋，中国民间传统棋类体育形式。源于民间，简便、通俗、易学，在民间广为流行，深受社会底层大众的喜爱。龙其在淮河流域的安徽省、河南省、江苏省、以及湖北省、山东省非常普及，并流传到中国各地，包括港、澳、台地区。起源于劳动人民生活，根植于民间大众之中，它简捷、明快，趣味性、竞技性强，是一项长期流行于民间，富有传统文化色彩的竞技项目。对于启迪智慧，休闲娱乐，增进交流非常有益。列安徽省第二批省级非物质文化遗产。
6*6纵横线组成，共三十六个棋点。每方十八枚棋子，以两色区分敌我。


####规则

对弈过程分三阶段。（凤阳下法）放子：对弈双方依次将己子放入空棋点，将手上的棋子放完才开始走子。逼子：若无棋子被吃，使得棋子放满棋盘。则两人各选对方一枚敌子移出游戏。走子：由后手方开始轮流移动己棋，沿线直横线一格。吃子：无论是下子或走子阶段，只要己方棋子排成以下排列称为成城，就要吃掉一定数量的敌子，但不可吃掉已成城子的敌棋。在放子阶段，被吃的子先作记号，等走子阶段开始才一齐提取。
成六：六枚棋子以纵、横和斜3个方向连成直线(除了四条边的直线)。吃掉敌方三子。

![six](http://img.blog.csdn.net/20170803145822176?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbmppZm91/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![six_two](http://img.blog.csdn.net/20170803145840358?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbmppZm91/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

斜五：连子的2头都靠棋盘边缘，吃掉敌方两子。

![five](http://img.blog.csdn.net/20170803145906750?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbmppZm91/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

斜四：连子的2头都靠棋盘边缘，吃掉敌方一子。

![four](http://img.blog.csdn.net/20170803145922915?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbmppZm91/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

斜三：连子的2头都靠棋盘边缘，吃掉敌方一子。

![three](http://img.blog.csdn.net/20170803145939228?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbmppZm91/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

成方：四枚棋子组成一个紧邻相连的小正方形，吃掉敌方一子。


![check](http://img.blog.csdn.net/20170803150001736?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbmppZm91/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

使对方只剩下三枚以下则获胜。因为是民间文化，各地稍有差异。

棋型的算法实现

```swift
//是否形成斜子棋（三子棋，四子棋，五子棋，六子棋）
static func isXiZiChess(_ point:SWSPoint,_ chessArray: [[FlagType]]) ->  LianZhuState?{
let type = chessArray[point.x][point.y]
let pointLeft = SWSPoint()
let pointRight = SWSPoint()
let ponitTop = SWSPoint()
let pointBottom = SWSPoint()

// 东北方向
var i = 0
while point.x - i >= 0 && point.y + i <= 5 && chessArray[point.x - i][point.y + i] == type {
pointLeft.x = point.x - i
pointLeft.y = point.y + i
i += 1
}
i = 0
while point.x + i <= 5 && point.y - i >= 0 && chessArray[point.x + i][point.y - i] == type {
pointRight.x = point.x + i
pointRight.y = point.y - i
i += 1
}

//西北方向
i = 0
while point.x - i >= 0 && point.y - i >= 0 && chessArray[point.x - i][point.y - i] == type {
ponitTop.x = point.x - i
ponitTop.y = point.y - i
i += 1
}
i = 0
while point.x + i <= 5 && point.y + i <= 5 && chessArray[point.x + i][point.y + i] == type {
pointBottom.x = point.x + i
pointBottom.y = point.y + i
i += 1
}
print(pointRight.x,pointRight.y,pointLeft.x,pointLeft.y,ponitTop.x,ponitTop.y,pointBottom.x,pointBottom.y)
let arr = [3,2,1,0]
for index in arr {

func condition() -> Bool {
if pointRight.x == 2+index && pointRight.y == 0 && pointLeft.x == 0 && pointLeft.y == 2+index {
return true
}
if pointRight.x == 5  && pointRight.y == 3 - index && pointLeft.x == 3 - index && pointLeft.y == 5 {
return true
}
if ponitTop.x == 0 && ponitTop.y == 3-index && pointBottom.x == 2+index && pointBottom.y == 5 {
return true
}
if ponitTop.x == 3-index && ponitTop.y == 0 && pointBottom.x == 5 && pointBottom.y == 2+index {
return true
}
return false
}

if condition() {
switch index {
case 0:
return .threeChess
case 1:
return .fourChess
case 2:
return .fiveChess
case 3:
return .sixChess
default:()
}
}
}
return nil
}

//是否形成方格棋
static func isCheckChess(_ point:SWSPoint,_ chessArray: [[FlagType]]) ->LianZhuState? {
let type = chessArray[point.x][point.y]
//左上
if point.x - 1 >= 0 && point.y - 1 >= 0 && chessArray[point.x][point.y-1] == type &&
chessArray[point.x-1][point.y] == type && chessArray[point.x-1][point.y-1] == type {
return .checkChess
}
//左下
if point.x - 1 >= 0 && point.y + 1 <= 5 && chessArray[point.x][point.y+1] == type &&
chessArray[point.x-1][point.y] == type && chessArray[point.x-1][point.y+1] == type {
return .checkChess
}
//右上
if point.x + 1 <= 5 && point.y - 1 >= 0 && chessArray[point.x][point.y-1] == type &&
chessArray[point.x+1][point.y] == type && chessArray[point.x+1][point.y-1] == type {
return .checkChess
}
//右下
if point.x + 1 <= 5 && point.y + 1 <= 5 && chessArray[point.x][point.y+1] == type &&
chessArray[point.x+1][point.y] == type && chessArray[point.x+1][point.y+1] == type {
return .checkChess
}
return nil
}

```

####小结

六洲棋，在我们老家被称为泥棋，小时候经常玩的一种棋，偶有回忆，因此实现下这个游戏，望能找到个棋友没事玩玩，这种棋，玩法多种，很有趣。


###五子棋

五子棋五子棋是比较流行的棋类游戏了，玩法简单，基本上人人会玩，在此就不介绍游戏规则了。下面使用 swift实现五子棋这个游戏，主要实现AI算法，包括极大值极小值算法，深度搜索算法，估值函数，Alpha Beta 剪枝算法等等。

```swift
//横向五子连珠（除去四边线的五子连珠）
static func isFiveChess(_ point:SWSPoint,_ chessArray: [[FlagType]]) -> Bool {
let type = chessArray[point.x][point.y]
let pointLeft = SWSPoint()
let pointRight = SWSPoint()
let pointTop = SWSPoint()
let pointBottom = SWSPoint()
let pointLeft45 = SWSPoint()
let pointRight45 = SWSPoint()
let pointTop135  = SWSPoint()
let pointBottom135 = SWSPoint()
//东西方向
var i = 0
while point.x - i >= 0 && chessArray[point.x - i][point.y] == type {
pointLeft.x = point.x - i
i += 1
}
i = 0
while point.x + i <= 14 && chessArray[point.x + i][point.y] == type {
pointRight.x = point.x + i
i += 1
}

if pointRight.x - pointLeft.x == 4 && (pointLeft.y != 15 || pointLeft.y != 0){
return true
}
//南北方向
i = 0
while point.y - i >= 0 && chessArray[point.x][point.y-i] == type {
pointTop.y = point.y - i
i += 1
}
i = 0
while point.y + i <= 14 && chessArray[point.x][point.y+i] == type {
pointBottom.y = point.y + i
i += 1
}
if pointBottom.y - pointTop.y == 4 && (pointTop.x != 15 || pointTop.x != 0) {
return true
}

// 东北方向
i = 0
while point.x - i >= 0 && point.y + i <= 14 && chessArray[point.x - i][point.y + i] == type {
pointLeft45.x = point.x - i
pointLeft45.y = point.y + i
i += 1
}
i = 0
while point.x + i <= 14 && point.y - i >= 0 && chessArray[point.x + i][point.y - i] == type {
pointRight45.x = point.x + i
pointRight45.y = point.y - i
i += 1
}

if pointLeft45.y - pointRight45.y == 4{
return true
}

//西北方向
i = 0
while point.x - i >= 0 && point.y - i >= 0 && chessArray[point.x - i][point.y - i] == type {
pointTop135.x = point.x - i
pointTop135.y = point.y - i
i += 1
}
i = 0
while point.x + i <= 14 && point.y + i <= 14 && chessArray[point.x + i][point.y + i] == type {
pointBottom135.x = point.x + i
pointBottom135.y = point.y + i
i += 1
}
if pointBottom135.y - pointTop135.y == 4{
return true
}

return false
}

```

在 [demo](https://github.com/tianjifou/Chess)中实现了五子棋的AI、同机、蓝牙、在线对战，下面重点介绍AI对战。


####五子棋的AI算法实现

2017年互联网最火的技术毫无疑问就是AI了，在此尝试写了个算法来和人脑来pk。五子棋属于零和游戏：一方胜利代表另一方失败，而零和游戏的代表算法就是极大值极小值搜索算法。

####极大值极小值搜索算法

A、B二人对弈，A先走，A始终选择使局面对自己最有利的位置，然后B根据A的选择，在剩下的位置中选择对A最不利的位置，以此类推下去直到到达我们定义的最大搜索深度。所以每一层轮流从子节点选择最大值－最小值－最大值－最小值...

![这里写图片描述](http://img.blog.csdn.net/20170803144141913?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbmppZm91/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

我们如何知道哪个位置最有利和最不利呢？在此我们引入一套评估函数，来对棋盘上每个位置进行分数评估

```swift
//活一、活二、活三、活四、连五、眠一，眠二、眠三、眠四
enum FiveChessType:Int {
case liveOne = 0
case liveTwo
case liveThree
case liveFour
case liveFive
case sleepOne
case sleepTwo
case sleepThree
case sleepFour
case unknown
var score:Int  {
switch self {
case .unknown:
return un_known
case .sleepOne:
return sleep_One
case .liveOne,.sleepTwo:
return live_One
case .liveTwo,.sleepThree:
return live_Two
case .liveThree:
return live_Three
case .sleepFour:
return sleep_Four
case .liveFour:
return live_Four
case .liveFive:
return live_Five

}
}

}
let live_Five = 1000000
let live_Four = 100000
let sleep_Four = 10000
let live_Three = 1000
let live_Two = 100
let sleep_Three = 100
let live_One = 10
let sleep_Two = 10
let sleep_One = 1
let un_known = 0
```
在使用极大值极小值进行深度搜索时，遍历节点是指数增长的，如果不进行算法优化，将会导致电脑计算时间过长，影响下棋体验，所以这里引入 Alpha Beta 剪枝原理。

#### Alpha Beta 剪枝原理

AlphaBeta剪枝算法是一个搜索算法旨在减少在其搜索树中，被极大极小算法评估的节点数。
Alpha-Beta只能用递归来实现。这个思想是在搜索中传递两个值，第一个值是Alpha，即搜索到的最好值，任何比它更小的值就没用了，因为策略就是知道Alpha的值，任何小于或等于Alpha的值都不会有所提高。
第二个值是Beta，即对于对手来说最坏的值。这是对手所能承受的最坏的结果，因为我们知道在对手看来，他总是会找到一个对策不比Beta更坏的。如果搜索过程中返回Beta或比Beta更好的值，那就够好的了，走棋的一方就没有机会使用这种策略了。
在搜索着法时，每个搜索过的着法都返回跟Alpha和Beta有关的值，它们之间的关系非常重要，或许意味着搜索可以停止并返回。
如果某个着法的结果小于或等于Alpha，那么它就是很差的着法，因此可以抛弃。因为我前面说过，在这个策略中，局面对走棋的一方来说是以Alpha为评价的。
如果某个着法的结果大于或等于Beta，那么整个节点就作废了，因为对手不希望走到这个局面，而它有别的着法可以避免到达这个局面。因此如果我们找到的评价大于或等于Beta，就证明了这个结点是不会发生的，因此剩下的合理着法没有必要再搜索。
如果某个着法的结果大于Alpha但小于Beta，那么这个着法就是走棋一方可以考虑走的，除非以后有所变化。因此Alpha会不断增加以反映新的情况。有时候可能一个合理着法也不超过Alpha，这在实战中是经常发生的，此时这种局面是不予考虑的，因此为了避免这样的局面，我们必须在博弈树的上一个层局面选择另外一个着法。[链接](http://www.xqbase.com/computer/search_alphabeta.htm)

c代码实现原理

```c
int AlphaBeta(int depth, int alpha, int beta) 
{
if (depth == 0) 
{
return Evaluate();
}
GenerateLegalMoves();
while (MovesLeft()) 
{
MakeNextMove();
val = -AlphaBeta(depth - 1, -beta, -alpha);
UnmakeMove();
if (val >= beta) 
{
return beta;
}
if (val > alpha) 
{
alpha = val;
}
}
return alpha;
} 

```
实际在代码中的运用，代码比较复杂请结合项目理解。[项目地址](https://github.com/tianjifou/Chess)

```swift
static func getAIPoint(chessArray:inout[[FlagType]],role:FlagType,AIScore:inout [[Int]],humanScore:inout [[Int]],deep:Int) ->(Int,Int,Int)? {

let maxScore = 10*live_Five
let minScore = -1*maxScore
let checkmateDeep = self.checkmateDeep
var total=0, //总节点数
steps=0,  //总步数
count = 0,  //每次思考的节点数
ABcut = 0 //AB剪枝次数


func humMax(deep:Int)->(Int,Int,Int)? {
let points = self.getFiveChessType(chessArray: chessArray, AIScore: &AIScore, humanScore: &humanScore)
var bestPoint:[(Int,Int)] = []
var best = minScore
count = 0
ABcut = 0

for i in 0..<points.count {
let p = points[i]
chessArray[p.x][p.y] = role
self.updateOneEffectScore(chessArray: chessArray, point: (p.x,p.y), AIScore: &AIScore, humanScore: &humanScore)
var score = -aiMaxS(deep: deep-1, alpha: -maxScore, beta: -best, role: self.reverseRole(role: role))
if p.x < 3 || p.x > 11 || p.y < 3 || p.y > 11 {
score = score/2
}
if TJFTool.equal(a: Float(score), b: Float(best)){
bestPoint.append((p.x,p.y))
}
if TJFTool.greatThan(a: Float(score), b: Float(best)){
best = score
bestPoint.removeAll()
bestPoint.append((p.x,p.y))
}
chessArray[p.x][p.y] = .freeChess
self.updateOneEffectScore(chessArray: chessArray, point: (p.x,p.y), AIScore: &AIScore, humanScore: &humanScore)

}
steps += 1
total += count
if bestPoint.count > 0 {
let num = arc4random()%UInt32(bestPoint.count)
return (bestPoint[Int(num)].0,bestPoint[Int(num)].1,best)
}
return nil

}

func aiMaxS(deep:Int,alpha:Int,beta:Int,role:FlagType) -> Int{
var score = 0
var aiMax = 0
var humMax = 0
var best = minScore
for i in 0..<15{
for j in 0..<15{
if chessArray[i][j] == .freeChess{
aiMax = max(AIScore[i][j], aiMax)
humMax = max(humanScore[i][j], humMax)
}
}
}
score = (role == .blackChess ? 1 : -1) * (aiMax-humMax)
count += 1
if deep <= 0 || TJFTool.greatOrEqualThan(a: Float(score), b: Float(live_Five)){
return score
}
let points =  self.getFiveChessType(chessArray: chessArray, AIScore: &AIScore, humanScore: &humanScore)
for i in 0..<points.count{
let p = points[i]
chessArray[p.x][p.y] = role
self.updateOneEffectScore(chessArray: chessArray, point: (p.x,p.y), AIScore: &AIScore, humanScore: &humanScore)
let some = -aiMaxS(deep: deep-1, alpha: -beta, beta: -1 * ( best > alpha ? best : alpha), role: self.reverseRole(role: role)) * deepDecrease
chessArray[p.x][p.y] = .freeChess
self.updateOneEffectScore(chessArray: chessArray, point: (p.x,p.y), AIScore: &AIScore, humanScore: &humanScore)
if TJFTool.greatThan(a: Float(some), b: Float(best)) {
best = some
}
//在这里进行ab 剪枝
if TJFTool.greatOrEqualThan(a: Float(some), b: Float(beta)){
ABcut += 1
return some
}
}

if (deep == 2 || deep == 3 || deep == 4) && TJFTool.littleThan(a: Float(best), b: Float(sleep_Four)) && TJFTool.greatThan(a: Float(best), b: -(Float)(sleep_Four)){

if let result = self.checkmateDeeping(chessArray: &chessArray, role: role, AIScore: &AIScore, humanScore: &humanScore, deep: checkmateDeep) {
return Int(Double(result[0].2) * pow(0.8, Double(result.count)) * (role == .blackChess ? 1:-1))
}
}
return best
}

var i = 2
var result:(Int,Int,Int)?
while i <= deep {
if let test = humMax(deep: i) {
result = test
if TJFTool.greatOrEqualThan(a: Float(test.2), b: Float(live_Four)) {
return test
}
}
i += 2
}
if result == nil {
var maxAiScore = 0
for i in 0..<15{
for j in 0..<15 {
if chessArray[i][j] == .freeChess && maxAiScore < AIScore[i][j] {
maxAiScore = AIScore[i][j]
result = (i,j,maxAiScore)
}
}
}
}

return result
}
```
经过Alpha Beta剪枝后，优化效果应该达到 1/2 次方，也就是说原来需要遍历X^Y个节点，现在只需要遍历X^(Y/2)个节点，相比之前已经有了极大的提升。
不过即使经过了Alpha Beta 剪枝，思考层数也只能达到四层，也就是一个不怎么会玩五子棋的普通玩家的水平。而且每增加一层，所需要的时间或者说计算的节点数量是指数级增加的。所以目前的代码想计算到第六层是很困难的。
我们的时间复杂度是一个指数函数 X^Y，其中底数X是每一层节点的子节点数，Y 是思考的层数。我们的剪枝算法能剪掉很多不用的分支，相当于减少了 Y，那么下一步我们需要减少 X，如果能把 X 减少一半，那么四层平均思考的时间能降低到 0.5^4 = 0.06 倍，也就是能从10秒降低到1秒以内。
如何减少X呢？我们知道五子棋中，成五、活四、双三、双眠四、眠四活三是必杀棋，于是我们遇到后就不用再往下搜索了。代码如下：

```swift
static func getFiveChessType(chessArray:[[FlagType]],AIScore:inout [[Int]],humanScore:inout [[Int]]) ->[(x:Int,y:Int)]{
var twos:[(Int,Int)] = []
var threes:[(Int,Int)] = []
var doubleThrees:[(Int,Int)] = []
var sleepFours:[(Int,Int)] = []
var fours:[(Int,Int)] = []
var fives:[(Int,Int)] = []
var oters:[(Int,Int)] = []
for i in 0..<15{
for j in 0..<15{
if chessArray[i][j] == .freeChess && self.effectivePoint(chessArray: chessArray, point: (x: i, y: j)) {
let aiScore = AIScore[i][j]
let humScore = humanScore[i][j]
if aiScore>=live_Five {
return[(i,j)]
}else if humScore >= live_Five {
fives.append((i,j))
}else if aiScore >= live_Four {
fours.insert((i,j), at: 0)
}else if humScore >= live_Four {
fours.append((i,j))
}else if aiScore >= sleep_Four{
sleepFours.insert((i,j), at: 0)
}else if humScore >= sleep_Four{
sleepFours.append((i,j))
}else if aiScore >= 2*live_Three{
doubleThrees.insert((i,j), at: 0)
}else if humScore >= 2*live_Three{
doubleThrees.append((i,j))
}else if aiScore >= live_Three {
threes.insert((i,j), at: 0)
}else if humScore >= live_Three {
threes.append((i, j))
}else if aiScore >= live_Two{
twos.insert((i,j), at: 0)
}else if humScore >= live_Two{
twos.append((i,j))
}else {
oters.append((i,j))
}
}
}
}

if fives.count > 0 {
return [fives[0]]
}
if fours.count > 0 {
return fours
}
if sleepFours.count > 0{
return [sleepFours[0]]
}
if doubleThrees.count > 0{
return doubleThrees + threes
}
let result = threes + twos + oters
var realy:[(Int,Int)] = []
if result.count > limitNum {
realy += result.prefix(limitNum)
return realy
}
return result
}
```

五子棋是一种进攻优势的棋，依靠连续不断地活三或者冲四进攻，最后很容易会形成必杀棋，所以在进行深度搜索时，我们另开一种连续进攻的搜索，如果，电脑可以依靠连续进攻获得胜利，我们可以直接走这条路劲。这条路劲，其实也是极大值极小值搜索算法的一种，只不过是只考虑活三冲四这两种棋型，指数的底数较小，搜索的节点比较少，因此是效率很高的算法。代码如下：

```swift
//优先考虑ai成五
static func findMaxScore(chessArray:[[FlagType]],role:FlagType,aiScore:[[Int]],humanScore:[[Int]],score:Int)->[(Int,Int,Int)]{
var result:[(Int,Int,Int)] = []
for i in 0..<15{
for j in 0..<15{
if chessArray[i][j] == .freeChess {
if self.effectivePoint(chessArray: chessArray, point: (i,j),chessCount: 1) {
let score1 =  role == .blackChess ?  aiScore[i][j] : humanScore[i][j]
if score1 >= live_Five {
return [(i,j,score1)]
}
if score1 >= score {
result.append((i,j,score1))

}
}
}
}
}
return  result.sorted { (a, b) -> Bool in
return b.2 > a.2
}

}
//考虑活三，冲四
static func findEnemyMaxScore(chessArray:[[FlagType]],role:FlagType,aiScore:[[Int]],humanScore:[[Int]],score:Int)->[(Int,Int,Int)]{
var result:[(Int,Int,Int)] = []
var fours:[(Int,Int,Int)] = []
var fives:[(Int,Int,Int)] = []
for i in 0..<15{
for j in 0..<15{
if chessArray[i][j] == .freeChess {
if  self.effectivePoint(chessArray: chessArray, point: (i,j),chessCount: 1) {
let score1 =  role == .blackChess ?  aiScore[i][j] : humanScore[i][j]
let score2 = role == .blackChess ?  humanScore[i][j] : aiScore[i][j]
if score1 >= live_Five {
return [(i,j,-score1)]
}
if score1 >= live_Four {
fours.insert((i,j,-score1), at: 0)
continue
}
if score2 >= live_Five {
fives.append((i,j,score2))
continue
}
if score2 >= live_Four{
fours.append((i,j,score2))
continue
}
if score1 > score || score2 > score {
result.append((i,j,score1))
}
}
}
}
}
if fives.count > 0 {
return [fives[0]]
}
if fours.count > 0 {
return [fours[0]]
}
return  result.sorted { (a, b) -> Bool in
return abs(b.2) > abs(a.2)
}
}
```

####小结
本次编写的AI还是比较强的，我胜利的机会很少，但还是存在赢的时候，因此AI算法还存在漏洞，主要表现在评分标准不准确和搜索深度不够问题上，如何优化评分标准和搜索算法，是实现AI无敌的关键工作。
另外，在增加搜索深度的同时，遍历的节点指数增长，计算时间增长，可以结合哈希算法，保存每次的棋盘评分，一定程度上提高计算时间，这也只是治标不治本的做法。

###蓝牙对战
####MultipeerConnectivity框架的使用
MultipeerConnectivity通过WiFi、P2P WiFi以及蓝牙个人局域网进行通信的框架，从而无需联网手机间就能传递消息。其原理是通过广播作为服务器去发现附近的节点，每个节点都以设备名称为标识。

```swift
myPeer = MCPeerID.init(displayName: UIDevice.current.name)
session = MCSession.init(peer: myPeer!, securityIdentity: nil, encryptionPreference: .none)
session?.delegate = self
```
MCSession的几个代理方法必须实现，否则无法建立连接

```swift
//监听连接状态
func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
switch state {
case .notConnected:
print("未连接")
case .connecting:
print("正在连接中")
case .connected:
print("连接成功")
}
}

//发送Dada数据
func sendData(_ messageVo: GPBMessage, successBlock:(()->())?,errorBlock:((NSError)->())?) {
guard let session = session else {
return
}
guard let data = NSDataTool.shareInstance().returnData(messageVo, messageId: 0) else {return}

do {
try session.send(data as Data , toPeers: session.connectedPeers, with: .reliable)
}catch let error as NSError {
errorBlock?(error)
return
}
successBlock?()
}

//接收到的Data数据
func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
// 解析出过来的data数据包
NSDataTool.shareInstance().startParse(data) { (gpbMessage) in
self.getMessageBlock?(gpbMessage)
}

}
//接收到的流数据
func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
print("streamName")
}
//接收到的文件类型数据
func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
print("resourceName")
}
//接收到的文件类型数据，可将文件换路劲
func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {

}
```


我们通过MCAdvertiserAssistant（广播）开启搜索服务

```swift
advertiser = MCAdvertiserAssistant.init(serviceType: serviceStr, discoveryInfo: nil, session: session!)
//发出广播
advertiser?.start()
advertiser?.delegate = self
```
MCBrowserViewControllerDelegate代理方法

```swift
/// 发出广播请求
func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
print("advertiserAssistantWillPresentInvitation")
}
/// 结束广播请求
func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
print("advertiserAssistantDidDismissInvitation")
} 
```
设置蓝牙连接页面，显示效果如图所示：


```swift
func setupBrowserVC() {
guard let session = session else {
return
}
browser = MCBrowserViewController.init(serviceType: serviceStr,  session: session)
browser?.delegate = self
}
```
![image](http://img.blog.csdn.net/20170731144916348?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbmppZm91/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

实现MCBrowserViewControllerDelegate代理方法

```swift
func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
print("蓝牙连接完成")
browser?.dismiss(animated: true, completion: { [weak self] in
self?.browserBlock?()

})

}

func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
print("取消蓝牙连接")
browser?.dismiss(animated: true, completion: nil)
}
```

####小结
使用蓝牙技术进行传输数据，尽管不需要连接网络服务，但是真实因为这样存在着许多安全隐患，为此我们引入Google Protobuf框架进行数据传输。下章会对该技术的运用进行详解。

###protobuf在iOS中的运用

protocolbuffer(以下简称protobuf)是google 的一种数据交换的格式，它独立于语言，独立于平台。google 提供了多种语言的实现：java、c#、c++、oc、go 和 python，每一种实现都包含了相应语言的编译器以及库文件。由于它是一种二进制的格式，比使用 xml和json 进行数据交换快许多。可以把它用于分布式应用之间的数据通信或者异构环境下的数据交换。作为一种效率和兼容性都很优秀的二进制数据传输格式，可以用于诸如网络传输、配置文件、数据存储等诸多领域。
我们重点介绍protobuf在iOS中的运用，[官方文档](https://github.com/google/protobuf/tree/master/objectivec)

####protobuf使用步骤
* 定义.proto文件
* 配置protobuf环境
* 映射相应语言的文件
* 导入第三方库protobuf

####.proto文件的定义
该文件主要是用来作为你传递数据的数据结构的文档，然后通过终端命令生成我们相应语言的model类，导入项目中使用。
.proto的定义语法有[官方文档](https://developers.google.com/protocol-buffers/docs/proto3)自己学习，在此不过多介绍，在此一定要注意的是，一定要使用proto3来定义，proto2已经在很多第三方库中被淘汰使用(以前用的都是proto2，Proto3出来并不了解，报错信息一度让我怀疑人生)。定义文件类似下图所示：

![这里写图片描述](http://img.blog.csdn.net/20170731150406217?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbmppZm91/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

####配置protobuf环境
使用homebrew进行配置（如果没安装，自己谷歌安装）

*  brew install automake
*  brew install libtool
*  brew install protobuf
*  ln -s /usr/local/Cellar/protobuf/(上步中安装protobuf的版本号)/bin/protoc /usr/local/bin
*  git clone https://github.com/alexeyxo/protobuf-objc.git（oc版本）或者
git clone https://github.com/alexeyxo/protobuf-swift.git（swift版本）
*  cd protobuf-objc
*  ./autogen.sh
*  ./configure CXXFLAGS=-I/usr/local/include LDFLAGS=-L/usr/local/lib
*  make install   

####映射相应语言的文件

* cd 到.proto文件的路劲中
* protoc --plugin=/usr/local/bin/protoc-gen-objc test.proto --objc_out=.  
此为生成oc类的命令，其中test.proto是自己生成的proto文件的名字。相应swift类的命令为：
protoc --plugin=/usr/local/bin/protoc-gen-swift test.proto --swift_out=.
* 将生成的文件导入项目中

####导入第三方库protobuf
这里建议使用pod管理：pod 'Protobuf'

####Protobuf库的使用
一般就是将Data类型的数据映射成model和将model生成data类型数据两个方法，他们分别是
使用GPBMessage中的俩个方法

```swift

+ (instancetype)parseFromData:(NSData *)data error:(NSError **)errorPtr {
return [self parseFromData:data extensionRegistry:nil error:errorPtr];
}

- (nullable NSData *)data;

```

####小结
使用protobuf传输还是存在安全问题和数据比较大时的耗能问题，于是我们想到了，在直播领域应用很普遍的RTMP协议。下章详细讲解，使用分包思想拆解数据包进行数据传输。

###RTMP协议蓝牙传输数据

####RTMP传统定义

rtmp协议中基本的数据单元被称为消息（message）结构一般为：

* 时戳：4  byte，单位毫秒。超过最大值后会翻转。
* 长度：消息负载的长度。
* 类型ID：Type Id 一部分ID范围用于rtmp的控制信令。还有一部分可以供上层使用，rtmp只是透           传。这样可以方便的在rtmp上进行扩展。
* 消息流ID：Message Stream ID，用于区分不同流的消息。

![这里写图片描述](http://img.blog.csdn.net/20170731153809255?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdGlhbmppZm91/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

消息在网络中传输时，会被分割成很多小的消息块，进行传输，增加传输的效率，而这些消息块是由消息头+消息体组成，消息头就是制定的标识消息的协议，消息体就是所传输的消息内容。

####RTMP在蓝牙中的定义

手机蓝牙传输数据，无法保证双方手机时间同步，因此刨除时间戳定义改为固定字符串，因此messageHeader定义为：

```oc
struct message_header
{
uint32_t magic;//magic number, 0x98765432
uint32_t total;//包长度，从这一字段头算起
uint32_t msgid;//消息ID
uint32_t seqnum;//客户端使用,自增量
uint32_t version;//协议版本，目前为1

};

```



将需要传输的数据添加message_header

```oc
//GPBMEssage为protobuf库里的类,请参考上篇文章
-(NSMutableData*)returnData:(GPBMessage*)req messageId:(int)messageId {
NSString *header=[NSString stringWithFormat:@"98765432%08lx%08x%08lx00000001",(unsigned long)req.data.length+20,messageId,(unsigned long)++self.header_count];
Byte bytes[40];
int j=0;
for(int i=0;i*2+1<header.length;i++)
{
int int_ch;  /// 两位16进制数转化后的10进制数
const char* hex_char=[[header substringWithRange:NSMakeRange(i*2, 2)] UTF8String];
int_ch = (int)strtoul(hex_char, 0, 16);
//        DLog(@"int_ch=%d",int_ch);
bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
j++;
}
NSMutableData *data = [[NSMutableData alloc] init];
[data appendBytes:bytes length:j];
[data appendData:req.data];
return data;
}
```
接受到数据后，需要把长度小于message_header长度的数据进行拼包，并解析message_header结构

```oc
//解析数据message_header结构
-(void)parseSocketReceiveData:(NSData*)data result:(void (^)(NSData*result ,int messageId,int hearderId))resultBlock finish:(void(^)())finishBlockMessage{

if (_halfData.length>0) {
[_halfData appendData:data];
data=[_halfData copy];
_halfData =[[NSMutableData alloc]init];
}else{
data=[data copy];
}

if (data.length<20) {
[_halfData appendData:data];
if (finishBlockMessage) {
finishBlockMessage();
}
return;
}
Byte *testByte = (Byte*)[data bytes];

int length=(int) ((testByte[4] & 0xFF<<24)
| ((testByte[5] & 0xFF)<<16)
| ((testByte[6] & 0xFF)<<8)
| ((testByte[7] & 0xFF)));

int messageId=(int) ((testByte[8] & 0xFF<<24)
| ((testByte[9] & 0xFF)<<16)
| ((testByte[10] & 0xFF)<<8)
| ((testByte[11] & 0xFF)));
int headerId=(int)((testByte[12] & 0xFF<<24)
| ((testByte[13] & 0xFF)<<16)
| ((testByte[14] & 0xFF)<<8)
| ((testByte[15] & 0xFF)));
if(length==data.length){
if (resultBlock) {
resultBlock([data subdataWithRange:NSMakeRange(20, length-20)],messageId,headerId);
}
if (finishBlockMessage) {
finishBlockMessage();
}
}else if(length<data.length){
if (resultBlock) {
resultBlock([data subdataWithRange:NSMakeRange(20, length-20)],messageId,headerId);
}
[self parseSocketReceiveData:[data subdataWithRange:NSMakeRange(length, data.length-length)] result:resultBlock finish:            finishBlockMessage];
}else{

[_halfData appendData:data];
if (finishBlockMessage) {
finishBlockMessage();
}
}
}
```

####小结

rtmp协议虽然加快了数据传输的效率，一定程度上的安全，但是并不是特别的安全，为避免攻击者攻击，一些安全措施还是有必要的，在这里不过多介绍，有兴趣自己调研。

###在线对战

IM采用的是环信SDK，环信作为免费的socket服务，相对已经很好了，功能也挺全面，但是，如果作为严谨的功能开发，他所暴露出来的api是远远不够的，如传输的数据必须是它定好的结构，虽然有个自定义字典可以传输但是，这个字典也是仅仅限于几种数据类型（做主要的DATA类型不接受）。[导入SDK官方文档](http://docs.easemob.com/im/300iosclientintegration/20iossdkimport)

####环信的主要用到的API
环信的主要用到的API需要实现的代理

```swift
//在初始化是设置代理
private override init() {
super.init()
EMClient.shared().add(self, delegateQueue: nil)
EMClient.shared().chatManager.add(self, delegateQueue: nil)
EMClient.shared().contactManager.add(self, delegateQueue: nil)
EMClient.shared().groupManager.add(self, delegateQueue: nil)
EMClient.shared().roomManager.add(self, delegateQueue: nil)

}  
//在对象释放时，释放代理对象
deinit {
EMClient.shared().removeDelegate(self)
EMClient.shared().chatManager.remove(self)
EMClient.shared().contactManager.removeDelegate(self)
EMClient.shared().groupManager.removeDelegate(self)
EMClient.shared().roomManager.remove(self)
}

```
实现登录异常的代理：服务器断开，开启定时器定时重连（环信并没有给出重连的api，我发现调用环信的需要连接服务器的api，sdk会自动重连服务器，所以断开服务器，定时调用上传错误日志的api，机制吧。）

```swift
extension ChatHelpTool: EMClientDelegate{
//主要处理断开服务器重连机制
func connectionStateDidChange(_ aConnectionState: EMConnectionState) {
networkState?(aConnectionState)
switch aConnectionState {
case EMConnectionConnected:
print("服务器已经连上")
if reconnectTimer != nil {
reconnectTimer.invalidate()
reconnectTimer = nil
}

case EMConnectionDisconnected:
print("服务器已断开")
if reconnectTimer != nil {
reconnectTimer.invalidate()
reconnectTimer = nil
}

DispatchQueue.global().async {
self.reconnectTimer = Timer.weak_scheduledTimerWithTimeInterval(2, selector: { [weak self] in
self?.reconnectNetwork()

}, repeats: true)
self.reconnectTimer.fire()
RunLoop.current.add(self.reconnectTimer, forMode: RunLoopMode.defaultRunLoopMode)
RunLoop.current.run()
}



default:
()
}
}

func autoLoginDidCompleteWithError(_ aError: EMError!) {
if let error = aError {
TJFTool.errorForCode(code: error.code)
TJFTool.loginOutMessage(message: "自动登录失败，请重新登录。")
}else {
PAMBManager.sharedInstance.showBriefMessage(message: "自动登录成功")
}
}
//异地登录
func userAccountDidLoginFromOtherDevice() {
TJFTool.loginOutMessage(message: "该账号在其他设备上登录,请重新登录。")
}

func userAccountDidRemoveFromServer() {
TJFTool.loginOutMessage(message: "当前登录账号已经被从服务器端删除,请重新登录")
}

func userDidForbidByServer() {
TJFTool.loginOutMessage(message: "服务被禁用,请重新登录")
}
}
```
实现发送消息的方法：因为是自定义的数据结构，所以使用消息的扩展，自定义字典传递数据。

```swift
//发送消息
extension ChatHelpTool {
// 定义消息model EMMessage
static func sendTextMessage(text:String,toUser:String,messageType:EMChatType,messageExt:[String:Any]?) ->EMMessage?{
let body = EMTextMessageBody.init(text: text)
let from = EMClient.shared().currentUsername
let message  = EMMessage.init(conversationID: toUser, from: from, to: toUser, body: body, ext: messageExt)
message?.chatType = messageType
return message
}
//发送消息
static  func senMessage(aMessage:EMMessage,progress aProgressBlock:(( _ progres: Int32)->())?,completion aCompletionBlock:((_ message:EMMessage?,_ error:EMError?)->())?) {

DispatchQueue.global().async {
EMClient.shared().chatManager.send(aMessage, progress: aProgressBlock,completion:aCompletionBlock)
}

}
}
```
实现接收消息的代理

```swift
extension ChatHelpTool: EMChatManagerDelegate{
//会话列表发生变化<EMConversation>
func conversationListDidUpdate(_ aConversationList: [Any]!) {
print("会话列表发生变化")
}
//收到消息
func messagesDidReceive(_ aMessages: [Any]!) {
aMessages.forEach { (message) in
if let message = message as? EMMessage {

if  let data = message.ext as? [String:Any] {
let model = MessageModel.init(dictionary: data)
if model.gameType == "1" {
self.letterOfChallengeAction(["userName":message.from,"message":(model.challengeList?.message).noneNull,"chessType":model.chessType.noneNull])

}else if model.gameType == "2" {
var role:Role = .blacker
var gameType:GameType = .LiuZhouChess
if model.chessType == "1" {
role = .whiter
gameType = .fiveInRowChess
}
TJFTool.pushToChessChatRoom(message.from,role,chessType: gameType)

}else {
self.buZiChessMessage?(message)
}
}

}
}
}
//收到已读回执
func messagesDidRead(_ aMessages: [Any]!) {
print("收到已读回执")
}
//收到消息送达回执
func messagesDidDeliver(_ aMessages: [Any]!) {
print("收到消息送达回执")
aMessages.forEach { (message) in
if let message = message as? EMMessage {
if  let data = message.ext as? [String:Any] {
let model = MessageModel.init(dictionary: data)
if model.gameType == "3" {

}
}
print(message.messageId)
print(TJFTool.timeWithTimeInterVal(time: message.timestamp),TJFTool.timeWithTimeInterVal(time: message.localTime))

}
}
}
//消息状态发生变化
func messageStatusDidChange(_ aMessage: EMMessage!, error aError: EMError!){
print("消息状态发生变化")
}

}
```

####小结

IM在没有服务器的情况下，使用第三方免费的最方便，但是同时并不能满足产品的需求，有机会，我会为大家分享一篇自定义socket服务器下的即时通信结构和逻辑的设定。


###最后

[简书地址](http://www.jianshu.com/p/42b75506ba5f)
[CSDN地址](http://blog.csdn.net/tianjifou/article/details/76619797)
代码中具体实现了两个棋类游戏（有时间会持续添加游戏种类），包括在线对战，人机对战（算法不错哦），蓝牙对战。
代码编写不易，喜欢的请点赞，谢谢！
