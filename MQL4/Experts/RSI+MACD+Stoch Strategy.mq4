//+------------------------------------------------------------------+
//|                                              MyExpertAdvisor.mq4 |
//|                                                   Johan Lijffijt |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Johan Lijffijt"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <CustomFunctions.mqh>


double ThisPipValue;
string ThisSymbol;
//int ThisMagicNumber;

//How to Actually Trade with RSI: The real Way (Including MACD and Stochastic)
//https://www.youtube.com/watch?v=510G39RXuPE

double ThisMA;
int ThisPeriodMA  = 20;

//Bollinger Band
int ThisPeriodBB  = 20;
int ThisDeviation2  = 2;
int ThisDeviation4  = 4;

double ThisBBUpper;
double ThisBBMain;
double ThisBBLower;

double ThisBBUpper2;
double ThisBBLower2;

//RSI
double ThisRSI;
double PrevRSI;
int ThisPeriodRSI = 14;

//
double CurrentBid;
double CurrentAsk;
double CurrentPoint;
double CurrentLotSize;
double CurrentLotMin;
double CurrentLotStep;
double CurrentLotMax;
       



double StopLossPrice = 0;

double StopLevelPrice;

double TakeProfitPrice = 0;

int StopLevel;
string ThisError;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   Print("EA BB Strategy started!");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print("EA BB Strategy stopped!");
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
      //Print("***ONTICK EVENT***************************");
      for(int SymInt=0;SymInt<SymbolsTotal(false);SymInt++)
   {
      
      
      ThisSymbol = SymbolName(SymInt, true);
      //Print("***" + ThisSymbol + "**********" + SymInt + "**************");
       
      if (IsTradingAllowed(ThisSymbol))
      {
      
       Print("***" + ThisSymbol + "**********" + SymInt + "**************");
      
       //Collect Data
       ThisPipValue     = GetPipValue(ThisSymbol);
       //ThisMagicNumber  = GetMagicNumber(ThisSymbol);
       
       //Moving Average
       ThisMA           = GetMovingAverage(ThisSymbol, ThisPeriodMA);
       
       //Bollinger Band 1
       ThisBBUpper      = GetBollingerBand(ThisSymbol, ThisPeriodBB , ThisDeviation2, MODE_UPPER);
       ThisBBMain       = GetBollingerBand(ThisSymbol, ThisPeriodBB, ThisDeviation2, MODE_MAIN);
       ThisBBLower      = GetBollingerBand(ThisSymbol, ThisPeriodBB, ThisDeviation2, MODE_LOWER);
       
       //Bollinger Band 2
       ThisBBUpper2      = GetBollingerBand(ThisSymbol, ThisPeriodBB , ThisDeviation4, MODE_UPPER);
       ThisBBLower2      = GetBollingerBand(ThisSymbol, ThisPeriodBB, ThisDeviation4, MODE_LOWER);
       
       ThisRSI          = GetRSI(ThisSymbol, ThisPeriodRSI, 0);
       PrevRSI          = GetRSI(ThisSymbol, ThisPeriodRSI, 1);
       
       CurrentBid       = MarketInfo(ThisSymbol,MODE_BID);
       CurrentAsk       = MarketInfo(ThisSymbol,MODE_ASK);
       CurrentPoint     = MarketInfo(ThisSymbol,MODE_POINT);
       CurrentLotSize   = MarketInfo(ThisSymbol,MODE_LOTSIZE );
       CurrentLotMin    = MarketInfo(ThisSymbol,MODE_MINLOT );
       CurrentLotStep   = MarketInfo(ThisSymbol,MODE_LOTSTEP );
       CurrentLotMax    = MarketInfo(ThisSymbol,MODE_MAXLOT );
              
       StopLossPrice = 0;
       TakeProfitPrice = 0;
       
       
       StopLevel =  (int)MarketInfo(ThisSymbol, MODE_STOPLEVEL);
       StopLevelPrice = (StopLevel * ThisPipValue);    // 20 * 0.0001 = 0.0002
       
       
       
       if ((CurrentAsk < ThisBBLower && ThisRSI > 50)) //Buy
       //if (CurrentAsk < ThisBBLower)  //Buy
       {
         Print("Price of " + ThisSymbol + " is below signalprice, Sending Buy\Long Order");
         
         StopLossPrice  = ThisBBLower2; 
         TakeProfitPrice = ThisBBMain;
       
         //Fix 130 - https://www.earnforex.com/guides/ordersend-error-130/  -- >> Use BUYLIMIT
         //if (StopLossPrice - CurrentAsk < StopLevel * CurrentPoint) StopLossPrice = CurrentAsk + StopLevel * CurrentPoint;
         //if (CurrentAsk - TakeProfitPrice < StopLevel * CurrentPoint) TakeProfitPrice = CurrentAsk - StopLevel * CurrentPoint;  
         
                 
         
         int OrderID = BuyOrder(ThisSymbol, CurrentAsk, StopLossPrice, TakeProfitPrice); 
         if (OrderID < 0) 
         {
           
            Print("Buy Order rejected for " + ThisSymbol + ". Order Error " + GetLastError());
            
            
         }
         else
         {
            
            Alert("Buy Order placed for " + ThisSymbol + ". Order " + OrderID);
         }
         
       } 
       else if (CurrentBid > ThisBBUpper  && ThisRSI < 50)  //Short/Sell
       //else if (CurrentBid > ThisBBUpper )  //Short/Sell
       {
         Print("Price of " + ThisSymbol + " is above signalprice, Sending Sell\Short Order");
         
         
          
         StopLossPrice = ThisBBUpper2;
         TakeProfitPrice = ThisBBMain;
         
         //Fix 130 - https://www.earnforex.com/guides/ordersend-error-130/  -- >> Use BUYLIMIT
         //if (CurrentBid - StopLossPrice < StopLevel * CurrentPoint) StopLossPrice = CurrentBid - StopLevelPrice * CurrentPoint;
         //if (TakeProfitPrice - CurrentBid < StopLevelPrice * CurrentPoint) TakeProfitPrice = CurrentBid + StopLevelPrice * CurrentPoint;
                 
         
         int OrderID = SellOrder(ThisSymbol, CurrentBid,StopLossPrice, TakeProfitPrice);
         if (OrderID < 0) 
         {
            
            Print("Sell Order rejected for " + ThisSymbol + ". Order Error " + GetLastError());
            
            
            
         
         }
         else
         {
            
            Alert("Sell Order placed for " + ThisSymbol + ". Order " + OrderID);
         }
         
       }
       
         
       
       
              
      }
      
      //Print("************" + ThisSymbol + "*********2*");
      
      
   }

   
  }
//+------------------------------------------------------------------+
