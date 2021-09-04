package bead.view
{
   import bagAndInfo.bag.PlayerPersonView;
   import bead.BeadManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import road7th.data.DictionaryData;
   
   public class BeadInfoView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _beadPower:Bitmap;
      
      private var _beadPowerTxt:BeadPowerText;
      
      private var _beadSprite:Sprite;
      
      private var _character:RoomCharacter;
      
      private var _beadList:Dictionary;
      
      private var _levelLimitData:Array;
      
      private var _info:PlayerInfo;
      
      private var _personView:PlayerPersonView;
      
      public function BeadInfoView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadinfo.bg");
         PositionUtils.setPos(this._bg,"beadInfoViewbg.pos");
         this._beadPower = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.beadPower");
         PositionUtils.setPos(this._beadPower,"beadInfoView.beadPowerBg.pos");
         this._beadSprite = new Sprite();
         PositionUtils.setPos(this._beadSprite,"beadInfoView.beadSprite.pos");
         this._beadPowerTxt = ComponentFactory.Instance.creatCustomObject("beadInsetView.beadPower.txt");
         PositionUtils.setPos(this._beadPowerTxt,"beadInsetView.beadPower.txt.pos");
         this._personView = ComponentFactory.Instance.creat("bagAndInfo.PlayerPersonView");
         PositionUtils.setPos(this._personView,"beadInfoView.PlayerPersonView.pos");
         this._personView.setHpVisble(false);
         this.createCell();
         addChild(this._bg);
         addChild(this._beadPower);
         addChild(this._beadSprite);
         addChild(this._beadPowerTxt);
         addChild(this._personView);
      }
      
      private function createCell() : void
      {
         var _loc3_:BeadCell = null;
         this._beadList = new Dictionary();
         var _loc1_:String = BeadManager.instance.beadConfig.GemHoleNeedLevel;
         this._levelLimitData = _loc1_.split("|");
         var _loc2_:int = 0;
         while(_loc2_ <= 4)
         {
            _loc3_ = ComponentFactory.Instance.creatCustomObject("otherBeadCell_" + _loc2_,[_loc2_,null]);
            this._beadSprite.addChild(_loc3_);
            this._beadList[_loc2_] = _loc3_;
            _loc3_.info = null;
            _loc3_.setBGVisible(false);
            _loc2_++;
         }
      }
      
      private function updateCell() : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:int = 0;
         if(!this._info)
         {
            for(_loc4_ in this._beadList)
            {
               this._beadList[_loc4_].info = null;
            }
            return;
         }
         var _loc1_:BagInfo = this._info.BeadBag;
         var _loc2_:int = this._info.Grade;
         for(_loc3_ in this._beadList)
         {
            this._beadList[_loc3_].info = _loc1_.items[_loc3_];
            _loc5_ = int(this._levelLimitData[_loc3_]);
            if(_loc2_ < _loc5_ || _loc5_ == -1)
            {
               this._beadList[_loc3_].lockCell(_loc5_);
            }
         }
      }
      
      private function updateBeadPower() : void
      {
         var _loc9_:InventoryItemInfo = null;
         if(!this._info)
         {
            this._beadPowerTxt.text = "";
            return;
         }
         var _loc1_:Object = BeadManager.instance.list;
         var _loc2_:DictionaryData = this._info.BeadBag.items;
         var _loc3_:int = 0;
         var _loc4_:String = "";
         var _loc5_:String = "    ";
         var _loc6_:String = "   ";
         var _loc7_:String = "  ";
         var _loc8_:int = 0;
         while(_loc8_ <= 4)
         {
            if(_loc2_[_loc8_])
            {
               _loc9_ = _loc2_[_loc8_] as InventoryItemInfo;
               if(_loc9_.beadLevel == 20)
               {
                  _loc3_ += int(_loc1_[_loc9_.Property2][20].Exp);
               }
               else
               {
                  _loc3_ += _loc9_.beadExp;
               }
               _loc4_ += LanguageMgr.GetTranslation("beadSystem.bead.name.color.html",BeadManager.instance.getBeadNameColor(_loc9_),LanguageMgr.GetTranslation("beadSystem.bead.nameLevel",_loc9_.Name,_loc9_.beadLevel,""));
               if(_loc9_.Name.substr(0,1) == "S" || _loc9_.Name.substr(0,1) == "s")
               {
                  if(_loc9_.beadLevel >= 10)
                  {
                     _loc4_ += _loc7_;
                  }
                  else
                  {
                     _loc4_ += _loc6_;
                  }
               }
               else if(_loc9_.beadLevel >= 10)
               {
                  _loc4_ += _loc6_;
               }
               else
               {
                  _loc4_ += _loc5_;
               }
               _loc4_ += BeadManager.instance.getDescriptionStr(_loc9_) + "\n";
            }
            _loc8_++;
         }
         this._beadPowerTxt.text = int(_loc3_ / 10).toString();
         this._beadPowerTxt.tipData = [LanguageMgr.GetTranslation("beadSystem.bead.beadPower.titleTip",this._beadPowerTxt.text),_loc4_];
      }
      
      public function set info(param1:PlayerInfo) : void
      {
         if(this._info == param1)
         {
            return;
         }
         if(this._info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
            this._info = null;
         }
         this._info = param1;
         if(this._info)
         {
            this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
         }
         this.updateView();
         if(this._personView)
         {
            this._personView.info = this._info;
         }
      }
      
      private function updateView() : void
      {
         this.updateBeadPower();
         this.updateCharacter();
         this.updateCell();
      }
      
      private function __changeHandler(param1:PlayerPropertyEvent) : void
      {
         this.updateView();
      }
      
      private function updateCharacter() : void
      {
         if(this._character)
         {
            this._character.dispose();
            this._character = null;
         }
         if(this._info)
         {
            this._character = CharactoryFactory.createCharacter(this._info,"room") as RoomCharacter;
            this._character.showGun = false;
            this._character.showWing = false;
            this._character.LightVible = false;
            this._character.show(false,-1);
            PositionUtils.setPos(this._character,"beadInfoView.character.pos");
            this._character.LightVible = false;
            addChildAt(this._character,this.getChildIndex(this._beadSprite));
         }
      }
      
      private function removeEvent() : void
      {
         if(this._info)
         {
            this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__changeHandler);
            this._info = null;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:BeadCell = null;
         this.removeEvent();
         for each(_loc1_ in this._beadList)
         {
            if(_loc1_)
            {
               ObjectUtils.disposeObject(_loc1_);
            }
         }
         this._beadList = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._beadPower)
         {
            ObjectUtils.disposeObject(this._beadPower);
         }
         this._beadPower = null;
         if(this._beadPowerTxt)
         {
            ObjectUtils.disposeObject(this._beadPowerTxt);
         }
         this._beadPowerTxt = null;
         if(this._beadSprite)
         {
            ObjectUtils.disposeObject(this._beadSprite);
         }
         this._beadSprite = null;
         if(this._character)
         {
            ObjectUtils.disposeObject(this._character);
         }
         this._character = null;
         ObjectUtils.disposeObject(this._personView);
         this._personView = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
