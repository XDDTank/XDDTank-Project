package fightToolBox
{
   public class FightToolBoxModel
   {
       
      
      private var _fightVipLevel_low:int = 0;
      
      private var _fightVipLevel_mid:int = 0;
      
      private var _fightVipLevel_high:int = 0;
      
      private var _fightVipTime_low:int = 0;
      
      private var _fightVipTime_mid:int = 0;
      
      private var _fightVipTime_high:int = 0;
      
      private var _fightVipPrice_low:int = 0;
      
      private var _fightVipPrice_mid:int = 0;
      
      private var _fightVipPrice_high:int = 0;
      
      private var _fightVipDamage_low:int = 0;
      
      private var _fightVipDamage_mid:int = 0;
      
      private var _fightVipDamage_high:int = 0;
      
      private var _guideDamageRatio_0:Number = 0;
      
      private var _guideDamageRatio_1:Number = 0;
      
      private var _guideDamageRatio_2:Number = 0;
      
      private var _guideDamageRatio_3:Number = 0;
      
      private var _guideDamageIncrease:Number = 0;
      
      private var _powerDamageRatio:Number = 0;
      
      private var _powerDamageIncrease:Number = 0;
      
      private var _headShotDamageRatio:Number = 0;
      
      public function FightToolBoxModel()
      {
         super();
      }
      
      public function get fightVipPrice_high() : int
      {
         return this._fightVipPrice_high;
      }
      
      public function set fightVipPrice_high(param1:int) : void
      {
         this._fightVipPrice_high = param1;
      }
      
      public function get fightVipPrice_mid() : int
      {
         return this._fightVipPrice_mid;
      }
      
      public function set fightVipPrice_mid(param1:int) : void
      {
         this._fightVipPrice_mid = param1;
      }
      
      public function get fightVipPrice_low() : int
      {
         return this._fightVipPrice_low;
      }
      
      public function set fightVipPrice_low(param1:int) : void
      {
         this._fightVipPrice_low = param1;
      }
      
      public function get fightVipTime_high() : int
      {
         return this._fightVipTime_high;
      }
      
      public function set fightVipTime_high(param1:int) : void
      {
         this._fightVipTime_high = param1;
      }
      
      public function get fightVipTime_mid() : int
      {
         return this._fightVipTime_mid;
      }
      
      public function set fightVipTime_mid(param1:int) : void
      {
         this._fightVipTime_mid = param1;
      }
      
      public function get fightVipTime_low() : int
      {
         return this._fightVipTime_low;
      }
      
      public function set fightVipTime_low(param1:int) : void
      {
         this._fightVipTime_low = param1;
      }
      
      public function get fightVipLevel_high() : int
      {
         return this._fightVipLevel_high;
      }
      
      public function set fightVipLevel_high(param1:int) : void
      {
         this._fightVipLevel_high = param1;
      }
      
      public function get fightVipLevel_mid() : int
      {
         return this._fightVipLevel_mid;
      }
      
      public function set fightVipLevel_mid(param1:int) : void
      {
         this._fightVipLevel_mid = param1;
      }
      
      public function get fightVipLevel_low() : int
      {
         return this._fightVipLevel_low;
      }
      
      public function set fightVipLevel_low(param1:int) : void
      {
         this._fightVipLevel_low = param1;
      }
      
      public function get fightVipDamage_low() : int
      {
         return this._fightVipDamage_low;
      }
      
      public function set fightVipDamage_low(param1:int) : void
      {
         this._fightVipDamage_low = param1;
      }
      
      public function get fightVipDamage_mid() : int
      {
         return this._fightVipDamage_mid;
      }
      
      public function set fightVipDamage_mid(param1:int) : void
      {
         this._fightVipDamage_mid = param1;
      }
      
      public function get fightVipDamage_high() : int
      {
         return this._fightVipDamage_high;
      }
      
      public function set fightVipDamage_high(param1:int) : void
      {
         this._fightVipDamage_high = param1;
      }
      
      public function get guideDamageRatio_0() : Number
      {
         return this._guideDamageRatio_0;
      }
      
      public function set guideDamageRatio_0(param1:Number) : void
      {
         this._guideDamageRatio_0 = param1;
      }
      
      public function get guideDamageRatio_1() : Number
      {
         return this._guideDamageRatio_1;
      }
      
      public function set guideDamageRatio_1(param1:Number) : void
      {
         this._guideDamageRatio_1 = param1;
      }
      
      public function get guideDamageRatio_2() : Number
      {
         return this._guideDamageRatio_2;
      }
      
      public function set guideDamageRatio_2(param1:Number) : void
      {
         this._guideDamageRatio_2 = param1;
      }
      
      public function get guideDamageRatio_3() : Number
      {
         return this._guideDamageRatio_3;
      }
      
      public function set guideDamageRatio_3(param1:Number) : void
      {
         this._guideDamageRatio_3 = param1;
      }
      
      public function getguideDamageRatioByLevel(param1:int) : int
      {
         var _loc2_:Number = 0;
         switch(param1)
         {
            case 0:
               _loc2_ = this.guideDamageRatio_0;
               break;
            case 1:
               _loc2_ = this.guideDamageRatio_1;
               break;
            case 2:
               _loc2_ = this.guideDamageRatio_2;
               break;
            case 3:
               _loc2_ = this.guideDamageRatio_3;
         }
         return (_loc2_ - 1) * 100;
      }
      
      public function get guideDamageIncrease() : Number
      {
         return this._guideDamageIncrease;
      }
      
      public function set guideDamageIncrease(param1:Number) : void
      {
         this._guideDamageIncrease = param1;
      }
      
      public function get powerDamageRatio() : Number
      {
         return this._powerDamageRatio;
      }
      
      public function set powerDamageRatio(param1:Number) : void
      {
         this._powerDamageRatio = param1;
      }
      
      public function get powerDamageIncrease() : Number
      {
         return this._powerDamageIncrease;
      }
      
      public function set powerDamageIncrease(param1:Number) : void
      {
         this._powerDamageIncrease = param1;
      }
      
      public function get headShotDamageRatio() : Number
      {
         return this._headShotDamageRatio;
      }
      
      public function set headShotDamageRatio(param1:Number) : void
      {
         this._headShotDamageRatio = param1;
      }
   }
}
