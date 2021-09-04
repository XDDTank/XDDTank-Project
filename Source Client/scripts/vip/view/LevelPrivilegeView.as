package vip.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.VipConfigInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.VipPrivilegeConfigManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class LevelPrivilegeView extends Sprite implements Disposeable
   {
      
      private static const MAX_LEVEL:int = 10;
      
      private static const VIP_SETTINGS_FIELD:Array = ["VIPRateForGP","VIPStrengthenEx","VIPQuestStar","VIPLotteryCountMaxPerDay","VIPExtraBindMoneyUpper","VIPTakeCardDisCount","VIPQuestFinishDirect","VIPLotteryNoTime","VIPBossBattle","CanBuyFert","FarmAssistant","PetFifthSkill","LoginSysNotice","VIPMetalRelieve","VIPWeekly","VIPBenediction"];
       
      
      private var _bg:Image;
      
      private var _titleBg:Bitmap;
      
      private var _titleSeperators:Image;
      
      private var _titleTxt:FilterFrameText;
      
      private var _titleIcons:Vector.<Image>;
      
      private var _itemScrollPanel:ScrollPanel;
      
      private var _itemContainer:VBox;
      
      private var _currentVip:Image;
      
      private var _units:Dictionary;
      
      private var _minPrivilegeLevel:Dictionary;
      
      public function LevelPrivilegeView()
      {
         this._minPrivilegeLevel = new Dictionary();
         super();
         this._units = new Dictionary();
         this._units[0] = this._units[1] = this._units[9] = this._units[10] = "%";
         this._units[2] = this._units[3] = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem.TimesUnit");
         this.initView();
         this.initItem();
      }
      
      private function initItem() : void
      {
         var _loc2_:PrivilegeViewItem = null;
         var _loc3_:VipConfigInfo = null;
         var _loc4_:Vector.<String> = null;
         var _loc5_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 11)
         {
            _loc2_ = null;
            _loc3_ = VipPrivilegeConfigManager.Instance.getById(_loc1_ + 1);
            if(!(_loc1_ == 4 || _loc1_ == 5 || _loc1_ == 6 || _loc1_ == 7 || _loc1_ == 8))
            {
               if(this._units[_loc1_] != null)
               {
                  if(_loc1_ == 9 || _loc1_ == 10)
                  {
                     _loc2_ = new PrivilegeViewItem(_loc1_,PrivilegeViewItem.UNIT_TYPE,this._units[_loc1_]);
                  }
                  else
                  {
                     _loc2_ = new PrivilegeViewItem(_loc1_ + 1,PrivilegeViewItem.UNIT_TYPE,this._units[_loc1_]);
                  }
               }
               else
               {
                  _loc2_ = new PrivilegeViewItem(_loc1_ + 1);
               }
               _loc2_.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem" + (_loc1_ + 1));
               _loc4_ = new Vector.<String>();
               _loc5_ = 1;
               while(_loc5_ <= 10)
               {
                  _loc4_.push(int(_loc3_["Level" + _loc5_]));
                  _loc5_++;
               }
               _loc2_.itemContent = _loc4_;
               this._itemContainer.addChild(_loc2_);
            }
            _loc1_++;
         }
         this.parsePrivilegeItem(5);
         this.parsePrivilegeItem(8);
         this.parsePrivilegeItem(9);
         this.parsePrivilegeItem(6);
         this.parsePrivilegeItem(7);
         this._itemScrollPanel.invalidateViewport();
      }
      
      private function parsePrivilegeItem(param1:int) : void
      {
         var _loc6_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(param1);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:int = 1;
         while(_loc4_ <= MAX_LEVEL)
         {
            _loc6_ = int(_loc3_["Level" + _loc4_]);
            _loc2_.push(_loc6_ == 1 ? "1" : "0");
            _loc4_++;
         }
         var _loc5_:PrivilegeViewItem = new PrivilegeViewItem(param1,PrivilegeViewItem.TRUE_FLASE_TYPE);
         _loc5_.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem" + param1);
         _loc5_.itemContent = Vector.<String>(_loc2_);
         this._itemContainer.addChild(_loc5_);
      }
      
      private function parseBenediction() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 2;
         var _loc3_:Vector.<String> = Vector.<String>(["0","0","0","0","0","0","0","0","0","0"]);
         var _loc4_:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(_loc2_);
         if(!_loc4_)
         {
            return;
         }
         var _loc5_:PrivilegeViewItem = null;
         var _loc6_:int = 0;
         while(_loc6_ < 10)
         {
            if(_loc6_ < 4)
            {
               _loc3_[_loc6_] = "0";
               _loc5_ = new PrivilegeViewItem(_loc2_);
            }
            else
            {
               _loc3_[_loc6_] = _loc4_["Level" + (_loc6_ + 1)];
               _loc5_ = new PrivilegeViewItem(_loc2_,PrivilegeViewItem.UNIT_TYPE,"%");
            }
            _loc5_.itemTitleText = LanguageMgr.GetTranslation("ddt.vip.PrivilegeViewItem" + _loc2_);
            _loc5_.itemContent = _loc3_;
            _loc6_++;
         }
         this._itemContainer.addChild(_loc5_);
      }
      
      private function benedictionAnalyzer(param1:Vector.<String>) : Vector.<DisplayObject>
      {
         var _loc2_:Vector.<DisplayObject> = null;
         var _loc4_:String = null;
         var _loc5_:DisplayObject = null;
         _loc2_ = new Vector.<DisplayObject>();
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject("vip.levelPrivilegeBenedctionItemTxtStartPos");
         for each(_loc4_ in param1)
         {
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross");
            PositionUtils.setPos(_loc5_,_loc3_);
            _loc5_.x = _loc3_.x + (40 - _loc5_.width);
            _loc3_.x += 40 + 15;
            _loc2_.push(_loc5_);
         }
         return _loc2_;
      }
      
      private function initView() : void
      {
         var _loc4_:Image = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeViewBg");
         this._titleBg = ComponentFactory.Instance.creatBitmap("vip.LevelPrivilegeTitleBg");
         this._titleSeperators = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewTitleItemSeperators");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.TitleTxt");
         this._titleTxt.text = LanguageMgr.GetTranslation("ddt.vip.LevelPrivilegeView.TitleTxt");
         this._currentVip = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.currentVip");
         this._currentVip.x += (PlayerManager.Instance.Self.VIPLevel - 1) * 57;
         this._currentVip.visible = PlayerManager.Instance.Self.IsVIP;
         addChild(this._bg);
         addChild(this._titleBg);
         addChild(this._titleSeperators);
         addChild(this._titleTxt);
         this._titleIcons = new Vector.<Image>();
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 1;
         while(_loc3_ <= MAX_LEVEL)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.VipIcon" + _loc3_);
            this._titleIcons.push(_loc4_);
            addChild(_loc4_);
            if(_loc3_ == 1)
            {
               _loc1_ = _loc4_.x;
               _loc2_ = _loc4_.y;
            }
            else if(_loc3_ == 10)
            {
               _loc4_.x = 642;
               _loc4_.y = 57;
            }
            else
            {
               _loc1_ += 55;
               _loc4_.x = _loc1_;
               _loc4_.y = _loc2_;
            }
            _loc3_++;
         }
         addChild(this._currentVip);
         this._itemScrollPanel = ComponentFactory.Instance.creatComponentByStylename("vip.LevelPrivilegeView.ItemScrollPanel");
         addChild(this._itemScrollPanel);
         this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemContainer");
         this._itemScrollPanel.setView(this._itemContainer);
      }
      
      public function dispose() : void
      {
         var _loc1_:Image = null;
         for each(_loc1_ in this._titleIcons)
         {
            ObjectUtils.disposeObject(_loc1_);
         }
         this._titleIcons = null;
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._titleBg);
         ObjectUtils.disposeObject(this._titleSeperators);
         ObjectUtils.disposeObject(this._titleTxt);
         ObjectUtils.disposeObject(this._itemContainer);
         ObjectUtils.disposeObject(this._itemScrollPanel);
         ObjectUtils.disposeObject(this._currentVip);
         this._bg = null;
         this._titleBg = null;
         this._titleSeperators = null;
         this._titleTxt = null;
         this._itemScrollPanel = null;
         this._itemContainer = null;
         this._currentVip = null;
      }
   }
}
