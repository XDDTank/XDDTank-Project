package game.view.settlement
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class SettlementNumber extends MovieClip implements Disposeable
   {
      
      public static const T_RED:int = 1;
      
      public static const T_GREEN:int = 2;
      
      public static const T_BLUE:int = 3;
      
      public static const P_RED:int = 4;
      
      public static const P_BROWN:int = 5;
      
      public static const P_BLUE:int = 6;
      
      public static const P_GREEN:int = 7;
      
      public static const FIGHT:int = 8;
      
      public static const FIGHT_ROBOT:int = 9;
       
      
      public var num_gold_1:MovieClip;
      
      public var num_gold_2:MovieClip;
      
      public var num_gold_3:MovieClip;
      
      public var num_gold_4:MovieClip;
      
      public var num_gold_5:MovieClip;
      
      public var num_gold_6:MovieClip;
      
      public var num_greenBig_1:MovieClip;
      
      public var num_greenBig_2:MovieClip;
      
      public var num_greenBig_3:MovieClip;
      
      public var num_greenBig_4:MovieClip;
      
      public var num_greenBig_5:MovieClip;
      
      public var num_greenBig_6:MovieClip;
      
      public var num_blueBig_1:MovieClip;
      
      public var num_blueBig_2:MovieClip;
      
      public var num_blueBig_3:MovieClip;
      
      public var num_blueBig_4:MovieClip;
      
      public var num_blueBig_5:MovieClip;
      
      public var num_blueBig_6:MovieClip;
      
      public var pro_red_1:MovieClip;
      
      public var pro_red_2:MovieClip;
      
      public var pro_red_3:MovieClip;
      
      public var pro_red_4:MovieClip;
      
      public var pro_red_5:MovieClip;
      
      public var pro_red_6:MovieClip;
      
      public var pro_blue_1:MovieClip;
      
      public var pro_blue_2:MovieClip;
      
      public var pro_blue_3:MovieClip;
      
      public var pro_blue_4:MovieClip;
      
      public var pro_blue_5:MovieClip;
      
      public var pro_blue_6:MovieClip;
      
      public var pro_green_1:MovieClip;
      
      public var pro_green_2:MovieClip;
      
      public var pro_green_3:MovieClip;
      
      public var pro_green_4:MovieClip;
      
      public var pro_green_5:MovieClip;
      
      public var pro_green_6:MovieClip;
      
      public var pro_brown_1:MovieClip;
      
      public var pro_brown_2:MovieClip;
      
      public var pro_brown_3:MovieClip;
      
      public var pro_brown_4:MovieClip;
      
      public var pro_brown_5:MovieClip;
      
      public var pro_brown_6:MovieClip;
      
      public var fight_1:MovieClip;
      
      public var fight_2:MovieClip;
      
      public var fight_3:MovieClip;
      
      public var fight_4:MovieClip;
      
      public var fight_5:MovieClip;
      
      public var fight_6:MovieClip;
      
      public var num_fightrobot_1:MovieClip;
      
      public var num_fightrobot_2:MovieClip;
      
      public var num_fightrobot_3:MovieClip;
      
      public var num_fightrobot_4:MovieClip;
      
      public var num_fightrobot_5:MovieClip;
      
      public var num_fightrobot_6:MovieClip;
      
      private var _num_1:MovieClip;
      
      private var _num_2:MovieClip;
      
      private var _num_3:MovieClip;
      
      private var _num_4:MovieClip;
      
      private var _num_5:MovieClip;
      
      private var _num_6:MovieClip;
      
      private var NUM_DIR:int = 17;
      
      private var _type:int;
      
      private var _point:Point;
      
      private var _currentNum:int = 0;
      
      private var _targetNum:int = 0;
      
      private var tst:int = 1;
      
      public function SettlementNumber()
      {
         this._num_1 = new MovieClip();
         this._num_2 = new MovieClip();
         this._num_3 = new MovieClip();
         this._num_4 = new MovieClip();
         this._num_5 = new MovieClip();
         this._num_6 = new MovieClip();
         this._point = new Point(0,0);
         super();
         stop();
      }
      
      public function set point(param1:Point) : void
      {
         this._point = param1;
         x = param1.x;
         y = param1.y;
      }
      
      public function get point() : Point
      {
         return this._point;
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
         switch(this._type)
         {
            case T_RED:
               this._num_1 = this.num_gold_1;
               this._num_2 = this.num_gold_2;
               this._num_3 = this.num_gold_3;
               this._num_4 = this.num_gold_4;
               this._num_5 = this.num_gold_5;
               this._num_6 = this.num_gold_6;
               break;
            case T_GREEN:
               this._num_1 = this.num_greenBig_1;
               this._num_2 = this.num_greenBig_2;
               this._num_3 = this.num_greenBig_3;
               this._num_4 = this.num_greenBig_4;
               this._num_5 = this.num_greenBig_5;
               this._num_6 = this.num_greenBig_6;
               break;
            case T_BLUE:
               this._num_1 = this.num_blueBig_1;
               this._num_2 = this.num_blueBig_2;
               this._num_3 = this.num_blueBig_3;
               this._num_4 = this.num_blueBig_4;
               this._num_5 = this.num_blueBig_5;
               this._num_6 = this.num_blueBig_6;
               break;
            case P_RED:
               this._num_1 = this.pro_red_1;
               this._num_2 = this.pro_red_2;
               this._num_3 = this.pro_red_3;
               this._num_4 = this.pro_red_4;
               this._num_5 = this.pro_red_5;
               this._num_6 = this.pro_red_6;
               this.NUM_DIR = 12;
               break;
            case P_BLUE:
               this._num_1 = this.pro_blue_1;
               this._num_2 = this.pro_blue_2;
               this._num_3 = this.pro_blue_3;
               this._num_4 = this.pro_blue_4;
               this._num_5 = this.pro_blue_5;
               this._num_6 = this.pro_blue_6;
               this.NUM_DIR = 12;
               break;
            case P_BROWN:
               this._num_1 = this.pro_brown_1;
               this._num_2 = this.pro_brown_2;
               this._num_3 = this.pro_brown_3;
               this._num_4 = this.pro_brown_4;
               this._num_5 = this.pro_brown_5;
               this._num_6 = this.pro_brown_6;
               this.NUM_DIR = 12;
               break;
            case P_GREEN:
               this._num_1 = this.pro_green_1;
               this._num_2 = this.pro_green_2;
               this._num_3 = this.pro_green_3;
               this._num_4 = this.pro_green_4;
               this._num_5 = this.pro_green_5;
               this._num_6 = this.pro_green_6;
               this.NUM_DIR = 12;
               break;
            case FIGHT:
               this._num_1 = this.fight_1;
               this._num_2 = this.fight_2;
               this._num_3 = this.fight_3;
               this._num_4 = this.fight_4;
               this._num_5 = this.fight_5;
               this._num_6 = this.fight_6;
               this.NUM_DIR = 12;
               break;
            case FIGHT_ROBOT:
               this._num_1 = this.num_fightrobot_1;
               this._num_2 = this.num_fightrobot_2;
               this._num_3 = this.num_fightrobot_3;
               this._num_4 = this.num_fightrobot_4;
               this._num_5 = this.num_fightrobot_5;
               this._num_6 = this.num_fightrobot_6;
               this.NUM_DIR = 12;
         }
         this.num_gold_1.visible = this._type == T_RED;
         this.num_gold_2.visible = this._type == T_RED;
         this.num_gold_3.visible = this._type == T_RED;
         this.num_gold_4.visible = this._type == T_RED;
         this.num_gold_5.visible = this._type == T_RED;
         this.num_gold_6.visible = this._type == T_RED;
         this.num_greenBig_1.visible = this._type == T_GREEN;
         this.num_greenBig_2.visible = this._type == T_GREEN;
         this.num_greenBig_3.visible = this._type == T_GREEN;
         this.num_greenBig_4.visible = this._type == T_GREEN;
         this.num_greenBig_5.visible = this._type == T_GREEN;
         this.num_greenBig_6.visible = this._type == T_GREEN;
         this.num_blueBig_1.visible = this._type == T_BLUE;
         this.num_blueBig_2.visible = this._type == T_BLUE;
         this.num_blueBig_3.visible = this._type == T_BLUE;
         this.num_blueBig_4.visible = this._type == T_BLUE;
         this.num_blueBig_5.visible = this._type == T_BLUE;
         this.num_blueBig_6.visible = this._type == T_BLUE;
         this.pro_blue_1.visible = this._type == P_BLUE;
         this.pro_blue_2.visible = this._type == P_BLUE;
         this.pro_blue_3.visible = this._type == P_BLUE;
         this.pro_blue_4.visible = this._type == P_BLUE;
         this.pro_blue_5.visible = this._type == P_BLUE;
         this.pro_blue_6.visible = this._type == P_BLUE;
         this.pro_red_1.visible = this._type == P_RED;
         this.pro_red_2.visible = this._type == P_RED;
         this.pro_red_3.visible = this._type == P_RED;
         this.pro_red_4.visible = this._type == P_RED;
         this.pro_red_5.visible = this._type == P_RED;
         this.pro_red_6.visible = this._type == P_RED;
         this.pro_brown_1.visible = this._type == P_BROWN;
         this.pro_brown_2.visible = this._type == P_BROWN;
         this.pro_brown_3.visible = this._type == P_BROWN;
         this.pro_brown_4.visible = this._type == P_BROWN;
         this.pro_brown_5.visible = this._type == P_BROWN;
         this.pro_brown_6.visible = this._type == P_BROWN;
         this.pro_green_1.visible = this._type == P_GREEN;
         this.pro_green_2.visible = this._type == P_GREEN;
         this.pro_green_3.visible = this._type == P_GREEN;
         this.pro_green_4.visible = this._type == P_GREEN;
         this.pro_green_5.visible = this._type == P_GREEN;
         this.pro_green_6.visible = this._type == P_GREEN;
         this.fight_1.visible = this._type == FIGHT;
         this.fight_2.visible = this._type == FIGHT;
         this.fight_3.visible = this._type == FIGHT;
         this.fight_4.visible = this._type == FIGHT;
         this.fight_5.visible = this._type == FIGHT;
         this.fight_6.visible = this._type == FIGHT;
         this.num_fightrobot_1.visible = this._type == FIGHT_ROBOT;
         this.num_fightrobot_2.visible = this._type == FIGHT_ROBOT;
         this.num_fightrobot_3.visible = this._type == FIGHT_ROBOT;
         this.num_fightrobot_4.visible = this._type == FIGHT_ROBOT;
         this.num_fightrobot_5.visible = this._type == FIGHT_ROBOT;
         this.num_fightrobot_6.visible = this._type == FIGHT_ROBOT;
      }
      
      public function playAndStopNum(param1:int) : void
      {
         param1 = Math.abs(param1);
         this._currentNum = 0;
         if(param1 > 0)
         {
            this._targetNum = param1;
            addEventListener(Event.ENTER_FRAME,this.__enterFrame);
         }
         this.setNum(0);
      }
      
      public function setNum(param1:int) : void
      {
         param1 = Math.abs(param1);
         var _loc2_:int = param1 / 100000;
         var _loc3_:int = param1 % 100000 / 10000;
         var _loc4_:int = param1 % 100000 % 10000 / 1000;
         var _loc5_:int = param1 % 100000 % 10000 % 1000 / 100;
         var _loc6_:int = param1 % 100000 % 10000 % 1000 % 100 / 10;
         var _loc7_:int = param1 % 100000 % 10000 % 1000 % 100 % 10;
         this._num_1.visible = true;
         this._num_2.visible = true;
         this._num_3.visible = true;
         this._num_4.visible = true;
         this._num_5.visible = true;
         if(_loc2_ != 0)
         {
            x = this._point.x;
            this._num_1.gotoAndStop(_loc2_ + 1);
            this._num_2.gotoAndStop(_loc3_ + 1);
            this._num_3.gotoAndStop(_loc4_ + 1);
            this._num_4.gotoAndStop(_loc5_ + 1);
            this._num_5.gotoAndStop(_loc6_ + 1);
         }
         else
         {
            this._num_1.visible = false;
            x = this._point.x - this.NUM_DIR;
            if(_loc3_ != 0)
            {
               this._num_2.gotoAndStop(_loc3_ + 1);
               this._num_3.gotoAndStop(_loc4_ + 1);
               this._num_4.gotoAndStop(_loc5_ + 1);
               this._num_5.gotoAndStop(_loc6_ + 1);
            }
            else
            {
               this._num_2.visible = false;
               x -= this.NUM_DIR;
               if(_loc4_ != 0)
               {
                  this._num_3.gotoAndStop(_loc4_ + 1);
                  this._num_4.gotoAndStop(_loc5_ + 1);
                  this._num_5.gotoAndStop(_loc6_ + 1);
               }
               else
               {
                  this._num_3.visible = false;
                  x -= this.NUM_DIR;
                  if(_loc5_ != 0)
                  {
                     this._num_4.gotoAndStop(_loc5_ + 1);
                     this._num_5.gotoAndStop(_loc6_ + 1);
                  }
                  else
                  {
                     this._num_4.visible = false;
                     x -= this.NUM_DIR;
                     if(_loc6_ != 0)
                     {
                        this._num_5.gotoAndStop(_loc6_ + 1);
                     }
                     else
                     {
                        this._num_5.visible = false;
                        x -= this.NUM_DIR;
                     }
                  }
               }
            }
         }
         this._num_6.gotoAndStop(_loc7_ + 1);
      }
      
      private function __enterFrame(param1:Event) : void
      {
         var _loc2_:int = Math.pow(this.tst,2);
         this._currentNum += _loc2_;
         this.tst += 2;
         if(this._currentNum >= this._targetNum)
         {
            this._currentNum = this._targetNum;
            removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         }
         this.setNum(this._currentNum);
      }
      
      public function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
         ObjectUtils.disposeObject(this._num_1);
         this._num_1 = null;
         ObjectUtils.disposeObject(this._num_2);
         this._num_2 = null;
         ObjectUtils.disposeObject(this._num_3);
         this._num_3 = null;
         ObjectUtils.disposeObject(this._num_4);
         this._num_4 = null;
         ObjectUtils.disposeObject(this._num_5);
         this._num_5 = null;
         ObjectUtils.disposeObject(this.num_gold_1);
         this.num_gold_1 = null;
         ObjectUtils.disposeObject(this.num_gold_2);
         this.num_gold_2;
         ObjectUtils.disposeObject(this.num_gold_3);
         this.num_gold_3 = null;
         ObjectUtils.disposeObject(this.num_gold_4);
         this.num_gold_4 = null;
         ObjectUtils.disposeObject(this.num_gold_5);
         this.num_gold_5 = null;
         ObjectUtils.disposeObject(this.num_greenBig_1);
         this.num_greenBig_1 = null;
         ObjectUtils.disposeObject(this.num_greenBig_2);
         this.num_greenBig_2;
         ObjectUtils.disposeObject(this.num_greenBig_3);
         this.num_greenBig_3 = null;
         ObjectUtils.disposeObject(this.num_greenBig_4);
         this.num_greenBig_4 = null;
         ObjectUtils.disposeObject(this.num_greenBig_5);
         this.num_greenBig_5 = null;
         ObjectUtils.disposeObject(this.pro_blue_1);
         this.pro_blue_1 = null;
         ObjectUtils.disposeObject(this.pro_blue_2);
         this.pro_blue_2;
         ObjectUtils.disposeObject(this.pro_blue_3);
         this.pro_blue_3 = null;
         ObjectUtils.disposeObject(this.pro_blue_4);
         this.pro_blue_4 = null;
         ObjectUtils.disposeObject(this.pro_blue_5);
         this.pro_blue_5 = null;
         ObjectUtils.disposeObject(this.pro_red_1);
         this.pro_red_1 = null;
         ObjectUtils.disposeObject(this.pro_red_2);
         this.pro_red_2;
         ObjectUtils.disposeObject(this.pro_red_3);
         this.pro_red_3 = null;
         ObjectUtils.disposeObject(this.pro_red_4);
         this.pro_red_4 = null;
         ObjectUtils.disposeObject(this.pro_red_5);
         this.pro_red_5 = null;
         ObjectUtils.disposeObject(this.pro_green_1);
         this.pro_green_1 = null;
         ObjectUtils.disposeObject(this.pro_green_2);
         this.pro_green_2;
         ObjectUtils.disposeObject(this.pro_green_3);
         this.pro_green_3 = null;
         ObjectUtils.disposeObject(this.pro_green_4);
         this.pro_green_4 = null;
         ObjectUtils.disposeObject(this.pro_green_5);
         this.pro_green_5 = null;
         ObjectUtils.disposeObject(this.pro_brown_1);
         this.pro_brown_1 = null;
         ObjectUtils.disposeObject(this.pro_brown_2);
         this.pro_brown_2;
         ObjectUtils.disposeObject(this.pro_brown_3);
         this.pro_brown_3 = null;
         ObjectUtils.disposeObject(this.pro_brown_4);
         this.pro_brown_4 = null;
         ObjectUtils.disposeObject(this.pro_brown_5);
         this.pro_brown_5 = null;
         ObjectUtils.disposeObject(this.fight_1);
         this.fight_1 = null;
         ObjectUtils.disposeObject(this.fight_2);
         this.fight_2;
         ObjectUtils.disposeObject(this.fight_3);
         this.fight_3 = null;
         ObjectUtils.disposeObject(this.fight_4);
         this.fight_4 = null;
         ObjectUtils.disposeObject(this.fight_5);
         this.fight_5 = null;
      }
   }
}
