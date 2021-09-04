package liveness
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class DailyReceiveItem extends Sprite implements Disposeable
   {
       
      
      private var _index:int;
      
      private var _bg:Scale9CornerImage;
      
      private var _dayTitleBg:Bitmap;
      
      private var _day:ScaleFrameImage;
      
      private var _line:ScaleBitmapImage;
      
      private var _already:Bitmap;
      
      private var _receiveBtn:TextButton;
      
      private var _itemCell:Vector.<BaseCell>;
      
      private var _itemCellHbox:HBox;
      
      public function DailyReceiveItem(param1:int)
      {
         super();
         this._index = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("liveness.frame.dailyReceiveItem.bg");
         this._line = ComponentFactory.Instance.creatComponentByStylename("ddthall.dailyLine");
         this._already = ComponentFactory.Instance.creatBitmap("ddt.dailyReceive.already");
         this._already.visible = false;
         this._dayTitleBg = ComponentFactory.Instance.creatBitmap("ddt.dailyReceive.dayBg");
         this._day = ComponentFactory.Instance.creatComponentByStylename("liveness.frame.dailyReceiveItem.day");
         this._day.setFrame(this._index);
         this._receiveBtn = ComponentFactory.Instance.creatComponentByStylename("ddthall.dailyReceive.receiveBtn");
         this._receiveBtn.text = LanguageMgr.GetTranslation("ddthall.dailyReceive.receiveTxt");
         this._itemCellHbox = ComponentFactory.Instance.creatComponentByStylename("ddthall.dailyReceive.itemCellBox");
         addChild(this._bg);
         addChild(this._line);
         addChild(this._dayTitleBg);
         addChild(this._day);
         addChild(this._receiveBtn);
         addChild(this._already);
         addChild(this._itemCellHbox);
         this.initCell();
         this.updateView();
      }
      
      private function initEvent() : void
      {
         this._receiveBtn.addEventListener(MouseEvent.CLICK,this.__receiveHandler);
      }
      
      private function removeEvent() : void
      {
         this._receiveBtn.removeEventListener(MouseEvent.CLICK,this.__receiveHandler);
      }
      
      private function __receiveHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendDailyReceive(PlayerManager.Instance.Self.awardLog);
      }
      
      private function initCell() : void
      {
         var _loc4_:BaseCell = null;
         var _loc5_:InventoryItemInfo = null;
         this._itemCell = new Vector.<BaseCell>();
         var _loc1_:Array = DailyReceiveManager.Instance.getByDayTemplateId(this._index);
         var _loc2_:Array = DailyReceiveManager.Instance.getByGradeAwards(_loc1_);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = new BaseCell(ComponentFactory.Instance.creatComponentByStylename("ddthall.dailyReceive.itemCellBg"));
            _loc5_ = new InventoryItemInfo();
            _loc5_.TemplateID = _loc2_[_loc3_].TemplateID;
            _loc5_.Count = _loc2_[_loc3_].Count;
            _loc5_.IsBinds = _loc2_[_loc3_].IsBinds;
            ItemManager.fill(_loc5_);
            _loc4_.isShowCount = true;
            _loc4_.info = _loc5_;
            _loc4_.setContentSize(40,40);
            _loc4_.picPos = new Point(4,4);
            this._itemCell.push(_loc4_);
            this._itemCellHbox.addChild(_loc4_);
            _loc3_++;
         }
      }
      
      private function updateCell() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._itemCell.length)
         {
            this._itemCell[_loc1_].alpha = 0.5;
            _loc1_++;
         }
      }
      
      private function updateView() : void
      {
         if(this._index < PlayerManager.Instance.Self.awardLog)
         {
            this._receiveBtn.visible = false;
            this._already.visible = true;
            this.updateCell();
         }
         else if(this._index > PlayerManager.Instance.Self.awardLog)
         {
            this._receiveBtn.visible = true;
            this._receiveBtn.enable = false;
            this._already.visible = false;
         }
         else if(PlayerManager.Instance.Self.isAward)
         {
            this._receiveBtn.visible = false;
            this._already.visible = true;
            this.updateCell();
         }
         else
         {
            this._receiveBtn.visible = true;
            this._receiveBtn.enable = true;
            this._already.visible = false;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._line)
         {
            ObjectUtils.disposeObject(this._line);
         }
         this._line = null;
         if(this._already)
         {
            ObjectUtils.disposeObject(this._already);
         }
         this._already = null;
         if(this._dayTitleBg)
         {
            ObjectUtils.disposeObject(this._dayTitleBg);
         }
         this._dayTitleBg = null;
         if(this._day)
         {
            ObjectUtils.disposeObject(this._day);
         }
         this._day = null;
         if(this._receiveBtn)
         {
            ObjectUtils.disposeObject(this._receiveBtn);
         }
         this._receiveBtn = null;
         if(this._itemCellHbox)
         {
            ObjectUtils.disposeObject(this._itemCellHbox);
         }
         this._itemCellHbox = null;
      }
   }
}
