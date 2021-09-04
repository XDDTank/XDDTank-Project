package ddt.data
{
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortionNewSkillInfo;
   import ddt.manager.PlayerManager;
   import ddt.view.tips.BuffTipInfo;
   import road7th.data.DictionaryData;
   
   public class FightConsotionBuff
   {
       
      
      private var _info:FightBuffInfo;
      
      public function FightConsotionBuff(param1:FightBuffInfo)
      {
         super();
         this._info = param1;
      }
      
      public function get tipData() : Object
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:ConsortionNewSkillInfo = null;
         var _loc9_:ConsortionNewSkillInfo = null;
         var _loc10_:ConsortionNewSkillInfo = null;
         var _loc1_:BuffTipInfo = new BuffTipInfo();
         var _loc2_:DictionaryData = PlayerManager.Instance.Self.isLearnSkill;
         var _loc3_:Vector.<int> = new Vector.<int>();
         var _loc4_:int = 0;
         if(this._info.isSelf)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc2_.length)
            {
               _loc8_ = ConsortionModelControl.Instance.model.getInfoByBuffId(_loc2_[_loc6_]);
               if(_loc8_ && _loc8_.BuffType == this._info.id)
               {
                  _loc3_.push(_loc8_.BuffID);
               }
               _loc6_++;
            }
            _loc7_ = 0;
            while(_loc7_ < _loc3_.length)
            {
               _loc9_ = ConsortionModelControl.Instance.model.getInfoByBuffId(_loc3_[_loc7_]);
               if(_loc9_.BuildLevel <= PlayerManager.Instance.Self.consortiaInfo.SmithLevel)
               {
                  _loc4_ = _loc3_[_loc7_];
               }
               _loc7_++;
            }
         }
         else
         {
            _loc10_ = ConsortionModelControl.Instance.model.getInfoByTypeAndData(this._info.id,this._info.data);
            _loc4_ = _loc10_.BuffID;
         }
         var _loc5_:ConsortionNewSkillInfo = ConsortionModelControl.Instance.model.getInfoByBuffId(_loc4_);
         _loc1_.name = _loc5_.BuffName;
         _loc1_.describe = _loc5_.Description;
         _loc1_.isActive = false;
         return _loc1_;
      }
   }
}
