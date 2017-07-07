//
//  test.hpp
//  TianJiFouChess
//
//  Created by 天机否 on 2017/6/19.
//  Copyright © 2017年 tianjifou. All rights reserved.
//

#ifndef test_hpp
#define test_hpp

#include <stdio.h>

#endif /* test_hpp */
#include <cstdlib>
#include <iostream>
#include<stdlib.h>
#include<string.h>
#include<time.h>
#define GRID_NUM    15 //每一行(列)的棋盘交点数
#define GRID_COUNT  225//棋盘上交点总数
#define BLACK        0 //黑棋用0表示
#define WHITE        1 //白棋用1表示
#define NOSTONE     '+'  //没有棋子
//这组宏定义了用以代表几种棋型的数字
#define STWO        1  //眠二
#define STHREE        2  //眠三
#define SFOUR        3  //冲四
#define TWO        4  //活二
#define THREE        5  //活三
#define FOUR        6  //活四
#define FIVE        7  //五连
#define NOTYPE        11 //未定义
#define ANALSISED   255//已分析过的
#define TOBEANALSIS 0  //已分析过的
//这个宏用以检查某一坐标是否是棋盘上的有效落子点
#define IsValidPos(x,y) ((x>=0 && x<GRID_NUM) && (y>=0 && y<GRID_NUM)
//定义了枚举型的数据类型，精确，下边界，上边界
enum ENTRY_TYPE{exact,lower_bound,upper_bound};
//哈希表中元素的结构定义
typedef struct HASHITEM
{
    __int64_t checksum;         //64位校验码
    ENTRY_TYPE entry_type;//数据类型
    short depth;         //取得此值时的层次
    short eval;         //节点的值
}HashItem;

typedef struct Node
{
    int x;
    int y;
}POINT;

//用以表示棋子位置的结构
typedef struct _stoneposition
{
    unsigned char x;
    unsigned char y;
}STONEPOS;

typedef struct _movestone
{
    unsigned char nRenjuID;
    POINT ptMovePoint;
}MOVESTONE;
//这个结构用以表示走法

typedef struct _stonemove
{
    STONEPOS StonePos;//棋子位置
    int Score;         //走法的分数
}STONEMOVE;
//=================================================================//
int AnalysisLine(unsigned char* position,int GridNum,int StonePos);
int AnalysisRight(unsigned char position[][GRID_NUM],int i,int j);
int AnalysisLeft(unsigned char position[][GRID_NUM],int i,int j);
int AnalysisVertical(unsigned char position[][GRID_NUM],int i,int j);
int AnalysisHorizon(unsigned char position[][GRID_NUM],int i,int j);
int Eveluate(unsigned int position[][GRID_NUM],bool bIsWhiteTurn);
int AddMove(int nToX, int nToY, int nPly);
int CreatePossibleMove(unsigned char position[][GRID_NUM], int nPly, int nSide);
void MergeSort(STONEMOVE* source,int n,bool direction);
void MergePass(STONEMOVE* source,STONEMOVE* target,const int s,const int n,const bool direction);
void Merge_A(STONEMOVE* source,STONEMOVE* target,int l,int m,int r);
void Merge(STONEMOVE* source,STONEMOVE* target,int l,int m,int r);
void EnterHistoryScore(STONEMOVE* move,int depth);
int GetHistoryScore(STONEMOVE* move);
void ResetHistoryTable();
int NegaScout(int depth,int alpha,int beta);
void SearchAGoodMove(unsigned char position[][GRID_NUM],int Type);
int IsGameOver(unsigned char position[][GRID_NUM],int nDepth);
void UnMakeMove(STONEMOVE* move);
unsigned char MakeMove(STONEMOVE* move,int type);
void _CSearchEngine();
void InitializeHashKey();
void EnterHashTable(ENTRY_TYPE entry_type, short eval, short depth, int TableNo);
int LookUpHashTable(int alpha, int beta, int depth, int TableNo);
void Hash_UnMakeMove(STONEMOVE *move,unsigned char CurPosition[][GRID_NUM]);
void Hash_MakeMove(STONEMOVE *move,unsigned char CurPosition[][GRID_NUM]);
void CalculateInitHashKey(unsigned char CurPosition[][GRID_NUM]);
__int64_t rand64();
long rand32();
void CTranspositionTable();
void _CTranspositionTable();
bool OnInitDialog();
//=================================================================//
int m_HistoryTable[GRID_NUM][GRID_NUM];//历史得分表
STONEMOVE m_TargetBuff[225];    //排序用的缓冲队列
unsigned int m_nHashKey32[15][10][9];          //32位随机树组，用以生成32位哈希值
 __uint64_t m_ulHashKey64[15][10][9];//64位随机树组，用以生成64位哈希值
HashItem *m_pTT[10];          //置换表头指针
unsigned int m_HashKey32;          //32位哈希值
__int64_t m_HashKey64;          //64 位哈希值
STONEMOVE m_MoveList[10][225];//用以记录走法的数组
unsigned char m_LineRecord[30];          //存放AnalysisLine分析结果的数组
int TypeRecord[GRID_NUM ][GRID_NUM][4];//存放全部分析结果的数组,有三个维度,用于存放水平、垂直、左斜、右斜 4 个方向上所有棋型分析结果
int TypeCount[2][20];          //存放统记过的分析结果的数组
int m_nMoveCount;//此变量用以记录走法的总数
unsigned char CurPosition[GRID_NUM][GRID_NUM];//搜索时用于当前节点棋盘状态的数组
STONEMOVE m_cmBestMove;        //记录最佳走法的变量
//CMoveGenerator* m_pMG;        //走法产生器指针
//CEveluation* m_pEval;        //估值核心指针
int m_nSearchDepth;        //最大搜索深度
int m_nMaxDepth;        //当前搜索的最大搜索深度
unsigned char m_RenjuBoard[GRID_NUM][GRID_NUM];//棋盘数组，用于显示棋盘
int m_nUserStoneColor;         //用户棋子的颜色
//CSearchEngine* m_pSE;         //搜索引擎指针
int X,Y;                               //AI输出落子位置
int SL;                                  //胜利标记
//位置重要性价值表,此表从中间向外,越往外价值越低
int PosValue[GRID_NUM][GRID_NUM]=
{
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {0,1,1,1,1,1,1,1,1,1,1,1,1,1,0},
    {0,1,2,2,2,2,2,2,2,2,2,2,2,1,0},
    {0,1,2,3,3,3,3,3,3,3,3,3,2,1,0},
    {0,1,2,3,4,4,4,4,4,4,4,3,2,1,0},
    {0,1,2,3,4,5,5,5,5,5,4,3,2,1,0},
    {0,1,2,3,4,5,6,6,6,5,4,3,2,1,0},
    {0,1,2,3,4,5,6,7,6,5,4,3,2,1,0},
    {0,1,2,3,4,5,6,6,6,5,4,3,2,1,0},
    {0,1,2,3,4,5,5,5,5,5,4,3,2,1,0},
    {0,1,2,3,4,4,4,4,4,4,4,3,2,1,0},
    {0,1,2,3,3,3,3,3,3,3,3,3,2,1,0},
    {0,1,2,2,2,2,2,2,2,2,2,2,2,1,0},
    {0,1,1,1,1,1,1,1,1,1,1,1,1,1,0},
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
};

//全局变量,用以统计估值函数的执行遍数
int count=0;

int Eveluate(unsigned char position[][GRID_NUM],bool bIsWhiteTurn)
{
    int i,j,k;
    unsigned char nStoneType;
    count++;//计数器累加
    
    //清空棋型分析结果
    memset(TypeRecord,TOBEANALSIS,GRID_COUNT*4*4);
    memset(TypeCount,0,40*4);
    
    for(i=0;i<GRID_NUM;i++)
        for(j=0;j<GRID_NUM;j++)
        {
            if(position[i][j]!=NOSTONE)
            {
                //如果水平方向上没有分析过
                if(TypeRecord[i][j][0]==TOBEANALSIS)
                    AnalysisHorizon(position,i,j);
                
                //如果垂直方向上没有分析过
                if(TypeRecord[i][j][1]==TOBEANALSIS)
                    AnalysisVertical(position,i,j);
                
                //如果左斜方向上没有分析过
                if(TypeRecord[i][j][2]==TOBEANALSIS)
                    AnalysisLeft(position,i,j);
                
                //如果右斜方向上没有分析过
                if(TypeRecord[i][j][3]==TOBEANALSIS)
                    AnalysisRight(position,i,j);
            }
        }
    
    //对分析结果进行统计,得到每种棋型的数量
    for(i=0;i<GRID_NUM;i++)
        for(j=0;j<GRID_NUM;j++)
            for(k =0;k<4;k++)
            {
                nStoneType=position[i][j];
                if(nStoneType!=NOSTONE)
                {
                    switch(TypeRecord[i][j][k])
                    {
                        case FIVE://五连
                            TypeCount[nStoneType][FIVE]++;
                            break;
                        case FOUR://活四
                            TypeCount[nStoneType][FOUR]++;
                            break;
                        case SFOUR://冲四
                            TypeCount[nStoneType][SFOUR]++;
                            break;
                        case THREE://活三
                            TypeCount[nStoneType][THREE]++;
                            break;
                        case STHREE://眠三
                            TypeCount[nStoneType][STHREE]++;
                            break;
                        case TWO://活二
                            TypeCount[nStoneType][TWO]++;
                            break;
                        case STWO://眠二
                            TypeCount[nStoneType][STWO]++;
                            break;
                        default:
                            break;
                    }
                }
            }
    
    //如果已五连,返回极值
    if(bIsWhiteTurn)
    {
        if(TypeCount[BLACK][FIVE])
        {
            
            
            
            return -9999;
        }
        if(TypeCount[WHITE][FIVE])
        {
            
            
            
            return 9999;
        }
    }
    else
    {
        if(TypeCount[BLACK][FIVE])
        {
            
            
            
            return 9999;
        }
        if(TypeCount[WHITE][FIVE])
        {
            
            
            
            return -9999;
        }
    }
    //两个冲四等于一个活四
    if(TypeCount[WHITE][SFOUR]>1)
        TypeCount[WHITE][FOUR]++;
    if(TypeCount[BLACK][SFOUR]>1)
        TypeCount[BLACK][FOUR]++;
    int WValue=0,BValue=0;
    
    if(bIsWhiteTurn)//轮到白棋走
    {
        if(TypeCount[WHITE][FOUR])
        {
            
            
            return 9990;//活四,白胜返回极值
        }
        if(TypeCount[WHITE][SFOUR])
        {
            
            
            return 9980;//冲四,白胜返回极值
        }
        if(TypeCount[BLACK][FOUR])
        {
            
            
            return -9970;//白无冲四活四,而黑有活四,黑胜返回极值
        }
        if(TypeCount[BLACK][SFOUR] && TypeCount[BLACK][THREE])
        {
            
            
            return -9960;//而黑有冲四和活三,黑胜返回极值
        }
        if(TypeCount[WHITE][THREE] && TypeCount[BLACK][SFOUR]== 0)
        {
            
            
            return 9950;//白有活三而黑没有四,白胜返回极值
        }
        if(TypeCount[BLACK][THREE]>1 && TypeCount[WHITE][SFOUR]==0 && TypeCount[WHITE][THREE]==0 && TypeCount[WHITE][STHREE]==0)
        {
            
            
            return -9940;//黑的活三多于一个,而白无四和三,黑胜返回极值
        }
        if(TypeCount[WHITE][THREE]>1)
            WValue+=2000;//白活三多于一个,白棋价值加2000
        else
            //否则白棋价值加200
            if(TypeCount[WHITE][THREE])
                WValue+=200;
        if(TypeCount[BLACK][THREE]>1)
            BValue+=500;//黑的活三多于一个,黑棋价值加500
        else
            //否则黑棋价值加100
            if(TypeCount[BLACK][THREE])
                BValue+=100;
        //每个眠三加10
        if(TypeCount[WHITE][STHREE])
            WValue+=TypeCount[WHITE][STHREE]*10;
        //每个眠三加10
        if(TypeCount[BLACK][STHREE])
            BValue+=TypeCount[BLACK][STHREE]*10;
        //每个活二加4
        if(TypeCount[WHITE][TWO])
            WValue+=TypeCount[WHITE][TWO]*4;
        //每个活二加4
        if(TypeCount[BLACK][STWO])
            BValue+=TypeCount[BLACK][TWO]*4;
        //每个眠二加1
        if(TypeCount[WHITE][STWO])
            WValue+=TypeCount[WHITE][STWO];
        //每个眠二加1
        if(TypeCount[BLACK][STWO])
            BValue+=TypeCount[BLACK][STWO];
    }
    else//轮到黑棋走
    {
        if(TypeCount[BLACK][FOUR])
        {
            
            return 9990;//活四,黑胜返回极值
        }
        if(TypeCount[BLACK][SFOUR])
        {
            
            return 9980;//冲四,黑胜返回极值
        }
        if(TypeCount[WHITE][FOUR])
            return -9970;//活四,白胜返回极值
        
        if(TypeCount[WHITE][SFOUR] && TypeCount[WHITE][THREE])
            return -9960;//冲四并活三,白胜返回极值
        
        if(TypeCount[BLACK][THREE] && TypeCount[WHITE][SFOUR]==0)
            return 9950;//黑活三,白无四。黑胜返回极值
        
        if(TypeCount[WHITE][THREE]>1 && TypeCount[BLACK][SFOUR]==0 && TypeCount[BLACK][THREE]==0 && TypeCount[BLACK][STHREE]==0)
            return -9940;//白的活三多于一个,而黑无四和三,白胜返回极值
        
        //黑的活三多于一个,黑棋价值加2000
        if(TypeCount[BLACK][THREE]>1)
            BValue+=2000;
        else
            //否则黑棋价值加200
            if(TypeCount[BLACK][THREE])
                BValue+=200;
        
        //白的活三多于一个,白棋价值加 500
        if(TypeCount[WHITE][THREE]>1)
            WValue+=500;
        else
            //否则白棋价值加100
            if(TypeCount[WHITE][THREE])
                WValue+=100;
        
        //每个眠三加10
        if(TypeCount[WHITE][STHREE])
            WValue+=TypeCount[WHITE][STHREE]*10;
        //每个眠三加10
        if(TypeCount[BLACK][STHREE])
            BValue+=TypeCount[BLACK][STHREE]*10;
        
        //每个活二加4
        if(TypeCount[WHITE][TWO])
            WValue+=TypeCount[WHITE][TWO]*4;
        //每个活二加4
        if(TypeCount[BLACK][STWO])
            BValue+=TypeCount[BLACK][TWO]*4;
        
        //每个眠二加1
        if(TypeCount[WHITE][STWO])
            WValue+=TypeCount[WHITE][STWO];
        //每个眠二加1
        if(TypeCount[BLACK][STWO])
            BValue+=TypeCount[BLACK][STWO];
    }
    
    //加上所有棋子的位置价值
    for(i=0;i<GRID_NUM;i++)
        for(j=0;j<GRID_NUM;j++)
        {
            nStoneType=position[i][j];
            if(nStoneType!=NOSTONE)
                if(nStoneType==BLACK)
                    BValue+=PosValue[i][j];
                else
                    WValue+=PosValue[i][j];
        }
    
    //返回估值
    if(!bIsWhiteTurn)
        return BValue-WValue;
    else
        return WValue-BValue;
}

//分析棋盘上某点在水平方向上的棋型
int AnalysisHorizon(unsigned char position[][GRID_NUM],int i,int j)
{
    //调用直线分析函数分析
    AnalysisLine(position[i],15,j);
    //拾取分析结果
    for(int s=0;s<15;s++)
        if(m_LineRecord[s]!=TOBEANALSIS)
            TypeRecord[i][s][0]= m_LineRecord[s];
    
    return TypeRecord[i][j][0];
}

//分析棋盘上某点在垂直方向上的棋型
int AnalysisVertical(unsigned char position[][GRID_NUM],int i,int j)
{
    unsigned char tempArray[GRID_NUM];
    //将垂直方向上的棋子转入一维数组
    for(int k=0;k<GRID_NUM;k++)
        tempArray[k]=position[k][j];
    //调用直线分析函数分析
    AnalysisLine(tempArray,GRID_NUM,i);
    //拾取分析结果
    for(int s=0;s<GRID_NUM;s++)
        if(m_LineRecord[s]!=TOBEANALSIS)
            TypeRecord[s][j][1]=m_LineRecord[s];
    
    return TypeRecord[i][j][1];
}

//分析棋盘上某点在左斜方向上的棋型
int AnalysisLeft(unsigned char position[][GRID_NUM],int i,int j)
{
    unsigned char tempArray[GRID_NUM];
    int x,y;
    int k;
    if(i<j)
    {
        y=0;
        x=j-i;
    }
    else
    {
        x=0;
        y=i-j;
    }
    //将斜方向上的棋子转入一维数组
    for(k=0;k<GRID_NUM;k++)
    {
        if(x+k>14 || y+k>14)
            break;
        tempArray[k]=position[y+k][x+k];
    }
    //调用直线分析函数分析
    AnalysisLine(tempArray,k,j-x);
    //拾取分析结果
    for(int s=0;s<k;s++)
        if(m_LineRecord[s]!=TOBEANALSIS)
            TypeRecord[y+s][x+s][2]=m_LineRecord[s];
    
    return TypeRecord[i][j][2];
}

//分析棋盘上某点在右斜方向上的棋型
int AnalysisRight(unsigned char position[][GRID_NUM],int i,int j)
{
    unsigned char tempArray[GRID_NUM];
    int x,y,realnum;
    int k;
    if(14-i<j)
    {
        y=14;
        x=j-14+i;
        realnum=14-i;
    }
    else
    {
        x=0;
        y=i+j;
        realnum=j;
    }
    //将斜方向上的棋子转入一维数组
    for(k=0;k<GRID_NUM;k++)
    {
        if(x+k>14 || y-k<0)
            break;
        tempArray[k]=position[y-k][x+k];
    }
    //调用直线分析函数分析
    AnalysisLine(tempArray,k,j-x);
    //拾取分析结果
    for(int s=0;s<k;s++)
        if(m_LineRecord[s]!=TOBEANALSIS)
            TypeRecord[y-s][x+s][3]=m_LineRecord[s];
    
    return TypeRecord[i][j][3];
}

int AnalysisLine(unsigned char* position,int GridNum,int StonePos)
{
    unsigned char StoneType;
    unsigned char AnalyLine[30];
    int nAnalyPos;
    int LeftEdge,RightEdge;
    int LeftRange,RightRange;
    
    if(GridNum<5)
    {
        //数组长度小于5没有意义
        memset(m_LineRecord,ANALSISED,GridNum);
        return 0;
    }
    nAnalyPos=StonePos;
    memset(m_LineRecord,TOBEANALSIS,30);
    memset(AnalyLine,0x0F,30);
    //将传入数组装入AnalyLine;
    memcpy(&AnalyLine,position,GridNum);
    GridNum--;
    StoneType=AnalyLine[nAnalyPos];
    LeftEdge=nAnalyPos;
    RightEdge=nAnalyPos;
    //算连续棋子左边界
    while(LeftEdge>0)
    {
        if(AnalyLine[LeftEdge-1]!=StoneType)
            break;
        LeftEdge--;
    }
    
    //算连续棋子右边界
    while(RightEdge<GridNum)
    {
        if(AnalyLine[RightEdge+1]!=StoneType)
            break;
        RightEdge++;
    }
    LeftRange=LeftEdge;
    RightRange=RightEdge;
    //下面两个循环算出棋子可下的范围
    while(LeftRange>0)
    {
        if(AnalyLine[LeftRange -1]==!StoneType)
            break;
        LeftRange--;
    }
    while(RightRange<GridNum)
    {
        if(AnalyLine[RightRange+1]==!StoneType)
            break;
        RightRange++;
    }
    //如果此范围小于4则分析没有意义
    if(RightRange-LeftRange<4)
    {
        for(int k=LeftRange;k<=RightRange;k++)
            m_LineRecord[k]=ANALSISED;
        return false;
    }
    //将连续区域设为分析过的,防止重复分析此一区域
    for(int k=LeftEdge;k<=RightEdge;k++)
        m_LineRecord[k]=ANALSISED;
    if(RightEdge-LeftEdge>3)
    {
        //如待分析棋子棋型为五连
        m_LineRecord[nAnalyPos]=FIVE;
        return FIVE;
    }
    
    if(RightEdge-LeftEdge== 3)
    {
        //如待分析棋子棋型为四连
        bool Leftfour=false;
        if(LeftEdge>0)
            if(AnalyLine[LeftEdge-1]==NOSTONE)
                Leftfour=true;//左边有气
        
        if(RightEdge<GridNum)
            //右边未到边界
            if(AnalyLine[RightEdge+1]==NOSTONE)
                //右边有气
                if(Leftfour==true)//如左边有气
                    m_LineRecord[nAnalyPos]=FOUR;//活四
                else
                    m_LineRecord[nAnalyPos]=SFOUR;//冲四
                else
                    if(Leftfour==true)//如左边有气
                        m_LineRecord[nAnalyPos]=SFOUR;//冲四
                    else
                        if(Leftfour==true)//如左边有气
                            m_LineRecord[nAnalyPos]=SFOUR;//冲四
        
        return m_LineRecord[nAnalyPos];
    }
    
    if(RightEdge-LeftEdge==2)
    {
        //如待分析棋子棋型为三连
        bool LeftThree=false;
        
        if(LeftEdge>1)
            if(AnalyLine[LeftEdge-1]==NOSTONE)
                //左边有气
                if(LeftEdge>1 && AnalyLine[LeftEdge-2]==AnalyLine[LeftEdge])
                {
                    //左边隔一空白有己方棋子
                    m_LineRecord[LeftEdge]=SFOUR;//冲四
                    m_LineRecord[LeftEdge-2]=ANALSISED;
                }
                else
                    LeftThree=true;
        
        if(RightEdge<GridNum)
            if(AnalyLine[RightEdge+1]==NOSTONE)
                //右边有气
                if(RightEdge<GridNum-1 && AnalyLine[RightEdge+2]==AnalyLine[RightEdge])
                {
                    //右边隔1个己方棋子
                    m_LineRecord[RightEdge]=SFOUR;//冲四
                    m_LineRecord[RightEdge+2]=ANALSISED;
                }
                else
                    if(LeftThree==true)//如左边有气
                        m_LineRecord[RightEdge]=THREE;//活三
                    else
                        m_LineRecord[RightEdge]=STHREE; //冲三
                    else
                    {
                        if(m_LineRecord[LeftEdge]==SFOUR)//如左冲四
                            return m_LineRecord[LeftEdge];//返回
                        
                        if(LeftThree==true)//如左边有气
                            m_LineRecord[nAnalyPos]=STHREE;//眠三
                    }
                    else
                    {
                        if(m_LineRecord[LeftEdge]==SFOUR)//如左冲四
                            return m_LineRecord[LeftEdge];//返回
                        if(LeftThree==true)//如左边有气
                            m_LineRecord[nAnalyPos]=STHREE;//眠三
                    }
        
        return m_LineRecord[nAnalyPos];
    }
    
    if(RightEdge-LeftEdge==1)
    {
        //如待分析棋子棋型为二连
        bool Lefttwo=false;
        bool Leftthree=false;
        
        if(LeftEdge>2)
            if(AnalyLine[LeftEdge-1]==NOSTONE)
                //左边有气
                if(LeftEdge-1>1 && AnalyLine[LeftEdge-2]==AnalyLine[LeftEdge])
                    if(AnalyLine[LeftEdge-3]==AnalyLine[LeftEdge])
                    {
                        //左边隔2个己方棋子
                        m_LineRecord[LeftEdge-3]=ANALSISED;
                        m_LineRecord[LeftEdge-2]=ANALSISED;
                        m_LineRecord[LeftEdge]=SFOUR;//冲四
                    }
                    else
                        if(AnalyLine[LeftEdge-3]==NOSTONE)
                        {
                            //左边隔1个己方棋子
                            m_LineRecord[LeftEdge-2]=ANALSISED;
                            m_LineRecord[LeftEdge]=STHREE;//眠三
                        }
                        else
                            Lefttwo=true;
        
        if(RightEdge<GridNum-2)
            if(AnalyLine[RightEdge+1]==NOSTONE)
                //右边有气
                if(RightEdge+1<GridNum-1 && AnalyLine[RightEdge+2]==AnalyLine[RightEdge])
                    if(AnalyLine[RightEdge+3]==AnalyLine[RightEdge])
                    {
                        //右边隔两个己方棋子
                        m_LineRecord[RightEdge+3]=ANALSISED;
                        m_LineRecord[RightEdge+2]=ANALSISED;
                        m_LineRecord[RightEdge]=SFOUR;//冲四
                    }
                    else
                        if(AnalyLine[RightEdge+3]==NOSTONE)
                        {
                            //右边隔 1 个己方棋子
                            m_LineRecord[RightEdge+2]=ANALSISED;
                            m_LineRecord[RightEdge]=STHREE;//眠三
                        }
                        else
                        {
                            if(m_LineRecord[LeftEdge]==SFOUR)//左边冲四
                                return m_LineRecord[LeftEdge];//返回
                            
                            if(m_LineRecord[LeftEdge]==STHREE)//左边眠三
                                return m_LineRecord[LeftEdge];
                            
                            if(Lefttwo==true)
                                m_LineRecord[nAnalyPos]=TWO;//返回活二
                            else
                                m_LineRecord[nAnalyPos]=STWO;//眠二
                        }
                        else
                        {
                            if(m_LineRecord[LeftEdge]==SFOUR)//冲四返回
                                return m_LineRecord[LeftEdge];
                            
                            if(Lefttwo==true)//眠二
                                m_LineRecord[nAnalyPos]=STWO;
                        }
        
        return m_LineRecord[nAnalyPos];
    }
    
    return 0;
}

//将历史记录表中所有项目全置为初值
void ResetHistoryTable()
{
    memset(m_HistoryTable,10,GRID_COUNT*sizeof(int));
}

//从历史得分表中取给定走法的历史得分
int GetHistoryScore(STONEMOVE* move)
{
    return m_HistoryTable[move->StonePos.x][move->StonePos.y];
}

//将一最佳走法汇入历史记录
void EnterHistoryScore(STONEMOVE* move,int depth)
{
    m_HistoryTable[move->StonePos.x][move->StonePos.y]+=2<<depth;
}

//对走法队列从小到大排序
//STONEMOVE* source原始队列
//STONEMOVE* target目标队列
//合并source[l…m]和 source[m +1…r]至target[l…r]
void Merge(STONEMOVE* source,STONEMOVE* target,int l,int m,int r)
{
    //从小到大排序
    int i=l;
    int j=m+1;
    int k=l;
    while(i<=m && j<=r)
        if(source[i].Score<=source[j].Score)
            target[k++]=source[i++];
        else
            target[k++]=source[j++];
    if(i>m)
        for(int q=j;q<=r;q++)
            target[k++]=source[q];
    else
        for(int q=i;q<=m;q++)
            target[k++]=source[q];
}

void Merge_A(STONEMOVE* source,STONEMOVE* target,int l,int m,int r)
{
    //从大到小排序
    int i=l;
    int j=m+1;
    int k=l;
    while(i<=m &&j<=r)
        if(source[i].Score>=source[j].Score)
            target[k++]=source[i++];
        else
            target[k++]=source[j++];
    if(i>m)
        for(int q=j;q<=r;q++)
            target[k++]=source[q];
    else
        for(int q=i;q<=m;q++)
            target[k++]=source[q];
}

//合并大小为 S 的相邻子数组
//direction 是标志,指明是从大到小还是从小到大排序
void MergePass(STONEMOVE* source,STONEMOVE* target,const int s,const int n,const bool direction)
{
    int i=0;
    while(i<=n-2*s)
    {
        //合并大小为 s的相邻二段子数组
        if(direction)
            Merge(source,target,i,i+s-1,i+2*s-1);
        else
            Merge_A(source,target,i,i+s-1,i+2*s-1);
        i=i+2*s;
    }
    if(i+s<n)//剩余的元素个数小于2s
    {
        if(direction)
            Merge(source,target,i,i+s-1,n-1);
        else
            Merge_A(source,target,i,i+s-1,n-1);
    }
    else
        for(int j=i;j<=n-1;j++)
            target[j]=source[j];
}

void MergeSort(STONEMOVE* source,int n,bool direction)
{
    int s=1;
    while(s<n)
    {
        MergePass(source,m_TargetBuff,s,n,direction);
        s+=s;
        MergePass(m_TargetBuff,source,s,n,direction);
        s+=s;
    }
}

int CreatePossibleMove(unsigned char position[][GRID_NUM], int nPly, int nSide)
{
    int i,j;
    m_nMoveCount=0;
    for(i=0;i<GRID_NUM;i++)
        for(j=0;j<GRID_NUM;j++)
        {
            if(position[i][j]==(unsigned char)NOSTONE)
                AddMove(j,i,nPly);
        }
    
    //使用历史启发类中的静态归并排序函数对走法队列进行排序
    //这是为了提高剪枝效率
    //        CHistoryHeuristic history;
    MergeSort(m_MoveList[nPly],m_nMoveCount,0);
    
    return m_nMoveCount;//返回合法走法个数
}

//在m_MoveList中插入一个走法
//nToX是目标位置横坐标
//nToY是目标位置纵坐标
//nPly是此走法所在的层次
int AddMove(int nToX, int nToY, int nPly)
{
    m_MoveList[nPly][m_nMoveCount].StonePos.x=nToX;
    m_MoveList[nPly][m_nMoveCount].StonePos.y=nToY;
    
    m_nMoveCount++;
    m_MoveList[nPly][m_nMoveCount].Score=PosValue[nToY][nToX];//使用位置价值表评估当前走法的价值
    return m_nMoveCount;
}

void CNegaScout_TT_HH()
{
    ResetHistoryTable();
    //        m_pThinkProgress=NULL;
}

void SearchAGoodMove(unsigned char position[][GRID_NUM],int Type)
{
    int Score;
    
    memcpy(CurPosition,position,GRID_COUNT);
    m_nMaxDepth=m_nSearchDepth;
    CalculateInitHashKey(CurPosition);
    ResetHistoryTable();
    Score=NegaScout(m_nMaxDepth,-20000,20000);
    X=m_cmBestMove.StonePos.y;
    Y=m_cmBestMove.StonePos.x;
    MakeMove(&m_cmBestMove,Type);
    memcpy(position,CurPosition,GRID_COUNT);
}

int IsGameOver(unsigned char position[][GRID_NUM],int nDepth)
{
    int score,i;//计算要下的棋子颜色
    i=(m_nMaxDepth-nDepth)%2;
    score=Eveluate(position,i);//调用估值函数
    if(abs(score)>8000)//如果估值函数返回极值，给定局面游戏结束
        return score;//返回极值
    return 0;//返回未结束
}

int NegaScout(int depth,int alpha,int beta)
{
    int Count,i;
    unsigned char type;
    int a,b,t;
    int side;
    int score;
    /*        if(depth>0)
     {
     i= IsGameOver(CurPosition,depth);
     if(i!=0)
     return i;  //已分胜负，返回极值
     }
     */
    side=(m_nMaxDepth-depth)%2;//计算当前节点的类型,极大0/极小1
    score=LookUpHashTable(alpha,beta,depth,side); 
    if(score!=66666) 
        return score;
    if(depth<=0)//叶子节点取估值
    {
        score=Eveluate(CurPosition,side);
        EnterHashTable(exact,score,depth,side);//将估值存入置换表
        
        return score;
    }
    Count=CreatePossibleMove(CurPosition,depth,side);
    for(i=0;i<Count;i++) 
        m_MoveList[depth][i].Score=GetHistoryScore(&m_MoveList[depth][i]);
    
    MergeSort(m_MoveList[depth],Count,0);
    int bestmove=-1;
    a=alpha;
    b=beta;
    
    int eval_is_exact=0;
    
    for(i=0;i<Count;i++) 
    {
        type=MakeMove(&m_MoveList[depth][i],side);
        Hash_MakeMove(&m_MoveList[depth][i],CurPosition);
        t=-NegaScout(depth-1,-b,-a);//递归搜索子节点，对第 1 个节点是全窗口，其后是空窗探测
        if(t>a && t<beta && i>0) 
        {
            //对于第一个后的节点,如果上面的搜索failhigh
            a=-NegaScout(depth-1,-beta,-t);//re-search
            eval_is_exact=1;//设数据类型为精确值
            if(depth==m_nMaxDepth)
                m_cmBestMove=m_MoveList[depth][i];
            bestmove=i;
        }
        Hash_UnMakeMove(&m_MoveList[depth][i],CurPosition); 
        UnMakeMove(&m_MoveList[depth][i]); 
        if(a<t)
        {
            eval_is_exact=1;
            a=t;
            if(depth==m_nMaxDepth)
                m_cmBestMove=m_MoveList[depth][i];
        }
        if(a>= beta) 
        {
            EnterHashTable(lower_bound,a,depth,side);
            EnterHistoryScore(&m_MoveList[depth][i],depth);
            return a;
        }
        b=a+1;                      /* set new null window */
    }
    if(bestmove!=-1)
        EnterHistoryScore(&m_MoveList[depth][bestmove], depth);
    if(eval_is_exact) 
        EnterHashTable(exact,a,depth,side);
    else 
        EnterHashTable(upper_bound,a,depth,side);
    
    return a;
}

unsigned char MakeMove(STONEMOVE* move,int type)
{
    CurPosition[move->StonePos.y][move->StonePos.x]=type;
    return 0;
}

void UnMakeMove(STONEMOVE* move)
{
    CurPosition[move->StonePos.y][move->StonePos.x]=NOSTONE;
}

__int64_t rand64(void)
{
    return rand()^((__int64_t)rand()<<15)^((__int64_t)rand()<<30)^
    ((__int64_t)rand()<<45)^((__int64_t)rand()<<60);
}

//生成32位随机数
long rand32(void)
{
    return rand()^((long)rand()<<15)^((long)rand()<<30);
}

void CTranspositionTable()
{
    InitializeHashKey();//建立哈希表，创建随机数组
}

void _CTranspositionTable()
{
    //释放哈希表所用空间
    delete m_pTT[0];
    delete m_pTT[1];
}

void CalculateInitHashKey(unsigned char CurPosition[][GRID_NUM])
{
    int j,k,nStoneType;
    
    m_HashKey32=0;
    m_HashKey32=0;
    //将所有棋子对应的哈希数加总
    for(j=0;j<GRID_NUM;j++)
        for(k=0;k<GRID_NUM;k++)
        {
            nStoneType=CurPosition[j][k];
            if(nStoneType!=0xFF)
            {
                m_HashKey32=m_HashKey32^m_nHashKey32[nStoneType][j][k]; 
                m_HashKey64=m_HashKey64^m_ulHashKey64[nStoneType][j][k]; 
            }
        }
}

void Hash_MakeMove(STONEMOVE *move,unsigned char CurPosition[][GRID_NUM])
{
    int type;
    
    type=CurPosition[move->StonePos.y][move->StonePos.x];//将棋子在目标位置的随机数添入
    m_HashKey32=m_HashKey32^m_nHashKey32[type][move->StonePos.y][move->StonePos.x];
    m_HashKey64=m_HashKey64^m_ulHashKey64[type][move->StonePos.y][move->StonePos.x];
}

void Hash_UnMakeMove(STONEMOVE *move,unsigned char CurPosition[][GRID_NUM])
{
    int type;
    type=CurPosition[move->StonePos.y][move->StonePos.x];//将棋子现在位置上的随机数从哈希值当中去除
    m_HashKey32=m_HashKey32^m_nHashKey32[type][move->StonePos.y][move->StonePos.x];
    m_HashKey64=m_HashKey64^m_ulHashKey64[type][move->StonePos.y][move->StonePos.x];
}

int LookUpHashTable(int alpha, int beta, int depth, int TableNo)
{
    int x;
    HashItem* pht;
    
    //计算二十位哈希地址，如果读者设定的哈希表大小不是 1M*2 的,
    //而是 TableSize*2，TableSize为读者设定的大小
    //则需要修改这一句为m_HashKey32% TableSize
    //下一个函数中这一句也一样
    x=m_HashKey32 & 0xFFFFF;
    pht=&m_pTT[TableNo][x];//取到具体的表项指针
    
    if(pht->depth>=depth && pht->checksum==m_HashKey64)
    {
        switch(pht->entry_type)//判断数据类型
        {
            case exact://确切值
                return pht->eval;
                
            case lower_bound://下边界
                if(pht->eval>=beta)
                    return pht->eval;
                else 
                    break;
                
            case upper_bound://上边界
                if (pht->eval<=alpha)
                    return pht->eval;
                else 
                    break;
        }
    }
    
    return 66666;
}

void EnterHashTable(ENTRY_TYPE entry_type, short eval, short depth, int TableNo)
{
    int x;
    HashItem* pht;
    
    x=m_HashKey32 & 0xFFFFF;//计算二十位哈希地址
    pht=&m_pTT[TableNo][x]; //取到具体的表项指针
    
    //将数据写入哈希表
    pht->checksum=m_HashKey64; //64位校验码
    pht->entry_type=entry_type;//表项类型
    pht->eval=eval;          //要保存的值
    pht->depth=depth;          //层次
}

void InitializeHashKey()
{
    int i,j,k;
    srand((unsigned)time(NULL));
    //填充随机数组
    for(i=0;i<15;i++)
        for(j=0;j<10;j++)
            for(k=0;k<9;k++)
            {
                m_nHashKey32[i][j][k]=rand32();
                m_ulHashKey64[i][j][k]=rand64();
            }
    
    //申请置换表所用空间。1M "2 个条目，读者也可指定其他大小
    m_pTT[0]=new HashItem[1024*1024];//用于存放取极大值的节点数据
    m_pTT[1]=new HashItem[1024*1024];//用于存放取极小值的节点数据
}


//using namespace std;

int main(int argc, char *argv[])
{
    SL=0; 
    int colour;
    char command[10]; //用于保存命令的字符串 
    for (int i = 0; i < GRID_NUM; i++) 
        for (int j = 0; j < GRID_NUM; j++) 
            m_RenjuBoard[i][j] = NOSTONE; //棋盘初始化 
    
    int XS;
    printf("请选择先手棋手：1表示AI先手 0表示棋手先手\n");
    std::cin >> XS; //是否电脑先手
    colour=BLACK;
    m_nUserStoneColor=WHITE;
    while (!SL) 
    { 
        printf("\n请输入落子坐标：\n");
        int rival_x, rival_y; //用于保存对手上一步落子点 
        std::cin >> rival_x >> rival_y; //读入对手上一步落子点  
        if(XS == 1 && rival_x == -1 && rival_y == -1) //如果己方执黑且是第一步，则占据棋盘中心位置 
        { 
            m_RenjuBoard[GRID_NUM / 2][GRID_NUM / 2] = colour; //更新棋盘信息
            //cout << GRID_NUM / 2 << ' ' << GRID_NUM / 2 << endl; //输出
            //cout << flush; //刷新缓冲区  
        }
        else 
        {
            m_RenjuBoard[rival_x][rival_y] =m_nUserStoneColor; 
            //更新棋盘信息 
            for (int i = 0; i < GRID_NUM; i++) 
            {
                for (int j = 0; j < GRID_NUM; j++) 
                {
                    if(m_RenjuBoard[i][j]==WHITE)
                        printf("O "); else  if(m_RenjuBoard[i][j]==BLACK)printf("X "); else printf("+ ");
                }
                printf("\n");
            }
            m_nSearchDepth=4;//AI难度等级设置 
            //最大搜索深度        
            do
            {
                CNegaScout_TT_HH();         //创建NegaScout_TT_HH搜索引擎
                CTranspositionTable();
                SearchAGoodMove(m_RenjuBoard,colour);
                m_RenjuBoard[X][Y]=colour;
                printf("\nAI落子坐标为：");
                std::cout << X << ' ' << Y << std::endl; //输出
                std::cout << &fflush; //刷新缓冲区
                _CTranspositionTable();
                break; //结束循环 
            }
            while (!SL); 
            //循环直至随机得到一个空位置 
            for (int i = 0; i < GRID_NUM; i++) 
            {
                for (int j = 0; j < GRID_NUM; j++) 
                {
                    if(m_RenjuBoard[i][j]==WHITE)
                        printf("O "); else  if(m_RenjuBoard[i][j]==BLACK)printf("X "); else printf("+ ");
                }
                printf("\n");
            }
            
            if(SL==1)printf("很遗憾AI胜利了继续努力吧少年！\n");else if(SL==2)printf("少年你太叼了居然打败了AI！\n");
            
            
        }
    }
    
    system("PAUSE");
    return EXIT_SUCCESS;
}
