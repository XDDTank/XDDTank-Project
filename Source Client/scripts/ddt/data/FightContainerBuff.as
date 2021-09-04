package ddt.data
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.LanguageMgr;
   import ddt.view.tips.BuffTipInfo;
   
   public class FightContainerBuff extends FightBuffInfo implements Disposeable
   {
       
      
      private var _buffs:Vector.<FightBuffInfo>;
      
      public function FightContainerBuff(param1:int, param2:int = 2)
      {
         this._buffs = new Vector.<FightBuffInfo>();
         super(param1);
         type = param2;
      }
      
      public function addFightBuff(param1:FightBuffInfo) : void
      {
         this._buffs.push(param1);
      }
      
      public function get tipData() : Object
      {
         var _loc1_:BuffTipInfo = new BuffTipInfo();
         if(type != BuffType.Pay)
         {
            if(type == BuffType.CONSORTIA)
            {
               _loc1_.isActive = true;
               _loc1_.name = LanguageMgr.GetTranslation("tank.view.buff.consortiaBuff");
               _loc1_.isFree = false;
               _loc1_.linkBuffs = this._buffs;
            }
            else if(type == BuffType.FREE_CONTINUE)
            {
               _loc1_.isActive = true;
               _loc1_.name = LanguageMgr.GetTranslation("ddt.vip.GrowthRuleView.freeContinue");
               _loc1_.isFree = false;
               _loc1_.linkBuffs = this._buffs;
            }
            else
            {
               _loc1_.isActive = true;
               _loc1_.name = LanguageMgr.GetTranslation("tank.view.buff.cardBuff");
               _loc1_.isFree = false;
               _loc1_.linkBuffs = this._buffs;
            }
         }
         return _loc1_;
      }
      
      public function dispose() : void
      {
         this._buffs.length = 0;
      }
   }
}
