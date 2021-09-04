package bagAndInfo.fightPower
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import pet.date.PetInfo;
   import road7th.data.DictionaryData;
   import store.StoreController;
   import store.data.RefiningConfigInfo;
   
   public class PowerUpSystemButton extends BaseButton
   {
      
      public static const EQUIP_SYSTEM:uint = 0;
      
      public static const STRENG_SYSTEM:uint = 1;
      
      public static const BEAD_SYSTEM:uint = 2;
      
      public static const PET_SYSTEM:uint = 3;
      
      public static const TOTEM_SYSTEM:uint = 4;
      
      public static const RUNE_SYSTEM:uint = 5;
      
      public static const REFINING_SYSTEM:uint = 6;
      
      public static const PETADVANCE_SYSTEM:uint = 7;
      
      public static const NOT_OPEN:uint = 8;
       
      
      private var _type:uint;
      
      private var _progress:Number;
      
      private var _progressMask:Shape;
      
      private var _bg:Bitmap;
      
      private var _recommend:Bitmap;
      
      private var _progressBmp:Bitmap;
      
      private var _tips:PowerUpSystemButtonTips;
      
      private var _tipsData:Vector.<String>;
      
      private var _damage:int = 0;
      
      private var _armor:int = 0;
      
      private var _energy:int = 0;
      
      private var _attack:int = 0;
      
      private var _defence:int = 0;
      
      private var _agility:int = 0;
      
      private var _luck:int = 0;
      
      private var _hp:int = 0;
      
      public function PowerUpSystemButton(param1:uint)
      {
         super();
         this._type = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc2_:FightPowerDescInfo = null;
         var _loc1_:PlayerInfo = PlayerManager.Instance.Self;
         this._energy = _loc1_.Energy;
         this._tipsData = new Vector.<String>(3);
         this._tipsData[0] = LanguageMgr.GetTranslation("ddt.FightPowerUpTips.titleTxt");
         switch(this._type)
         {
            case EQUIP_SYSTEM:
               this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.EquipSystem");
               this.calStrengPower();
               this.calRefiningPower();
               this._damage = int(_loc1_.getPropertyAdditionByType("Damage")["Equip"]) - this._damage;
               this._armor = int(_loc1_.getPropertyAdditionByType("Armor")["Equip"]) - this._armor;
               this._attack = _loc1_.getPropertyAdditionByType("Attack")["Equip"] - this._attack;
               this._defence = _loc1_.getPropertyAdditionByType("Defence")["Equip"] - this._defence;
               this._agility = _loc1_.getPropertyAdditionByType("Agility")["Equip"] - this._agility;
               this._luck = _loc1_.getPropertyAdditionByType("Luck")["Equip"] - this._luck;
               this._hp = _loc1_.getPropertyAdditionByType("HP")["Equip"] - this._hp;
               _loc2_ = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.EQUIP_FIGHT_POWER);
               this._tipsData[1] = _loc2_.RecommendDesc;
               this._progress = this.calFightPower() / _loc2_.StandFigting;
               break;
            case STRENG_SYSTEM:
               this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.strengSystem");
               this.calStrengPower();
               _loc2_ = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.STRENG_FIGHT_POWER);
               this._tipsData[1] = _loc2_.RecommendDesc;
               this._progress = this.calFightPower() / _loc2_.StandFigting;
               break;
            case BEAD_SYSTEM:
               this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.beadSystem");
               this._attack = _loc1_.getPropertyAdditionByType("Attack")["Bead"];
               this._defence = _loc1_.getPropertyAdditionByType("Defence")["Bead"];
               this._agility = _loc1_.getPropertyAdditionByType("Agility")["Bead"];
               this._luck = _loc1_.getPropertyAdditionByType("Luck")["Bead"];
               this._hp = _loc1_.getPropertyAdditionByType("HP")["Bead"];
               _loc2_ = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.BEAD_FIGHT_POWER);
               this._tipsData[1] = _loc2_.RecommendDesc;
               this._progress = this.calFightPower() / _loc2_.StandFigting;
               break;
            case PET_SYSTEM:
               this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.petSystem");
               this.calPetAdvance();
               this._attack = int(_loc1_.getPropertyAdditionByType("Attack")["Pet"] / 100) - this._attack;
               this._defence = int(_loc1_.getPropertyAdditionByType("Defence")["Pet"] / 100) - this._defence;
               this._agility = int(_loc1_.getPropertyAdditionByType("Agility")["Pet"] / 100) - this._defence;
               this._luck = int(_loc1_.getPropertyAdditionByType("Luck")["Pet"] / 100) - this._luck;
               this._hp = int(_loc1_.getPropertyAdditionByType("HP")["Pet"] / 100) - this._hp;
               _loc2_ = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.PET_FIGHT_POWER);
               this._tipsData[1] = _loc2_.RecommendDesc;
               this._progress = this.calFightPower() / _loc2_.StandFigting;
               break;
            case TOTEM_SYSTEM:
               this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.totemSystem");
               this._damage += int(_loc1_.getPropertyAdditionByType("Damage")["Totem"]);
               this._armor += int(_loc1_.getPropertyAdditionByType("Armor")["Totem"]);
               this._attack += _loc1_.getPropertyAdditionByType("Attack")["Totem"];
               this._defence += _loc1_.getPropertyAdditionByType("Defence")["Totem"];
               this._agility += _loc1_.getPropertyAdditionByType("Agility")["Totem"];
               this._luck += _loc1_.getPropertyAdditionByType("Luck")["Totem"];
               this._hp += _loc1_.getPropertyAdditionByType("HP")["Totem"];
               _loc2_ = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.TOTEM_FIGHT_POWER);
               this._tipsData[1] = _loc2_.RecommendDesc;
               this._progress = this.calFightPower() / _loc2_.StandFigting;
               break;
            case RUNE_SYSTEM:
               this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.runeSystem");
               this._attack += _loc1_.getPropertyAdditionByType("Attack")["Embed"];
               this._defence += _loc1_.getPropertyAdditionByType("Defence")["Embed"];
               this._agility += _loc1_.getPropertyAdditionByType("Agility")["Embed"];
               this._luck += _loc1_.getPropertyAdditionByType("Luck")["Embed"];
               this._hp += _loc1_.getPropertyAdditionByType("HP")["Embed"];
               _loc2_ = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.RUNE_FIGHT_POWER);
               this._tipsData[1] = _loc2_.RecommendDesc;
               this._progress = this.calFightPower() / _loc2_.StandFigting;
               break;
            case PETADVANCE_SYSTEM:
               this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.petAdvanceSystem");
               this.calPetAdvance();
               _loc2_ = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.PET_ADVANCE_FIGHT_POWER);
               this._tipsData[1] = _loc2_.RecommendDesc;
               this._progress = this.calFightPower() / _loc2_.StandFigting;
               break;
            case REFINING_SYSTEM:
               this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.refiningSystem");
               this.calRefiningPower();
               _loc2_ = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.REFINING_FIGHT_POWER);
               this._tipsData[1] = _loc2_.RecommendDesc;
               this._progress = this.calFightPower() / _loc2_.StandFigting;
               break;
            case NOT_OPEN:
               this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.notOpen");
               this.enable = false;
               this._progress = 1;
         }
         this._progress *= 100;
         this._progress = this._progress > 100 ? Number(100) : Number(int(this._progress));
         this._tipsData[2] = LanguageMgr.GetTranslation("ddt.FightPowerUpTips.socreTxt",this._progress);
         if(this._progress <= 35)
         {
            this._progressBmp = ComponentFactory.Instance.creatBitmap("asset.hall.greenProgress");
         }
         else if(this._progress < 75)
         {
            this._progressBmp = ComponentFactory.Instance.creatBitmap("asset.hall.blueProgress");
         }
         else if(this._progress < 100)
         {
            this._progressBmp = ComponentFactory.Instance.creatBitmap("asset.hall.purpleProgress");
         }
         else
         {
            this._progressBmp = ComponentFactory.Instance.creatBitmap("asset.hall.orangeProgress");
         }
         this._progressMask = new Shape();
         this._progressMask.graphics.beginFill(0,0);
         this._progressMask.graphics.drawRect(0,0,int(this._progressBmp.width * this._progress / 100),this._progressBmp.height);
         this._progressMask.graphics.endFill();
         PositionUtils.setPos(this._progressBmp,"hall.powerUpSystemButtonProgress.Pos");
         PositionUtils.setPos(this._progressMask,"hall.powerUpSystemButtonProgress.Pos");
         this._recommend = ComponentFactory.Instance.creatBitmap("asset.hall.recommend");
         this._recommend.visible = false;
         this._tips = new PowerUpSystemButtonTips();
         this._tips.visible = false;
         this._tips.tipData = this._tipsData;
         addChild(this._bg);
         if(this._type != NOT_OPEN)
         {
            addChild(this._progressBmp);
            addChild(this._progressMask);
            this._progressBmp.mask = this._progressMask;
         }
         addChild(this._recommend);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      override protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this._tips)
         {
            this._tips.visible = true;
            LayerManager.Instance.addToLayer(this._tips,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this.localToGlobal(new Point(this.width - 50,this.height / 2));
            this._tips.x = _loc2_.x;
            this._tips.y = _loc2_.y;
         }
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
         if(this._tips)
         {
            this._tips.visible = false;
         }
      }
      
      public function setRecommendVisible() : void
      {
         this._recommend.visible = true;
      }
      
      private function calFightPower() : int
      {
         return this._attack + this._damage * 2 + this._armor * 2 + this._defence + this._luck + this._agility + this._hp / 2;
      }
      
      private function calPetAdvance() : void
      {
         var _loc2_:PetInfo = null;
         var _loc3_:PetInfo = null;
         var _loc4_:PetInfo = null;
         var _loc5_:PetInfo = null;
         var _loc1_:DictionaryData = PlayerManager.Instance.Self.pets;
         if(_loc1_.length > 0 && _loc1_[0])
         {
            _loc2_ = _loc1_[0];
            if(_loc2_.MagicLevel == 0 || _loc2_.OrderNumber == 1)
            {
               return;
            }
            _loc3_ = PetInfoManager.instance.getPetInfoByTemplateID(_loc2_.TemplateID);
            _loc3_.OrderNumber = 1;
            _loc4_ = PetInfoManager.instance.getPetInfoByTemplateID(_loc2_.TemplateID);
            _loc4_.OrderNumber = _loc2_.OrderNumber;
            _loc5_ = PetInfoManager.instance.getTransformPet(_loc3_,_loc4_);
            this._attack += int(_loc5_.Attack / 100);
            this._defence += int(_loc5_.Defence / 100);
            this._agility += int(_loc5_.Agility / 100);
            this._luck += int(_loc5_.Luck / 100);
            this._hp += int(_loc5_.Blood / 100);
         }
      }
      
      private function calStrengPower() : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:int = 0;
         var _loc4_:EquipmentTemplateInfo = null;
         var _loc1_:uint = 10;
         for(; _loc1_ < 16; _loc1_++)
         {
            _loc2_ = PlayerManager.Instance.Self.Bag.getItemAt(_loc1_);
            if(!_loc2_)
            {
               continue;
            }
            _loc3_ = ItemManager.Instance.getMinorProperty(_loc2_,_loc2_);
            _loc4_ = ItemManager.Instance.getEquipTemplateById(_loc2_.TemplateID);
            _loc4_ = ItemManager.Instance.getEquipPropertyListById(_loc4_.MainProperty1ID);
            switch(_loc4_.PropertyID)
            {
               case 1:
                  this._attack += _loc3_;
                  break;
               case 2:
                  this._defence += _loc3_;
                  break;
               case 3:
                  this._agility += _loc3_;
                  break;
               case 4:
                  this._luck += _loc3_;
                  break;
               case 5:
                  this._damage += _loc3_;
                  break;
               case 6:
                  this._armor += _loc3_;
                  break;
               case 7:
                  this._hp += _loc3_;
                  break;
            }
         }
      }
      
      private function calRefiningPower() : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:RefiningConfigInfo = null;
         var _loc1_:uint = 16;
         while(_loc1_ < 20)
         {
            _loc2_ = PlayerManager.Instance.Self.Bag.getItemAt(_loc1_);
            if(_loc2_)
            {
               _loc3_ = StoreController.instance.Model.getRefiningConfigByLevel(_loc2_.StrengthenLevel);
               this._attack += _loc3_.Attack;
               this._defence += _loc3_.Defence;
               this._agility += _loc3_.Agility;
               this._luck += _loc3_.Lucky;
               this._hp += _loc3_.Blood;
            }
            _loc1_++;
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._progressMask);
         this._progressMask = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._recommend);
         this._recommend = null;
         ObjectUtils.disposeObject(this._progressBmp);
         this._progressBmp = null;
         ObjectUtils.disposeObject(this._tips);
         this._tips = null;
         ObjectUtils.disposeObject(this._tipsData);
         this._tipsData = null;
         super.dispose();
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      public function get progress() : int
      {
         return this._progress;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
   }
}
