package liveness
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.OneLineTip;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class LivenessBox extends Sprite implements Disposeable
   {
       
      
      private var _liveBox:Bitmap;
      
      private var _boxGot:Bitmap;
      
      private var _boxShine:MovieClip;
      
      private var _boxDesc:FilterFrameText;
      
      private var _index:uint;
      
      private var _pointShine:MovieClip;
      
      private var _status:uint;
      
      private var _boxPointBmp:Bitmap;
      
      private var _boxTip:OneLineTip;
      
      private var _rewardItem:InventoryItemInfo;
      
      public function LivenessBox(param1:uint)
      {
         super();
         this._index = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._liveBox = ComponentFactory.Instance.creatBitmap("asset.liveness.livenessBox" + this._index);
         this._boxGot = ComponentFactory.Instance.creatBitmap("asset.liveness.boxGot");
         this._boxShine = ComponentFactory.Instance.creat("asset.liveness.boxShine" + this._index);
         this._boxDesc = ComponentFactory.Instance.creatComponentByStylename("liveness.livenessBoxDesc");
         this._boxPointBmp = ComponentFactory.Instance.creatBitmap("asset.liveness.boxPointBmp");
         PositionUtils.setPos(this._boxGot,"liveness.livenessBoxGot.pos");
         this._boxGot.visible = false;
         this._boxShine.visible = false;
         this._boxPointBmp.visible = false;
         this._boxDesc.text = (this._index + 1) * 20 + LanguageMgr.GetTranslation("ddt.liveness.livenessBoxDesc.txt");
         addChild(this._liveBox);
         addChild(this._boxPointBmp);
         addChild(this._boxGot);
         addChild(this._boxShine);
         addChild(this._boxDesc);
         this.setStatus(LivenessModel.BOX_CANNOT_GET);
         this._rewardItem = new InventoryItemInfo();
         this._rewardItem.TemplateID = int(ServerConfigManager.instance.getLivenessAward()[this._index].split(",")[1]);
         ItemManager.fill(this._rewardItem);
         this._rewardItem.BindType = 4;
         this._boxTip = new OneLineTip();
         this._boxTip.tipData = this._rewardItem.Description;
         this._boxTip.visible = false;
         PositionUtils.setPos(this,"liveness.livenessBox" + (this._index + 1) + ".pos");
      }
      
      private function initEvent() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.__clickBox);
         this.addEventListener(MouseEvent.ROLL_OVER,this.__rollOver);
         this.addEventListener(MouseEvent.ROLL_OUT,this.__rollOut);
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.__clickBox);
         this.removeEventListener(MouseEvent.ROLL_OVER,this.__rollOver);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.__rollOut);
      }
      
      private function __rollOver(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(this._boxTip)
         {
            this._boxTip.visible = true;
            LayerManager.Instance.addToLayer(this._boxTip,LayerManager.GAME_TOP_LAYER);
            _loc2_ = this.localToGlobal(new Point(0,0));
            this._boxTip.x = _loc2_.x + this.width / 2 - this._boxTip.width / 2;
            this._boxTip.y = _loc2_.y + this.height - 25;
         }
      }
      
      private function __rollOut(param1:MouseEvent) : void
      {
         if(this._boxTip)
         {
            this._boxTip.visible = false;
         }
      }
      
      private function __clickBox(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._status == LivenessModel.BOX_CAN_GET)
         {
            SocketManager.Instance.out.SendGetDailyQuestReward(this._index);
         }
      }
      
      public function setStatus(param1:uint) : void
      {
         if(this._status == param1)
         {
            return;
         }
         this._status = param1;
         switch(param1)
         {
            case LivenessModel.BOX_HAS_GET:
               this.filters = ComponentFactory.Instance.creatFilters("darkFilter");
               this._boxGot.visible = true;
               this._boxShine.visible = false;
               this._boxPointBmp.visible = true;
               this.buttonMode = false;
               this.useHandCursor = false;
               break;
            case LivenessModel.BOX_CAN_GET:
               this.filters = null;
               this._boxGot.visible = false;
               this._boxShine.visible = true;
               this._boxPointBmp.visible = true;
               this.buttonMode = true;
               this.useHandCursor = true;
               ObjectUtils.disposeObject(this._pointShine);
               if(!LivenessAwardManager.Instance.model.pointMovieHasPlay[this._index])
               {
                  this._pointShine = null;
                  this._pointShine = ComponentFactory.Instance.creat("asset.liveness.livenessPointMovie");
                  PositionUtils.setPos(this._pointShine,"liveness.livenessBoxPointShine.pos");
                  this._pointShine.addEventListener(Event.COMPLETE,this.__removePointMovie);
                  addChild(this._pointShine);
                  this._pointShine.gotoAndPlay(2);
               }
               break;
            case LivenessModel.BOX_CANNOT_GET:
               this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
               this._boxGot.visible = false;
               this._boxShine.visible = false;
               this._boxPointBmp.visible = false;
               this.buttonMode = false;
               this.useHandCursor = false;
         }
      }
      
      private function __removePointMovie(param1:Event) : void
      {
         ObjectUtils.disposeObject(this._pointShine);
         this._pointShine = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._liveBox);
         this._liveBox = null;
         ObjectUtils.disposeObject(this._boxGot);
         this._boxGot = null;
         ObjectUtils.disposeObject(this._boxShine);
         this._boxShine = null;
         ObjectUtils.disposeObject(this._boxDesc);
         this._boxDesc = null;
         ObjectUtils.disposeObject(this._pointShine);
         this._pointShine = null;
         ObjectUtils.disposeObject(this._boxPointBmp);
         this._boxPointBmp = null;
         ObjectUtils.disposeObject(this._boxTip);
         this._boxTip = null;
         ObjectUtils.disposeObject(this._rewardItem);
         this._rewardItem = null;
      }
      
      public function get rewardItem() : InventoryItemInfo
      {
         return this._rewardItem;
      }
   }
}
