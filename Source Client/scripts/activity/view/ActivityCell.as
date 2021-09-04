package activity.view
{
   import activity.data.ActivityRewardInfo;
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   
   public class ActivityCell extends BaseCell
   {
       
      
      private var _getIcon:Bitmap;
      
      private var _giftBagPic:Bitmap;
      
      private var _showItem:Boolean;
      
      private var _count:FilterFrameText;
      
      private var _euipQualityBg:ScaleFrameImage;
      
      private var _rewardInfo:ActivityRewardInfo;
      
      public function ActivityCell(param1:ActivityRewardInfo, param2:Boolean = true, param3:Bitmap = null)
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:ItemTemplateInfo = null;
         this._showItem = param2;
         if(param1)
         {
            this._rewardInfo = param1;
            _loc4_ = new InventoryItemInfo();
            _loc5_ = ItemManager.Instance.getTemplateById(int(this._rewardInfo.TemplateId));
            _loc4_.TemplateID = int(this._rewardInfo.TemplateId);
            _loc4_.ValidDate = this._rewardInfo.ValidDate;
            _loc4_.IsBinds = this._rewardInfo.IsBind;
            ItemManager.fill(_loc4_);
            _loc4_.StrengthenLevel = this._rewardInfo.getProperty()[0];
            _loc4_.Attack = _loc5_.Attack;
            _loc4_.Defence = _loc5_.Defence;
            _loc4_.Agility = _loc5_.Agility;
            _loc4_.Luck = _loc5_.Luck;
            _info = _loc4_;
         }
         if(param3 == null)
         {
            _bg = ComponentFactory.Instance.creatBitmap("ddtcalendar.exchange.cellBg");
         }
         else
         {
            _bg = param3;
         }
         super(_bg,_info);
         this._giftBagPic = ComponentFactory.Instance.creatBitmap("asset.ActivityCell.giftbag.pic");
         addChild(this._giftBagPic);
         this._getIcon = ComponentFactory.Instance.creatBitmap("asset.ActivityCell.getIcon");
         this._getIcon.visible = false;
         addChild(this._getIcon);
         this._count = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCell.count");
         this._count.text = "0";
         addChild(this._count);
         this.setType();
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         var _loc2_:EquipmentTemplateInfo = null;
         super.info = param1;
         if(info == null)
         {
            _loc2_ = null;
            this.initeuipQualityBg(0);
         }
         if(info != null)
         {
            _loc2_ = ItemManager.Instance.getEquipTemplateById(info.TemplateID);
         }
         if(_loc2_ != null && info.Property8 == "0")
         {
            this.initeuipQualityBg(_loc2_.QualityID);
         }
         else
         {
            this.initeuipQualityBg(0);
         }
      }
      
      public function showBg(param1:Boolean) : void
      {
         _bg.visible = param1;
      }
      
      public function showCount(param1:Boolean) : void
      {
         this._count.visible = param1;
      }
      
      private function initeuipQualityBg(param1:int) : void
      {
         if(this._euipQualityBg == null)
         {
            this._euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
            PositionUtils.setPos(this._euipQualityBg,"ddtactivity.ActivityCell.qualityBg.pos");
            this._euipQualityBg.width = 43;
            this._euipQualityBg.height = 43;
         }
         if(param1 == 0)
         {
            this._euipQualityBg.visible = false;
         }
         else if(param1 == 1)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 2)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 3)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 4)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 5)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
      }
      
      public function set count(param1:int) : void
      {
         this._count.text = param1.toString();
      }
      
      public function setType() : void
      {
         if(this._showItem)
         {
            _pic.visible = true;
            _bg.visible = true;
            this._count.visible = true;
            this._giftBagPic.visible = false;
         }
         else
         {
            _pic.visible = false;
            _bg.visible = false;
            this._count.visible = false;
            this._giftBagPic.visible = true;
         }
      }
      
      public function set canGet(param1:Boolean) : void
      {
         if(param1)
         {
            this._giftBagPic.filters = null;
            _pic.filters = null;
         }
         else
         {
            this._giftBagPic.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            _pic.filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function set hasGet(param1:Boolean) : void
      {
         this._getIcon.visible = param1;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._giftBagPic);
         this._giftBagPic = null;
         ObjectUtils.disposeObject(this._getIcon);
         this._getIcon = null;
         ObjectUtils.disposeObject(this._count);
         this._count = null;
         ObjectUtils.disposeObject(this._euipQualityBg);
         this._euipQualityBg = null;
         super.dispose();
      }
   }
}
