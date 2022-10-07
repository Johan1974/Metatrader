//+------------------------------------------------------------------+
//|                                            CustomFunctions.mqh   |
//|                                                   Johan Lijffijt |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Johan Lijffijt"
#property link  ""    
#property strict

int THISTIME = PERIOD_CURRENT;



double GetTradeContractSize(string ThisSymbol)
{

   return SymbolInfoDouble(ThisSymbol, SYMBOL_TRADE_CONTRACT_SIZE);
   
}

int BuyOrder(string ThisSymbol, double CurrentAsk, double StopLoss, double TakeProfit, double RiskPerTrade )
{

   double LotSize = OptimalLotSize(RiskPerTrade, CurrentAsk, StopLoss, ThisSymbol);
   
   return OrderSend(ThisSymbol,OP_BUYLIMIT,LotSize, CurrentAsk, 10, StopLoss, TakeProfit ) ;

}




int SellOrder(string ThisSymbol, double CurrentBid, double StopLoss, double TakeProfit, double RiskPerTrade)
{
   double LotSize = OptimalLotSize(RiskPerTrade, CurrentBid, StopLoss, ThisSymbol);
   
   return OrderSend(ThisSymbol,OP_SELLLIMIT, LotSize, CurrentBid, 10, StopLoss, TakeProfit) ;
}


double GetMinimumLot(string ThisSymbol)
{

   return MarketInfo(ThisSymbol,MODE_MINLOT);
   
}


double GetPipValue(string ThisSymbol)
{
   if((int)MarketInfo(ThisSymbol,MODE_DIGITS) >=4)
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
   
   double ThisIma = iMA(ThisSymbol,THISTIME,ThisPeriod, 0, MODE_SMA, PRICE_CLOSE, 0);
   
   return NormalizeDouble(ThisIma, TheseDigits);

}

double GetRSI(string ThisSymbol, int ThisPeriod, int Shift )
{
   int TheseDigits = (int)MarketInfo(ThisSymbol,MODE_DIGITS);
   
   double ThisRSI = iRSI(ThisSymbol, THISTIME,ThisPeriod, PRICE_CLOSE, Shift);
   
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

bool IsTradingAllowed(string ThisSymbol)
{
   
   if(!IsTradeAllowed())
   {
      Print("Expert Advisor is NOT Allowed to Trade. Check AutoTrading. " + ThisSymbol);
      return false;
   }
   
   if(!IsTradeAllowed(ThisSymbol, TimeCurrent()))
   {
      //Print("Trading Not Allowed for " + ThisSymbol + " and Time");
      return false;
   }

   if (DoubleTrade(ThisSymbol)) 
   {
      //Print("Symbol " + ThisSymbol + " allready in order.");
      return false;
   }

   if(OrdersTotal() > 4 )
   {
      //Print("Trading NOT Allowed, Max orders reached");
      return false;
   }
     
   return true;
}
  
bool DoubleTrade(string ThisSymbol)
{
   string SelectSymbol;
   
   for (int i= 0; i < OrdersTotal(); i++)
   {
     
     
     if(OrderSelect(i, SELECT_BY_POS)==true)
     {
      
      if (ThisSymbol == OrderSymbol())
      {
        return true; 
      }
     }
     
   } 
   return false;
   
}  
  
  
double OptimalLotSize(double maxRiskPrc, int maxLossInPips, string ThisSymbol)
{

  
  double accEquity = AccountEquity();
  
  double lotSize = MarketInfo(ThisSymbol,MODE_LOTSIZE);
  
  double tickValue = MarketInfo(ThisSymbol,MODE_TICKVALUE);
  
  
  if(MarketInfo(ThisSymbol,MODE_DIGITS ) <= 3)
  {
   tickValue = tickValue /100;
   
  }
  
  
  double maxLossDollar = accEquity * maxRiskPrc;
   
  double maxLossInQuoteCurr = maxLossDollar / tickValue;
   
  double optimalLotSize = NormalizeDouble(maxLossInQuoteCurr /(maxLossInPips * GetPipValue( ThisSymbol))/lotSize,2);
  
  return optimalLotSize;
 
}


double OptimalLotSize(double maxRiskPrc, double entryPrice, double stopLoss, string ThisSymbol)
{

   int maxLossInPips = MathAbs(entryPrice - stopLoss)/GetPipValue(ThisSymbol);
   
   if (maxLossInPips == 0) 
   {
      maxLossInPips = 1;
   } 
   
   return OptimalLotSize(maxRiskPrc,maxLossInPips, ThisSymbol);
}


