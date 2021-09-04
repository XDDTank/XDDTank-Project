package activity.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ActivityNum extends MovieClip
   {
      
      public static const COST:String = "Cost";
      
      public static const CHARGE:String = "Charge";
      
      public static const CHARGE_ONCE:String = "ChargeOnce";
       
      
      public var num1_cost:MovieClip;
      
      public var num2_cost:MovieClip;
      
      public var num3_cost:MovieClip;
      
      public var num4_cost:MovieClip;
      
      public var num5_cost:MovieClip;
      
      public var num6_cost:MovieClip;
      
      public var num7_cost:MovieClip;
      
      public var num1_charge:MovieClip;
      
      public var num2_charge:MovieClip;
      
      public var num3_charge:MovieClip;
      
      public var num4_charge:MovieClip;
      
      public var num5_charge:MovieClip;
      
      public var num6_charge:MovieClip;
      
      public var num7_charge:MovieClip;
      
      private var _num_1:MovieClip;
      
      private var _num_2:MovieClip;
      
      private var _num_3:MovieClip;
      
      private var _num_4:MovieClip;
      
      private var _num_5:MovieClip;
      
      private var _num_6:MovieClip;
      
      private var _num_7:MovieClip;
      
      private var _type:String;
      
      private var NUM_DIR:int = 20;
      
      private var _point:Point;
      
      public function ActivityNum()
      {
         this._num_1 = new MovieClip();
         this._num_2 = new MovieClip();
         this._num_3 = new MovieClip();
         this._num_4 = new MovieClip();
         this._num_5 = new MovieClip();
         this._num_6 = new MovieClip();
         this._num_7 = new MovieClip();
         this._point = new Point(57,2);
         super();
      }
      
      public function set type(param1:String) : void
      {
         this._type = param1;
         this._point = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityNum.pos" + this._type);
         PositionUtils.setPos(this,this._point);
         switch(this._type)
         {
            case COST:
               this._num_1 = this.num1_cost;
               this._num_2 = this.num2_cost;
               this._num_3 = this.num3_cost;
               this._num_4 = this.num4_cost;
               this._num_5 = this.num5_cost;
               this._num_6 = this.num6_cost;
               this._num_7 = this.num7_cost;
               break;
            case CHARGE:
            case CHARGE_ONCE:
               this._num_1 = this.num1_charge;
               this._num_2 = this.num2_charge;
               this._num_3 = this.num3_charge;
               this._num_4 = this.num4_charge;
               this._num_5 = this.num5_charge;
               this._num_6 = this.num6_charge;
               this._num_7 = this.num7_charge;
         }
         this.num1_cost.visible = this._type == COST;
         this.num2_cost.visible = this._type == COST;
         this.num3_cost.visible = this._type == COST;
         this.num4_cost.visible = this._type == COST;
         this.num5_cost.visible = this._type == COST;
         this.num6_cost.visible = this._type == COST;
         this.num7_cost.visible = this._type == COST;
         this.num1_charge.visible = this._type == CHARGE;
         this.num2_charge.visible = this._type == CHARGE;
         this.num3_charge.visible = this._type == CHARGE;
         this.num4_charge.visible = this._type == CHARGE;
         this.num5_charge.visible = this._type == CHARGE;
         this.num6_charge.visible = this._type == CHARGE;
         this.num7_charge.visible = this._type == CHARGE;
      }
      
      public function setNum(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         param1 = Math.abs(param1);
         _loc2_ = param1 / 1000000;
         _loc3_ = param1 % 10000000 % 1000000 / 100000;
         _loc4_ = param1 % 10000000 % 1000000 % 100000 / 10000;
         var _loc5_:int = param1 % 10000000 % 1000000 % 100000 % 10000 / 1000;
         var _loc6_:int = param1 % 10000000 % 1000000 % 100000 % 10000 % 1000 / 100;
         _loc7_ = param1 % 10000000 % 1000000 % 100000 % 10000 % 1000 % 100 / 10;
         var _loc8_:int = param1 % 10000000 % 1000000 % 100000 % 10000 % 1000 % 100 % 10;
         this._num_1.visible = true;
         this._num_2.visible = true;
         this._num_3.visible = true;
         this._num_4.visible = true;
         this._num_5.visible = true;
         this._num_6.visible = true;
         this._num_7.visible = true;
         if(_loc2_ != 0)
         {
            x = this._point.x;
            this._num_1.gotoAndStop(_loc2_ + 1);
            this._num_2.gotoAndStop(_loc3_ + 1);
            this._num_3.gotoAndStop(_loc4_ + 1);
            this._num_4.gotoAndStop(_loc5_ + 1);
            this._num_5.gotoAndStop(_loc6_ + 1);
            this._num_6.gotoAndStop(_loc7_ + 1);
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
               this._num_6.gotoAndStop(_loc7_ + 1);
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
                  this._num_6.gotoAndStop(_loc7_ + 1);
               }
               else
               {
                  this._num_3.visible = false;
                  x -= this.NUM_DIR;
                  if(_loc5_ != 0)
                  {
                     this._num_4.gotoAndStop(_loc5_ + 1);
                     this._num_5.gotoAndStop(_loc6_ + 1);
                     this._num_6.gotoAndStop(_loc7_ + 1);
                  }
                  else
                  {
                     this._num_4.visible = false;
                     if(_loc6_ != 0)
                     {
                        this._num_5.gotoAndStop(_loc6_ + 1);
                        this._num_6.gotoAndStop(_loc7_ + 1);
                     }
                     else
                     {
                        this._num_5.visible = false;
                        if(_loc7_ != 0)
                        {
                           this._num_6.gotoAndStop(_loc7_ + 1);
                        }
                        else
                        {
                           this._num_6.visible = false;
                           x -= this.NUM_DIR;
                        }
                     }
                  }
               }
            }
         }
         this._num_7.gotoAndStop(_loc8_ + 1);
      }
      
      public function dispose() : void
      {
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
         ObjectUtils.disposeObject(this._num_6);
         this._num_5 = null;
         ObjectUtils.disposeObject(this._num_7);
         this._num_5 = null;
      }
   }
}
