package ddt.utils
{
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.StateManager;
   import game.model.Living;
   import totem.TotemManager;
   
   public class StaticFormula
   {
       
      
      public function StaticFormula()
      {
         super();
      }
      
      public static function getHertAddition(param1:int, param2:int) : Number
      {
         var _loc3_:Number = param1 * Math.pow(1.1,param2) - param1;
         return Math.round(_loc3_);
      }
      
      public static function getDefenseAddition(param1:int, param2:int) : Number
      {
         var _loc3_:Number = param1 * Math.pow(1.1,param2) - param1;
         return Math.round(_loc3_);
      }
      
      public static function getRecoverHPAddition(param1:int, param2:int) : Number
      {
         var _loc3_:Number = param1 * Math.pow(1.1,param2) - param1;
         return Math.floor(_loc3_);
      }
      
      public static function getImmuneHertAddition(param1:int) : Number
      {
         var _loc2_:Number = 0.95 * param1 / (param1 + 500);
         _loc2_ *= 100;
         return Number(_loc2_.toFixed(1));
      }
      
      public static function isDeputyWeapon(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.TemplateID >= 17000 && param1.TemplateID <= 17010)
         {
            return true;
         }
         return false;
      }
      
      public static function getActionValue(param1:PlayerInfo) : int
      {
         var _loc2_:int = 0;
         return int((param1.Attack + param1.Agility + param1.Luck + param1.Defence + 1000) * (Math.pow(getDamage(param1),3) + Math.pow(getRecovery(param1),3) * 3.5) / 100000000 + getMaxHp(param1) * 0.95 - 950);
      }
      
      public static function isShield(param1:PlayerInfo) : Boolean
      {
         return false;
      }
      
      public static function getDamage(param1:PlayerInfo) : int
      {
         var _loc2_:int = 0;
         if(param1.ZoneID != 0 && StateManager.isInFight && param1.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            return -1;
         }
         _loc2_ = param1.Damage;
         _loc2_ += TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(param1.totemId)).Damage;
         if(param1.propertyAddition && param1.propertyAddition["Damage"])
         {
            _loc2_ += Boolean(param1.propertyAddition["Damage"]["Bead"]) ? param1.propertyAddition["Damage"]["Bead"] : 0;
         }
         return _loc2_;
      }
      
      public static function getRecovery(param1:PlayerInfo) : int
      {
         var _loc2_:int = 0;
         if(param1.ZoneID != 0 && StateManager.isInFight != PlayerManager.Instance.Self.ZoneID)
         {
            return -1;
         }
         _loc2_ = param1.Guard;
         _loc2_ += TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(param1.totemId)).Guard;
         if(param1.propertyAddition && param1.propertyAddition["Armor"])
         {
            _loc2_ += Boolean(param1.propertyAddition["Armor"]["Bead"]) ? param1.propertyAddition["Armor"]["Bead"] : 0;
         }
         return _loc2_;
      }
      
      public static function getMaxHp(param1:PlayerInfo) : int
      {
         var _loc3_:Living = null;
         return param1.hp;
      }
      
      public static function getEnergy(param1:PlayerInfo) : int
      {
         if(param1.ZoneID != 0 && StateManager.isInFight && param1.ZoneID != PlayerManager.Instance.Self.ZoneID)
         {
            return -1;
         }
         var _loc2_:int = 0;
         return int(240 + param1.Agility / 30);
      }
      
      private static function isDamageJewel(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.CategoryID == 11 && param1.Property1 == "31" && param1.Property2 == "3")
         {
            return true;
         }
         return false;
      }
      
      public static function getBeadDamage(param1:PlayerInfo) : int
      {
         var _loc5_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         var _loc3_:BagInfo = param1.BeadBag;
         var _loc4_:int = 3;
         while(_loc4_ < 12)
         {
            _loc5_ = _loc3_.items[_loc4_];
            if(_loc5_ && isDamageJewel(_loc5_))
            {
               _loc2_ += int(_loc5_.Property7);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function getBeadRecovery(param1:PlayerInfo) : int
      {
         var _loc5_:InventoryItemInfo = null;
         var _loc2_:int = 0;
         var _loc3_:BagInfo = param1.BeadBag;
         var _loc4_:int = 3;
         while(_loc4_ < 12)
         {
            _loc5_ = _loc3_.items[_loc4_];
            if(_loc5_)
            {
               _loc2_ += int(_loc5_.Property8);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function getJewelDamage(param1:InventoryItemInfo) : int
      {
         var _loc2_:int = 0;
         if(!param1)
         {
            return 0;
         }
         if(param1.Hole1 != -1 && param1.Hole1 != 0 && int(param1.StrengthenLevel / 3) >= 1)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole1)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole1).Property7);
            }
         }
         if(param1.Hole2 != -1 && param1.Hole2 != 0 && int(param1.StrengthenLevel / 3) >= 2)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole2)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole2).Property7);
            }
         }
         if(param1.Hole3 != -1 && param1.Hole3 != 0 && int(param1.StrengthenLevel / 3) >= 3)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole3)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole3).Property7);
            }
         }
         if(param1.Hole4 != -1 && param1.Hole4 != 0 && int(param1.StrengthenLevel / 3) >= 4)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole4)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole4).Property7);
            }
         }
         if(param1.Hole5 != -1 && param1.Hole5 != 0 && param1.Hole5Level > 0)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole5)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole5).Property7);
            }
         }
         if(param1.Hole6 != -1 && param1.Hole6 != 0 && param1.Hole6Level > 0)
         {
            if(isDamageJewel(ItemManager.Instance.getTemplateById(param1.Hole6)))
            {
               _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole6).Property7);
            }
         }
         return _loc2_;
      }
      
      public static function getJewelRecovery(param1:InventoryItemInfo) : int
      {
         var _loc2_:int = 0;
         if(!param1)
         {
            return 0;
         }
         if(param1.Hole1 != -1 && param1.Hole1 != 0 && int(param1.StrengthenLevel / 3) >= 1)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole1).Property8);
         }
         if(param1.Hole2 != -1 && param1.Hole2 != 0 && int(param1.StrengthenLevel / 3) >= 2)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole2).Property8);
         }
         if(param1.Hole3 != -1 && param1.Hole3 != 0 && int(param1.StrengthenLevel / 3) >= 3)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole3).Property8);
         }
         if(param1.Hole4 != -1 && param1.Hole4 != 0 && int(param1.StrengthenLevel / 3) >= 4)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole4).Property8);
         }
         if(param1.Hole5 != -1 && param1.Hole5 != 0 && param1.Hole5Level > 0)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole5).Property8);
         }
         if(param1.Hole6 != -1 && param1.Hole6 != 0 && param1.Hole6Level > 0)
         {
            _loc2_ += int(ItemManager.Instance.getTemplateById(param1.Hole6).Property8);
         }
         return _loc2_;
      }
   }
}
