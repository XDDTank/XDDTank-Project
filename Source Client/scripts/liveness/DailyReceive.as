package liveness
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.DropGoodsManager;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.events.Event;
   import flash.geom.Point;
   import road7th.comm.PackageIn;
   
   public class DailyReceive extends Frame
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _itemBox:VBox;
      
      private var _dailyItem:Vector.<DailyReceiveItem>;
      
      public function DailyReceive()
      {
         super();
         escEnable = false;
         this.initView();
         this.initEvent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("liveness.frame.dailyReceive.bg");
         addToContent(this._bg);
         this._itemBox = ComponentFactory.Instance.creatComponentByStylename("ddthall.dailyReceive.itemBox");
         addToContent(this._itemBox);
         titleText = LanguageMgr.GetTranslation("ddt.liveness.dailyReceive.Title");
         this.initDailyItem();
      }
      
      private function initDailyItem() : void
      {
         var _loc2_:DailyReceiveItem = null;
         this._dailyItem = new Vector.<DailyReceiveItem>();
         var _loc1_:int = 1;
         while(_loc1_ < 8)
         {
            _loc2_ = new DailyReceiveItem(_loc1_);
            this._dailyItem.push(_loc2_);
            this._itemBox.addChild(_loc2_);
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__resposeHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DAILY_AWARD,this.__dailyAward);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__resposeHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DAILY_AWARD,this.__dailyAward);
      }
      
      private function __dailyAward(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         if(_loc3_)
         {
            this.dispose();
            this.dropGoods();
            PlayerManager.Instance.Self.isAward = true;
            DailyReceiveManager.Instance.dispatchEvent(new Event(DailyReceiveManager.CLOSE_ICON));
         }
      }
      
      private function dropGoods() : void
      {
         var _loc5_:ItemTemplateInfo = null;
         var _loc6_:Point = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = DailyReceiveManager.Instance.getByDayTemplateId(PlayerManager.Instance.Self.awardLog);
         var _loc3_:Array = DailyReceiveManager.Instance.getByGradeAwards(_loc2_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = ItemManager.Instance.getTemplateById(_loc3_[_loc4_].TemplateID);
            _loc1_.push(_loc5_);
            _loc4_++;
         }
         if(_loc1_.length > 0)
         {
            _loc6_ = new Point(500,300);
            DropGoodsManager.play(_loc1_,_loc6_);
         }
      }
      
      private function __resposeHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.ESC_CLICK || param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._itemBox)
         {
            ObjectUtils.disposeObject(this._itemBox);
         }
         this._itemBox = null;
         super.dispose();
      }
   }
}
