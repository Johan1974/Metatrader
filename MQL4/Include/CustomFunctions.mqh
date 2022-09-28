//+------------------------------------------------------------------+
//|                                            CustomFunctions.mqh   |
//|                                                   Johan Lijffijt |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Johan Lijffijt"
#property link  ""    
#property strict

int THISTIME = PERIOD_CURRENT;

double CalculateTakeProfit(bool isLong, double entryPrice, int pips)
{
   double takeProfit;
   if(isLong)
   {
      takeProfit = entryPrice + pips * GetPipValue("123");
   }
   else
   {
      takeProfit = entryPrice - pips * GetPipValue("123");
   }
   
   return takeProfit;
}

double CalculateStopLoss(bool isLong, double entryPrice, int pips)
{
   double stopLoss;
   if(isLong)
   {
      stopLoss = entryPrice - pips * GetPipValue("123");
   }
   else
   {
      stopLoss = entryPrice + pips * GetPipValue("123");
   }
   return stopLoss;
}

double GetTradeContractSize(string ThisSymbol)
{

   return SymbolInfoDouble(ThisSymbol, SYMBOL_TRADE_CONTRACT_SIZE);
   
}

int BuyOrder(string ThisSymbol, double CurrentAsk, double StopLoss, double TakeProfit)
{
   
   return OrderSend(ThisSymbol,OP_BUY, 0.01, CurrentAsk, 10, StopLoss, TakeProfit, NULL, GetMagicNumber(ThisSymbol) ) ;
}

int SellOrder(string ThisSymbol, double CurrentBid, double StopLoss, double TakeProfit)
{
   
   return OrderSend(ThisSymbol,OP_SELL, 0.01, CurrentBid, 10, StopLoss, TakeProfit, NULL, GetMagicNumber(ThisSymbol) ) ;
}


double GetMinimumLot(string ThisSymbol)
{

   return MarketInfo(ThisSymbol,MODE_MINLOT);
   
}


double GetPipValue(string ThisSymbol)
{

   int digits = (int)MarketInfo(ThisSymbol,MODE_DIGITS);
   if(digits >=4)
   {
      return 0.0001;
   }
   else
   {
      return 0.01;
   }
}

double GetMovingAverage(string ThisSymbol, int ThisPeriod )
{
   int TheseDigits = (int)MarketInfo(ThisSymbol,MODE_DIGITS);
   
   double ThisIma = iMA(ThisSymbol, THISTIME,ThisPeriod, 0, MODE_SMA, PRICE_CLOSE, 0);
   
   return NormalizeDouble(ThisIma, TheseDigits);

}

double GetRSI(string ThisSymbol, int ThisPeriod )
{
   int TheseDigits = (int)MarketInfo(ThisSymbol,MODE_DIGITS);
   
   double ThisRSI = iRSI(ThisSymbol, THISTIME,ThisPeriod, PRICE_CLOSE, 0);
   
   return NormalizeDouble(ThisRSI, TheseDigits);

}


double GetBollingerBand(string ThisSymbol, int ThisPeriod, int ThisDev, int ThisMode )
{
   int TheseDigits = (int)MarketInfo(ThisSymbol,MODE_DIGITS);
   
   double ThisBB = iBands(ThisSymbol,THISTIME, ThisPeriod, ThisDev, 0, PRICE_CLOSE, ThisMode, 0);
   
   return NormalizeDouble(ThisBB, TheseDigits);

}



int GetMagicNumber(string ThisSymbol)
{
   
   bool x =  StringToUpper(ThisSymbol);
      
   
   //Remove all other characters  
   for(int i=0;i<255;i++)
   {
      if ((i < 65) || (i > 90))
      {
         StringReplace(ThisSymbol,CharToString(i),"");
      }     
   }
    
   for(int i=0;i<26;i++)
   {
      StringReplace(ThisSymbol,CharToString(i+65),i+1);   
   }
   
   ThisSymbol = StringSubstr(ThisSymbol,0,9);
   
   
   return StrToInteger(ThisSymbol); 

}


double GetStopLossPrice(bool bIsLongPosition, double entryPrice, int maxLossInPips)
{
   double stopLossPrice;
   if (bIsLongPosition)
   {
      stopLossPrice = entryPrice - maxLossInPips * 0.0001;
   }
   else
   {
      stopLossPrice = entryPrice + maxLossInPips * 0.0001;
   }
   return stopLossPrice;
}


bool IsTradingAllowed(string ThisSymbol)
{
   if(!IsTradeAllowed())
   {
      Print("Expert Advisor is NOT Allowed to Trade. Check AutoTrading.");
      return false;
   }
   
   if(!IsTradeAllowed(ThisSymbol, TimeCurrent()))
   {
      //Print("Trading NOT Allowed for " + ThisSymbol + " and Time");
      return false;
   }

   if(OrdersTotal() > 4 )
   {
      //Print("Trading NOT Allowed, Max orders reached");
      return false;
   }
   

   return true;
}
  
  
double OptimalLotSize(double maxRiskPrc, int maxLossInPips)
{

  double accEquity = AccountEquity();
  Print("accEquity: " + accEquity);
  
  double lotSize = MarketInfo(NULL,MODE_LOTSIZE);
  Print("lotSize: " + lotSize);
  
  double tickValue = MarketInfo(NULL,MODE_TICKVALUE);
  
  if(Digits <= 3)
  {
   tickValue = tickValue /100;
  }
  
  Print("tickValue: " + tickValue);
  
  double maxLossDollar = accEquity * maxRiskPrc;
  Print("maxLossDollar: " + maxLossDollar);
  
  double maxLossInQuoteCurr = maxLossDollar / tickValue;
  Print("maxLossInQuoteCurr: " + maxLossInQuoteCurr);
  
  double optimalLotSize = NormalizeDouble(maxLossInQuoteCurr /(maxLossInPips * GetPipValue("123"))/lotSize,2);
  
  return optimalLotSize;
 
}


double OptimalLotSize(double maxRiskPrc, double entryPrice, double stopLoss)
{
   int maxLossInPips = MathAbs(entryPrice - stopLoss)/GetPipValue("123");
   return OptimalLotSize(maxRiskPrc,maxLossInPips);
}



bool CheckIfOpenOrdersByMagicNB(int magicNB)
{
   int openOrders = OrdersTotal();
   
   for(int i = 0; i < openOrders; i++)
   {
      if(OrderSelect(i,SELECT_BY_POS)==true)
      {
         if(OrderMagicNumber() == magicNB) 
         {
            return true;
         }  
      }
   }
   return false;
}