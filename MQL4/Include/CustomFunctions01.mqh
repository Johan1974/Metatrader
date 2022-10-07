//+------------------------------------------------------------------+
//|                                            CustomFunctions01.mqh |
//|                                                    Mohsen Hassan |
//|                             https://www.MontrealTradingGroup.com |
//+------------------------------------------------------------------+
#property copyright "Mohsen Hassan"
#property link      "https://www.MontrealTradingGroup.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+


double CalculateTakeProfit(bool isLong, double entryPrice, int pips)
{
   double takeProfit;
   if(isLong)
   {
      takeProfit = entryPrice + pips * GetPipValue();
   }
   else
   {
      takeProfit = entryPrice - pips * GetPipValue();
   }
   
   return takeProfit;
}

double CalculateStopLoss(bool isLong, double entryPrice, int pips)
{
   double stopLoss;
   if(isLong)
   {
      stopLoss = entryPrice - pips * GetPipValue();
   }
   else
   {
      stopLoss = entryPrice + pips * GetPipValue();
   }
   return stopLoss;
}




double GetPipValue()
{
   if(_Digits >=4)
   {
      return 0.0001;
   }
   else
   {
      return 0.01;
   }
}


void DayOfWeekAlert()
{

   Alert("");
   
   int dayOfWeek = DayOfWeek();
   
   switch (dayOfWeek)
   {
      case 1 : Alert("We are Monday. Let's try to enter new trades"); break;
      case 2 : Alert("We are tuesday. Let's try to enter new trades or close existing trades");break;
      case 3 : Alert("We are wednesday. Let's try to enter new trades or close existing trades");break;
      case 4 : Alert("We are thursday. Let's try to enter new trades or close existing trades");break;
      case 5 : Alert("We are friday. Close existing trades");break;
      case 6 : Alert("It's the weekend. No Trading.");break;
      case 0 : Alert("It's the weekend. No Trading.");break;
      default : Alert("Error. No such day in the week.");
   }
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
      Print("Expert Advisor is NOT Allowed to Trade. Check AutoTrading. " + ThisSymbol);
      return false;
   }
   
   if(!IsTradeAllowed(ThisSymbol, TimeCurrent()))
   {
      //Print("Trading Not Allowed for " + ThisSymbol + " and Time");
      return false;
   }

   if(OrdersTotal() > 4 )
   {
      Print("Trading NOT Allowed, Max orders reached");
      return false;
   }
     
   return true;
}
  
bool DoubleTrade(string ThisSymbol)
{

   for (int i= 0; i < OrdersTotal(); i++)
   {
     //Print ("******");
     //Print ("OrdersTotal " +  OrdersTotal());
     if(OrderSelect(i, SELECT_BY_POS)==true)
     {
      //Print ("ThisSymbol   " + i +  ThisSymbol);
      //Print ("OrderSymbol  " + i + OrderSymbol());   
      if (ThisSymbol == OrderSymbol())
      {
        return true; 
      }
     }
     //Print ("******"); 
   } 
   return false;
   
}  
  
  
double OptimalLotSize(double maxRiskPrc, int maxLossInPips, string ThisSymbol)
{

  double accEquity = AccountEquity();
  Print("accEquity: " + accEquity);
  
  double lotSize = MarketInfo(ThisSymbol,MODE_LOTSIZE);
  Print("lotSize: " + lotSize);
  
  double tickValue = MarketInfo(ThisSymbol,MODE_TICKVALUE);
  
  if(Digits <= 3)
  {
   tickValue = tickValue /100;
  }
  
  Print("tickValue: " + tickValue);
  
  double maxLossDollar = accEquity * maxRiskPrc;
  Print("maxLossDollar: " + maxLossDollar);
  
  double maxLossInQuoteCurr = maxLossDollar / tickValue;
  Print("maxLossInQuoteCurr: " + maxLossInQuoteCurr);
  
  double optimalLotSize = NormalizeDouble(maxLossInQuoteCurr /(maxLossInPips * GetPipValue())/lotSize,2);
  
  return optimalLotSize;
 
}


double OptimalLotSize(double maxRiskPrc, double entryPrice, double stopLoss, string ThisSymbol)
{
   int maxLossInPips = MathAbs(entryPrice - stopLoss)/GetPipValue();
   return OptimalLotSize(maxRiskPrc,maxLossInPips, ThisSymbol);
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