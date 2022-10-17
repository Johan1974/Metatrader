//+------------------------------------------------------------------+
//|                                                 BB 2Bands MR.mq4 |
//|                                                    Mohsen Hassan |
//|                             https://www.MontrealTradingGroup.com |
//+------------------------------------------------------------------+
#property copyright "Mohsen Hassan"
#property link      "https://www.MontrealTradingGroup.com"
#property version   "1.00"
#property strict
#property show_inputs
#include  <CustomFunctions01.mqh>

input int bbPeriod = 50;

input int bandStdEntry = 2;
input int bandStdProfitExit = 1;
input int bandStdLossExit = 6;
int rsiPeriod = 14;
input double riskPerTrade = 0.02;
input int rsiLowerLevel = 40;
input int rsiUpperLevel = 60;


int MaxOrders = 5;

string ThisSymbol;

double bbLowerEntry;
double bbUpperEntry;
double bbMid;

double bbLowerProfitExit;
double bbUpperProfitExit;

double bbLowerLossExit;
double bbUpperLossExit;

double ThisRSI;
double PrevRSI;
                

double CurrentBid;
double CurrentAsk;
double CurrentPoint;
double CurrentLotSize;
double CurrentLotMin;
double CurrentLotStep;
double CurrentLotMax;
double CurrentDigits;       


int THISPERIOD = PERIOD_CURRENT;
  

int openOrderID;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Alert("");
   Alert("Starting Strategy BB 2Bans MR");

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Alert("Stopping Strategy BB 2Bans MR");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  
   
  
   for(int SymInt=0;SymInt<SymbolsTotal(false);SymInt++)
   {
      
      
      ThisSymbol = SymbolName(SymInt, true);
      
      Print (ThisSymbol);
       
      if (IsTradingAllowed(ThisSymbol))
      {
   
         Print ("Trading is allowed " + ThisSymbol  );
         
         CurrentDigits    = MarketInfo(ThisSymbol,MODE_DIGITS );   
         CurrentBid       = NormalizeDouble( MarketInfo(ThisSymbol,MODE_BID),CurrentDigits);
         CurrentAsk       = NormalizeDouble( MarketInfo(ThisSymbol,MODE_ASK),CurrentDigits);
         CurrentPoint     = NormalizeDouble( MarketInfo(ThisSymbol,MODE_POINT),CurrentDigits);
         CurrentLotSize   = NormalizeDouble( MarketInfo(ThisSymbol,MODE_LOTSIZE ),CurrentDigits);
         CurrentLotMin    = NormalizeDouble( MarketInfo(ThisSymbol,MODE_MINLOT ),CurrentDigits);
         CurrentLotStep   = NormalizeDouble( MarketInfo(ThisSymbol,MODE_LOTSTEP ),CurrentDigits);
         CurrentLotMax    = NormalizeDouble( MarketInfo(ThisSymbol,MODE_MAXLOT ),CurrentDigits);
                 
         
         bbLowerEntry = iBands(ThisSymbol,THISPERIOD,bbPeriod,bandStdEntry,0,PRICE_CLOSE,MODE_LOWER,0);
         bbUpperEntry = iBands(ThisSymbol,THISPERIOD,bbPeriod,bandStdEntry,0,PRICE_CLOSE,MODE_UPPER,0);
         bbMid = iBands(ThisSymbol,THISPERIOD,bbPeriod,bandStdEntry,0,PRICE_CLOSE,0,0);
         
         bbLowerProfitExit = iBands(ThisSymbol,THISPERIOD,bbPeriod,bandStdProfitExit,0,PRICE_CLOSE,MODE_LOWER,0);
         bbUpperProfitExit = iBands(ThisSymbol,THISPERIOD,bbPeriod,bandStdProfitExit,0,PRICE_CLOSE,MODE_UPPER,0);
         
         bbLowerLossExit = iBands(ThisSymbol,THISPERIOD,bbPeriod,bandStdLossExit,0,PRICE_CLOSE,MODE_LOWER,0);
         bbUpperLossExit = iBands(ThisSymbol,THISPERIOD,bbPeriod,bandStdLossExit,0,PRICE_CLOSE,MODE_UPPER,0);
         
         ThisRSI = iRSI(ThisSymbol,THISPERIOD,rsiPeriod,PRICE_CLOSE,0);
         PrevRSI = iRSI(ThisSymbol,THISPERIOD,rsiPeriod,PRICE_CLOSE,1);
         
         if(!DoubleTrade(ThisSymbol) )//if no open orders try to enter new position
         {
         
            Print ("No Double Trade " + ThisSymbol  );
         
            //if ((CurrentAsk < ThisBBLower && PrevRSI < 30 && ThisRSI > 30)) //Buy
            //if ((CurrentAsk < ThisBBLower && ThisRSI > 50)) //Buy
            if (CurrentAsk < bbLowerEntry)  //Buy
            //if(CurrentAsk < bbLowerEntry &&  iOpen(ThisSymbol,THISPERIOD, 0) > bbLowerEntry && rsiValue < rsiLowerLevel)//buying
            {
               Print("Price is bellow bbLower and rsiValue is lower than " + rsiLowerLevel+ " , Sending buy order");
               double stopLossPrice = NormalizeDouble(bbLowerLossExit, CurrentDigits);
               double takeProfitPrice = NormalizeDouble(bbUpperProfitExit,CurrentDigits);;
               Print("Entry Price = " + CurrentAsk);
               Print("Stop Loss Price = " + stopLossPrice);
               Print("Take Profit Price = " + takeProfitPrice);
               
               double lotSize = OptimalLotSize(riskPerTrade,CurrentAsk,stopLossPrice);
               if (OrdersTotal() < MaxOrders)
               {
                  openOrderID = OrderSend(ThisSymbol,OP_BUYLIMIT,lotSize,CurrentAsk,10,stopLossPrice,takeProfitPrice,NULL);
                  if(openOrderID < 0) Alert("order rejected. Order error: " + GetLastError());
               }
               else
               {
                  Print("Maxorders Reached : " + OrdersTotal());
               }
               
            }
            //else if (CurrentBid > ThisBBUpper  && PrevRSI > 70 && ThisRSI < 70)  //Short/Sell
            //else if (CurrentBid > ThisBBUpper  && ThisRSI < 50)  //Short/Sell
            else if (CurrentBid > bbUpperEntry )  //Short/Sell
            //else if(CurrentBid > bbUpperEntry && iOpen(ThisSymbol, THISPERIOD, 0) < bbUpperEntry && rsiValue > rsiUpperLevel)//shorting
            {
               Print("Price is above bbUpper and rsiValue is above " + rsiUpperLevel + " Sending short order");
               double stopLossPrice = NormalizeDouble(bbUpperLossExit,CurrentDigits);
               double takeProfitPrice = NormalizeDouble(bbLowerProfitExit,CurrentDigits);
               Print("Entry Price = " + CurrentBid);
               Print("Stop Loss Price = " + stopLossPrice);
               Print("Take Profit Price = " + takeProfitPrice);
         	  
         	   double lotSize = OptimalLotSize(riskPerTrade,CurrentBid,stopLossPrice);
      
               if (OrdersTotal() < MaxOrders)
               {
               
               if (Entry - Bid < StopLevel * _Point) Entry = Bid + StopLevel * _Point;
               if (StopLoss - Entry < StopLevel * _Point) StopLoss = Entry + StopLevel * _Point;
               if (Entry - TakeProfit < StopLevel * _Point) TakeProfit = Entry - StopLevel * _Point;

                  openOrderID = OrderSend(ThisSymbol,OP_SELLLIMIT,lotSize,CurrentBid,10,stopLossPrice,takeProfitPrice,NULL);
         	      if(openOrderID < 0) Alert("order rejected. Order error: " + GetLastError());   }
               
               else
               {
                  Print("Maxorders Reached : " + OrdersTotal());
               }
      
         	  
            }
         }
         else //else if you already have a position, update orders if need too.
         {
            if(OrderSelect(openOrderID,SELECT_BY_TICKET)==true)
            {
                  int orderType = OrderType();// Short = 1, Long = 0
      
                  double optimalTakeProfit;
                  
                  if(orderType == 0)//long position
                  {
                     optimalTakeProfit = NormalizeDouble(bbUpperProfitExit,CurrentDigits);
                     
                  }
                  else //if short
                  {
                     optimalTakeProfit = NormalizeDouble(bbLowerProfitExit,CurrentDigits);
                  }
      
                  double TP = OrderTakeProfit();
                  double TPdistance = MathAbs(TP - optimalTakeProfit);
                  if(TP != optimalTakeProfit && TPdistance > 0.0001)
                  {
                     bool Ans = OrderModify(openOrderID,OrderOpenPrice(),OrderStopLoss(),optimalTakeProfit,0);
                  
                     if (Ans==true)                     
                     {
                        Print("Order modified: ",openOrderID);
                        return;                           
                     }else
                     {
                        Print("Unable to modify order: ",openOrderID);
                     }   
                  }
               }
            }
         }
      }        
   }

//+------------------------------------------------------------------+
